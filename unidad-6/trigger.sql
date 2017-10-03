--TRIGGERS

--4.12. Crear un Trigger:
--Que indique con un mensaje que no se permite eliminar las historias de los pacientes.

CREATE TRIGGER tr_eliminar_registros 
ON Registro
FOR DELETE
AS
IF ((SELECT COUNT(*) FROM deleted)>= 1)
        PRINT 'No se pueden ELIMINAR Historias de Pacientes'
        ROLLBACK TRANSACTION
GO

DELETE FROM Registro
WHERE dni_paciente='38524799'
GO

--4.13. Crear un Trigger:
--Que modifique la condición de médico activo sin eliminarlo.
--El trigger no debe permitir eliminar a un médico, se lo debe registrar como inactivo

CREATE TRIGGER tr_eliminar_medicos 
	ON Medicos
	INSTEAD OF DELETE
	AS 
		UPDATE Medicos SET activo = 'inactivo'
		WHERE matricula IN (SELECT matricula FROM deleted)
	GO

DELETE FROM Medico
WHERE nombre_medico = 'Juan'

--4.14. Crear un Trigger: (Corregir) 
/*Que determine el número de plan correspondiente al plan de la obra social cada vez que se
registre uno nuevo en la Base de Datos. El número de plan se calcula en forma correlativa a los
ya existentes para esa obra social, comenzando con 1 (uno) el primer plan que se ingrese a
cada obra social o prepaga.*/

CREATE TRIGGER tr_nro_planes
ON Planes
INSTEAD OF INSERT 
AS
declare @sigla sigla
declare @nombre varchar (30)
declare @activo bit
set @sigla=(select sigla from inserted)
set @nombre=(select nombre from inserted)
set @activo=(select activo from inserted)
if (exists (select * from ooss where sigla=@sigla) and not exists 
	(select * from planes where nombre=@nombre))
	begin
		declare @nro smallint
		set @nro = isnull ((select max (nroplan) from planes where sigla=@sigla),0)+1
		insert planes values (@sigla,@nro,@nombre,@activo)
	end
go

--4.15. Crear un Trigger: (Corregir)
--Que muestre el valor anterior y el nuevo valor de cada columna que se actualizó en la tabla pacientes. 

CREATE TRIGGER ValoresActualizados
ON pacientes
FOR UPDATE
as
declare @dni_ant dni,@dni_nuevo dni
declare @nombre_ant varchar(20), @nombre_nuevo varchar(20)
declare @apellido_ant varchar(25), @apellido_nuevo varchar(25)
declare @sexo_ant char (1),@sexo_nuevo char (1)
declare @f_nac_ant datetime,@f_nac_nuevo datetime
if ((select count(*) from deleted)=1)
	begin
		set @dni_ant=(select dni from deleted)
		set @nombre_ant=(select nombre from deleted)
		set @apellido_ant=(select apellido from deleted)
		set @sexo_ant=(select sexo from deleted)
		set @f_nac_ant=(select nacimiento from deleted)
		set @dni_nuevo=(select dni from inserted)
		set @nombre_nuevo=(select nombre from inserted)
		set @apellido_nuevo=(select apellido from inserted)
		set @sexo_nuevo=(select sexo from inserted)
		set @f_nac_nuevo=(select nacimiento from inserted)

	if (@dni_ant <> @dni_nuevo)
	print 'DNI anterior: '+ @dni_ant +' DNI nuevo '+ @dni_nuevo 
	if (@nombre_ant <> @nombre_nuevo)
	print 'NOMBRE anterior: ' + @nombre_ant + ' NOMBRE nuevo: '+@nombre_nuevo
	if (@apellido_ant <> @apellido_nuevo)
	print 'APELLIDO anterior: '+ @apellido_ant +' APELLIDO nuevo: '+@apellido_nuevo
	if (@sexo_ant <> @sexo_nuevo)
	print 'SEXO anterior: '+ @sexo_ant + ' SEXO nuevo: '+ @sexo_nuevo
	if (@f_nac_ant <> @f_nac_nuevo)
	print 'FECHA NACIMIENTO anterior: '+ @f_nac_ant + ' FECHA NACIMIENTO nuevo: '+ @f_nac_nuevo
end
go

--4.16. Crear un Trigger:
--Que controle que un médico no indique un estudio a un paciente que no sea afín con la especialidad del médico.

CREATE TRIGGER tr_medico_especialidad_estudio
ON Registro
FOR INSERT
AS
declare @matricula int, @idEstudio int
set @matricula= (select matricula_medido from inserted)
set @idEstudio=(select id_estudio from inserted)

if not exists (select * 
		from Medico_Especialidad a inner join Especialidad_Estudio b on 
		a.id_especialidad=b.id_especialidad 
		where
		a.id_medico = @matricula and b.id_estudio = @idEstudio )
	begin
		rollback transaction
		print 'El estudio indicado, no corresponde a la Especialidad del Medico que lo solicito'
	end

--4.17. Crear un Trigger: (Corregir)
--Que controle que todas las historias que correspondan al estudio que hace referencia en ese instituto, se encuentran
--pagadas para poder permitir que se modifique el precio del estudio.

CREATE TRIGGER tr_registros_pagados
ON precios
FOR update
as
if ((select count (*) from deleted)=1 )
begin
	if exists (select * from inserted i inner join historias h on
 	i.idEstudio=h.idEstudio and i.idInstituto=h.idInstituto and 
	h.pagado='si')
		begin
			rollback transaction 
			print 'El estudio al que se hace referencia no '
			print 'fue pagado por la totalidad de los pacientes del Instituto '	
			print 'Por tal motivo, su precio no puede ser actualizado'
	end
end
GO
