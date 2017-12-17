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
 * Definir una función fn###### que:
 * 		+ Reciba un id_Club, una categoría y un número entero n
 *		+ Devolver los n jugadores más viejos de ese club en esa categoria
 *		+ La resolución debe efectuarse en una consulta correlacionada. Sin utilizar la cláusula top.
 **/
CREATE FUNCTION fn1037546_2 (@id_Club smallint, @categoria tinyint, @n int)
RETURNS table
AS
RETURN (
	SELECT * 
	FROM Jugadores j 
	WHERE 
		@n > (
				SELECT COUNT(*) 
				FROM Jugadores jj 
				WHERE j.Fecha_Nac > jj.Fecha_Nac
				AND jj.Id_club = @id_Club 
				AND jj.categoria = @categoria
			)
		AND j.Id_Club = @id_Club
		AND j.categoria = @categoria 
	)
GO

SELECT * FROM fn1037546_2 ('23', '84', '5')

CREATE FUNCTION fn1037546 (@id_Club smallint, @categoria tinyint, @n int)
	RETURNS TABLE
	AS
	RETURN (
		SELECT *
		FROM Jugadores jj
		WHERE jj.Nrodoc IN (
							SELECT j.Nrodoc
							FROM Jugadores j 
							WHERE j.id_Club = @id_Club AND j.Categoria = @categoria 
							ORDER BY j.Fecha_Nac ASC
							OFFSET 0 ROWS
							FETCH NEXT @n ROWS ONLY 
						)
	)
GO

SELECT * FROM fn1037546 ('23', '84', '5')


/**
 * 3. Trigger
 *
 * Definir una trigger tr###### que se accione al eliminar suplentes, debiendo controlar:
 * 		+ Si se quita un jugador como suplente, el mismo debe registrarse como titular.
 *		+ No permitir eliminar jugadores de distinto club y categoría en la misma eliminación.
 * No utilizar cursores.
 *
 **/
CREATE TRIGGER tr1037546
ON Suplentes
AFTER DELETE
AS
	BEGIN
		IF ((SELECT COUNT(*) FROM Deleted) = 1)
			BEGIN
				INSERT INTO Titulares (Tipodoc, Nrodoc) VALUES (SELECT Tipodoc, Nrodoc FROM Deleted)
			END
		ELSE
			BEGIN
				DECLARE @idClub int
				DECLARE @cat int

				SET @idClub = (
								SELECT j.Id_Club 
								FROM Jugadores j 
								INNER JOIN Deleted d ON d.Tipodoc = j.Tipodoc AND d.Nrodoc = j.Nrodoc
								ORDER BY j.Tipodoc, j.Nrodoc
								OFFSET 0 ROWS FETCH FIRST 1 rows only
							)
				SET @cat = (
								SELECT j.Categoria 
								FROM Jugadores j
								INNER JOIN Deleted d ON d.Tipodoc = j.Tipodoc AND d.Nrodoc = j.Nrodoc
								ORDER BY j.Tipodoc, j.Nrodoc
								OFFSET 0 ROWS FETCH FIRST 1 rows only
							)

				-- Inserta en Titulares siempre y cuando el que se está borrando
				-- sea del mismo equipo y categoría que el primero que se borro
				INSERT INTO Titulares (Tipodoc, Nrodoc) VALUES (
																	SELECT d.Tipodoc, d.Nrodoc 
																	FROM Deleted d
																	INNER JOIN Jugadores j ON j.Tipodoc = d.Tipodoc AND j.Nrodoc = d.Nrodoc
																	WHERE 
																		j.Id_Club = @idClub 
																		AND j.Categoria = @cat
																)
				-- Inserta en Suplentes siempre y cuando el que se esté borrando
				-- se haya borrado por error y no sea del mismo equipo y categoria
				INSERT INTO Suplentes (Tipodoc, Nrodoc) VALUES (
																	SELECT d.Tipodoc, d.Nrodoc 
																	FROM Deleted d
																	INNER JOIN Jugadores j ON j.Tipodoc = d.Tipodoc AND j.Nrodoc = d.Nrodoc
																	WHERE 
																		j.Id_Club <> @idClub 
																		AND j.Categoria <> @cat
																)
			END
	END
GO

/**
 * 4. Transacción
 *
 * Crear un store procedure st###### donde se definan los siguientes procedimientos,
 * conformando una única transacción.
 *		+ Establecer en cada categoría de cada club hasta un máximo de 11 jugadores como titulares,
 *		los restantes como suplentes (se debe invocar la función del punto 2).
 *		+ Incorporar como suplente para cada categoría de cada club al jugador titular (de ese club
 *		y categoría) que posea el nombre más corto en cantidad de caracteres.
 *		+ Proyectar todos los jugadores suplentes
 *		+ Deshacer la última actualización
 * Finalizar la transacción.
 * Los menesajes de error deben mostrarse con la función raiserror.

 **/
CREATE PROCEDURE st1037546 
AS





