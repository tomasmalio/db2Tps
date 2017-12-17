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
	declare @id_club_eliminar smallint
	declare @categoria_eliminar Tinyint
	declare @cant_jugadores_titulares Integer
	declare @tipodoc_eliminar Char(3)
	declare @nrodoc_eliminar Integer

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
			PRINT 'Son 11 jugadores, no se puede borrar más'
			ROLLBACK TRANSACTION
		END
GO



