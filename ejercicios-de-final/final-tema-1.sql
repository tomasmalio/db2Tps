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
 * Definir una trigger fn###### que se accione al eliminar suplentes, debiendo controlar:
 * 		+ Si se quita un jugador como suplente, el mismo debe registrarse como titular.
 *		+ No permitir eliminar jugadores de distinto club y categoría en la misma eliminación.
 * No utilizar cursores.
 *
 **/

CREATE TRIGGER tr1037546
ON Suplentes
FOR DELETE
AS
	declare @id_club_ant smallint
	declare @categoria_ant Tinyint
	declare @id_club_nuevo smallint
	declare @categoria_nuevo Tinyint

	IF ((SELECT COUNT(*) FROM Deleted) > 1)
		BEGIN
			SET @id_club_nuevo 		= (SELECT TOP 1 j.Id_Club FROM Deleted d INNER JOIN Jugadores j ON j.Nrodoc = d.Nrodoc)
			SET @categoria_nuevo 	= (SELECT TOP 1 j.Categoria FROM Deleted d INNER JOIN Jugadores j ON j.Nrodoc = d.Nrodoc)
			SET @id_club_ant 		= (SELECT TOP 2 j.Id_Club FROM Inserted i INNER JOIN Jugadores j ON j.Nrodoc = i.Nrodoc)
			SET @categoria_ant 		= (SELECT TOP j.Categoria FROM Inserted i INNER JOIN Jugadores j ON j.Nrodoc = i.Nrodoc)
			
			IF ((@id_club_nuevo = @id_club_ant) AND (@categoria_nuevo = @categoria_ant))
				BEGIN
					INSERT INTO Titulares (Tipodoc, Nrodoc) (SELECT Tipodoc, Nrodoc FROM Deleted)
				END
			ELSE
				BEGIN
					INSERT INTO Suplentes (Tipodoc, Nrodoc) (SELECT Tipodoc, Nrodoc FROM Deleted)
				END
		END
	ELSE
		BEGIN
			INSERT INTO Titulares (Tipodoc, Nrodoc) (SELECT Tipodoc, Nrodoc FROM Deleted)
		END 
GO

/**
 * 4. Transacción
 *
 * Crear un store procedure st###### donde se definan los siguientes procedimientos,
 * conformando una única transacción.
 *		+ Establecer en cada categoría de cada club hasta un máximo de 11 jugadores como titulares,
 *		los restantes como suplentes (se debe invocar la función del punto 2).
 *		+ Incorporar como suplente para cada categoría de cada club aljugador titular (de ese club
 *		y categoría) que posea el nombre más corto en cantidad de caracteres.
 *		+ Proyectar todos los jugadores suplentes
 *		+ Deshacer la última actualización
 *		+ Finalizar la transacción.
 * Los menesajes de error deben mostrarse con la función raiserror.

 **/
CREATE PROCEDURE st1037546 





