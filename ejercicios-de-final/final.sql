/**
 * Creación de tablas
 * 
 * Considerando la tabla de jugadores existente generar las tablas de titulares y suplentes 
 * que permita registrar cuales jugadores son titulares y cuales suplenetes del club al que pertenecen.
 * Se deberá implementar las restricciones de entidad, dominio e integridad referencial 
 * que correspondan, indicando estructura y comportamiento.
 *
 **/
create table Titulares (
	Tipodoc Char(3),
	Nrodoc Integer,
	Primary Key (Tipodoc, Nrodoc),
	Constraint titulares_pk_jugadores Foreign Key (Tipodoc, Nrodoc) references jugadores(Tipodoc, Nrodoc)
)

create table Suplentes (
	Tipodoc Char(3),
	Nrodoc Integer,
	Primary Key (Tipodoc, Nrodoc),
	Constraint suplentes_pk_jugadores Foreign Key (Tipodoc, Nrodoc) references jugadores(Tipodoc, Nrodoc)
)

/**
 * 2. Función
 *
 * Definir una función fn###### que:
 * 		Reciba un id_Club, una categoría y un número entero n
 *		Devolver los n jugadores más viejos de ese club en esa categoria
 *		La resolución debe efectuarse en una consulta correlacionada. Sin utilizar la cláusula top.
 **/
CREATE FUNCTION fn1037546 (@id_Club smallint, @categoria int, @n int)
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

/**
 * 3. Trigger
 *
 * Definir una trigger fn###### que se accione al eliminar suplentes, debiendo controlar:
 * 		Si se quita un jugador como suplente, el mismo debe registrarse como titular.
 *		No permitir eliminar jugadores de distinto club y categoría en la misma eliminación.
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

	SET @id_club_nuevo 		= (SELECT j.Id_Club FROM Deleted d INNER JOIN Jugadores j ON j.Nrodoc = d.Nrodoc)
	SET @categoria_nuevo 	= (SELECT j.Categoria FROM Deleted d INNER JOIN Jugadores j ON j.Nrodoc = d.Nrodoc)

	IF ((SELECT COUNT(*) FROM Deleted) > 1)
		BEGIN
			
			SET @id_club_ant 		= (SELECT j.Id_Club FROM Inserted i INNER JOIN Jugadores j ON j.Nrodoc = i.Nrodoc)
			SET @categoria_ant 		= (SELECT j.Categoria FROM Inserted i INNER JOIN Jugadores j ON j.Nrodoc = i.Nrodoc)

			IF ((@id_club_nuevo = @id_club_ant) AND (@categoria_nuevo = @categoria_ant))
				BEGIN
					INSERT INTO Titulares (Tipodoc, Nrodoc) (SELECT Tipodoc, Nrodoc FROM Deleted)
				END
		END
	ELSE
		BEGIN
			INSERT INTO Titulares (Tipodoc, Nrodoc) (SELECT Tipodoc, Nrodoc FROM Deleted)
		END 
GO