-- 30. Listar los partidos jugados como local por el Club SAN MARTIN. 
-- Proyectar: NroFecha, p.NroZona, Categoria, Visitante, GolesL, GolesV.

select p.NroFecha, p.NroZona, p.Categoria, p.id_clubv as Visitante, p.GolesL, p.GolesV
from Partidos p
where (
		select c.nombre
		from clubes c where
		 p.Id_ClubL=c.Id_Club
 )= 'SAN MARTIN'


 
 -- 32. Listar los partidos jugados como local o visitante por el Club Los Andes. (correlacionar)
 -- Proyectar: NroFecha, p.NroZona, Categoria, Local, Visitante, GolesL, GolesV.


 SELECT * FROM CLUBES  WHERE NOMBRE='LOS ANDES'

 select p.NroFecha, p.NroZona, p.Categoria, p.Id_ClubL as Local, p.Id_ClubV as Visitante, p.GolesL, p.GolesV
 from partidos p
 where  EXISTS
 (select * from clubes c where (p.Id_ClubL=c.Id_Club or p.Id_ClubV=c.Id_Club)
 and c.nombre='LOS ANDES')


-- 34. Determinar los jugadores más viejos de cada club ordenados por Club.
-- Proyectar: Jugador, Fecha_Nac, Club.

 select c.Nombre,j.nombre,j.Fecha_Nac
 from  jugadores j inner join clubes c on c.Id_club=j.Id_Club
 where  j.Fecha_Nac = (select min(j1.fecha_nac) 
					from jugadores j1
					where j.Id_Club=j1.Id_club
					 ) 

-- 36. Determinar los clubes con menos de 40 jugadores. (por correlación y agrupamiento).

select c1.Nombre 
from clubes c1
where 40 > (
			select count(*) 
			from clubes c inner join jugadores j on c.Id_Club=j.Id_Club
			where c1.id_club=c.Id_Club
			group by c.id_club
			)

--OPERADOR EXISTS

-- 37. Determinar el club donde juegue el jugador FLORES SERGIO.

select c.nombre
from clubes c
where exists (select *
			  from jugadores j
			  where c.Id_Club=j.Id_Club
			  and j.nombre='FLORES, SERGIO')


-- 38. Determinar los jugadores de los equipos que no hayan ganado más de 2 partidos.
-- Proyectar: Nombre del jugador y nombre del club ordenados por club y jugador.

select c.nombre, j.nombre
from jugadores j inner join clubes c on j.id_Club=c.Id_Club
where exists  (select j.id_club 
			   from general g 
			   where g.id_club = j.id_club and g.ganados <3 )
order by c.nombre, j.nombre 


select * from general g 
where g.ganados <3 

select id_club ,count (* ) from jugadores j 
where id_club in (19,24)
group by id_club 

-- 40. Determinar los partidos que se perdio como local y que haya jugado el jugador FLORES, SERGIO.
-- Proyectar: NroFecha, p.NroZona, Categoria, Local, Visitante, GolesL, GolesV


