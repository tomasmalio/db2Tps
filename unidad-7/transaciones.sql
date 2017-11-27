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
		SELECT pa.dni, pa.nombre, pa.apellido 
		FROM Paciente as pa
		WHERE pa.dni = @dni_paciente
	
	DECLARE @dni dni, 
			@nombre varchar(20), 
			@apellido varchar(20)
	
	open cr_paciente_to_DELETE
	
	fetch next FROM cr_paciente_to_DELETE
	into @dni, @nombre, @apellido
	while @@fetch_status = 0
		BEGIN
			INSERT INTO ex_pacientes VALUES (@dni, @nombre, @apellido, CURRENT_USER, cast(getdate() as varchar))
			fetch next FROM cr_paciente_to_DELETE
			into @dni, @nombre, @apellido
		END
	close cr_paciente_to_DELETE
	deallocate cr_paciente_to_DELETE
	
	DECLARE @dni_paciente_a_borrar dni

	SELECT @dni_paciente_a_borrar = pa.dni
	FROM Paciente as pa
	WHERE pa.dni = @dni

	DELETE Paciente_PlanB
	WHERE dni = @dni_paciente_a_borrar

	DELETE Paciente
	WHERE idPaciente = @dni_paciente_a_borrar
	
	DECLARE cr_historial_to_DELETE cursor scroll
	for
		SELECT re.fecha_estduio, re.id_estudio, re.id_instituto, re.matricula_medico, re.id_obra_social, re.dni_paciente, re.id, re.pagado 
		FROM Registro as re
		WHERE re.dni_aciente = @dni_paciente_a_borrar
	
	DECLARE @fecha_estudio date, 
			@id_estudio id, 
			@id_instituto id, 
			@matricula_medico id, 
			@id_obra_social id, 
			@dni_paciente dni, 
			@pagado pagado

	open cr_historial_to_DELETE
	
	fetch next FROM cr_historial_to_DELETE
	into @fecha_estudio, @id_estudio, @id_instituto, @matricula_medico, @id_obra_social, @dni_paciente, @pagado
		BEGIN
			insert into ex_registros values (@fecha_estudio, @id_estudio, @id_instituto, @matricula_medico, @id_obra_social, @dni_paciente, @pagado)
			fetch next FROM cr_historial_to_DELETE
			into @fecha_estudio, @id_estudio, @id_instituto, @matricula_medico, @id_obra_social, @dni_paciente, @pagado
		END

	close cr_historial_to_DELETE
	deallocate cr_historial_to_DELETE
	
	DELETE Registro
	WHERE Registro.dni_paciente = @dni_paciente_a_borrar
END


create procedure sp_eliminar_paciente
@dniPaciente dni
as
BEGIN
	BEGIN transaction
		ALTER TABLE Registro DISABLE TRIGGER historias_pacientes

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
				ALTER TABLE Registro ENABLE TRIGGER historias_pacientes
			
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
	anular la transacción de eliminación).
*/
CREATE TRIGGER tr_eliminar_medicos 
	ON Medico
	INSTEAD OF DELETE
	AS 
		UPDATE Medico SET estado = 'inactivo'
		WHERE matricula IN (SELECT matricula FROM deleted)
	GO

create procedure eliminar_medico
	@matricula smallint
as

begin
	begin transaction

	if exist(select id_medico from medico_especialidad where id_medico =@matricula group by id_medico having (count(id_medico)>1))
		begin
				raiserror 50001 'No se pueden eliminar medicos con mas de una especialidad'
		end
	else
		begin
				delete medico_especialidad where id_medico = @matricula;
				delete Medico where matricula = @matricula;
		end
	

	IF(@@error<>0)
			ROLLBACK TRANSACTION

		COMMIT TRANSACTION

	RETURN @@error
end

create procedure eliminar_medico_por_especialidad 
	@nombre_especialidad varchar(50)
as
BEGIN
DECLARE @input_especialidad smallint ;
select @input_especialidad  from Especialidad where nombre_especialidad = @nombre_especialidad;


begin transaction  delete_medicos_por_especialidad WITH MARK = 'Elimina lógicamente de la Base de Datos a todos los médicos de una determinada especialidad.'

create table #medicos_historias (usuarioResponasable varchar(50), medicosEspecialidadAELiminar varchar(50),matricula smallint, nombreYapellido varchar(255), fechaEstudio date, tipoEstudio  varchar(50), totalEstudios int)
DECLARE @usuarioResponasable varchar(50), @medicosEspecialidadAELiminar varchar(50),@matricula smallint, @nombreYapellido varchar(255), @fechaEstudio date, @tipoEstudio varchar(50))

DECLARE lista_medicos_especialidad CURSOR 
FOR select id_medico from medico_especialidad me where me.id_especialidad=@input_especialidad
		where  ( select count(id_especialidad) from medico m where m.id_especialidade = me.idsp group by id_especialidad) < 2


OPEN lista_medicos_especialidad
FETCH NEXT FROM lista_medicos_especialidad into @matricula

WHILE @@FETCH_STATUS = 0
   BEGIN
			PRINT @matricula  
			
			declare @totalEstudios int = 0

			begin transaction
			DECLARE @id smallint,@id_estudio smallint,@id_instituto smallint,@id_obra_social smallint, @matricula_medico smallint,	@dni_paciente varchar(8),@fecha_estudio date,	@pagado pagado)
			
			declare cursor_registros cursor
			forward_only read_only

			for 
			select id,id_estudio ,id_instituto,id_obra_social,matricula_medico,dni_paciente,fecha_estudio,pagado
			from Registro where matricula_medico = @matricula

			open cursor_registros
			fetch next from cursor_registros
			into @id,@id_estudio,@id_instituto,@id_obra_social, @matricula_medico,	@dni_paciente ,@fecha_estudio,	@pagado)
			
			if @@FETCH_STATUS <>0
				raiserror 50001 'No hay registros de estudios realizados'
			else
						
			while @@FETCH_STATUS = 0
				begin	
				INSERT INTO  #medicos_historias VALUES(CURRENT_USER, select nombre_especialidad from Especialidad esp inner join Medico_Especialidad me on esp.id_especialidad = me.id_especialidad where me.id_medico = @matricula ,@matricula, select nombre_medico + ' ' + apellido_medico  from Medico where matricula=@matricula, cast(@fechaEstudio as varchar), select nombre_estudio from Estudio where id=@id_estudio, @totalEstudios
				@totalEstudios = @totalEstudios + 1;
				fetch next from cursor_registros
				end
			
			if(@@error<>0)
				begin
					raiserror 50001 'Error al crear el listado temporal'
					rollback transaction
				end
			else
				begin
					commit transaction
				end

					DECLARE listado_historias_medicos CURSOR FORWARD_ONLY READ_ONLY
					FOR SELECT usuarioResponasable, medicosEspecialidadAELiminar,matricula, nombreYapellido, fechaEstudio, tipoEstudio, totalEstudios 
					From #medicos_historias

					OPEN listado_historias_medicos
					FETCH NEXT FROM listado_historias_medicos into @usuarioResponasable, @medicosEspecialidadAELiminar,@matricula, @nombreYapellido, @fechaEstudio, @tipoEstudio, @totalEstudios 	
					WHILE @@FETCH_STATUS = 0
					   BEGIN
									Print 'Usuario responsable'+ @usuarioResponasable
									Print 'ELIMINACION DE MEDICOS DE LA ESPECIALIDAD '+ @medicosEspecialidadAELiminar
									Print 'Dr(a) '+ @nombreYapellido
					                Print 'Fecha y estudio que indicó'+ @fechaEstudio + ' ' + @tipoEstudio
									Print 'Total de estudios ' + @totalEstudios

								FETCH NEXT FROM listado_historias_medicos 
					   END

					CLOSE listado_historias_medicos
					DEALLOCATE listado_historias_medicos

					exec eliminar_medico @matricula

					IF (@@Error = 0)
					Commit transaction

	END

CLOSE lista_medicos_especialidad
DEALLOCATE lista_medicos_especialidad
Drop table #medicos_historias

END

