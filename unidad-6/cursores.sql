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
