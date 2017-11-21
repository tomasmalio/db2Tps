/* 7. TRANSACCIONES */

/* 7.1. Definir una transacción para modificar la sigla y el nombre de una obra social que se inicie desde una stored procedure
que recibe los parámetros de la obra social a modificarse.
	INPUT: sigla anterior, sigla nueva, nombre nuevo.
	RETURN: código de error.
	Se debe actualizar en cadena todas las tablas afectadas al proceso.
	En caso de error se anulará la transacción presentando el mensaje correspondiente y devolviENDo un código de error.
	Modificar en caso de ser necesaria la definición de los atributos de las tablas que impidan la ejecución de la transacción.
*/

CREATE PROCEDURE [sp_ObraSocial_UpdateSiglaNombre]
	@sigla_vieja varchar(8),
	@sigla_nueva varchar(8),
	@descripcion varchar (70)
AS
BEGIN
	BEGIN TRANSACTION
		DECLARE @categoria varchar(2)
		SET @categoria = (select categoria from OOSS where sigla = @sigla_vieja)

		INSERT INTO ObraSocial(sigla, nombre, categoria) VALUES (@sigla_nueva, @descripcion, @categoria)
		IF(@@error<>0)
			ROLLBACK TRANSACTION

		--Elimino la Obra Social anterior
		DELETE FROM ObraSocial
			WHERE sigla = @sigla_vieja
		IF(@@error<>0)
			ROLLBACK TRANSACTION

		COMMIT TRANSACTION

	RETURN @@error
END

/* 
	7.2. Definir una transacción que elimine de la Base de Datos a un paciente.
	Se anidarán las stored procedures que se necesiten para completar la transacción, que debe incluir los siguientes procesos:
	Eliminar triggerasociado a la tabla historias para la acción de DELETE, previa verificación de existencia del mismo.
	Volver a afectar dicho trigger al finalizar el proceso de eliminación.
	Crear las tablas ex_pacientes y ex_historias (si no existen) y grabar los datos intervinientes en la eliminación.
	(los datos correspondientes a la afiliación del paciente se eliminan pero no se registran). Incluir en la tabla ex_pacientes 
	la registración del usuario que invocó la transacción y la fecha.
	Se deben eliminar en cadena todas las tablas afectadas al proceso, en caso de error se anulará la transacción presentando el 
	mensaje correspondiente y devolviENDo un código de error.
*/

CREATE PROCEDURE sp_paciente
	@dni_paciente dni
AS
BEGIN
	BEGIN transaction
		IF (NOT EXISTS (SELECT * FROM sys.tables as tabla
			WHERE tabla.name = 'ex_pacientes'))
			BEGIN
				CREATE TABLE ex_pacientes (
					ex_Paciente_dni dni not null,
					ex_paciente_nombre varchar(80),
					ex_paciente_apellido varchar(80),
					usuario varchar(80),
					fecha date
				)
			END
		if(@@error <> 0)
			BEGIN
				rollback tran
			END
		ELSE
			BEGIN
				commit
			END
	
	SELECT * FROM Registro

	BEGIN transaction
		IF(NOT EXISTS (SELECT * FROM sys.tables tabla
			WHERE tab.name = 'ex_registros'))
			BEGIN
				CREATE TABLE ex_registros (
					ex_fecha_estudio date,
					ex_id_estudio id,
					ex_id_instituto id,
					ex_matricula_medico id,
					ex_id_obra_social id,
					ex_id_paciente id,
					ex_Pagado pagado,
					exResultado varchar(50),
					exAbonado bit
				)
			END
		IF (@@error <> 0)
			BEGIN
				rollback tran
			END
		ELSE
			BEGIN
				commit
			END
			
	
	DECLARE cr_paciente_to_DELETE cursor scroll
	for
		SELECT pa.dni, pa.nombre, pa.apellido FROM Paciente as pa
		WHERE pa.dni = @dniPac
	
	DECLARE @dni dni, @nombre varchar(20), @apellido varchar(20)
	
	open cr_paciente_to_DELETE
	
	fetch next FROM cr_paciente_to_DELETE
	into @dni, @nombre, @apellido
	while @@fetch_status = 0
		BEGIN
			insert into ex_pacientes values (@dni, @nombre, @apellido, CURRENT_USER, cast(getdate() as varchar))
			fetch next FROM cr_paciente_to_DELETE
			into @dni, @nombre, @apellido
		END
	close cr_paciente_to_DELETE
	deallocate cr_paciente_to_DELETE
	
	DECLARE @idPacienteABorrar id

	SELECT @idPacienteABorrar = pa.idPaciente
	FROM Paciente as pa
	WHERE pa.dni = @dni

	DELETE Paciente_PlanB
	WHERE idPaciente = @idPacienteABorrar

	DELETE Paciente
	WHERE idPaciente = @idPacienteABorrar
	
	DECLARE cr_historial_to_DELETE cursor scroll
	for
		SELECT re.fecha, re.idEstudio, re.idInstituto, re.idMedico, re.idObraSocial, re.idPaciente, re.idRegistro, re.pago, re.resultado FROM Registro as re
		WHERE re.idPaciente = @idPacienteABorrar
	
	DECLARE @fecha date, @idEstudio id, @idInstituto id, @idMedico id, @idObraSocial id, @idPaciente id, @pago float, @resultado varchar(50), @abonado bit

	open cr_historial_to_DELETE
	
	fetch next FROM cr_historial_to_DELETE
	into @fecha, @idEstudio, @idInstituto, @idMedico, @idObraSocial, @idPaciente, @pago, @resultado, @abonado
	while(@@fetch_status = 0)
		BEGIN
			insert into ex_registros values (@fecha, @idEstudio, @idInstituto, @idMedico, @idObraSocial, @idPaciente, @pago, @resultado, @abonado)
			fetch next FROM cr_historial_to_DELETE
			into @fecha, @idEstudio, @idInstituto, @idMedico, @idObraSocial, @idPaciente, @pago, @resultado, @abonado
		END

	close cr_historial_to_DELETE
	deallocate cr_historial_to_DELETE
	
	DELETE Registro
	WHERE Registro.idPaciente = @idPacienteABorrar
END


create procedure sp_eliminar_paciente
@dniPaciente dni
as
BEGIN
	BEGIN transaction
		ALTER TABLE registro DISABLE TRIGGER historias_pacientes

		if(@@error <> 0)
			BEGIN
				RAISERROR ('Error en deshabilitar el trigger', 16, 1)
				ROLLBACK TRAN
				return
			END
	
		BEGIN transaction
			exec sp_DELETE_paciente @dniPaciente
		
			if(@@error <> 0)
				BEGIN
					RAISERROR ('Error en DELETE de paciente', 16, 1)
					ROLLBACK TRAN
					return
				END
		
			BEGIN transaction
				ALTER TABLE registro ENABLE TRIGGER historias_pacientes
			
				if(@@error <> 0)
					BEGIN
						RAISERROR ('Error en activar el trigger', 16, 1)
						ROLLBACK TRAN
						return
					END
			
	while(@@TRANCOUNT <> 0)
		BEGIN
			COMMIT
		END
END



/*7.3. Definir una transacción que elimine lógicamente de la Base de Datos a todos los médicos de una determinada especialidad.
Se anidarán las stored procedures que se necesiten para completar la transacción, que debe tener en cuenta lo siguiente:
La eliminación del médico debe ser lógica conforme al trigger asociado a la acción de DELETE. (TP5)
No se realizará la eliminación del médico si el mismo posee otra especialidad.
Las historias no serán eliminadas.
Crear una tabla temporaria donde se registrarán las referencias a los médicos e historias que intervinieron en el proceso.
Emitir un listado de los datos involucrados en el proceso (grabados en la tabla temporaria), según el siguiente formato:
Usuario responsable
ELIMINACION DE MEDICOS DE LA ESPECIALIDAD X
Dr(a) Nombre Apellido
Fecha y estudio que indicó
Total de estudios
En caso de error se anulará la transacción presentando el mensaje correspondiente (Un error en la emisión del listado no debe 
anular la transacción de eliminación).*/
