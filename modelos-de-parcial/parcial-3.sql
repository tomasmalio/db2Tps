/**
	1. Función
	Definir una función fn###### que:
		Reciba el número de una zona.
		Retorne la cantidad de partidos ganados, empatados y perdidos por el club en esa zona.
		Se debe proyectar una única fila por club.
**/
CREATE FUNCTION fn1037546_03 (@numeroDeZona tinyint)
RETURNS TABLE
AS
	RETURN (
		SELECT DISTINCT(c.Nombre), c.Nrozona,
			(
				(SELECT COUNT(*) FROM Partidos gl WHERE gl.GolesL > gl.GolesV AND gl.Id_ClubL = c.Id_Club) + 
				(SELECT COUNT(*) FROM Partidos gv WHERE gv.GolesL < gv.GolesV AND gv.Id_ClubL = c.Id_Club)
			) AS Ganados,
			(
				(SELECT COUNT(*) FROM Partidos pl WHERE pl.GolesL < pl.GolesV AND pl.Id_ClubL = c.Id_Club) +
				(SELECT COUNT(*) FROM Partidos pv WHERE pv.GolesL > pv.GolesV AND pv.Id_ClubL = c.Id_Club)
			) AS Perdidos,
			(SELECT COUNT(*) FROM Partidos pe WHERE pe.GolesL = pe.GolesV AND (pe.Id_ClubL = c.Id_Club OR pe.Id_ClubV = c.Id_Club)) AS Empatados
		FROM Clubes c
		WHERE c.Nrozona = @numeroDeZona
	)
GO


/**
	2. Trigger
	Definir un trigger tr###### que se accione cuando se ingresan clubes.
		Debe asignar el número de zona (NroZona) entre 1 o 2.
		Controlar la cantidad de clubes que debe ser la misma en cada zona. Si la cantidad de clubes es impar, la zona 1 es la que se asigna.
**/
CREATE TRIGGER tr1037546_03
ON Clubes
INSTEAD OF INSERT 
AS
BEGIN
	DECLARE @nuevaZona int
	-- Impar
	IF (((SELECT COUNT(c.Nrozona) FROM Clubes c WHERE c.Nrozona = 1) + (SELECT COUNT(c.Nrozona) FROM Clubes c WHERE c.Nrozona = 2)) % 2 == 1)
		BEGIN
			SET @nuevaZona = 1
		END
	-- Par
	ELSE
		BEGIN
			SET @nuevaZona = 2
		END
	INSERT INTO Clubes (Id_Club, Nombre, Nrozona) VALUES (SELECT Id_Club, Nombre, @nuevaZona FROM Inserted)
END
GO