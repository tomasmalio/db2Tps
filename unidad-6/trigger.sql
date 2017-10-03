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

--4.14. Crear un Trigger:
/*Que determine el número de plan correspondiente al plan de la obra social cada vez que se
registre uno nuevo en la Base de Datos. El número de plan se calcula en forma correlativa a los
ya existentes para esa obra social, comenzando con 1 (uno) el primer plan que se ingrese a
cada obra social o prepaga.*/

CREATE TRIGGER tr_nro_planes
ON Planes
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @nuevoNroPlan INT
	SET @nuevoNroPlan = (SELECT MAX(id) FROM Planes WHERE id_obra_social = (SELECT id_obra_social FROM Inserted)) + 1
	INSERT INTO Planes (id, id_obra_social, estado)
						(SELECT @nuevoNroPlan, id_obra_social, estado FROM Inserted)
END
GO

--4.15. Crear un Trigger:
--Que muestre el valor anterior y el nuevo valor de cada columna que se actualizó en la tabla pacientes. 

CREATE TRIGGER tr_valores_actualizados
ON Paciente
FOR UPDATE
AS
declare @dni_ant varchar(8), @dni_nuevo varchar(8)
declare @nombre_ant varchar(50), @nombre_nuevo varchar(50)
declare @apellido_ant varchar(50), @apellido_nuevo varchar(50)
declare @sexo_ant char (1),@sexo_nuevo char (1)
declare @fecha_nac_ant date,@fecha_nac_nuevo date
IF ((SELECT COUNT(*) FROM deleted)=1)
	BEGIN
		SET @dni_ant=(SELECT dni FROM deleted)
		SET @nombre_ant=(SELECT nombre FROM deleted)
		SET @apellido_ant=(SELECT apellido FROM deleted)
		SET @sexo_ant=(SELECT sexo FROM deleted)
		SET @f_nac_ant=(SELECT fecha_nacimiento FROM deleted)
		SET @dni_nuevo=(SELECT dni FROM inserted)
		SET @nombre_nuevo=(SELECT nombre FROM inserted)
		SET @apellido_nuevo=(SELECT apellido FROM inserted)
		SET @sexo_nuevo=(SELECT sexo FROM inserted)
		SET @f_nac_nuevo=(SELECT fecha_nacimiento FROM inserted)
	
	IF (@dni_ant <> @dni_nuevo)
	PRINT 'DNI anterior: '+ @dni_ant +' DNI nuevo '+ @dni_nuevo 
	IF (@nombre_ant <> @nombre_nuevo)
	PRINT 'NOMBRE anterior: ' + @nombre_ant + ' NOMBRE nuevo: '+@nombre_nuevo
	IF (@apellido_ant <> @apellido_nuevo)
	PRINT 'APELLIDO anterior: '+ @apellido_ant +' APELLIDO nuevo: '+@apellido_nuevo
	IF (@sexo_ant <> @sexo_nuevo)
	PRINT 'SEXO anterior: '+ @sexo_ant + ' SEXO nuevo: '+ @sexo_nuevo
	IF (@f_nac_ant <> @f_nac_nuevo)
	PRINT 'FECHA NACIMIENTO anterior: '+ @f_nac_ant + ' FECHA NACIMIENTO nuevo: '+ @f_nac_nuevo
END
GO

--4.16. Crear un Trigger:
--Que controle que un médico no indique un estudio a un paciente que no sea afín con la especialidad del médico.

CREATE TRIGGER tr_medico_especialidad_estudio
ON Registro
FOR INSERT
AS
declare @matricula INT, @idEstudio INT
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

--4.17. Crear un Trigger:
--Que controle que todas las historias que correspondan al estudio que hace referencia en ese instituto, se encuentran
--pagadas para poder permitir que se modifique el precio del estudio.

CREATE TRIGGER tr_modificar_precio_estudio
ON Instituto_Estudio
INSTEAD OF UPDATE
AS
BEGIN
	IF EXISTS (SELECT id_estudio FROM Registro WHERE pagado = 'No' AND id_estudio = (SELECT id_estudio FROM Inserted))
		PRINT 'No puede modificar el precio porque hay estudios impagos'
	ELSE
		UPDATE Instituto_Estudio SET precio = (SELECT precio FROM Inserted) 
		WHERE id_estudio = (SELECT id_estudio FROM Inserted) AND id_instituto = (SELECT id_insituto FROM Inserted)	
END
GO
