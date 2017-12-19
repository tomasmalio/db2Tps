/*
 * 1 - Resolver mediante la utilizacion de cursores
 * Generar un listado con los datos existentes de los partidos de la base de jugadores, 
 * conforme a las siguientes caracteristicas:
 * 	a - Debe corresponder a los partidos de referentes a la fecha (nº de fecha), en la que 
 * 	se convirtieron la mayor cantidad de goles.
 * 	b - Indicar la cantidad de goles convertidos por cada club en esa fecha, discriminados 
 * 	por categoria.
 * 	c - La nomina de clubes que convirtieron goles debe ordenarse de mayor a menor por 
 * 	cantidad total de goles entre ambas categorias.
 * 	d - Los resultados a mostrar debe respetar el siguiente formato:
 * 	
 *	Fecha con mayor cantidad de goles convertidos.
 * 		Nº fecha:(nº)           Cantidad de goles: (total de la fecha) 
 *
 * 	Goles convertidos por los clubes ordenados de mayor a menor.
 *		Club:(nombre)           Total de goles:(total del club)
 *      Categoria 84: (subtotal de la categoria)
 *      Categoria 85: (subtotal de la categoria)
 *
 **/
DECLARE @NroFecha 						int
DECLARE @cantidadDeGoles 				int
DECLARE @NroFecha_maximo 				int
DECLARE @cantidadDeGoles_maximo 		int
DECLARE @cantidad_de_goles_resultado 	int
DECLARE @nombre_del_club 				varchar
DECLARE @cantidad_de_goles_club			int
DECLARE @Categoria 						int 
DECLARE @cantidad_de_goles_categoria 	int

SET @cantidadDeGoles_maximo = 0

DECLARE cu1037546_a CURSOR FOR
	SELECT SUM(p.GolesL + p.GolesV) AS cantidad, p.NroFecha
	FROM Partidos p
	GROUP BY p.NroFecha

OPEN cu1037546_a

FETCH NEXT FROM cu1037546_a INTO @cantidadDeGoles, @NroFecha

-- Recorremos los datos con el objetivo de encontrar la fecha
-- con mayor cantidad de goles
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (@cantidadDeGoles > @cantidadDeGoles_maximo)
			BEGIN
				SET @cantidadDeGoles_maximo = @cantidadDeGoles
				SET @NroFecha_maximo = @NroFecha
			END
		FETCH NEXT FROM cu1037546_a INTO @cantidadDeGoles, @NroFecha
	END
CLOSE cu1037546_a
DEALLOCATE cu1037546_a

-- Una vez encontrada la fecha con mayor cantidad de goles
-- buscamos sus datos para mostrarlos
DECLARE cu1037546_a_res CURSOR SCROLL FOR
	SELECT SUM(p.GolesL + p.GolesV) AS cantidad
	FROM Partidos p
	WHERE p.NroFecha = @NroFecha_maximo
	GROUP BY p.NroFecha

OPEN cu1037546_a_res

FETCH FIRST FROM cu1037546_a_res INTO @cantidad_de_goles_resultado

IF (@@FETCH_STATUS = 0)
	BEGIN
		PRINT 'Nº fecha:(nº) ' + convert(varchar(5), @NroFecha_maximo) + ' Cantidad de goles: (total de la fecha) ' + convert(varchar(5), @cantidad_de_goles_resultado)
	END

CLOSE cu1037546_a_res
DEALLOCATE cu1037546_a_res


-- Generamos un cursor con los datos de cada equipo y la cantidad
-- de goles como visitante y local
DECLARE cu1037546_b_clubes CURSOR FOR
	SELECT cc.Nombre, tabla.Cantidad
	FROM Clubes cc
	INNER JOIN (
		SELECT c.Id_Club, SUM(pL.GolesL + pV.GolesV) as Cantidad
		FROM Clubes c
		LEFT JOIN Partidos pL ON pL.Id_ClubL = c.Id_Club
		LEFT JOIN Partidos pV ON pV.Id_ClubV = c.Id_Club
		GROUP BY c.Id_Club
	) tabla ON tabla.Id_Club = cc.Id_Club
	ORDER BY tabla.Cantidad DESC

OPEN cu1037546_b_clubes

FETCH NEXT FROM cu1037546_b_clubes INTO @nombre_del_club, @cantidad_de_goles_club

WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT 'Club:(nombre) ' + @nombre_del_club + ' Total de goles: (total del club) ' + convert(varchar(5), @cantidad_de_goles_club)
		FETCH NEXT FROM cu1037546_b_clubes INTO @nombre_del_club, @cantidad_de_goles_club
	END

CLOSE cu1037546_b_clubes
DEALLOCATE cu1037546_b_clubes

-- Generamos una tabla con los datos de la categoria y la
-- cantidad de goles.
DECLARE cu1037546_b_categorias CURSOR FOR
	SELECT p.Categoria, SUM(p.GolesL + p.GolesV) 
	FROM Partidos p
	GROUP BY p.Categoria

OPEN cu1037546_b_categorias

FETCH NEXT FROM cu1037546_b_categorias INTO @Categoria, @cantidad_de_goles_categoria

WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT 'Categoria ' + convert(varchar(5), @Categoria) + ': ' + convert(varchar(5), @cantidad_de_goles_categoria)
		FETCH NEXT FROM cu1037546_b_categorias INTO @Categoria, @cantidad_de_goles_categoria
	END

CLOSE cu1037546_b_categorias
DEALLOCATE cu1037546_b_categorias

GO

/**
 * 2 - Implementar una unica transaccion que invoque una funcion y actualice y 
 * proyecte la tabla de partidos, conforme a siguiente detalle:
 * 	a - Definir una función escalar que retorne en nº de fecha donde se registraron 
 * 	la menor cantidad de empates entre los clubes de la zona 2.
 * 	Debe resolverse por correlacionada.
 *
 * 	b - Iniciar una transaccion que actualice todos los partidos de la zona 2 
 * 	correspondiente a la fecha retornada por la funcion, agregando un
 * 	gol a cada club visitante en la categoria 85.
 *
 *	c - Modificar la tabla poscate285 en funcion de los goles agregados en el punto b. 
 *	Debiendo:
 * 		I - Actualizar la cantidad de partidos ganados, empatados y perdidos de los clubes afectados.
 * 		II - Actualizar la cantidad de goles (a favor) y golesC (en contra) de los mismos.
 * 		III - Actualizar los puntos de dichos clubes teniendo en cuenta 3 puntos por partido 
 *		ganado y 1 punto por partido empatado.
 *	d - Proyectar la tabla poscate285 luego de ser actualizada.
 *	e - Deshacer el punto c y confirmar el punto b de la transaccion antes de finalizarla.
 * 
 * Debe controlar las salidas por error mostrando un mensaje identificatorio del error. 
 * No utilizar cursores.
 *
 **/
CREATE FUNCTION fn1037546_fecha_menor_empates ()
RETURNS INT
AS
	BEGIN
		DECLARE @fechaMinima int 
		SET @fechaMinima = (
				SELECT MIN(p.Cantidad)
				FROM (
							SELECT COUNT(*) as Cantidad, pp.NroFecha 
							FROM Partidos pp 
							WHERE 
								pp.NroZona = 2 
								AND pp.GolesL = pp.GolesV 
							GROUP BY pp.NroFecha
					) p
			)
		RETURN @fechaMinima
	END

DECLARE @respuesta int;   
EXEC @respuesta = fn1037546_fecha_menor_empates
PRINT @respuesta

-- Ejercicio b
BEGIN TRAN

	UPDATE partidos SET GolesV = GolesV + 1 WHERE (NroFecha = DBO.fn1037546_fecha_menor_empates()) AND (Categoria = 85)

	IF (@@error <> 0)
		BEGIN
			RAISERROR('Error al actualizar partidos', 16, 1)
			ROLLBACK TRAN
			RETURN
		END

	SAVE TRAN Actualizar

	
	UPDATE Poscate285 SET Ganados = 0, Empatados = 0, perdidos = 0, GolesF = 0, golesc = 0

	-- Locales
	UPDATE Poscate285 SET 
		Ganados = Ganados + (
							SELECT COUNT(Id_ClubL) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubL = Poscate285.Id_Club 
								AND GolesL > GolesV
							),
		Empatados = Empatados + (
								SELECT COUNT(Id_ClubL) 
								FROM Partidos 
								WHERE 
									Categoria = 85 
									AND Id_ClubL = Poscate285.Id_Club 
									AND GolesL = GolesV
								),
		Perdidos = Perdidos + (
								SELECT COUNT(Id_ClubL) 
								FROM Partidos 
								WHERE 
									Categoria = 85 
									AND Id_ClubL = Poscate285.Id_Club 
									AND GolesL < GolesV
								),
		GolesF = GolesF + (
							SELECT SUM(Golesl) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubL = Poscate285.Id_Club 
							),
		GolesC = GolesC + (
							SELECT SUM(GolesV) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubL = Poscate285.Id_Club
							)

	IF (@@error <> 0)
		BEGIN
			RAISERROR('Error al actualizar poscate285 L',16,2)
			ROLLBACK TRAN
			RETURN
		End

		
	-- Visitantes
	UPDATE Poscate285 SET 
		Ganados = Ganados + (
							SELECT COUNT(Id_ClubV) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubV = Poscate285.Id_Club 
								AND GolesV > GolesL
							),
		Empatados = Empatados + (
								SELECT COUNT(Id_ClubV) 
								FROM Partidos 
								WHERE 
									Categoria = 85 
									AND Id_ClubV = Poscate285.Id_Club 
									AND GolesV = GolesL
								),
		Perdidos = Perdidos + (
								SELECT COUNT(id_clubV) 
								FROM Partidos 
								WHERE 
									Categoria = 85 
									AND Id_ClubV = Poscate285.Id_Club 
									AND GolesV < GolesL
								),
		GolesF = GolesF + (
							SELECT SUM(GolesV) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubV = Poscate285.Id_Club 
							),
		GolesC = GolesC + (
							SELECT SUM(GolesV) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubV = Poscate285.Id_Club
							)

	IF (@@error <> 0)
		BEGIN
			RAISERROR('Error al actualizar poscate285 V',16,3)
			ROLLBACK TRAN
			RETURN
		END


	-- Diferencia y Puntos
	UPDATE Poscate285 SET Diferencia = (GolesF - GolesC), Puntos = (Ganados * 3) + (Empatados * 1)

	IF (@@error <> 0)
		Begin
			RAISERROR('Error al actualizar poscate285 Dif y Puntos', 16, 4)
			ROLLBACK TRAN
			RETURN
		End
	
	ROLLBACK TRAN Actualizar

COMMIT TRAN


/*
 * 3 - Definir un desencadenador que se accione cuando se modifica el club al que pertenecen los jugadores.
 * 		a - La modificacion del club se interpreta como un intercambio entre clubes, de modo 
 * 		que si los jugadores del club1 se modifican al club2, los jugadores del club2 pasan al club1.
 * 		b - La modificacion se realiza intercambiando la misma cantidad de jugadores 
 * 		entre los dos clubes de la misma zona y en la misma categoria.
 * 		c - Si la cantidad a intercambiar no es posible satisfacerla, se ajusta a la cantidad correcta 
 * 		para realizar el intercambio.
 *
 *		No utilizar cursores.
 **/
 CREATE TRIGGER trZona 
ON Clubes
FOR INSERT, UPDATE
AS
BEGIN
END

