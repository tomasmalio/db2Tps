--CURSORES
--6.1. Definir un Cursor:
--Que liste la ficha de los pacientes de los últimos seis meses conforme al siguiente formato de salida:
--Datos del paciente.
--Identificación del médico.
--Detalle de los estudios realizados.

DECLARE @dni varchar(8), @nombre varchar(50), @apellido varchar(50),@sexo char(1),@matricula_medico smallint
DECLARE lista_pacientes CURSOR 
FOR Select p.dni, p.nombre, p.apellido, p.sexo, r.matricula_medico
from dbo.Registro r inner join paciente p on r.dni_paciente= p.dni where datediff(MM, r.fecha_estudio, getdate())<=6

OPEN lista_pacientes
FETCH NEXT FROM lista_pacientes into @dni , @nombre , @apellido ,@sexo ,@matricula_medico 
WHILE @@FETCH_STATUS = 0
   BEGIN
			PRINT @dni +' - '+ @nombre +' - '+ @apellido +' - '+ @sexo +' - '+ convert(varchar(50),@matricula_medico)
	       FETCH NEXT FROM lista_pacientes 
   END
CLOSE lista_pacientes
DEALLOCATE lista_pacientes



--6.2. Definir un Cursor:
--Que liste el detalle de los planes que cubren un determinado estudio identificando el porcentaje cubierto y la obra social, según formato:
--Estudio.
--Obra social.
--Plan y Cobertura (ordenado en forma decreciente).
--select * from Planes p join Plan_Estudio pe on p.id = pe.id_plan join Estudio e on e.id = pe.id_estudio

   DECLARE @nombre_estudio varchar(50), @id_os smallint, @id_plan smallint, @cobertura decimal(3,0)

   DECLARE Cursor_planes CURSOR FORWARD_ONLY READ_ONLY
   FOR select e.nombre_estudio, p.id_obra_social, p.id,pe.cobertura from Planes p join Plan_Estudio pe on p.id = pe.id_plan join Estudio e on e.id = pe.id_estudio
   OPEN Cursor_planes
   FETCH NEXT FROM Cursor_planes INTO @nombre_estudio, @id_os, @id_plan, @cobertura 
   
   IF @@FETCH_STATUS <> 0 
        PRINT 'NO TIENE planes que cubren un determinado estudio'
   ELSE
        PRINT '==  TIENE planes que cubren un determinado estudio =='     
	
	DECLARE @mensaje varchar(255)
   WHILE @@FETCH_STATUS = 0
   BEGIN
	print @nombre_estudio + convert(varchar(25),@id_os) +','+  convert(varchar(25),@id_plan) +','+  convert(varchar(3),@cobertura) 
     
      FETCH NEXT FROM Cursor_planes INTO @nombre_estudio, @id_os, @id_plan, @cobertura 
   END

   CLOSE Cursor_planes
   DEALLOCATE Cursor_planes
   GO


-- 6.3.  Crear una StoredProcedure que defina un Cursor:
--Que liste el resumen mensual de los importes a cargo de una obra social.
--INPUT: nombre de la obra social, mes y año a liquidar.
--Obra social
--Nombre del Instituto
--Detalle del estudio
--Subtotal del Instituto
--Total de la obra social

create procedure sp_cursor_resumen_mensual @nombre_obra_social varchar(50),@mes int,@anio int
as

 DECLARE @nombre_instituto varchar(50),@detalle_estudio varchar(50), @nombre_os varchar(50), @subtotalinstituo decimal(10), @totalOS decimal(10) = 0

   DECLARE Cursor_resumen CURSOR FORWARD_ONLY READ_ONLY
   FOR select i.nombre_instituto ,e.nombre_estudio,o.nombre,sum(precio)as[subtotal x instituto] from ObraSocial o join Planes p on p.id_obra_social=o.id
join Plan_Estudio pe on pe.id_plan = p.id
join Instituto_Estudio ie on ie.id_estudio = pe.id_estudio
join Estudio e on ie.id_estudio= e.id join Instituto i on i.id = ie.id_instituto
join Registro r on r.id_estudio = e.id
where o.nombre=@nombre_obra_social and datepart(mm, r.fecha_estudio) = @mes and datepart(YY, fecha_estudio) = @anio group by i.nombre_instituto,o.nombre,e.nombre_estudio
   OPEN Cursor_resumen
   FETCH NEXT FROM Cursor_resumen INTO @nombre_instituto, @detalle_estudio, @nombre_os, @subtotalinstituo
   
   IF @@FETCH_STATUS <> 0 
        PRINT 'NO TIENE planes que cubren un determinado estudio'
   ELSE
        PRINT '==  TIENE planes que cubren un determinado estudio =='     
	
	DECLARE @mensaje varchar(255)
   WHILE @@FETCH_STATUS = 0
   BEGIN
  set @totalOS = convert(varchar(50),@subtotalinstituo) + @totalOS
		PRINT @nombre_instituto
		PRINT @detalle_estudio
		PRINT @nombre_os
		PRINT convert(varchar(50),@subtotalinstituo)
		
	
     FETCH NEXT FROM Cursor_resumen INTO @nombre_instituto, @detalle_estudio, @nombre_os, @subtotalinstituo
   END
   PRINT 'El total de la OS fue :'+convert(varchar(50),@totalOS)
   CLOSE Cursor_resumen
   DEALLOCATE Cursor_resumen
   GO

   EXEC sp_cursor_resumen_mensual 'OSDE',5,2017




