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

