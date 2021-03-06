/**
 * Creación de tablas
 * 
 * Considerando la tabla de jugadores existente generar las tablas de titulares y suplentes 
 * que permita registrar cuales jugadores son titulares y cuales suplenetes del club al que pertenecen.
 * Se deberá implementar las restricciones de entidad, dominio e integridad referencial 
 * que correspondan, indicando estructura y comportamiento.
 *
 **/
CREATE TABLE Titulares (
	Tipodoc Char(3),
	Nrodoc Integer,
	Primary Key (Tipodoc, Nrodoc),
	Constraint titulares_pk_jugadores Foreign Key (Tipodoc, Nrodoc) references Jugadores(Tipodoc, Nrodoc)
)

CREATE TABLE Suplentes (
	Tipodoc Char(3),
	Nrodoc Integer,
	Primary Key (Tipodoc, Nrodoc),
	Constraint suplentes_pk_jugadores Foreign Key (Tipodoc, Nrodoc) references Jugadores(Tipodoc, Nrodoc)
)

/**
 * 2. Función
 *
 * Definir una función fn######_jovenes que:
 * 		+ Reciba un id_Club, una categoría y un número entero n
 *		+ Devolver los n jugadores más jovenes de ese club en esa categoria
 *		+ La resolución debe efectuarse en una consulta correlacionada. Sin utilizar la cláusula top.
 **/
CREATE FUNCTION fn1037546_jovenes (@id_club smallint, @categoria tinyint, @n int)
RETURNS TABLE
AS
	RETURN (
		SELECT *
		FROM Jugadores j
		WHERE @n > (
				SELECT COUNT(*)
				FROM Jugadores jj
				WHERE 
					j.Fecha_Nac < jj.Fecha_Nac
					AND jj.Id_Club = @id_club
					AND jj.Categoria = @categoria
			)
			AND j.Id_Club = @id_club
			AND j.Categoria = @categoria
	)
GO
SELECT * FROM fn1037546_jovenes (23, 84, 5)

/**
 * 3. Trigger
 *
 * Definir una trigger tr######_02 que se accione al eliminar suplentes, debiendo controlar:
 * 		+ Si se quita un jugador como titular, el mismo debe registrarse como suplente.
 *		+ No permitir menos de 11 titulares por club y categoria.
 * No utilizar cursores.
 *
 **/
CREATE TRIGGER tr1037546_02
ON Titulares
FOR DELETE
AS
	declare @id_club_eliminar 			smallint
	declare @categoria_eliminar 		Tinyint
	declare @cant_jugadores_titulares 	int
	declare @tipodoc_eliminar 			Char(3)
	declare @nrodoc_eliminar 			int

	-- Obtenemos los datos del jugador (id_club y categoria) que se está eliminado
	SET @id_club_eliminar 			= (
										SELECT j.Id_Club 
										FROM Jugadores j
										INNER JOIN Deleted d ON d.Nrodoc = j.Nrodoc
									)
	SET @categoria_eliminar 		= (
										SELECT j.Categoria
										FROM Jugadores j
										INNER JOIN Deleted d ON d.Nrodoc = j.Nrodoc
									)

	-- Obtenemos la cantidad de jugadores titulares en el Club / Categoria que se está eliminado
	SET @cant_jugadores_titulares 	= (
										SELECT COUNT(*) 
										FROM Jugadores j 
										WHERE 
											j.Id_Club = @id_club_eliminar 
											AND j.Categoria = @categoria_eliminar
											AND j.Nrodoc IN (
													SELECT t.Nrodoc
													FROM Titulares t
												)
										);	

	IF (@cant_jugadores_titulares > 11)
		BEGIN
			-- Vamos a quitar un jugador como titular pero registrarlo como Suplente
			-- Primero obtenemos los datos del jugador para poder insertarlo en Suplentes
			SET @tipodoc_eliminar 	= (SELECT d.Tipodoc FROM Deleted d)
			SET @nrodoc_eliminar 	= (SELECT d.Nrodoc FROM Deleted d)

			-- Insertamos el jugador en suplentes
			INSERT INTO Suplentes (Tipodoc, Nrodoc) VALUES (@tipodoc_eliminar, @nrodoc_eliminar)
		END
	ELSE
		BEGIN
			-- Cancelamos la operación porque la cantidad de jugadores como tituales no es 11
			PRINT '¡ATENCIÓN! Son 11 jugadores, no se puede borrar más por condición'
			ROLLBACK TRANSACTION
		END
GO

/**
 * 4. Transacción
 *
 * Crear un store procedure st######_02 donde se definan los siguientes procedimientos,
 * conformando una única transacción.
 *		+ Establecer en cada categoría de cada club hasta un máximo de 11 jugadores como titulares,
 *		los restantes como suplentes (se debe invocar la función del punto 2).
 *		+ Incorporar como titular para cada categoría de cada club al jugador suplente (de ese club
 *		y categoría) que posea el nombre más largo en cantidad de caracteres.
 *		+ Proyectar todos los jugadores titulares
 *		+ Deshacer la última actualización
 * Finalizar la transacción.
 * Los menesajes de error deben mostrarse con la función raiserror.

 **/
CREATE PROCEDURE st1037546_02 
AS
	DECLARE @Id_Club_buscado 				int
	DECLARE @Categoria_buscado 				tinyint
	DECLARE @cant_jugadores_por_equipo_cat 	int
	DECLARE @Tipodoc_jugador_buscado 		Char(3)
	DECLARE @Nrodoc_jugador_buscado 		int
	DECLARE @cantidad_jugadores_ingresados	int

	BEGIN TRANSACTION transaction_02
	
	-- Establecer en cada categoría de cada club hasta un máximo de 11 jugadores como titulares, 
	-- los restantes como suplentes (se debe invocar la función del punto 2)
	DECLARE listado_de_equipos CURSOR FOR
		SELECT j.Id_Club, j.Categoria 
		FROM Jugadores j 
		GROUP BY j.Id_Club, j.Categoria  
		ORDER BY j.Id_Club, j.Categoria ASC

	OPEN listado_de_equipos

	FETCH NEXT FROM listado_de_equipos INTO @Id_Club_buscado, @Categoria_buscado

	-- Recorremos cada equipo para saber si tiene 11 jugadores como titulares
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			-- Obtenemos la cantidad de jugadores que tiene el equipo de esa categoria
			SET @cant_jugadores_por_equipo_cat = (
														SELECT COUNT(*)
														FROM Jugadores j
														WHERE 
															j.Id_Club = @Id_Club_buscado
															AND j.Categoria = @Categoria_buscado
													)

			-- Buscamos todos los jugadores que tiene el equipo de esa categoria
			-- utilizando la función del punto 2 (fn1037546_jovenes)
			DECLARE jugadores_a_titular_suplentes CURSOR FOR
				SELECT Tipodoc, Nrodoc 
				FROM fn1037546_jovenes (@Id_Club_buscado, @Categoria_buscado, @cant_jugadores_por_equipo_cat)

			OPEN jugadores_a_titular_suplentes

			FETCH NEXT FROM jugadores_a_titular_suplentes INTO @Tipodoc_jugador_buscado, @Nrodoc_jugador_buscado
			
			-- Generamos una variable para recorrer 
			SET @cantidad_jugadores_ingresados = 1

			-- Recorremos el cursor generado anteriormente con el objetivo de poner
			-- 11 jugadores en titulares y el resto en suplentes
			WHILE @@FETCH_STATUS = 0
				BEGIN
					-- Como todavía no se ingresaron más de 11 jugadores es titular
					IF (@cantidad_jugadores_ingresados <= 11)
						BEGIN
							INSERT INTO Titulares (Tipodoc, Nrodoc) VALUES (@Tipodoc_jugador_buscado, @Nrodoc_jugador_buscado)
						END
					-- Cuando superan los 11 jugadores titulares se los ingresa en Suplentes
					ELSE 
						BEGIN
							INSERT INTO Suplentes (Tipodoc, Nrodoc) VALUES (@Tipodoc_jugador_buscado, @Nrodoc_jugador_buscado)
						END

					-- Incrementamos una variable para saber cuantos jugadores se ingresaron
					SET @cantidad_jugadores_ingresados = @cantidad_jugadores_ingresados + 1

					FETCH NEXT FROM jugadores_a_titular_suplentes INTO @Tipodoc_jugador_buscado, @Nrodoc_jugador_buscado
				END

			CLOSE jugadores_a_titular_suplentes
			DEALLOCATE jugadores_a_titular_suplentes

			
			FETCH NEXT FROM listado_de_equipos INTO @Id_Club_buscado, @Categoria_buscado
		END  

	CLOSE listado_de_equipos
	DEALLOCATE listado_de_equipos

	-- Establecemos un punto de grabación
	SAVE TRANSACTION punto_de_grabacion

	-- Eof primera transacción

	-- Incorporar como titular para cada categoría de cada club al jugador suplente (de ese club
	-- y categoría) que posea el nombre más largo en cantidad de caracteres.

	DECLARE listado_de_equipos CURSOR FOR
		SELECT j.Id_Club, j.Categoria 
		FROM Jugadores j 
		GROUP BY j.Id_Club , j.Categoria 
		ORDER BY j.Id_Club, j.Categoria ASC

	OPEN listado_de_equipos

	FETCH NEXT FROM listado_de_equipos INTO @Id_Club_buscado, @Categoria_buscado

	-- Recorremos cada equipo para buscar el que tiene más nombre del equipo Suplente
	-- para pasarlo al equipo Titular
	WHILE @@FETCH_STATUS = 0
		BEGIN 
			-- Generamos un cursor con el listado de jugadores ordenados por nombre
			-- más largo de un Club y Categoria (id_club / categoria) que sea Suplente
			DECLARE jugadores_sup_por_nombre_largo CURSOR SCROLL FOR
				SELECT j.Tipodoc, j.Nrodoc
				FROM Jugadores j
				WHERE 
					j.Id_Club = @Id_Club_buscado
					AND j.Categoria = @Categoria_buscado
					AND j.Nrodoc IN (
										SELECT s.Nrodoc 
										FROM Suplentes s
									)
				ORDER BY len(j.Nombre) ASC

			OPEN jugadores_sup_por_nombre_largo

			-- Selecccionamos únicamente el primer jugador que cumpla con todas las condiciones
			FETCH FIRST FROM jugadores_sup_por_nombre_largo INTO @Tipodoc_jugador_buscado, @Nrodoc_jugador_buscado

			IF ((SELECT t.Nrodoc FROM Titulares t WHERE t.Tipodoc = @Tipodoc_jugador_buscado AND t.Nrodoc = @Nrodoc_jugador_buscado) <> @Nrodoc_jugador_buscado)
				BEGIN
					-- Insertamos en Titulares el jugador con el nombre más largo
					INSERT INTO Titulares (Tipodoc, Nrodoc) VALUES (@Tipodoc_jugador_buscado, @Nrodoc_jugador_buscado)

					-- Borramos de Suplentes el jugador con el nombre más largo
					DELETE Suplentes WHERE Tipodoc = @Tipodoc_jugador_buscado AND Nrodoc = @Nrodoc_jugador_buscado
				END
			ELSE
				BEGIN
					PRINT 'El jugador del equipo ' + convert(varchar(5), @Id_Club_buscado) + ' cuya categoria es ' + convert(varchar(5), @Categoria_buscado) + ' ya se encontraba en los Titulares'
				END				

			CLOSE jugadores_sup_por_nombre_largo
			DEALLOCATE jugadores_sup_por_nombre_largo

			FETCH NEXT FROM listado_de_equipos INTO @Id_Club_buscado, @Categoria_buscado
		END

	CLOSE listado_de_equipos
	DEALLOCATE listado_de_equipos

	-- Eof segunda transacción

	-- Proyectar todos los jugadores suplentes
	PRINT 'Proyectamos todos los jugadores suplentes'

	SELECT j.Tipodoc, j.Nrodoc, j.Nombre, j.Fecha_Nac, j.Categoria, j.Id_Club, c.Nombre
	FROM Jugadores j
	LEFT JOIN Clubes c ON (c.Id_Club = j.Id_Club)
	WHERE j.Nrodoc IN (
						SELECT s.Nrodoc 
						FROM Suplentes s 
						WHERE 
							s.Tipodoc = j.Tipodoc 
							AND s.Nrodoc = j.Nrodoc
					)
	-- Eof tercera transacción

	-- Deshacemos la transacción hasta el punto de grabación 
	ROLLBACK TRANSACTION punto_de_grabacion
	-- Eof cuarta transacción

	COMMIT TRANSACTION transaction_02
GO






