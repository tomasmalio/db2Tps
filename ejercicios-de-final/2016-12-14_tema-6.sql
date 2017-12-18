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

declare @contador int
declare @tipodoc char(3)
set @contador = 0
DECLARE cu107878 CURSOR FORWARD_ONLY 
FOR
SELECT tipodoc FROM jugadores
for
UPDATE of tipodoc 

OPEN cu107878

FETCH NEXT FROM cu107878 INTO @tipodoc


if (@tipodoc  = 'Cpa')
UPDATE jugadores SET tipodoc = 'PPA'
WHERE CURRENT OF cu107878

else
	if (@tipodoc = 'PB')
	UPDATE jugadores SET tipodoc = 'PBA'
	WHERE CURRENT OF cu107878

	else
		print 'no se modifico nada'

set @contador = @contador + 1 
FETCH NEXT FROM cu107878 INTO @tipodoc
WHILE @@FETCH_STATUS = 0
begin
	if (@tipodoc  = 'Cpa')
UPDATE jugadores SET tipodoc = 'PPA'
WHERE CURRENT OF cu107878

else
	if (@tipodoc = 'PB')
	UPDATE jugadores SET tipodoc = 'PBA'
	WHERE CURRENT OF cu107878

	else
		print 'no se modifico nada'

set @contador = @contador + 1 
end
print @contador
CLOSE cu107878
DEALLOCATE cu107878
GO


select * from jugadores