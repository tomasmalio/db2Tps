/*Ejercicio 1*/


CREATE PROCEDURE sp107878 
   @nm int
AS 
	select c.nombre,j.Nrodoc,j.nombre 
	from jugadores j inner join clubes c on  c.id_club = j.id_club
	where @nm = (select count (*)
		     from jugadores as jj 
		     where jj.id_club = j.id_club
		     and jj.nrodoc > j.nrodoc)

exec sp107878 1


/*Ejercicio 2*/

alter function fn107878 (@categoria tinyint,@nrozona tinyint,@NroFecha tinyint)
RETURNS TABLE
AS
RETURN ( 

SELECT cv.nombre as 'Nombre de Vicitante',cl.nombre as 'Nombre de Local',p.golesl,p.golesV
FROM   partidos p inner join clubes cv on p.id_clubv = cv.id_club
       inner join clubes cl on p.id_clubl = cl.id_club
WHERE  categoria = @categoria and p.nrozona =@nrozona and @NroFecha = NroFecha

)

SELECT * FROM fn107878(84,2,7)


/*Ejercicio 3*/ 

alter PROCEDURE st107878 
   @categoria tinyint
AS 

	BEGIN TRANSACTION Creartabla
		create table tb107878
		( idClub smallint not null primary key, 
  		  cantJugadores int not null, 
  		  cantSuplentes int not null
		 )
		insert into tb107878
			select c.id_club,count(*),4
			from jugadores j inner join 
			clubes c on c.id_club = j.id_club
			where nrozona = 2 and categoria = 84 and 30 > 
				(select count (*)
	    	 		from jugadores jj
	    			where jj.id_club = j.id_club)
			group by c.id_club
	
	if (not exists(select * from tb107878))
	RAISERROR ('no hay datos',16,1)
	
	commit TRANSACTION Creartabla


		

exec st107878  85

/*Ejercicio 4*/


CREATE TRIGGER tr107878
ON tb107878
AFTER update
AS 
IF ((Select cantSuplentes from inserted) > 4)
    BEGIN
        PRINT 'Sentencia no realizada, disculpe las molestias'
        ROLLBACK TRANSACTION
    END
GO

update tb107878
	set cantSuplentes = 5

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
SELECT Tipodoc FROM jugadores
FOR
UPDATE of tipodoc 

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