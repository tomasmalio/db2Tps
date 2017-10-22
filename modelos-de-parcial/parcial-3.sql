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
/**
	Verificar si esta bien
**/

/**
	3. Vista
	Definir una vista vw###### que:
		Proyecte el nombre y la zona de los clubes que no ganaron en la última fecha de los partidos jugados.
		Debe ser resuelta utilizando un join externo.
**/
CREATE VIEW vw1037546_03 
AS
	SELECT DISTINCT(c.Nombre), c.Nrozona
	FROM Clubes c
	LEFT JOIN Partidos pl ON ((pl.Id_ClubL = c.Id_Club AND pl.GolesL < pl.GolesV) OR (pl.Id_ClubV = c.Id_Club AND pl.GolesV < pl.GolesL))
	WHERE 
		pl.Nrofecha = (SELECT MAX(u.Nrofecha) FROM Partidos u) 
GO

/**
	4. Procedimiento
	Definir una vista pr###### que:
		Reciba en parámetros diferentes:
			* el nombre de zona de los clubes
			* una categoría
			* dos valores enteros distintos entre 1 y 10.
		Devuelva el nombre del club, y el nombre y la fecha de nacimiento de los jugadores más jóvenes que
		correspondan a los valores ingresados en los parámetros
		Por ejemplo el 2ª y el 5ª jugador más joven de los clubes de la zona 2 en la categoría 84.
**/
CREATE PROCEDURE pr1037546_03
	@numeroDeZona tinyint,
	@numeroDeCategoria tinyint,
	@valor_uno int,
	@valor_dos int
AS
	SELECT res.clubNombre, res.jugadorNombre, res.jugadorFechaNac
	FROM (
		SELECT (ROW_NUMBER() OVER (ORDER BY j.Fecha_Nac DESC)) AS numeroDeColumna, c.Nombre AS clubNombre, j.Nombre AS jugadorNombre, j.Fecha_Nac AS jugadorFechaNac
		FROM Jugadores j
		INNER JOIN Clubes c ON c.Id_Club = j.Id_Club
		WHERE j.Categoria = @numeroDeCategoria
			AND c.Nrozona = @numeroDeZona
	) AS res
	WHERE res.numeroDeColumna = @valor_uno OR res.numeroDeColumna = @valor_dos
GO

/**
	5. Procedimiento
	Definir un procedimiento ps###### que:
		Reciba una categoría y el nombre de un club.
		Devuelva la cantidad de partidos como local y la cantidad de partidos como visitante en los cualesvparticipó el club en esa categoría.
		Ambos resultados deben ser retornados en parámetros de salida.
		Ejecutar el procedimiento y mostrar el resultado.
**/

