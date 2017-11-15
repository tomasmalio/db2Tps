/*CURSORES*/

/*6.1. Definir un Cursor:
Que liste la ficha de los pacientes de los últimos seis meses conforme al siguiente formato de salida:
Datos del paciente.
Identificación del médico.
Detalle de los estudios realizados.*/

DECLARE cr_ficha_pacientes CURSOR FOR
SELECT p.dni, p.apellido, m.apellido_medico, r.fecha_estudio, e.nombre_estudio FROM Registro r
LEFT JOIN Paciente p ON p.dni= r.dni_paciente
LEFT JOIN Medico m ON m.matricula = r.matricula_medico
LEFT JOIN Estudio e on e.id = r.id_estudio
where r.fecha_estudio > DATEADD(mm,-6,GETDATE())

open cr_ficha_pacientes 
declare @DniPaciente int
declare @ApellidoPaciente varchar(50)
declare @Medico varchar (50)
declare @fecha date
declare @Estudio varchar (100)
declare @DateText varchar (20)
WHILE @@FETCH_STATUS = 0
	FETCH NEXT FROM cr_ficha_pacientes
		INTO @DniPaciente, @ApellidoPaciente, @Medico, @fecha, @Estudio, @resultado
		BEGIN
			SET @DateText = cast(@fecha AS varchar)
			PRINT 'Paciente: ' + @ApellidoPaciente + '; Medico: ' + @Medico + '; fecha estudio: ' + @DateText + '; Estudio:  ' + @Estudio + ';
		END

CLOSE cr_ficha_pacientes
DEALLOCATE cr_ficha_pacientes


/*6.2. Definir un Cursor:
Que liste el detalle de los planes que cubren un determinado estudio identificando el porcentaje cubierto y la obra social, según formato:
Estudio.
Obra social.
Plan y Cobertura (ordenado en forma decreciente).*/

create procedure detalle_plan
@nombreEstudio varchar(50)
AS
BEGIN
	DECLARE cr_detalle_plan CURSOR SCROLL
	FOR
		SELECT e.nombre_estudio, os.nombre, pl.nombre_plan, pe.cobertura FROM Plan_Estudio pe
		LEFT JOIN Estudio e ON e.id = pe.id_estudio
		LEFT JOIN Planes pl ON pl.id = pe.id_plan
		LEFT JOIN ObraSocial os ON os.id = pl.id_obra_social
		ORDER BY cobertura DESC

	DECLARE @nestudio VARCHAR(50), @nobraSocial sigla, @nplan VARCHAR(50), @pcubierto INT
	OPEN cr_detalle_plan

	FETCH NEXT FROM cr_detalle_plan
		INTO @nestudio, @nobraSocial, @nplan, @pcubierto
		IF(@nestudio = @nombreEstudio)
		BEGIN
			PRINT 'Estudio: ' + @nestudio + '; OS: ' + @nobrasocial + '; Plan: ' + @nplan + '; porcentaje cubierto: ' + CAST(@pcubierto AS VARCHAR)
		END
	WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM cr_detalle_plan
		INTO @nestudio, @nobraSocial, @nplan, @pcubierto
		IF(@nestudio = @nombreEstudio)
		BEGIN
			PRINT 'Estudio: ' + @nestudio + '; OS: ' + @nobrasocial + '; Plan: ' + @nplan + '; Cobertura: ' + cast(@pcubierto as VARCHAR)
		END
	END
	CLOSE cr_detalle_plan
	deallocate cr_detalle_plan
end

exec detalle_plan'Cardiología'
DEALLOCATE cr_detalle_plan


/*6.3. Crear una StoredProcedure que defina un Cursor:
Que liste el resumen mensual de los importes a cargo de una obra social.
INPUT: nombre de la obra social, mes y año a liquidar.
Obra social
Nombre del Instituto
Detalle del estudio
Subtotal del Instituto
Total de la obra social*/


/*6.4. Crear una Stored Procedure que defina un Cursor:
Que devuelva una tabla de referencias cruzadas que represente el importe mensual abonado a cada instituto en los últimos n meses.
INPUT: entero que representa los n meses anterioes.
Mes año Mes año Mes año Mes año Total Inst.
Inst. A - - $ $
Inst. B $ $ - $
Total $ $ $ $*/


/*6.5. Definir un Cursor:
Que actualiceel campo observaciones de la tabla historias con las siguientes indicaciones:
Repetir estudio: si el mismo se realizó en el segundo instituto registrado en la tabla (orden alfabético).
Diagnóstico no confirmado: si el mismo se realizó en cualquier otro instituto y fue solicitado por el
tercer médico de la tabla (orden alfabético).*/


/*6.6. Definir un Cursor:
Que actualiceel campo precio de la tabla precios incrementando en un 2% los mismos para cada estudio de distinta especialidad a las restantes.
Ej.: 1º especialidad un 2%, 2º especialidad un 4%, ... */

/*6.7. Definir un Cursor:
Que elimine todas las claves foráneas de la tabla Registro (registro de los estudios realizados).
Debe proyectar el nombre de las restricciones realizadas indicando la tabla referenciada.
- Volver a crearlas con un proceso externo al cursor - */
