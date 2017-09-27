
/**
 * Borrar medicos
 **/
CREATE TRIGGER tr_del_medicos 
	ON Medicos
	INSTEAD OF DELETE
	AS 
		UPDATE Medicos SET activo = 0
		WHERE matricula IN (SELECT matricula FROM deleted)
	GO
	