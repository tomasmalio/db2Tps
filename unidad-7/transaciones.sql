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
create procedure imprimirlista @especialidad varchar(15) as
begin try
    create table #medicosTemp 
    (id_medico varchar(15) not null,
    fecha datetime not null,
    estudio_id varchar(14)not null,
    primary key(id_medico,fecha,estudio_id))
 
 
    insert into #medicosTemp (id_medico,fecha,estudio_id)(select id_medico,fecha, estudio_id from historiaestudios where
        (id_medico in (select id_medico from medico_especialidad where id_especialidad=@especialidad)) 
        and (id_medico not in (select id_medico from medico_especialidad where id_especialidad<>@especialidad)) 
        )
 
    print 'Usuario responsable: '+ user_name()
    print 'ELIMINACION DE MEDICOS DE LA ESPECIALIDAD '+@especialidad
    print '__________________________________________________________'
 
 
    declare #cursor_lista cursor read_only forward_only for select * from #medicosTemp 
    declare @medico varchar(15),@fecha datetime,@estudio varchar(15),@medicoant varchar(15),@suma int,@nombre varchar(20),@apellido varchar(20)
    set @suma=0
    open #cursor_lista 
    fetch next from #cursor_lista into @medico,@fecha,@estudio
    set @medicoant=@medico
    select  @nombre=nombre,  @apellido=apellido from medico where matricula =@medico
    print ' '
    print 'Dr(a) '+ @nombre +' '+@apellido
    while @@fetch_status=0
        begin
            if @medicoant=@medico
                begin
                    set @suma=@suma+1
                    print 'Fecha: '+convert(varchar(20),@fecha)+' Estudio que indico: '+convert(varchar(15),@estudio)
                    fetch next from #cursor_lista  into @medico,@fecha,@estudio 
                end
            else
                begin
                    print 'Total de estudio: '++convert(varchar(2),@suma)
                    set @suma=0
                    set @medicoant=@medico
                    select  @nombre=nombre,  @apellido=apellido from medico where matricula=@medico
                    print ' '
                    print 'Dr(a) '+ @nombre +' '+@apellido
                end
             
        end
    print 'Total de estudio: '++convert(varchar(2),@suma)
    close #cursor_lista 
    deallocate #cursor_lista 
    drop table #medicosTemp 
end try
begin catch
    return -100
end catch
return 0
go
 
 
 
create procedure eliminar_medicos @especialidad varchar(15) as
begin tran tr
  
if not exists (select * from sys.objects where name='tr_eliminar_medicos')
    begin
        print 'Trigger de eliminacion logica inexistente'
        rollback tran tr
        return -100
    end
 
delete from medico where
    (matricula   in (select id_medico  from medico_especialidad where id_especialidad=@especialidad)) 
    and (matricula   not in (select id_medico  from medico_especialidad where id_especialidad<>@especialidad)) 
if @@error<>0
    begin
        print 'Error al eliminar los medicos'
        return -101
    end
save tran tr_save
declare @e int
exec @e=imprimirlista @especialidad 
if @e<>0 or @@error<>0
    begin
        print 'No se pudo generar el listado'
        rollback tran tr_save
        commit tran tr
        return -102
    end
commit tran tr
return 0
go

