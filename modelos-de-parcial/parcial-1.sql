/**
	nombre del servidor: db2tps.database.windows.net
	usuario: jugadores
	password: Jugadb@2017
**/
/**
	1. Función
	Definir una función fn###### que:
		Reciba el nombre de un jugador.
		Retorne el nombre y apellido en columnas separadas.
**/
CREATE FUNCTION fn1037546 (@nombreJugador varchar(30))
RETURNS TABLE
AS
	RETURN (
		SELECT substring(j.Nombre, 1, CHARINDEX(', ', j.Nombre) - 1) as nombreDelJugador, substring(j.Nombre, CHARINDEX(', ', j.Nombre)+1, len(j.Nombre)-(CHARINDEX(' ', Nombre)-1)) as apellidoDelJugador
		FROM Jugadores j
		WHERE j.Nombre = @nombreJugador
	)
GO


/**
	2. Procedimiento
	Definir un  procedimiento pr###### que:
		Reciba el nombre de un club.
		Retorne en dos parámetros de salida la cantidad de goles obtenidos como local y la cantidad de goles como visitante del club correspondiente.
		Ejecutar el procedimiento y mostrar el resultado.
**/
CREATE PROCEDURE pr1037546
	@nombreDelClub char(30) = '%'
AS
	SELECT (SELECT SUM(pl.GolesL) FROM Partidos pl WHERE pl.Id_ClubL = c.Id_Club) AS golesDeLocal, (SELECT SUM(pv.GolesV) FROM Partidos pv WHERE pv.Id_ClubV = c.Id_Club) AS golesDeVisitante
	FROM Clubes c
	WHERE c.Nombre = @nombreDelClub
GO

EXEC pr1037546 'BOCA-J. HERNANDEZ'
GO

/**
	3. Trigger
	Definir un trigger tr###### que se accione cuando se ingresan clubes.
		Debe determinar el Id_Club del mismo siendo el menor número entero  mayor a cero disponible en la tabla.
**/
CREATE TRIGGER tr1037546
ON Clubes
INSTEAD OF INSERT 
AS
BEGIN
	DECLARE @nuevoIdClub INT
	SET @nuevoIdClub = (SELECT MAX(c.Id_Club) FROM Clubes c) + 1
	INSERT INTO Clubes (Id_Club, Nombre, Nrozona) VALUES (SELECT @nuevoIdClub, Nombre, Nrozona FROM Inserted)
END 
GO

INSERT INTO Clubes (Id_Club, Nombre, Nrozona) VALUES (1, 'RIVER PLATE', 1) 
GO
/**
	4. Vista
	Definir una  vista vw###### que:
		Proyecte el nombre de los jugadores de la categoría 84 pertenecientes a los clubes que ganaron y perdieron la misma cantidad de partidos en dicha categoría.
		Debe ser resuelta utilizando correlación.
**/

CREATE VIEW vw1037546
	SELECT j.Nombre
	FROM Jugadores j
	WHERE j.Categoria = 84 
	AND (SELECT COUNT(*) FROM PosCate184 posG WHERE (posG.Ganados - posG.Perdidos) > 1 
	AND posG.Id_Club = j.Id_Club) = (SELECT COUNT(*) FROM PosCate184 posP WHERE (posP.Perdidos - posP.Ganados) > 1 AND posP.Id_Club = j.Id_Club) > 1


