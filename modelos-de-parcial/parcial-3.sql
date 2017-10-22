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