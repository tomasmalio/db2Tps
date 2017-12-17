/**
	1.Funcion
**/
CREATE FUNCTION fn1037546 (@numFechaPartido tinyint)
RETURNS TABLE
AS
	RETURN (
		SELECT DISTINCT (c.Nombre)
		FROM Clubes c
		LEFT OUTER JOIN Partidos p ON (c.Id_Club = p.Id_ClubL OR c.Id_Club = p.Id_ClubV)
		WHERE c.Id_Club NOT IN (
									SELECT Id_ClubL FROM Partidos pl WHERE pl.NroFecha = @numFechaPartido
								)
								AND c.Id_Club NOT IN (
									SELECT Id_ClubV FROM Partidos pv WHERE pv.NroFecha = @numFechaPartido
								)
		GROUP BY c.Nombre
	)
GO

SELECT * FROM fn1037546(1)

/**
	3. Trigger
**/
CREATE TRIGGER tr1037546 
ON Jugadores
INSTEAD OF DELETE
AS
	DECLARE @nroZona smallint, @categoria smallint, @idClub smallint, @rows smallint
	SET @categoria = (SELECT categoria FROM Deleted)
	SET @idClub = (SELECT Id_Club FROM Deleted)
	SET @nroZona = (SELECT NroZona FROM Clubes WHERE Id_Club = @idClub)
	SET @rows  = (SELECT COUNT(*) FROM Deleted)

	IF (@rows > 1)
		BEGIN
			PRINT 'No se puede eliminar un jugador que afecte a más de un club'
			ROLLBACK TRANSACTION
		END

	--
	DECLARE @nombreClub varchar(80), @menorCant int
	SET @menorCant = (SELECT Id_Club FROM Clubes WHERE Nombre = @nombreClub)

	IF (@menorCant = @idClub)
		BEGIN
			PRINT 'El Jugador pertenece actualmente al club que desea eliminar'
			ROLLBACK TRANSACTION
		END

	UPDATE Jugadores SET Id_Club = @menorCant 
		WHERE Nrodoc = (SELECT Nrodoc FROm Deleted) 
		AND Tipodoc = (SELECT Tipodoc FROM Deleted)
GO

/**
	4. Vista
**/
CREATE VIEW vw1037546
AS
	SELECT c.Nombre AS Club, j.Nombre AS Jugador, datediff(dd, jViejo.Fecha_Nac, getdate()) 'Edad en Días'
	FROM Clubes c, (
			SELECT MIN(j.Fecha_Nac) Fecha_Nac, j.Id_Club
			FROM Jugadores j
			WHERE j.Categoria = 85
			GROUP BY j.Id_Club
		) jViejo
	LEFT JOIN Jugadores j ON j.Fecha_Nac = jViejo.Fecha_Nac AND j.Id_Club = jViejo.Id_Club
	WHERE jViejo.Id_Club = c.Id_Club
GO

SELECT * FROM vw1037546