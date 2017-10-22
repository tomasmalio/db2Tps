/**
	1. Función
	Definir una función fn###### que:
		Reciba una categoría.
		Retorne los nombres de los clubes que participaron en los partidos que no hubo la mayor diferencia de goles en dicha categoría. 
		La resolución debe efectuarse en una consulta correlacionada.
**/
CREATE FUNCTION fn1037546_02 (@Categoria tinyint)
RETURNS TABLE
AS
	RETURN (

	)
GO


/**
	2. Procedimiento
	Definir un procedimiento pr###### que:
		Reciba el nombre de un club y un patrón de caracteres.
		Retorne en dos parámetros de salida la cantidad de jugadores de la categoría 84 y de la 85, cuyo nombre corresponda con el patrón y pertenezcan al club ingresado.
		Ejecutar el procedimiento y mostrar el resultado.
**/
CREATE PROCEDURE pr1037546_02
	@nombreDelClub char(30),
	@patron char(30)
AS
	SELECT 
	(
		SELECT COUNT(*) 
		FROM Jugadores j 
		WHERE j.Id_Club = c.Id_Club 
			AND j.Categoria = 84 
			AND j.Nombre LIKE @patron
	) AS 'Jugadores Categoria 84',
	(
		SELECT COUNT(*) 
		FROM Jugadores j 
		WHERE j.Id_Club = c.Id_Club 
			AND j.Categoria = 85 
			AND j.Nombre LIKE @patron
	) AS 'Jugadores Categoria 85'
	FROM Clubes c
	WHERE c.Nombre = @nombreDelClub
GO

EXEC pr1037546_02 'LOS ANDES', '%PABLO%'
GO
/**
	No funciona cuando lo llamas, tira vacio y cuando lo haces por separado si anda
**/

/**
	3. Vista
	Definir una vista vw###### que:
		Proyecte el nombre y la zona de los clubes que no participaron en la última fecha de los partidos jugados.
		Debe ser resuelta utilizando un join externo.
**/
CREATE VIEW vw1037546_02
	SELECT DISTINCT (c.Nombre), c.Nrozona
	FROM Clubes c
	LEFT JOIN Partidos ps ON ps.Nrofecha = (SELECT MAX(p.Nrofecha) FROM Partidos p) AND ((ps.Id_ClubL <> c.Id_Club) AND (ps.Id_ClubV <> c.Id_Club))
/**
	No funciona, trae equipos que están en esa fecha
**/

/**
	4. Trigger
	Definir un trigger tr###### que se accione cuando se actualice el campo fecha de la tabla partido.
		Debe permitir que se actualice únicamente si corresponde a un día sábado a los partidos de la categoría 84 y domingo a los de la categoría 85 del año en curso.
**/
CREATE TRIGGER tr1037546_02
ON FechaPartido
AFTER UPDATE
BEGIN
	DECLARE @fechaPartido datetime
	IF (DATENAME(DW, @fechaPartido) == 'Saturday' OR DATENAME(DW, @fechaPartido) == 'Sunday')
		BEGIN
			IF (DATENAME(DW, @fechaPartido) == 'Saturday')
				BEGIN

				END
			ELSE
				BEGIN
				END
		END
END
GO
/**
	No se como seguirlo
**/

/**
	5. Rol
	Crear el rol ro###### y asignarles los siguientes privilegios
		No permitir eliminaciones en la tabla partidos.
		Poder actualizar únicamente los resultados de los partidos (goles) y la fecha del partido.
**/




