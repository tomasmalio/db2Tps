Select * From Clubes

-----3.1----- Listar los partidos jugados como local o visitante por el Club Los Andes. (correlacionar) Proyectar: NroFecha, p.NroZona, Categoria, Local, Visitante, GolesL, GolesV.

Select	p.NroFecha, p.NroZona, p.Categoria, p.Id_ClubL, p.Id_ClubV, p.GolesL, p.GolesV 
From	Partidos p, Clubes c
Where	exists (select * from (
                              select Id_Club 
							  from clubes clb 
							  where (clb.Nombre like 'Los Andes'
							  )) andes
		        where ((andes.id_club=p.Id_ClubL)and(p.Id_ClubV=c.Id_Club)) 
				or andes.id_club=p.Id_ClubV and (p.Id_ClubL=c.Id_Club)) 

-----3.2----- Determinar los jugadores más viejos de cada club ordenados por Club. Proyectar: Jugador, Fecha_Nac, Club.

select	j.nrodoc Nro_Documento, j.nombre Nombre_del_Jugador, j.Fecha_Nac, c.nombre Club 	
from	jugadores j inner join clubes c on c.Id_Club=j.Id_Club
where	EXISTS	(select * from (select min(j.Fecha_Nac) Mas_Viejos, j.Id_Club from jugadores j group by j.Id_Club) jv 
		where (jv.Mas_Viejos=j.Fecha_Nac) and (jv.Id_Club=j.Id_Club))

-----3.3----- Determinar los clubes con menos de 40 jugadores. (por correlación y agrupamiento).
select *
from clubes c
where c.Id_club=any(select cant.Id_Club 
			from (select count(j.Id_Club) cant, j.Id_CLub from jugadores j group by j.Id_Club)cant
			where cant.cant<40)

---EXISTS---

-----3.4----- Determinar el club donde juegue el jugador FLORES SERGIO.--Asi se hace?
select 	c.nombre Club 
from 	clubes c
where	EXISTS (select * from (select j.Id_Club from jugadores j where j.nombre like 'FLORES, SERGIO')fs
	       where fs.Id_Club=c.Id_Club)

-----3.3----- Determinar los jugadores de los equipos que no hayan ganado más de 2 partidos. Proyectar Nombre del jugador y nombre del club ordenados por club y jugador.

select c.nombre Nombre_Club, j.nombre nombre_Jugador
from jugadores j inner join clubes c on c.Id_Club=j.Id_Club
where EXISTS (select * from (select g.Id_Club from general g where g.ganados<3) tp where tp.Id_Club=j.Id_Club)
order by c.nombre,j.nombre 

--7.	Determinar los partidos que se perdio como local y que haya jugado el jugador FLORES, SERGIO.
	--Proyectar: NroFecha, p.NroZona, Categoria, Local, Visitante, GolesL, GolesV
select 	p.NroFecha, p.NroZona, p.Categoria,p.Id_ClubL, p.Id_ClubV,c.nombre _Local,cv.nombre Visitante, p.GolesL, p.GolesV
from 	(partidos p inner join clubes c on c.Id_Club=p.Id_ClubL )inner join clubes cv on cv.Id_Club=p.Id_ClubV
where 	exists(select *
	      from (select j.Id_club, j.categoria from jugadores j where j.nombre like 'FLORES, SERGIO')as pjfs
	      where p.Id_ClubL=pjfs.Id_Club and pjfs.categoria=p.categoria)


					--UTILIZANDO OPERARDOR ANY

--8.	Listar los jugadores que no se encuentren entre los mas viejos de cada club.(no utilizar la función min()).
	--Proyectar nombre del jugador, fecha de nacimiento con formato:
	--dd mmm aaaa y nombre del club.

select j.nombre, datename (dd,j.Fecha_Nac)+ ' ' + datename(month, j.Fecha_Nac)+' '+datename(year,j.Fecha_Nac), c.nombre Club
from	jugadores j inner join clubes c on c.Id_Club=j.Id_Club
where  	j.Fecha_Nac >any (select j1.Fecha_Nac from jugadores j1
	      		  where j1.Id_Club=j.Id_Club)
		
select upper('gabri')--Pone en mayuscula.
select substring('Gaby',1, 2) --Saca una letra.


--9.	Listar los jugadores de la categoría 84 cuyo club haya  marcado mas de 10 goles de visitante en algún partido.
	--Proyectar Nombre del Jugador, Categoría y Nombre del Club.
select 	j84.Nombre, j84.categoria, c.nombre Club
from 	clubes c inner join (select * from jugadores j where j.categoria=84)j84 on j84.Id_Club=c.ID_Club 
where c.Id_Club=any(select distinct p.Id_ClubV from partidos p where p.GolesV>10)
order by c.Id_Club

--10.	Listar los clubes que ganaron 2 o mas partidos por dos goles de diferencia VER COMO USAR ANY!!!!!!!!
	
select c.Id_Club, c.nombre
from 	clubes c
where  c.Id_Club=ANY

	(select 	ptot.Id_Club
	from	(select c.Id_Club, sum(isnull(pl.cantL,0) + pv.cantV) cant_part, c.nombre Club
		from 		clubes c left join (select count (*) cantL,p.Id_ClubL 
				from partidos p 
				where (p.GolesL-p.GolesV)=2 group by p.Id_ClubL) as pl on pl.Id_ClubL=c.Id_Club
				inner join (select count (*) cantV, p.Id_ClubV 
				from partidos p 
				where (p.GolesL-p.GolesV)=2 group by p.Id_ClubV)as pv on pv.Id_ClubV=c.Id_Club
		group by c.Id_Club, c.nombre) as ptot
	where	ptot.cant_part>=2)

						--OPERARDOR ALL

--11.	Listar los jugadores que se encuentren entre los más jóvenes de cada club. (no utilizar max())
select j.TipoDoc, j.NroDoc, j.nombre, j.Fecha_nac, c.nombre Club
from jugadores j inner join clubes c on c.Id_Club=j.Id_Club
where j.Fecha_Nac>=all(select j1.Fecha_Nac from jugadores j1 where j1.Id_Club=j.Id_Club)
order by j.Id_Club

--12.	Listar los Clubes de la categoría 85 que no hayan marcado goles en ningún partido jugando de visitante 
--	en las primeras 6 fechas.
select *
from clubes c 
where 0=all	(select p.GolesV
		from partidos p 
		where (p.Id_ClubV=c.Id_Club)and(p.nrofecha between 1 and 6)and (p.categoria=85))
     	
			
--13.	Listar los jugadores del club de la categoría 84 
--	que hayan  marcado goles en todos los partidos de las primeras 8 fechas.
select *
from (select * from jugadores j where j.categoria=84) j84
where  (0!=ALL(select p.golesV from partidos p where (p.categoria=84)and(p.nrofecha between 1 and 8)and(p.Id_ClubV=j84.Id_Club)) )
	and(0!=ALL(select p.golesL from partidos p where (p.categoria=84)and(p.nrofecha between 1 and 8)and(p.Id_ClubL=j84.Id_Club))) 
order by j84.Id_Club

--select * from partidos p where (p.categoria=84)and(p.nrofecha between 1 and 8)	
--order by p.nrofecha, p.Id_ClubL		
			
--14.	Listar los jugadores y el nombre del club con menor diferencia de goles.
select 	j.tipodoc, j.nrodoc, j.nombre,c.nombre Club
from	jugadores j inner join clubes c on c.Id_Club=j.Id_Club

where 	j.Id_Club=any	(select 	g.Id_Club
			from 	general g
			where	g.diferencia<=ALL(select g.diferencia from general g))


CUALQUIER OPERADOR

--15.	Determinar el Club y la cantidad de jugadores de los clubes que ganaron más partidos que los que perdieron.
select c.nombre Club, count(*) cant_jug
from clubes c inner join jugadores j on j.Id_Club=c.Id_Club
where c.Id_Club=Any(select g.Id_club from general g where g.ganados>g.perdidos)
group by c.nombre

--16.	Listar los 5 números de documento más altos de los jugadores de cada categoría.
select j.nrodoc, j.categoria, j.nombre
from jugadores j
where 5>(select count(*) from jugadores j1 where (j1.nrodoc>j.nrodoc)and(j.categoria=j1.categoria))
group by j.categoria, j.nrodoc, j.nombre
order by j.nrodoc desc

--17.	Listar los 3 números de documento más bajos de los jugadores de cada club.
select j.nrodoc, j.Id_Club
from jugadores j --inner join clubes c on c.Id_Club=j.Id_Club
where 3>(select count(*) from jugadores j1 where (j1.nrodoc<j.nrodoc) and (j1.Id_Club=j.Id_Club))
group by j.nrodoc, j.Id_Club
order by j.Id_Club
--18.	Listar el 5ª y 6ª número de documento más alto de los jugadores de cada club.
/*select j.nrodoc
from jugadores j
where 6>(select count(*) from jugadores j1 where j1.nrodoc<j.nrodoc)
order by j.nrodoc desc
*/
select j.nrodoc, j.Id_Club
from jugadores j
where ((select count(*) from jugadores j1 where j1.nrodoc<j.nrodoc and (j.Id_Club=j1.Id_Club)))between 4 and 5
order by j.Id_Club desc

--19.	Listar equipo y zona de la categoría 85 que hayan empatado entre la 5º y 7º fecha.
select cl.nombre ClubLocal, cv.nombre ClubVisitante, p1.nrozona
from (partidos p1 inner join clubes cl on cl.Id_Club=p1.Id_ClubL)inner join clubes cv on cv.Id_Club=p1.Id_ClubV
where EXISTS(select * from partidos p where (p.golesV=p.golesL)and(p.categoria=85)and(p.nrofecha between 5 and 7)
	and(p1.Id_Partido=p.Id_Partido))

--Esto tambien funciona!!!
select cl.nombre ClubLocal, cv.nombre ClubVisitante, p1.nrozona
from ((select * from partidos p where p.categoria=85)as p1 inner join clubes cl on cl.Id_Club=p1.Id_ClubL)inner join clubes cv on cv.Id_Club=p1.Id_ClubV
where EXISTS(select * from partidos p where (p.golesV=p.golesL)and(p.nrofecha between 5 and 7)
	and(p1.Id_Partido=p.Id_Partido))


--20.	Listar los equipos que ganaron por 10 goles de diferencia en la zona número 2.
select *
from clubes c
where EXISTS(select * from partidos p where (p.nrozona=2)and(((p.Id_ClubV=c.Id_Club) and ((p.golesV-p.golesL)=10))
		or((p.Id_ClubL=c.Id_Club) and ((p.golesL-p.golesV)=10))))

select *
from clubes c
where (c.Id_Club=any(select p.Id_ClubV from partidos p where (p.nrozona=2)and((p.Id_ClubV=c.Id_Club) and ((p.golesV-p.golesL)=10))))
	or(c.Id_Club=any(select p.Id_ClubL from partidos p where (p.nrozona=2)and((p.Id_ClubL=c.Id_Club) and ((p.golesL-p.golesV)=10))))

--No seria viable si hay mas de uno...
select *
from clubes c
where 2=any(select p.nrozona from partidos p where (((p.Id_ClubV=c.Id_Club) and ((p.golesV-p.golesL)=10))
		or((p.Id_ClubL=c.Id_Club) and ((p.golesL-p.golesV)=10))))


--21.	Listar los equipos de la zona 1 que marcaron goles en las 5 primeras fechas jugando de visitante.
select *
from (select * from clubes c where c.nrozona=1) cz1
where EXISTS(select * from partidos p where ((p.Id_ClubV=cz1.Id_Club)and(golesV>0)and(p.nrofecha between 1 and 5)))
	--and 5<any(select p.nrofecha from partidos p where p.Id_ClubV=cz1.Id_Club and golesV>0)
select *
from (select * from clubes c where c.nrozona=1) cz1
where cz1.Id_Club=any(select p.Id_ClubV from partidos p where ((golesV>0)and(p.nrofecha between 1 and 5)))


select *
from clubes c
where 1=any(select p.nrozona from partidos p where ((golesV>0)and(p.nrofecha between 1 and 5)and(p.Id_ClubV=c.Id_Club)))

--select * from partidos p where (p.nrofecha between 1 and 5)and(p.nrozona=1)and(p.golesV>0)

--22.	Listar los equipos que no marcaron goles en las 5 primeras fechas.
select *
from clubes c
where 	EXISTS	(select * from (select count(*) cant from partidos p where (((c.Id_Club=p.Id_ClubV)and(p.golesV=0)and(p.nrofecha between 1 and 5))
		or ((c.Id_Club=p.Id_ClubL)and(p.golesL=0)and(p.nrofecha between 1 and 5)))
		group by c.Id_Club) as nt
		where  nt.cant=5)

select *
from clubes c
where 	5=any(select count(*) cant from partidos p where (((c.Id_Club=p.Id_ClubV)and(p.golesV=0)and(p.nrofecha between 1 and 5))
		or ((c.Id_Club=p.Id_ClubL)and(p.golesL=0)and(p.nrofecha between 1 and 5)))
		group by c.Id_Club)
--23.	Listar los equipos de la categoría 85 que no hayan ganado de local en la primera fecha.
select *
from clubes c
where EXISTS(select * from partidos p where p.nrofecha=1 and p.categoria=85 and ((c.Id_Club=p.Id_ClubL and golesL<=golesV)or(c.Id_Club=p.Id_ClubV and golesV<=golesL)))



--24.	Cantidad de Jugadores por categoría de los equipos que no participaron en la primera fecha del campeonato.
select count(*) cant_jugadores,j.categoria, c.Id_Club, c.nombre Club
from clubes c inner join jugadores j on j.Id_Club=c.Id_Club
where NOT EXISTS(select * from partidos p where (p.nrofecha=1)and ((p.Id_ClubV=c.Id_Club)or(p.Id_ClubL=c.Id_Club)))
group by c.Id_Club, j.categoria, c.nombre

select count(*) cant_jugadores,j.categoria, c.Id_Club, c.nombre Club
from clubes c inner join jugadores j on j.Id_Club=c.Id_Club
where (c.Id_Club!=ALL(select p.Id_ClubL from partidos p where p.nrofecha=1))and 
	(c.Id_Club!=ALL(select p.Id_ClubV from partidos p where p.nrofecha=1))
group by c.Id_Club, j.categoria, c.nombre

--25.	Listar los equipos que no posean partidos empatados.
select *
from clubes c
where NOT EXISTS(select * from partidos p where (p.Id_ClubV=c.Id_Club and p.golesV=p.golesL)or
		(p.Id_ClubL=c.Id_Club and p.golesL=p.golesV))

select *
from clubes c
where (c.Id_Club!=ALL(select p.Id_ClubL from partidos p where p.golesL=p.golesV))and
(c.Id_Club!=ALL(select p.Id_ClubV from partidos p where p.golesL=p.golesV))


--26.	Listar todos los equipos que finalizaron ganando 2 a 0.
select *
from clubes c
where 	(c.Id_Club=any(select p.Id_ClubL from partidos p where (p.golesL-p.golesV)=2))or
	(c.Id_Club=any(select p.Id_ClubV from partidos p where (p.golesV-p.golesL)=2))


select *
from clubes c
where EXISTS(select * from partidos p where (p.Id_ClubL=c.Id_Club and (p.golesL-p.golesV)=2)or
			(p.Id_ClubV=c.Id_Club and (p.golesV-p.golesL=2)))
--27.	Identificar a los equipos que participaron en el partido que hubo mayor diferencia de goles
select cl.nombre CLubLocal, cv.nombre ClubVisitante
from (partidos p inner join clubes cl on cl.Id_Club=p.Id_ClubL)inner join clubes cv on cv.Id_Club=p.Id_ClubV
where  (((p.golesV-p.golesL)>=all(select p1.golesL-p1.golesV from partidos p1 where (p1.golesL-p1.golesV)>=all(select p.golesL-p.golesV from partidos p)))and
	(p.golesV-p.golesL)>all(select p1.golesV-p1.golesL from partidos p1 where(p1.golesV-p1.golesL)>=all(select p.golesV-p.golesL from partidos p)))
	
	or(((p.golesL-p.golesV)>=all(select p1.golesL-p1.golesV from partidos p1 where (p1.golesL-p1.golesV)>=all(select p.golesL-p.golesV from partidos p)))and
	(p.golesV-p.golesL)>=all(select p1.golesV-p1.golesL from partidos p1 where(p1.golesV-p1.golesL)>=all(select p.golesV-p.golesL from partidos p)))	




	((p.golesL-p.golesV)>=all(select p1.golesL-p1.golesV from partidos p1 where (p1.golesL-p1.golesV)>=all(select p.golesL-p.golesV from partidos p)))
	and((p.golesL-p.golesV)>all(select p1.golesV-p1.golesL from partidos p1 where(p1.golesV-p1.golesL)>=all(select p.golesV-p.golesL from partidos p)))
	
	






