/**
 *	VISTAS
 **/
 -- 2.1 
CREATE VIEW vw_planes
AS
SELECT p.id, os.nombre, os.categoria, p.estado FROM Planes p
inner join ObraSocial os on p.id_obra_social = os.id
GO

-- 2.2 
CREATE VIEW vw_medicos_activos
AS
SELECT m.matricula, m.nombre_medico, m.apellido_medico, m.sexo FROM Medico m where m.estado='activo'
GO

-- 2.3
CREATE VIEW vw_pacientes
AS
SELECT p.dni, p.nombre, p.apellido, p.sexo, p.fecha_nacimiento FROM Paciente p
GO

-- 2.4 vw_pacientes_sin_cobertura
CREATE VIEW vw_pacientes_sin_cobertura
AS
SELECT p.dni, p.nombre, p.apellido, p.sexo, p.fecha_nacimiento FROM Paciente p
	LEFT JOIN Paciente_Plan pp ON pp.dni_paciente = p.dni
	WHERE pp.id_plan is NULL
GO

-- 2.5 vw_total_medicos_sin_especialidades
CREATE VIEW vw_total_medicos_sin_especialidades
AS
SELECT count(m.sexo) as total, m.sexo FROM Medico m 
	Left join Medico_Especialidad me on me.id_medico = m.matricula
	where me.id_especialidad is null
	group by m.sexo
GO

-- 2.6
CREATE VIEW vw_afiliados_con_una_cobertura
AS
SELECT * FROM Paciente p
	LEFT JOIN Paciente_Plan pp on pp.dni_paciente = p.dni
	WHERE pp.id_plan IS NOT NULL
GO


-- 2.7
CREATE VIEW vw_cantidad_estudios_por_medico
AS
SELECT COUNT(r.id) AS cantidadDeEstudios, m.matricula, m.nombre_medico FROM Medico m
	left JOIN Registro r on r.matricula_medico = m.matricula group by m.matricula,m.nombre_medico 
GO

-- 2.8
CREATE VIEW vw_historias_de_estudios
AS
SELECT p.dni, p.nombre, p.apellido, p.sexo, p.fecha_nacimiento, 
e.nombre_estudio, esp.nombre_especialidad, e.estado, 
i.nombre_instituto,
m.matricula, m.nombre_medico
FROM Registro r
	LEFT JOIN Paciente p ON p.dni = r.dni_paciente
	RIGHT JOIN Estudio e ON e.id = r.id_estudio
	RIGHT JOIN Instituto i ON i.id = r.id_instituto
	RIGHT JOIN Medico m ON m.matricula = r.matricula_medico
	RIGHT JOIN Medico_Especialidad me ON me.id_medico = m.matricula
	RIGHT JOIN Especialidad esp ON esp.id = me.id_especialidad

-- 2.9
CREATE VIEW vw_ooss_pacientes
AS
SELECT os.nombre AS ooss, os.categoria, pla.id, pla.estado, p.dni, p.nombre, p.apellido FROM ObraSocial os
	LEFT JOIN Planes pla ON pla.id_obra_social = os.id
	LEFT JOIN Paciente_Plan pp ON pp.id_plan = pla.id
	LEFT JOIN Paciente p ON p.dni = pp.dni_paciente
GO

-- 2.10
CREATE VIEW vw_estudios_sin_cobertura
as
  select * from estudio est left join [db5099n_03].[dbo].[Plan_Estudio] plest
  on est.id = plest.id_estudio where est.id is null
GO


-- 2.11
CREATE VIEW vw_planes_sin_cobertura 
AS
SELECT os.nombre, p.id FROM Plan_Estudio pe
right join Planes p on pe.id_plan = p.id
left join Estudio e on pe.id_estudio = e.id
inner join ObraSocial os on p.id_obra_social = os.id
where pe.id_estudio is null
GO

-- 2.12 FALTA
CREATE VIEW vw_tabla_de_precios
AS
SELECT e.nombre_estudio, os.nombre, i.nombre_instituto, ie.precio, pe.cobertura, pe.id_plan AS idPlan 
FROM 
	LEFT JOIN Estudio e ON e.id = 
	LEFT JOIN ObraSocial os ON os.id = 
	LEFT JOIN Instituto i ON i.id = 
	LEFT JOIN Instituto_Estudio ie ON ie.id_instituto = i.id
	LEFT JOIN Plan_Estudio pe ON pe.id_estudio = e.id

-- 2.13
CREATE VIEW vw_estudios_en_tres_meses
AS
select est.nombre_estudio from Registro reg inner join Estudio est on reg.id_estudio = est.id where reg.fecha_estudio >= DATEADD(MM, -3, GETDATE())
GO

-- 2.14
Create view vw_estudios_a_prepagas
as
select est.nombre_estudio from ObraSocial os inner join Planes p on os.id = p.id_obra_social inner join Plan_Estudio plest on plest.id_plan = p.id inner join Registro reg on plest.id_estudio = reg.id_estudio inner join Estudio est on plest.id_estudio = est.id
where os.categoria='pp' and DATEDIFF(dd,reg.fecha_estudio,getDate())<45
GO

-- 2.15 FALTA


-- 2.16 MAL
CREATE VIEW vw_estudios_por_instituto
AS
	SELECT count(reg.id_instituto) as [Total estudio x Instituto], inst.nombre_instituto 
	FROM Registro reg 
	INNER JOIN Instituto inst ON reg.id_instituto = inst.id 
	WHERE (DATEDIFF(dd, reg.fecha_estudio, getDate()) < 14) group by reg.id_instituto 
GO

-- 2.17
create view vw_estudios_en_sabado
as
select count(med.matricula) as cantidad, med.nombre_medico from Registro reg
 inner join Medico med
  on reg.matricula_medico = med.matricula 
 where datepart(dw,reg.fecha_estudio)=7 
  group by med.matricula,med.nombre_medico 
GO


-- 2.18
CREATE VIEW vw_paciente
AS
SELECT p.dni, p.nombre, p.apellido, p.sexo, p.fecha_nacimiento FROM Paciente p
GO

-- 2.19



/**
CREATE VIEW vw_especialidad
AS
SELECT e.id, e.nombre_especialidad FROM Especialidad e
GO

CREATE VIEW vw_estudio
AS
SELECT e.id, e.nombre_estudio FROM Estudio e
GO

CREATE VIEW vw_especialidad_estudio
AS
SELECT est.nombre_estudio, esp.nombre_especialidad FROM Especialidad_Estudio ee 
inner join Estudio est on ee.id_estudio = est.id 
inner join Especialidad esp on ee.id_especialidad = esp.id
GO



CREATE VIEW vw_total_medicos_sin_especialidades
AS
SELECT count(m.sexo) as total, m.sexo FROM Medico m 
	Left join Medico_Especialidad me on me.id_medico = m.matricula
	where me.id_especialidad is null
	group by m.sexo
GO

CREATE VIEW vw_instituto
AS
SELECT i.id, i.nombre_instituto, i.direccion, i.estado FROM Instituto i
GO
	
CREATE VIEW vw_instituto_estudio
AS
SELECT i.nombre_instituto, i.direccion, i.estado, e.nombre_estudio FROM Instituto_Estudio ie 
inner join Instituto i on ie.id_instituto = i.id
inner join Estudio e on ie.id_estudio = e.id
GO

CREATE VIEW vw_obrasocial
AS
SELECT id, nombre, categoria FROM ObraSocial
GO

CREATE VIEW vw_paciente
AS
SELECT p.dni, p.nombre, p.apellido, p.sexo, p.fecha_nacimiento FROM Paciente p
GO


CREATE VIEW vw_paciente_plan
AS
SELECT p.dni, p.nombre, p.apellido, p.sexo, p.fecha_nacimiento, pl.id, pl.id_obra_social, pl.estado FROM Paciente_Plan pp
inner join Paciente p on pp.dni_paciente = p.dni
inner join Planes pl on pp.id_plan = pl.id
GO


CREATE VIEW vw_plan_estudio
AS
SELECT p.id, p.id_obra_social, p.estado, e.id, e.nombre_estudio, pe.cobertura FROM Plan_Estudio pe
inner join Planes p on pe.id_plan = p.id
inner join Estudio e on pe.id_estudio = e.id
GO


CREATE VIEW vw_registro
AS
SELECT r.id, r.fecha_estudio, 
e.nombre_estudio, 
i.nombre_instituto, i.direccion, i.estado, 
m.nombre_medico, m.apellido_medico, m.sexo,
p.nombre, p.apellido, p.sexo, p.fecha_nacimiento
FROM Registro r
inner join Estudio e on r.id_estudio = e.id
inner join Instituto i on r.id_instituto = i.id
inner join Medico m on r.matricula_medico = m.matricula
inner join Paciente p on r.dni_paciente = p.dni
GO


CREATE VIEW vw_estudios_en_tres_meses
AS
select est.nombre_estudio from Registro reg inner join Estudio est on reg.id_estudio = est.id where reg.fecha_estudio >= DATEADD(MM, -3, GETDATE())
GO

Create view vw_estudios_a_prepagas
as
select est.nombre_estudio from ObraSocial os inner join plan p on os.id = p.id_obra_social inner join Plan_Estudio plest on plest.id_plan = p.id inner join Registro reg on plest.id_estudio = reg.id_estudio inner join Estudio est on plest.id_estudio = est.id
where os.categoria='pp' and DATEDIFF(dd,reg.fecha_estudio,getDate())<45
GO

Create view vw_estudios_en_sabado
as
select count(med.matricula), med.nombre_medico from registro reg inner join Medicos med on reg.matricula = med.matricula where datepart(dw,reg.fecha_estudio)=7 group by med.matricula 
GO

Create view vw_estudios_por_instituto
as
select count(reg.id_instituto) as [Total estudio x Instituto], inst.nombre_instituto from registro reg inner join instituto inst on reg.id_instituto = inst.id where (DATEDIFF(dd,reg.fechaestudio,getDate())<14) group by reg.id_instituto 
GO
**/
