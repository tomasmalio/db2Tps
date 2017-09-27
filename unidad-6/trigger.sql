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
