/**
 * 1) Correlacionadas
 * Crear un store procedure sp###### que reciba la posición del número de
 * documento más alto de los jugadores de cada club.
 * (Ej.: el 3 número de documento más alto)
 * 	+ Devolver el nombre del club y el documento y nombre del jugador 
 * 	+ Ejecutar el store procedure y mostrar el resultado
 *
 **/
CREATE PROCEDURE sp107878 (@nm int)
AS 
	SELECT c.nombre, j.Nrodoc, j.nombre 
	FROM Jugadores j 
	INNER JOIN Clubes c ON c.id_club = j.id_club
	WHERE @nm = (
					SELECT COUNT (*) 
					FROM Jugadores jj 
					WHERE 
						jj.id_club = j.id_club
						AND jj.nrodoc > j.nrodoc
				)

exec sp107878 1


/**
 * 2) Función
 * Definir una función fn###### que:
 * 	+ Reciba la categoria, la zona y el número de fecha de los partidos.
 * 	+ Retomar el resultado de los partidos (nombre del club local, nombre del
 * 	club visitante, goles del local y goles del visitante), para esa fecha,
 * 	zona y categoria.
 * + Debe estar ordenado por club local (no usar modificador Top)
 * + Ejecutar la función y mostrar el resultado
 *
 **/

CREATE FUNCTION fn107878 (@categoria tinyint, @nrozona tinyint, @NroFecha tinyint)
RETURNS TABLE
AS
	RETURN ( 
			SELECT cv.nombre AS 'Nombre de Visitante', cl.nombre AS 'Nombre de Local', p.golesl AS 'Goles Local', p.golesV AS 'Goles Visitante'
			FROM Partidos p 
			INNER JOIN Clubes cv ON p.id_clubv = cv.Id_Club
			INNER JOIN Clubes cl ON p.id_clubl = cl.Id_Club
			WHERE 
				p.Categoria = @categoria 
				AND p.nrozona = @nrozona
				AND p.NroFecha = @NroFecha
			ORDER BY cl.Id_Club ASC
	)
GO

SELECT * FROM fn107878(84,2,7)


/**
 * 3) Transacciones
 * Crear un store procedure st###### que reciba una categoria como
 * parámetro y que defina los siguientes pasos en una transacción:
 * 	+ Crear una tabla tb###### (idClub, cantJugadores, cantSuplentes)
 * 	+ Insertar los idClub y cantidad de jugadores de la categoría que sean
 * 	menores a 30 y 4 suplentes a los clubes de la zona 1 
 * 	+ Mostrar los mensajes de error utilizando la función raiserror.
 * + Ejecutar la transacción
 *
 **/

CREATE PROCEDURE st107878 
   @categoria tinyint
AS 
	BEGIN TRANSACTION Creartabla
		CREATE TABLE tb107878 ( 
			idClub smallint not null primary key, 
			cantJugadores int not null, 
			cantSuplentes int not null
		)

		INSERT INTO tb107878
			SELECT c.id_club, COUNT(*), 4
			FROM Jugadores j 
			INNER JOIN Clubes c ON c.id_club = j.id_club
			WHERE 
				nrozona = 2 
				AND categoria = 84 
				AND 30 >  (
							SELECT COUNT(*)
							FROM Jugadores jj
							WHERE jj.id_club = j.id_club
						)
				GROUP BY c.id_club
	
		IF (NOT EXISTS (SELECT * FROM tb107878))
			BEGIN
				RAISERROR ('No hay datos', 16, 1)
			END
	
	COMMIT TRANSACTION Creartabla
GO

exec st107878  85


/**
 * 4) Trigger
 * Definir un trigger tr###### a la tabla creada tb###### para que se accione si
 * se ejecuta un update
 * 	+ Debe actualizar únicamente el campo cantSuplentes si es menor o igual a 4
 * 	+ Mostrar un mensaje de sentencia no realizada en caso contrario
 *
 **/
CREATE TRIGGER tr107878
ON tb107878
AFTER UPDATE
AS 
	IF ((SELECT cantSuplentes FROM Inserted) > 4)
	    BEGIN
	        PRINT 'Sentencia no realizada, disculpe las molestias, no cumple con los requisitos'
	        ROLLBACK TRANSACTION
	    END
GO

UPDATE tb107878 SET cantSuplentes = 5

/*
 * 5) Cursores
 * Definir un cursor que actualice automáticamente el campo Tipodo de la tabla
 * Jugadores. Respetando las siguientes condiciones:
 * + Si Tipodoc es igual a CPA modificar a PPA
 * + Si Tipodoc es igual a PB modificar a PBA
 * + Caso contrario no se modifica
 * + Mostrar nuevo Tipodoc y Nrodoc de las filas modificadas
 * + Mostrar el mensaje: 'Cantidad de actualizaciones XX'
 *
 **/

DECLARE @contador int
DECLARE @tipodoc char(3)

SET @contador = 0
DECLARE cu107878 CURSOR FORWARD_ONLY 
FOR
SELECT Tipodoc FROM Jugadores
FOR
UPDATE of Tipodoc 

OPEN cu107878

FETCH NEXT FROM cu107878 INTO @tipodoc


IF (@tipodoc = 'CPA')
	BEGIN
		UPDATE Jugadores SET Tipodoc = 'PPA' WHERE CURRENT OF cu107878
	END
ELSE
	IF (@tipodoc = 'PB')
		BEGIN
			UPDATE Jugadores SET Tipodoc = 'PBA' WHERE CURRENT OF cu107878
		END
	ELSE
		BEGIN
			PRINT 'No se modifico nada'
		END

SET @contador = @contador + 1 

FETCH NEXT FROM cu107878 INTO @tipodoc

WHILE @@FETCH_STATUS = 0
	BEGIN
		if (@tipodoc  = 'CPA')
			BEGIN
				UPDATE jugadores SET Tipodoc = 'PPA' WHERE CURRENT OF cu107878
			END
		else
			BEGIN
				IF (@tipodoc = 'PB')
					BEGIN
						UPDATE Jugadores SET Tipodoc = 'PBA' WHERE CURRENT OF cu107878
					END
				ELSE
					BEGIN
						PRINT 'No se modifico nada'
					END
			END
		SET @contador = @contador + 1 
	END

PRINT @contador

CLOSE cu107878
DEALLOCATE cu107878

GO

SELECT * FROM Jugadores