/*
 * 1 - Definir un desencadenador que se accione cuando se modifica el club al que pertenecen los jugadores.
 **/
CREATE TRIGGER tr_intercambiar_jugadores 
ON Jugadores
FOR UPDATE
AS
	BEGIN
		DECLARE @id_club_proveniente 				int
		DECLARE @id_club_destino 					int

		DECLARE @cant_de_jugadores_int_proveniente 	int
		DECLARE @cant_de_jugadores_int_destino 		int

		DECLARE @diferencia_de_jugadores 			int
		SET @diferencia_de_jugadores 				= 0

		DECLARE @cant_de_jugadores_prov_zona_cate 	int
		DECLARE @cant_de_jugadores_dest_zona_cate 	int

		-- Lo inicializamos por si no se eligio otro jugador del otro equipo
		SET @cant_de_jugadores_dest_zona_cate		= 0

		-- Obtenemos el id del club principal a hacer el intercambio
		SET @id_club_proveniente = (
										SELECT DISTINCT(i.Id_Club)
										FROM inserted i
									)
		-- Obtenemos el id del club secundario a hacer el intercambio
		SET @id_club_destino = (
									SELECT DISTINCT(d.Id_Club)
									FROM Deleted d
								)

		-- Obtenemos la cantidad de jugadores del equipo que provienen
		SET @cant_de_jugadores_int_proveniente = (
													SELECT COUNT(*)
													FROM inserted i
													WHERE i.Id_Club = @id_club_proveniente
												)
		
		-- Obtenemos la cantidad de jugadores del otro equipo
		SET @cant_de_jugadores_int_destino = (
												SELECT COUNT(*)
												FROM Inserted i
												WHERE i.Id_Club = @id_club_destino
											)
	
		-- Validamos que ambos equipos estén intercambiando la misma cantidad de jugadores
		IF (@cant_de_jugadores_int_proveniente <> @cant_de_jugadores_int_destino)
			BEGIN
				PRINT 'No se está realizando un intercambio con la misma cantidad de jugadores de ambos equipos.'
				SET @diferencia_de_jugadores = (@cant_de_jugadores_int_proveniente - @cant_de_jugadores_int_destino)
			END

		-- Obtenemos la cantidad de jugadores del club que provienen en función de su
		-- zona y categoria
		SET @cant_de_jugadores_prov_zona_cate = (
												SELECT MAX(cc.Cantidad)
												FROM (
														SELECT COUNT(i.Nrodoc) AS Cantidad, i.Categoria, c.Nrozona
														FROM Inserted i
														INNER JOIN Clubes c ON c.Id_Club = i.Id_Club
														WHERE 
															i.Id_Club = @id_club_proveniente
														GROUP BY c.Nrozona, i.Categoria
													) cc
												)

		-- Obtenemos la cantidad de jugadores del otro club en función de su
		-- zona y categoria
		SET @cant_de_jugadores_dest_zona_cate = (
												SELECT MAX(cc.Cantidad)
												FROM (
														SELECT COUNT(i.Nrodoc) AS Cantidad, i.Categoria, c.Nrozona
														FROM Inserted i
														INNER JOIN Clubes c ON c.Id_Club = i.Id_Club
														WHERE 
															i.Id_Club = @id_club_destino
														GROUP BY c.Nrozona, i.Categoria
													) cc
												)

		-- Verificamos que la cantidad de jugadores sea igual en ambos clubes por 
		-- zona y categoria
		if (@cant_de_jugadores_dest_zona_cate is null)
			BEGIN
				RAISERROR ('¡ATENCION! No se eligio un jugador del otro club', 16, 2)
			END

		IF (@cant_de_jugadores_prov_zona_cate <> @cant_de_jugadores_dest_zona_cate)
			BEGIN
				PRINT 'No son la misma cantidad de jugadores o no son de la misma zona y categoria'
			END

		-- Si la cantidad a intercambiar no es posible satisfacerla, se ajusta a la cantidad 
		-- correcta para realizar el intercambio.
		IF (@diferencia_de_jugadores > 0)
			BEGIN
				-- Identificamos de que club es el que tiene menos jugadores a intercambiar
				-- para realizar dicha operación
				DECLARE @equipo_a_buscar int
			
				-- La cantidad de jugadores del equipo principal es menor que la de destino
				-- con lo cual tendremos que buscar la cantidad de jugadores que faltan para
				-- equipararlo.
				IF (@cant_de_jugadores_int_proveniente < @cant_de_jugadores_int_destino)
					BEGIN
						SET @equipo_a_buscar = @id_club_proveniente
					END
				ELSE
					BEGIN
						SET @equipo_a_buscar = @id_club_destino
					END

				-- Generamos una variable para recorrer
				DECLARE @variable_i int
				SET @variable_i = 0

				-- Variable para indentificar el jugador
				DECLARE @jugador_intercambiar int;

				-- Recorremos hasta que la cantidad de jugadores que necesitaba encontrar
				WHILE (@variable_i < @diferencia_de_jugadores)
					BEGIN
						
						DECLARE @categoria_jugadores int
						DECLARE @nrodoc_jugador int

						-- Buscamos en que categoria se encontraba el jugador
						SET @categoria_jugadores = (
													SELECT DISTINCT(ii.Categoria)
													FROM (
															SELECT i.Categoria
															FROM Deleted i
															WHERE i.Id_Club = @equipo_a_buscar
														) ii
													)
						PRINT @categoria_jugadores

						-- Localizamos un jugador a traspazar que no esté seleccionado
						SET @nrodoc_jugador = (
												SELECT MAX(n.Nrodoc)
												FROM (
														SELECT DISTINCT(j.Nrodoc)
														FROM Jugadores j
														WHERE 
															j.Id_Club = @equipo_a_buscar
															AND j.Categoria = @categoria_jugadores
															AND NOT EXISTS (
																	SELECT *
																	FROM Inserted i
																	WHERE i.Nrodoc = j.Nrodoc
																)
														) n
												)
						PRINT @nrodoc_jugador
						-- Si el jugador a intercambiar es mayor a 0 (cero) significa que encontre
						-- uno para poder actualizarlo y así equiparar los equipos
						IF (@nrodoc_jugador > 0)
							BEGIN
								UPDATE Jugadores SET Id_Club = @id_club_destino WHERE Nrodoc = @nrodoc_jugador
							END
						ELSE
							BEGIN	
								RAISERROR ('¡ATENCION! No hay jugadores para poder hacer el intercambio', 16, 1)
								
								-- Forzamos a que salga del while ya que no hay jugadores
								SET @variable_i = @diferencia_de_jugadores 
								ROLLBACK TRANSACTION
							END

						-- Incrementamos en uno la variable para continuar
						SET @variable_i = @variable_i + 1
					END
					-- Eof while recorremos hasta que la cantidad de jugadores que necesitaba encontrar
			END
			-- Eof if si hay diferencia de jugadores entre ambos
	END
GO



/*
 * 2 - Resolver mediante la utilizacion de cursores
 **/
DECLARE @NroFecha 						int
DECLARE @cantidadDeGoles 				int
DECLARE @NroFecha_maximo 				int
DECLARE @cantidadDeGoles_maximo 		int
DECLARE @cantidad_de_goles_resultado 	int
DECLARE @nombre_del_club 				varchar(50)
DECLARE @Nrozona 						int 
DECLARE @cantidad_de_goles_zona 		int
DECLARE @cantidad_de_goles_zona_club	int
			
-- La instanciamos para poder comparar				
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
		-- Si la cantidad de goles es mayor a la cantidad encontrada lo actualizamos 
		-- la variable y la fecha
		IF (@cantidadDeGoles > @cantidadDeGoles_maximo)
			BEGIN
				SET @cantidadDeGoles_maximo = @cantidadDeGoles
				SET @NroFecha_maximo = @NroFecha
			END

		FETCH NEXT FROM cu1037546_a INTO @cantidadDeGoles, @NroFecha
	END
-- Eof while 

CLOSE cu1037546_a
DEALLOCATE cu1037546_a

-- Una vez encontrada la fecha con mayor cantidad de goles buscamos sus datos para mostrarlos
DECLARE cu1037546_a_res CURSOR SCROLL FOR
	SELECT SUM(p.GolesL + p.GolesV) AS cantidad
	FROM Partidos p
	WHERE p.NroFecha = @NroFecha_maximo
	GROUP BY p.NroFecha

OPEN cu1037546_a_res

FETCH FIRST FROM cu1037546_a_res INTO @cantidad_de_goles_resultado

-- Si hay resultado entonces vamos a mostrar la fecha con la cantidad de goles
IF (@@FETCH_STATUS = 0)
	BEGIN
		PRINT 'Nº fecha: ' + convert(varchar(5), @NroFecha_maximo) + ' | Cantidad de goles: (total de la fecha) ' + convert(varchar(5), @cantidad_de_goles_resultado)
	END

CLOSE cu1037546_a_res
DEALLOCATE cu1037546_a_res


-- Creamos una tabla con los datos de la zona y la cantidad de goles.
DECLARE cu1037546_b_zona CURSOR FOR
	SELECT c.Nrozona, SUM(p.GolesL + p.GolesV) 
	FROM Clubes c
	INNER JOIN Partidos p ON (p.Id_ClubL = c.Id_Club OR p.Id_ClubL = c.Id_Club)
	GROUP BY c.Nrozona

OPEN cu1037546_b_zona

FETCH NEXT FROM cu1037546_b_zona INTO @Nrozona, @cantidad_de_goles_zona

-- Recorremos hasta que no tengamos más datos en nuestro cursor
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT '-----------------------------------------------------------------'
		PRINT 'Goles de la zona ' + convert(varchar(5), @Nrozona) + ' | Cantidad de goles (total de la zona) ' +  convert(varchar(5), @cantidad_de_goles_zona)
		PRINT ' '
		-- Generamos un nuevo cursor para poder obtener los clubes con sus
		-- respectivos goles
		DECLARE cu1037546_b_zona_club CURSOR FOR
			SELECT c.Nombre, SUM(p.GolesL + p.GolesV) AS Cantidad
			FROM Clubes c
			INNER JOIN Partidos p ON (p.Id_ClubL = c.Id_Club OR p.Id_ClubL = c.Id_Club)
			WHERE c.Nrozona = @Nrozona
			GROUP BY c.Nombre
			ORDER BY Cantidad DESC

		OPEN cu1037546_b_zona_club
		FETCH NEXT FROM cu1037546_b_zona_club INTO @nombre_del_club, @cantidad_de_goles_zona_club

		-- Recorremos cada club de dicha zona pra poder mostrar su nombre
		-- y la cantidad de goles que realizo tanto de visitante como local
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				PRINT 'Nombre del Club: '+ convert(varchar(50), @nombre_del_club) + ' | Total de goles del club: ' + convert(varchar(5), @cantidad_de_goles_zona_club)
				FETCH NEXT FROM cu1037546_b_zona_club INTO @nombre_del_club, @cantidad_de_goles_zona_club
			END
		-- Eof while

		CLOSE cu1037546_b_zona_club
		DEALLOCATE cu1037546_b_zona_club

		FETCH NEXT FROM cu1037546_b_zona INTO @Nrozona, @cantidad_de_goles_zona
	END
-- Eof while
CLOSE cu1037546_b_zona
DEALLOCATE cu1037546_b_zona

GO


/**
 * 3)
 **/
CREATE FUNCTION fn1037546_fecha_mayor_victorias ()
RETURNS INT
AS
	BEGIN
		DECLARE @fecha int 
		SET @fecha = (
				SELECT MAX(p.Cantidad)
				FROM (
							SELECT COUNT(*) as Cantidad, pp.NroFecha 
							FROM Partidos pp 
							WHERE 
								pp.NroZona = 1 
								AND pp.GolesL < pp.GolesV
								AND pp.Categoria = 85 
							GROUP BY pp.NroFecha
					) p
			)
		RETURN @fecha
	END
GO

DECLARE @fecha int;   
EXEC @fecha = fn1037546_fecha_mayor_victorias
PRINT 'Fecha Número: ' + convert(varchar(5), @fecha)


BEGIN TRAN
	-- Quitamos un gol
	UPDATE partidos SET GolesV = GolesV - 1 WHERE (NroFecha = DBO.fn1037546_fecha_mayor_victorias()) AND (Categoria = 85)

	IF (@@error <> 0)
		BEGIN
			RAISERROR('Hubo un problema a la hora de actualizar los partidos.', 16, 1)
			ROLLBACK TRAN
			RETURN
		END

	SAVE TRAN Actualizar

	-- Inicializamos todo para poder hacer los calculos pertinentes
	UPDATE Poscate185 SET Ganados = 0, Empatados = 0, perdidos = 0, GolesF = 0, golesc = 0

	-- Actualizamos los Locales
	UPDATE Poscate185 SET 
		Ganados = Ganados + (
							SELECT COUNT(Id_ClubL) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubL = Poscate185.Id_Club 
								AND GolesL > GolesV
							),
		Empatados = Empatados + (
								SELECT COUNT(Id_ClubL) 
								FROM Partidos 
								WHERE 
									Categoria = 85 
									AND Id_ClubL = Poscate185.Id_Club 
									AND GolesL = GolesV
								),
		Perdidos = Perdidos + (
								SELECT COUNT(Id_ClubL) 
								FROM Partidos 
								WHERE 
									Categoria = 85 
									AND Id_ClubL = Poscate185.Id_Club 
									AND GolesL < GolesV
								),
		GolesF = GolesF + (
							SELECT SUM(Golesl) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubL = Poscate185.Id_Club 
							),
		GolesC = GolesC + (
							SELECT SUM(GolesV) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubL = Poscate185.Id_Club 
							)

	IF (@@error <> 0)
		BEGIN
			RAISERROR('Error al actualizar los datos para la tabla Poscate185 / Locales',16,2)
			ROLLBACK TRAN
			RETURN
		End

	-- Actualizamos los visitantes
	UPDATE Poscate185 SET 
		Ganados = Ganados + (
							SELECT COUNT(Id_ClubV) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubV = Poscate185.Id_Club 
								AND GolesV > GolesL
							),
		Empatados = Empatados + (
								SELECT COUNT(Id_ClubV) 
								FROM Partidos 
								WHERE 
									Categoria = 85 
									AND Id_ClubV = Poscate185.Id_Club 
									AND GolesV = GolesL
								),
		Perdidos = Perdidos + (
								SELECT COUNT(id_clubV) 
								FROM Partidos 
								WHERE 
									Categoria = 85 
									AND Id_ClubV = Poscate185.Id_Club 
									AND GolesV < GolesL
								),
		GolesF = GolesF + (
							SELECT SUM(GolesV) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubV = Poscate185.Id_Club 
							),
		GolesC = GolesC + (
							SELECT SUM(GolesV) 
							FROM Partidos 
							WHERE 
								Categoria = 85 
								AND Id_ClubV = Poscate185.Id_Club 
							)

	IF (@@error <> 0)
		BEGIN
			RAISERROR('Error al actualizar los datos para la tabla Poscate185 / Visitantes', 16, 3)
			ROLLBACK TRAN
			RETURN
		END

	-- Efectuamos la diferencia de Puntos y goles obtenidos
	UPDATE Poscate185 SET Diferencia = (GolesF - GolesC), Puntos = (Ganados * 3) + (Empatados * 1)

	IF (@@error <> 0)
		Begin
			RAISERROR('Error al actualizar los datos para la tabla Poscate185 / Diferencia de Goles y los puntos obtenidos', 16, 4)
			ROLLBACK TRAN
			RETURN
		End
	
	ROLLBACK TRAN Actualizar

COMMIT TRAN
