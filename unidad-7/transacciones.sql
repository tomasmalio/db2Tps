/* 7. TRANSACCIONES */

/* 7.1. Definir una transacción para modificar la sigla y el nombre de una obra social que se inicie desde una stored procedure
que recibe los parámetros de la obra social a modificarse.
INPUT: sigla anterior, sigla nueva, nombre nuevo.
RETURN: código de error.
Se debe actualizar en cadena todas las tablas afectadas al proceso.
En caso de error se anulará la transacción presentando el mensaje correspondiente y devolviendo un código de error.
Modificar en caso de ser necesaria la definición de los atributos de las tablas que impidan la ejecución de la transacción.*/

CREATE PROCEDURE trans_obrasocial
@siglaNueva sigla, 
@siglaAnterior sigla, 
@nombreNuevo varchar(80),
@error int OUTPUT

AS
BEGIN transaction
UPDATE ObraSocial SET nombre = @nombreNuevo, @sigla = @siglaNueva WHERE sigla = @siglaAnterior
IF (@@Error = 0)
	BEGIN
		SET @errorcito = @@ERROR
		commit transaction 
	END
ELSE
	BEGIN
		SET @error = @@ERROR
		rollback transaction
	END
RETURN



/*7.2. Definir una transacción que elimine de la Base de Datos a un paciente.
Se anidarán las stored procedures que se necesiten para completar la transacción, que debe incluir los siguientes procesos:
Eliminar triggerasociado a la tabla historias para la acción de delete, previa verificación de existencia del mismo.
Volver a afectar dicho trigger al finalizar el proceso de eliminación.
Crear las tablas ex_pacientes y ex_historias (si no existen) y grabar los datos intervinientes en la eliminación.
(los datos correspondientes a la afiliación del paciente se eliminan pero no se registran). Incluir en la tabla ex_pacientes 
la registración del usuario que invocó la transacción y la fecha.
Se deben eliminar en cadena todas las tablas afectadas al proceso, en caso de error se anulará la transacción presentando el 
mensaje correspondiente y devolviendo un código de error.*/

CREATE PROCEDURE sp_paciente
@dniPac dni
AS
BEGIN
	BEGIN transaction
		IF(NOT EXISTS (SELECT * FROM sys.tables as tabla
			WHERE tabla.name = 'ex_pacientes'))
			BEGIN
				CREATE TABLE ex_pacientes (
					exPaciente_dni dni not null,
					exPaciente_nombre varchar(80),
					exPaciente_apellido varchar(80),
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
					exFecha date,
					exIdEstudio id,
					exIdInstituto id,
					ex_matricula_medico id,
					exIdObraSocial id,
					exIdPaciente id,
					exPago float,
					exResultado varchar(50),
					exAbonado bit
				)
			END
		IF (@@error <> 0)
			begin
				rollback tran
			END
		ELSE
			begin
				commit
			END
			
	
	declare cr_paciente_to_delete cursor scroll
	for
		select pa.dni, pa.nombre, pa.apellido from Paciente as pa
		where pa.dni = @dniPac
	
	declare @dni dni, @nombre varchar(20), @apellido varchar(20)
	
	open cr_paciente_to_delete
	
	fetch next from cr_paciente_to_delete
	into @dni, @nombre, @apellido
	while @@fetch_status = 0
		begin
			insert into ex_pacientes values (@dni, @nombre, @apellido, CURRENT_USER, cast(getdate() as varchar))
			fetch next from cr_paciente_to_delete
			into @dni, @nombre, @apellido
		end
	close cr_paciente_to_delete
	deallocate cr_paciente_to_delete
	
	declare @idPacienteABorrar id

	select @idPacienteABorrar = pa.idPaciente
	from Paciente as pa
	where pa.dni = @dni

	delete Paciente_PlanB
	where idPaciente = @idPacienteABorrar

	delete Paciente
	where idPaciente = @idPacienteABorrar
	
	declare cr_historial_to_delete cursor scroll
	for
		select re.fecha, re.idEstudio, re.idInstituto, re.idMedico, re.idObraSocial, re.idPaciente, re.idRegistro, re.pago, re.resultado from Registro as re
		where re.idPaciente = @idPacienteABorrar
	
	declare @fecha date, @idEstudio id, @idInstituto id, @idMedico id, @idObraSocial id, @idPaciente id, @pago float, @resultado varchar(50), @abonado bit

	open cr_historial_to_delete
	
	fetch next from cr_historial_to_delete
	into @fecha, @idEstudio, @idInstituto, @idMedico, @idObraSocial, @idPaciente, @pago, @resultado, @abonado
	while(@@fetch_status = 0)
		begin
			insert into ex_registros values (@fecha, @idEstudio, @idInstituto, @idMedico, @idObraSocial, @idPaciente, @pago, @resultado, @abonado)
			fetch next from cr_historial_to_delete
			into @fecha, @idEstudio, @idInstituto, @idMedico, @idObraSocial, @idPaciente, @pago, @resultado, @abonado
		end

	close cr_historial_to_delete
	deallocate cr_historial_to_delete
	
	delete Registro
	where Registro.idPaciente = @idPacienteABorrar
end


create procedure sp_eliminar_paciente
@dniPaciente dni
as
begin
	begin transaction
		ALTER TABLE registro DISABLE TRIGGER historias_pacientes

		if(@@error <> 0)
			begin
				RAISERROR ('Error en deshabilitar el trigger', 16, 1)
				ROLLBACK TRAN
				return
			end
	
		begin transaction
			exec sp_delete_paciente @dniPaciente
		
			if(@@error <> 0)
				begin
					RAISERROR ('Error en delete de paciente', 16, 1)
					ROLLBACK TRAN
					return
				end
		
			begin transaction
				ALTER TABLE registro ENABLE TRIGGER historias_pacientes
			
				if(@@error <> 0)
					begin
						RAISERROR ('Error en activar el trigger', 16, 1)
						ROLLBACK TRAN
						return
					end
			
	while(@@TRANCOUNT <> 0)
		begin
			COMMIT
		end
end



/*7.3. Definir una transacción que elimine lógicamente de la Base de Datos a todos los médicos de una determinada especialidad.
Se anidarán las stored procedures que se necesiten para completar la transacción, que debe tener en cuenta lo siguiente:
La eliminación del médico debe ser lógica conforme al trigger asociado a la acción de delete. (TP5)
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
