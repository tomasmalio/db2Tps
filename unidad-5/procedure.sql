/*
Store Procedures
*/

/*4.1. Crear un procedimiento para ingresar el precio de un estudio.
INPUT: nombre del estudio, nombre del instituto y precio.
Si ya existe la tupla en Precios debe actualizarla.
Si no existe debe crearla.
Si no existen el estudio o el instituto debe crearlos.*/

CREATE PROCEDURE pr_IngresarPrecio
	@nomEstudio varchar(50) not null,
	@nombreInstituto varchar(50) not null,
	@precio money not null,
AS
	DECLARE @id_estudio int, @id_instituto int 
	
	SELECT @id_estudio = e.id FROM Estudio e WHERE e.nombre_estudio = @nombEstudio
	IF (@id_estudio isnull)
		BEGIN
			SET @id_estudio isnull ((SELECT MAX(e.id) FROM Estudio), 0) + 1
			INSERT INTO Estudio (id, nombre_estudio,estado) VALUES @id_estudio, @nombEstudio
		END

	SELECT @id_estudio = e.id FROM Instituto i WHERE i.nombre_instituto = @nombEstudio
	IF (@id_instituto isnull)
		BEGIN
			SET @id_instituto isnull ((SELECT MAX(i.id) FROM Instituto ), 0) + 1
			INSERT INTO Estudio (id, nombre_estudio,estado) VALUES @id_estudio, @nombEstudio
		END

	IF EXISTS (SELECT 1 FROM Instituto_Estudio ie WHERE ie.id_estudio = @id_estudio AND ie.id_instituto = @id_instituto)
		BEGIN
			UPDATE Instituto_Estudio SET precio = @precio
			WHERE id_estudio = @id_estudio AND id_instituto = @id_instituto
		END
	ELSE
		BEGIN
			INSERT INTO Instituto_Estudio (id_instituto, id_estudio, precio) 
			VALUES (@id_instituto, @id_estudio, @precio)
		END
	RETURN
GO

/*4.2. Crear un procedimiento para ingresar datos del afiliado.
INPUT: dni del paciente, sigla de la obra social, nro del plan, nro de afiliado.
Si ya existe la tupla en Afiliados debe actualizar el nro de plan y el nro de afiliado.
Si no existe debe crearla.*/

CREATE PROCEDURE ingresarAfiliado
  @dni dni, 
  @sigla sigla,
  @nroPlan int,
AS
	declare @plan int
	SELECT @plan = pa.id 
	FROM Planes pa 
	INNER JOIN ObraSocial o ON o.id = pa.id_obra_social
	WHERE o.sigla = @sigla

if @plan = @nroPlan
  BEGIN
	  if exists (SELECT dni FROM Paciente WHERE dni = @dni)
	    BEGIN
			UPDATE Paciente_Plan
			SET id_plan = @nroPlan, dni_paciente = @dni
			WHERE dni_paciente = @dni
	    END
	  ELSE
	    BEGIN
			if exists (SELECT dni from Paciente where dni = @dni)
		        BEGIN
			    	INSERT INTO Paciente_Plan values (@dni, @nroPlan)
				END
	    END
  END
GO

/*4.3. Crear un procedimiento para que proyecte los estudios realizados en un determinado mes.
INPUT: mes y año.
Proyectar los datos del afiliado y los de los estudios realizados.*/

CREATE procedure pr_Estudios
  @mes int,
  @año int
AS
  SELECT p.*, e.nombre_estudio, r.fecha_estudio, r.id_instituto, r.matricula_medico
    FROM (Registro r INNER JOIN Paciente p ON r.dni_paciente = p.dni)
      INNER JOIN Estudio e ON r.id_estudio = e.id
  WHERE datepart(mm, r.fecha_estudio) = @mes AND datepart(yyyy, r.fecha_estudio) = @año


/*4.4. Crear un procedimiento que proyecte los datos de los médicos para una determinada especialidad.
INPUT: nombre de la especialidad y sexo (default null).
Proyectar los datos de los médicos activos que cumplan con la condición. Si no se especifica sexo, listar ambos.*/

CREATE procedure pr_medicos
  @especialidad varchar(50),
  @sexo varchar(1) = null
AS
  SELECT m.*, e.nombre_especialidad
    FROM (Medico m INNER JOIN Medico_Especialidad me ON m.matricula = em.id_medico)
      INNER JOIN Especialidad e ON e.id = em.id_especialidad
  WHERE e.nombre_especialidad = @especialidad 
    AND m.sexo = isnull(@sexo, sexo) 
    AND m.estado = 'activo'


/*4.5. Crear un procedimiento que proyecte los estudios que están cubiertos por una determinada obra social.
INPUT: nombre de la obra social, nombre del plan ( default null ).
Proyectar los estudios y la cobertura que poseen (estudio y porcentaje cubierto.
Si no se ingresa plan, se deben listar todos los planes de la obra social.*/

CREATE PROCEDURE EstudiosCubiertos
	@ooss varchar(20) = '%',
	@nombre_plan varchar(20)= NULL
AS
	if @NOMBRE IS NULL
		BEGIN
			SELECT o.sigla, o.nombre, p.nroplan, p.nombre 
			FROM ObraSocial o INNER JOIN Planes p on o.id = p.id_obra_social 
			WHERE o.sigla = @ooss		
		END
	else
		BEGIN
			SELECT o.sigla, o.nombre, p.id, p.nombre_plan, c.cobertura 
			FROM ObraSocial o 
			INNER JOIN Planes p ON o.id = p.id_obra_social
			INNER JOIN Plan_Estudio pe ON pe.id_plan = p.id		
			WHERE o.sigla = @ooss and p.nombre_plan = @nombre_plan
		END
GO



/*4.6. Crear un procedimiento que proyecte cantidad de estudios realizados agrupados por obra social, nombre del plan y matricula del médico.
INPUT: nombre de la obra social, nombre del plan, matrícula del médico.
(todos deben admitir valores nulos por defecto )
Proyectar la cantidad de estudios realizados.
Si no se indica alguno de los parámetros se deben discriminar todas las ocurrencias.*/

CREATE PROCEDURE VerEstudios
  @nombreooss varchar(20) = null,
  @nroPlan int = null,
  @matricula int = null
AS
	SELECT os.nombre, a.nroplan, h.matricula, count(1) estudios
	FROM (Registro r 
	INNER JOIN Paciente p ON r.dni_paciente = p.dni
    INNER JOIN ObraSocial os ON p.id_obra_social = os.id
    INNER JOIN Paciente_Plan pp ON pp.dni_paciente = p.dni
  	WHERE os.nombre = isnull(@nombreooss, os.nombre)
    AND pp.id_plan = isnull(@nroPlan, pp.id_plan)
    AND r.matricula_medico = isnull(@matricula, r.matricula_medico)
	GROUP BY os.nombre, pp.id_plan, r.matricula_medico
GO


/*4.7. Crear un procedimiento que proyecte dni, fecha de nacimiento, nombre y apellido de los pacientes que correspondan a 
los n (valor solicitado) pacientes más viejos cuyo apellido cumpla con determinado patrón de caracteres.
INPUT: cantidad (valor n), patrón caracteres (default null).
Proyectar los pacientes que cumplan con la condición.
(Ejemplo: los 10 pacientes más viejos cuyo apellido finalice con ‘ez’ o los 8 que comiencen con la letra ‘A’*/

CREATE procedure pr_pacientes
  @n int,
  @patron varchar(20) = null
AS
  SELECT p.nombre, p.apellido, p.dni, p.fecha_nacimiento FROM Paciente p
  WHERE @n >= (SELECT COUNT(1) FROM Paciente p1 WHERE p1.fecha_nacimiento <= p.fecha_nacimiento)
    AND apellido LIKE isnull(@patron, apellido)

/*4.8. Crear un procedimiento que devuelva el precio total a liquidar a un determinado instituto.
INPUT: nombre del instituto, periodo a liquidar.
OUTPUT: precio neto.
Devuelve el neto a liquidar al instituto para ese período en una variable.*/

CREATE PROCEDURE VerInstitutos
  @instituto varchar(20),
  @mes int,
  @año int,
  @precioNeto decimal(6, 2) output
as
	SELECT @precioNeto = sum(p.precio * c.cobertura / 100)
	FROM Registro r 
	INNER JOIN Instituto_Estudio ie on r.idEstudio = ie.idEstudio and r.idInstituto = ie.idInstituto
    INNER JOIN Paciente_Plan pp on r.dni_paciente = pp.dni_paciente
	INNER JOIN Plan_Estudio pe on pe.id_plan = pp.id_plan AND r.id_estudio = pe.id_estudio
	INNER JOIN Instituto i on r.id_instituto = i.id
	WHERE i.nombre_instituto = @instituto AND datepart(mm, r.fecha_estudio) = @mes AND datepart(yyyy, r.fecha_estudio) = @año
GO

/*4.9. Crear un procedimiento que devuelva el monto a abonar de un paciente moroso.
INPUT: dni del paciente, estudio realizado, fecha de realización, punitorio (mensual).
OUTPUT: precio neto.
Obtener punitorio diario y precio a abonar.
Devuelve precio + punitorio en una variable.*/



/*4.10. Crear un procedimiento que devuelva la cantidad posible de juntas médicas que puedan crearse combinando los médicos existentes.
INPUT / OUTPUT: entero.
Ingresar la cantidad de combinaciones posibles de juntas entre médicos ( 2 a 6 ) que se pueden generar con los médicos activos de la Base de Datos.
Retorna la Combinatoria (m médicos tomados de a n ) = m! / n! (m-n)! en una variable.*/

CREATE procedure pr_cantidad_posible_junta_medicas
	@combinatoria_cantidad int,
	@combinatoria_medicos int output
AS






/*4.11. Crear un procedimiento que devuelva la cantidad de pacientes y médicos que efectuaron estudios en un determinado período.
INPUT / OUTPUT: dos enteros.
Ingresar período a consultar (mes y año )
Retornar cantidad de pacientes que se realizaron uno o más estudios y cantidad de médicos solicitantes de los mismos, en dos variables.*/

CREATE procedure pr_pacientes_medicos
	@mes int,
	@año int,
	@pacientes int output,
	@medicos int output
AS
SET @pacientes= (SELECT COUNT(DISTINCT dni_paciente) FROM Registro 
		WHERE datepart(yy,fecha_estudio)=@año AND datepart (mm,fecha_estudio)=@mes)
SET @medicos= (SELECT COUNT(DISTINCT matricula_medico) FROM Registro 
	       WHERE datepart(yy,fecha)=@año AND datepart (mm,fecha)=@mes)
