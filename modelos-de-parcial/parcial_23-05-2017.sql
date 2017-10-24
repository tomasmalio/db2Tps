/**
	1. Vista
	Crear un vista vw####### que:
		Retome la diferencia de edad en dias entre el jugador más joven de la categoria 85 y el más viejo de la categoria 84, de cada club.
		La consulta debe ser correlacionada
**/

SELECT datediff(dd, jViejo.Fecha_Nac, jJoven.Fecha_Nac) AS diferencia
FROM Clubes c, 
	(
		SELECT TOP 
		FROM Jugadores j4
		WHERE j4.Categoria = 84
			AND j4.Id_Club = c.Id_Club
		ORDER BY j4.Fecha_Nac ASC
	) jViejo,
	(
		SELECT * 
		FROM jugadorores j5
		WHERE j4.Categoria = 85
			AND j4.Id_Club = c.Id_Club
		ORDER BY j4.Fecha_Nac DESC
	) jJoven,

