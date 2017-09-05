/**
 *	VISTAS
 **/
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

CREATE VIEW vw_medicos_activos
AS
SELECT m.matricula, m.nombre_medico, m.apellido_medico, m.sexo FROM Medico m where m.estado='activo'

GO

CREATE VIEW vw_total_medicos_sin_especialidades
AS
SELECT count(me.sexo)as total, me.sexo  FROM Medico m 
Left join Medico_Especialidad me 
Medico_Especialidad me 
on me.id_medico = m.matricula
group by me.sexo
having me.id_especialidad is null
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

CREATE VIEW vw_planes
AS
SELECT p.id, os.nombre, os.categoria, p.estado FROM Plan p
inner join ObraSocial os on p.id_obra_social = os.id
GO

CREATE VIEW vw_planes_sin_cobertura 
AS
SELECT os.nombre, p.id FROM Plan_Estudio pe
right join Plan p on pe.id_plan = p.id
left join Estudio e on pe.id_estudio = e.id
inner join ObraSocial os on p.id_obra_social = os.id
where pe.id_estudio is null
GO

CREATE VIEW vw_paciente_plan
AS
SELECT p.dni, p.nombre, p.apellido, p.sexo, p.fecha_nacimiento, pl.id, pl.id_obra_social, pl.estado FROM Paciente_Plan pp
inner join Paciente p on pp.dni_paciente = p.dni
inner join Plan pl on pp.id_plan = pl.id
GO

CREATE VIEW vw_plan_estudio
AS
SELECT pl.id, pl.id_obra_social, pl.estado, e.id, e.nombre_estudio, pe.cobertura FROM Plan_Estudio pe
inner join Plan p on pe.id_plan = p.id
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
