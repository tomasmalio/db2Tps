--1. Crear una vista vw_estudios que proyecte:
--nombre y el estado ( activo = si o no ) de los estudios.
create view vw_estudio
as
select nombre_estudio, estado from Estudio;

select * from vw_estudio;

--2. Crear una vista vw_ooss que proyecte:
--nombre y categoría (obra social o prepaga) de las obras sociales.
create view vw_ooss
as
Select nombre, categoria from ooss

select * from vw_ooss

--3. Crear una vista vw_planes que proyecte:
--nombre de la obra social, descripción del plan y el estado ( activo = si o no ) del mismo.
create view vw_planes 
as
select sigla, nombre, activo from planes

select * from vw_planes


--4. Crear una vista vw_medicos_activos que proyecte:
--matrícula, nombre, apellido y sexo (masculino, femenino) de los médicos en estado activo.
create view vw_medicos_activos
as 
select matricula, nombre, apellido,
(case when sexo='M' then 'Masculino' else 'Femenino' end) as sexo
from medicos where activo='si'

--5. Crear una vista vw_pacientes que proyecte:
--dni, nombre, apellido, sexo y fecha de nacimiento de los pacientes, obra social a la que
--pertenece, plan y nº de afiliado y categoría de ésta. (utilizar join )
create view vw_pacientes
as
select P.dni, P.nombre, P.apellido, P.sexo, P.nacimiento, A.sigla, A.nroafiliado, O.categoria, PL.nombre as nombre_plan
from pacientes P
join afiliados A on A.dni=p.dni
join ooss O on O.SIGLA=A.SIGLA
join planes PL on PL.nroPlan=A.nroPlan and PL.SIGLA=A.SIGLA


--6. Crear una vista vw_pacientes_sin_cobertura que proyecte:
--dni, nombre, apellido, sexo y fecha de nacimiento de los pacientes sin cobertura
create view vw_pacientes_sin_cobertura
as
select P.dni, P.nombre, P.apellido, P.sexo, P.nacimiento, A.SIGLA from pacientes P
left join afiliados A on A.dni=P.dni
where a.sigla is null

o

select P.dni, P.nombre, P.apellido, P.sexo, P.nacimiento, A.SIGLA from afiliados a 
right join pacientes p on A.dni=P.dni
where a.sigla is null
--------------------------------------------------------------------------


--7. Crear una vista vw_medicos_varias_especialidades que proyecte:
--datos de los médicos activos y la especialidad de aquellos que tienen mas de una especialidad.
create view vw_medicos_varias_especialidades
as
select M.matricula,m.nombre,e.especialidad as cantidad
from medicos M
join espemedi EM on EM.matricula=M.matricula
join especialidades E on E.idespecialidad=EM.idespecialidad
Where M.activo='si'
and m.matricula in (select matricula 
from espemedi 
group by matricula
having count (idespecialidad) > 1
) 


--8. Crear una vista vw_total_medicos_sin_especialidades que proyecte:
--la cantidad de los médicos que no tienen especificada la especialidad
--agrupados por sexo (proyectar: masculino - femenino).
create view vw_total_medicos_sin_especialidades
as
select count(matricula) as cantidad_medicos, (case when sexo='f' then 'Femenino' else 'Masculino' end) as Sexo
from medicos 
where matricula not in (select matricula from espemedi)
group by sexo



--9. Crear una vista vw_afiliados_con_una_cobertura que proyecte:
--datos de los afiliados (nombre y afiliación y plan) que posean 1 sola cobertura médica.
create view vw_afiliados_con_una_cobertura
as
select P.nombre, A.SIGLA, A.nroplan
from afiliados A
join pacientes P on P.dni=A.dni
where P.dni in
(select dni from afiliados 
group by dni
having count(dni)=1)




--10. Crear una vista vw_cantidad_estudios_por_instituto que proyecte:
--el nombre del instituto, el nombre del estudio y a la cantidad veces que se solicitó.

create view vw_cantidad_estudios_por_instituto
as

select i.instituto ,h.idEstudio,e.estudio,count (h.idestudio) as cantidad
from historias h join institutos i on i.idinstituto = h.idinstituto
join estudios e on e.idestudio =h.idestudio
group by i.instituto ,h.idEstudio,e.estudio

select * from historias






--11. Crear una vista vw_cantidad_estudios_por_medico que proyecte: 
--los datos la matrícula y el nombre del médico junto a la cantidad de estudios 

create view vw_cantidad_estudios_por_medico
as
select m.matricula,m.nombre,m.apellido,count(es.idestudio) as cantidad
from medicos m inner join historias h on m.matricula=h.matricula
inner join estudios es on es.idestudio =h.idestudio
group by m.matricula,m.nombre,m.apellido


--12. Crear una vista vw_historias_de_estudios que proyecte: 

-- los datos del paciente, el estudio realizado, el instituto, matricula y nombre del medico solicitante, fecha del estudio, obra social que factura el estudio, y observaciones. 

create view vw_historias_de_estudios
as
select p.dni,p.nombre,p.apellido,es.estudio,m.nombre as medico, h.fecha, o.nombre as ObraSocial,h.observaciones,i.instituto
from pacientes p inner join historias h on h.dni=p.dni
inner join estudios es on es.idestudio= h.idestudio
inner join medicos m on m.matricula = h.matricula
inner join institutos i on i.idinstituto=h.idinstituto
inner join ooss o on o.sigla=h.sigla

--13. Crear una vista vw_pagos_pacientes que proyecte: 
-- nombre y dni del paciente, el estudio realizado, la fecha y el monto a pagar. 

create view vw_pagos_pacientes
as
select p.dni, p.nombre,p.apellido, es.estudio, h.fecha, pr.precio
from pacientes p inner join historias h on h.dni=p.dni
inner join estudios es on es.idestudio =h.idestudio
inner join precios pr on pr.idestudio = es.idestudio and h.idinstituto = pr.idinstituto
inner join institutos i on i.idinstituto=h.idinstituto

--14. Crear una vista vw_ooss_pacientes que proyecte: 

-- nombre de todos las obras con el nombre y estado de todos sus planes, detallando dni, nombre y apellido de los afiliados a los distintos planes. 

create view vw_ooss_pacientes
as
select a.dni,p.nombre,p.apellido,o.sigla,pl.activo
from afiliados a inner join pacientes p on a.dni =p.dni
inner join ooss o on o.sigla=a.sigla
inner join planes pl on pl.sigla=a.sigla and pl.nroplan = a.nroplan

--15. Crear una vista vw_estudios_sin_cobertura que proyecte: 
--nombre del estudio que no es cubierto por ninguna obra social

create view vw_estudios_sin_cobertura
as 
select es.estudio, c.idestudio
from estudios es left join coberturas c on es.idestudio = c.idestudio
where c.idestudio is null


--16. Crear una vista vw_planes_sin_cobertura que proyecte: 
--nombre de la obra social y el plan que no cubran ningún estudio. 

create view vw_planes_sin_cobertura
as 
select es.estudio, c.idestudio
from estudios es left join coberturas c on es.idestudio = c.idestudio
where c.idestudio is null
OK

alter VIEW vw_estudios_sin_cobertura
AS
	SELECT E.estudio
	FROM Estudios E
	WHERE E.idEstudio NOT IN
		(SELECT idEstudio FROM Coberturas)

--17. Crear una vista vw_tabla_de_precios que proyecte: 
--nombre del estudio, obra social, plan, instituto, porcentaje cubierto, precio del estudio y neto a facturar a la obra social y al paciente. 

create VIEW vw_tabla_de_precios
AS
	SELECT E.estudio, O.Nombre [Obra Social], PL.Nombre [Plan], I.instituto, C.cobertura, PR.precio, 
	((PR.precio*C.cobertura)/100) [Facturar a OS], (PR.precio-((PR.precio*C.cobertura)/100)) [Facturar a Paciente]
	FROM Estudios E 
	JOIN Precios PR ON E.idEstudio = PR.idEstudio
	JOIN Institutos I ON PR.idInstituto = I.idInstituto
	JOIN Coberturas C ON E.idEstudio = C.idEstudio
	JOIN Planes PL ON C.sigla = PL.sigla AND C.nroplan = PL.nroplan
	JOIN OOSS O ON PL.sigla = O.sigla


--18. Crear una vista vw_edad_de_pacientes que proyecte: 
--edad de los pacientes 

create view vw_edad_de_pacientes
as 
select DATEdiff (year,p.nacimiento ,getdate()) as edad
from pacientes p


-- 19. Crear una vista vw_estudios_en_tres_meses que proyecte: los estudios realizados en los últimos tres meses 


create view vw_estudios_en_tres_meses
as
	select es.estudio, h.fecha
	from estudios es inner join historias h on h.idestudio=es.idestudio
	where DATEDIFF(M, H.Fecha, GETDATE()) <=3

CREATE VIEW vw_estudios_en_tres_meses
AS
	SELECT DISTINCT E.Estudio
	FROM Estudios E
	JOIN Historias H ON E.idEstudio = H.idEstudio
	WHERE DATEDIFF(M, H.Fecha, GETDATE()) <= 3


-- 20. Crear una vista vw_estudios_a_prepagas que proyecte: los estudios realizados a las prepagas en los últimos 45 días. 

create view vw_estudios_a_prepagas
as
	select es.estudio, h.fecha
	from estudios es inner join historias h on h.idestudio=es.idestudio
	where DATEDIFF(d, H.Fecha, GETDATE()) <= 45

-- 21. Crear una vista vw_estudios_por_mes que agrupe: por mes la cantidad de estudios realizados a los pacientes en el último año diferenciándolos por sexo y estudio realizado. 

create VIEW vw_estudios_por_mes
AS
	SELECT DATEPART(MM, H.Fecha) AS Mes, E.Estudio, P.Sexo, COUNT(E.Estudio) Cantidad
	FROM Historias H
	JOIN Estudios E ON H.idEstudio = E.idEstudio
	JOIN Pacientes P ON H.dni = P.dni
	--WHERE DATEDIFF(YY, H.Fecha, GETDATE()) <= 1
	GROUP BY E.Estudio, P.Sexo, DATEPART(MM, H.Fecha)


-- 22. Crear una vista vw_estudios_por_instituto que agrupe: por semana la cantidad de estudios que realizó cada instituto en los últimos 14 días. 

create view vw_estudios_por_instituto
as
select i.instituto, datepart (week,h.fecha) as semana,count (h.idestudio) as cant
from estudios es inner join historias h on h.idestudio =es.idestudio
inner join institutos i on i.idinstituto=h.idinstituto
where datediff (dd,h.fecha,getdate()) <=14
group by i.instituto,i.idinstituto,datepart (ww,h.fecha)


--23. Crear una vista vw_estudios_en_sabado que proyecte: 
--la cantidad de estudios que ordeno un médico y se realizaron un día sábado. 

CREATE VIEW vw_estudios_en_sabado
AS
	SELECT COUNT(idEstudio) [Cantidad de estudios]
	FROM Historias
	WHERE DATEPART(WEEKDAY, Fecha) = 6

--24. Crear una vista vw_nombre_de_institutos que proyecte: 

--todas las palabras que componen el nombre de un Instituto en letras minúsculas y 
--la primera en mayúscula, por ej: Instituto Del Diagnóstico. 
--(independientemente de como haya sido ingresado en la base). 
--NO REALIZAR


-- 25. Modificar la vista vw_pacientes definida en el punto 5: 

--5. Crear una vista vw_pacientes que proyecte:
--dni, nombre, apellido, sexo y fecha de nacimiento de los pacientes, obra social a la que
--pertenece, plan y nº de afiliado y categoría de ésta. (utilizar join 

-- si no tiene ingresado el nº de afiliado debe proyectar: 'a determinar'. 

create view vw_pacientes_5
as
select 


--26. Modificar la vista vw_pagos_pacientes del punto 13: 
--si el estudio no es cubierto debe pagar el 100%. 

create view vw_pagos_pacientes_13
as
select p.dni, p.nombre,p.apellido, es.estudio, h.fecha, pr.precio
from pacientes p inner join historias h on h.dni=p.dni
inner join estudios es on es.idestudio =h.idestudio
inner join precios pr on pr.idestudio = es.idestudio and h.idinstituto = pr.idinstituto
inner join institutos i on i.idinstituto=h.idinstituto
inner join coberturas c on es.idestudio = c.idestudio
where c.sigla is null

