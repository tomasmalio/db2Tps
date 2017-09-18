use jugadores
/*
30.	Listar los partidos jugados como local por el Club SAN MARTIN. 
	Proyectar: NroFecha, p.NroZona, Categoria, Visitante, GolesL, GolesV.
	

select p.NroFecha, p.NroZona, p.Categoria, p.id_clubv as Visitante, p.GolesL, p.GolesV
from Partidos p
where ( select c.nombre
		from clubes c where
		 p.Id_ClubL=c.Id_Club)= 'SAN MARTIN'
*/

-- 3.1. Listar los partidos jugados como local por el Club Los Andes. (correlacionar)
--		Proyectar: NroFecha, p.NroZona, Categoria, Local, Visitante, GolesL, GolesV.

SELECT * FROM Clubes  WHERE NOMBRE='LOS ANDES'
SELECT p.NroFecha, p.NroZona, p.Categoria, p.Id_ClubL as Local, p.Id_ClubV as Visitante, p.GolesL, p.GolesV
FROM Partidos p
WHERE EXISTS (SELECT * FROM Clubes c WHERE (p.Id_ClubL = c.Id_Club or p.Id_ClubV = c.Id_Club)
and c.Nombre = 'LOS ANDES')

-- 3.2.	Determinar los jugadores mas viejos de cada club ordenados por Club.
--		Proyectar: Jugador, Fecha_Nac, Club.
SELECT c.Nombre as club, j.nombre, j.Fecha_Nac
FROM jugadores j INNER JOIN Clubes c on c.Id_club = j.Id_Club
WHERE j.Fecha_Nac = (select min(jj.fecha_nac) FROM Jugadores jj WHERE jj.Id_Club = jj.Id_club)

--3.3. Determinar los clubes con menos de 40 jugadores. (por correlación y agrupamiento).
SELECT cc.Nombre 
FROM clubes cc
WHERE 40 > (SELECT count(*) 
			FROM clubes c inner join jugadores j on c.Id_Club = j.Id_Club
			WHERE cc.id_club = c.Id_Club
			GROUP BY c.id_club)



--ESTOS SON DEL OPERADOR EXISTS

--34.	Determinar el club donde juegue el jugador FLORES SERGIO.

select c.Nombre 
from Clubes c
where exists (select * from Jugadores j
where c.Id_club=j.Id_club and j.Nombre ='FLORES, SERGIO')

--35.	Determinar los jugadores de los equipos que no hayan ganado más de 2 partidos.
--	Proyectar Nombre del jugador y nombre del club ordenados por club y jugador.

select j.nombre [Jugador], c.nombre [Club]
from jugadores j inner join clubes c on j.id_club=c.id_club
where exists 
	(select perdidos
	 from general g
	 where perdidos>2 and c.id_club=g.id_club)
group by c.nombre, j.nombre


--36.	Determinar los partidos que se perdio como local y que haya jugado el jugador FLORES, SERGIO.
--	Proyectar: NroFecha, p.NroZona, Categoria, Local, Visitante, GolesL, GolesV

select NroFecha, p.NroZona, Categoria , Id_clubL [Local], Id_ClubV Visitante, GolesL, GolesV
from Partidos p
where ((golesL-golesV < 0 )and 
	exists (select * from Jugadores j
		where p.Id_clubl=j.Id_club and j.Nombre ='FLORES, SERGIO'))


--ESTOS SON DEL OPERARDOR ANY

-- 37.	Listar los jugadores que no se encuentren entre los mas viejos de cada club.(no utilizar la función min()).
--	Proyectar nombre del jugador, fecha de nacimiento con formato:
--	dd mmm aaaa y nombre del club.

select j.nombre, convert( char(12), j.fecha_nac,103)
AS [fecha nacimiento], c.nombre
from   jugadores j, clubes c
where  fecha_nac > ANY
        (select fecha_nac from jugadores j1
         where j1.id_club = j.id_club and
         c.id_club=j.id_club
 group by j.id_club, fecha_nac)
order by j.id_club


-- 38.	Listar los jugadores de la categoría 84 cuyo club haya  marcado mas de 10 goles de visitante en algún partido.
--	Proyectar Nombre del Jugador, Categoría y Nombre del Club.

select j.nombre [Jugador],j.categoria [Categoria], c.nombre [Club]
from jugadores j, clubes c
where j.id_club=c.id_club
and 10 < any
(select p.golesv
 from partidos p
 where j.categoria=84
 and c.id_club=p.id_clubv)

--39.	Listar los clubes que ganaron 2 o mas partidos por dos goles de diferencia

select c.nombre
from Clubes c
where 2 <= ANY (Select count(*) from Partidos p 
where (abs (p.golesL-p.golesV) = 2)
and ((c.id_club = p.id_clubl) or (c.id_club = p.id_clubv)) )

--ESTOS SON DEL OPERARDOR ALL

--40.	Listar los jugadores que se encuentren entre los más jóvenes de cada club. (no utilizar max())

select j.nombre Jugador, c.nombre [Club]
from   jugadores j inner join clubes c on c.id_club=j.id_club
where  j.fecha_nac >= ALL
        (select j1.fecha_nac from jugadores j1
         where j1.Id_Club = j.Id_Club)
order by j.id_club

--41.	Listar los Clubes de la categoría 85 que no hayan marcado goles en ningún partido jugando de visitante en las primeras 6 fechas.

select *
from clubes c
where 0=all 
(select p1.golesv
 from partidos p1
 where p1.categoria=85
 and c.id_club=p1.id_clubv
 and p1.nrofecha<=6)

--42.	Listar los jugadores de la categoría 84 que hayan  marcado goles en todos los partidos de las primeras 8 fechas.



-- 43.	Listar los jugadores y el nombre del club con menor diferencia de goles.

select j.nombre Jugador, c.nombre Club
from Jugadores j inner join Clubes c on c.Id_club=j.Id_club
where c.Id_club in (select Id_club from General g
where Diferencia <= ALL (Select Diferencia from General)
And c.Id_club=g.Id_club)

--ESTOS SON DE CUALQUIER OPERADOR

--44.	Determinar el Club y la cantidad de jugadores de los clubes que ganaron más partidos que los que perdieron.

select c.nombre [Club], count(j.nombre) [Cantidad de Jugadores]
from clubes c inner join jugadores j on c.id_club=j.id_club
	inner join general g on c.id_club=g.id_club
where g.ganados > (select g1.perdidos
 from general g1
 where c.id_club=g1.id_club)
group by c.nombre



--45.	Listar los 5 números de documento más altos de los jugadores de cada categoría.

SELECT Categoria, nrodoc [Nro. Documento]
FROM jugadores j1
WHERE 5 > (SELECT count(*) FROM jugadores j2
WHERE j1.nrodoc < j2.nrodoc and j1.categoria = j2.categoria)
GROUP BY categoria, nrodoc
ORDER BY categoria, nrodoc DESC


--46.	Listar los 3 números de documento más bajos de los jugadores de cada club.
select c.Nombre Club, j.Nrodoc [Nro. Documento]
from Clubes c inner join Jugadores j on c.id_club=j.id_club
where  3 > ( select count(*) from jugadores j1
            where j.Nrodoc < j1.Nrodoc )
order by c.Nombre


--47.	Listar el 5ª y 6ª número de documento más alto de los jugadores de cada club.

SELECT j1.id_club, c.Nombre, j1.nrodoc as [Nro.DOC.]
FROM jugadores j1 inner join clubes c on c.id_club=j1.id_club
WHERE (SELECT count(*) FROM jugadores j2
WHERE j1.nrodoc < j2.nrodoc and j1.id_club = j2.id_club) between 5-1 and 6-1
GROUP BY j1.id_club, c.Nombre, nrodoc
ORDER BY j1.id_club, nrodoc DESC



-- 48.	Listar equipo y zona de la categoría 85 que hayan empatado entre la 5º y 7º fecha.

Select c.Nombre, c.Nrozona
from Clubes c
where exists
((select p.ID_clubL as IDClub
 from Partidos p 
where (p.golesL=p.golesV)  and (p.NroFecha between 5 and 7)
and (categoria=85) and (p.ID_clubL = c.Id_club))
union
(select p.ID_clubV as IDClub 
from Partidos p 
where (p.golesL=p.golesV)  and (p.NroFecha between 5 and 7) 
and (categoria=85) and (p.ID_clubv = c.Id_club)))


--49.	Listar los equipos que ganaron por 10 goles de diferencia en la zona número 2.

select c.Id_club, c.nombre from Clubes c
where exists 
((select p.ID_clubL as IDClub
 from Partidos p 
where p.golesL-p.golesV = 10 and p.NroZona = 2 and p.ID_clubL = c.Id_club)
union
(select p.ID_clubV as IDClub 
from Partidos p 
where p.golesV-p.golesL = 10 and p.NroZona = 2 and p.ID_clubV= c.Id_club))


--50.	Listar los equipos de la zona 1 que marcaron goles en las 5 primeras fechas jugando de visitante.

select *
from clubes c
where 0<any
(select p1.golesv
 from partidos p1
 where p1.nrozona=1
 and c.id_club=p1.id_clubv
 and p1.nrofecha<=5)


--51.	Listar los equipos que no marcaron goles en las 5 primeras fechas.

SELECT c.nombre
FROM clubes c
WHERE exists
((select p.ID_clubL as IDClub
 from Partidos p 
where (p.golesL=0)  and (p.NroFecha <= 5)
and (p.ID_clubL = c.Id_club))
union
(select p.ID_clubV as IDClub 
from Partidos p 
where (p.golesV=0)  and (p.NroFecha <=5) 
and (p.ID_clubv = c.Id_club)))

--Opcion 2
-- Equipos que no marcaron goles en ningun partido de las 5 primeras fechas 

SELECT c.nombre
FROM clubes c
WHERE not exists
((select p.ID_clubL as IDClub
 from Partidos p 
where (p.NroFecha <= 5)
and (p.ID_clubL = c.Id_club)
group by p.Id_clubL
having sum(p.golesL)>0)
union
(select p.ID_clubV as IDClub
 from Partidos p 
where (p.NroFecha <= 5)
and (p.ID_clubV = c.Id_club)
group by p.Id_clubV
having sum(p.golesV)>0))

--52.	Listar los equipos de la categoría 85 que no hayan ganado de local en la primera fecha.

select c.Id_club, c.nombre from Clubes c 
where exists 
(select p.ID_clubL as IDClub
 from Partidos p 
where p.golesL-p.golesV <= 0 
and p.categoria = 85
and p.NroFecha=1
and p.ID_clubL = c.Id_club)
order by c.nombre


-- 53.	Cantidad de Jugadores por categoría de los equipos que no participaron en la primera fecha del campeonato.

Select j.Categoria, count(*) as [Cant. Jugadores] 
from jugadores j 
where not exists
(select *
 from clubes c
 where c.Id_club=j.Id_club and 1 = any
(select nrofecha
 from partidos p
 where c.id_club=p.id_clubv or c.id_club=p.id_clubl))
group by j.categoria

--54.	Listar los equipos que no posean partidos empatados.

SELECT c.nombre
FROM clubes c
WHERE NOT EXISTS (SELECT * FROM general g
WHERE g.id_club = c.id_club and g.empatados = 0)

-- 55. Listar todos los equipos que finalizaron ganando 2 a 0.

select c.Id_club, c.Nombre from Clubes c
where exists 
((select p.ID_clubL as IDClub
 from Partidos p 
where p.golesL= 2 and p.golesV = 0  and p.ID_clubL = c.Id_club)
union
(select p.ID_clubV as IDClub 
	from Partidos p 
where p.golesL=0 and p.golesV = 2 and p.ID_clubV= c.Id_club))
order by c.nombre


-- 56.	Identificar a los equipos que participaron en el partido que hubo mayor diferencia de goles.
select *
from general g
where g.diferencia > all (select g1.diferencia from general g1 where g.id_club<>g1.id_club)
