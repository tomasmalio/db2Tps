/**
	1. Vista
	Crear un vista vw####### que:
		Retome la diferencia de edad en dias entre el jugador más joven de la categoria 85 y el más viejo de la categoria 84, de cada club.
		La consulta debe ser correlacionada
**/
CREATE VIEW vw1037546_23052017
AS
	SELECT datediff(dd, jViejo.Fecha_Nac, jJoven.Fecha_Nac) AS 'Diferencia De Dias', c.Nombre, c.Id_Club
	FROM Clubes c,
		(
			SELECT MIN(j4.Fecha_Nac) Fecha_Nac, j4.Id_Club
			FROM Jugadores j4
			WHERE j4.Categoria = 84
			GROUP BY j4.Id_Club
		) jViejo,
		(
			SELECT MAX(j5.Fecha_Nac) Fecha_Nac, j5.Id_Club
			FROM jugadores j5
			WHERE j5.Categoria = 85
			GROUP BY j5.Id_Club
		) jJoven
	WHERE jViejo.Id_Club = c.Id_Club AND jJoven.Id_Club = c.Id_Club
GO

SELECT * FROM vw1037546_23052017

