/**
	3.1 Listar los partidos jugados como local o visitante por el Club Los Andes. (correlacionar) 
	Proyectar: NroFecha, p.NroZona, Categoria, Local, Visitante, GolesL, GolesV.
**/
SELECT p.NroFecha, p.NroZona, p.Categoria, p.Id_ClubL, p.Id_ClubV, p.GolesL, p.GolesV 
FROM Partidos p, Clubes c
WHERE EXISTS (
				SELECT * 
				FROM (
						SELECT Id_Club 
						FROM clubes clb 
						WHERE (clb.Nombre LIKE 'Los Andes')
					) andes
				WHERE ((andes.id_club = p.Id_ClubL) AND (p.Id_ClubV = c.Id_Club)) 
					OR andes.id_club = p.Id_ClubV 
					AND (p.Id_ClubL = c.Id_Club)
			) 

/**
	3.2 Determinar los jugadores más viejos de cada club ordenados por Club. 
	Proyectar: Jugador, Fecha_Nac, Club.
**/
SELECT j.nrodoc Nro_Documento, j.nombre Nombre_del_Jugador, j.Fecha_Nac, c.nombre Club 	
FROM Jugadores j 
INNER JOIN Clubes c on c.Id_Club = j.Id_Club
WHERE EXISTS 
	(
		SELECT * FROM (
						SELECT MIN(j.Fecha_Nac) Mas_Viejos, j.Id_Club FROM Jugadores j GROUP BY j.Id_Club
					) jv 
		WHERE (jv.Mas_Viejos = j.Fecha_Nac) AND (jv.Id_Club = j.Id_Club)
	)

/** 
	3.3 Determinar los clubes con menos de 40 jugadores. (por correlación y agrupamiento).
**/
SELECT *
FROM clubes c
WHERE c.Id_club = ANY (
						SELECT cant.Id_Club 
						FROM (
								SELECT COUNT(j.Id_Club) cant, j.Id_CLub FROM jugadores j GROUP BY j.Id_Club
							) cant
						WHERE cant.cant < 40
					)

/**
	EXISTS
**/
/**
	3.4 Determinar el club donde juegue el jugador FLORES SERGIO.

	************************
	IMPORTANTE: ¿Esta bien?
	************************
**/
SELECT c.nombre Club 
FROM Clubes c
WHERE EXISTS (
				SELECT * 
				FROM (
						SELECT j.Id_Club FROm jugadores j WHERE j.nombre LIKE 'FLORES, SERGIO'
					) fs
				WHERE fs.Id_Club = c.Id_Club
			)

/**
	3.5 / 3.6 Determinar los jugadores de los equipos que no hayan ganado más de 2 partidos. 
	Proyectar Nombre del jugador y nombre del club ordenados por club y jugador.
**/
SELECT c.nombre Nombre_Club, j.nombre nombre_Jugador
FROM Jugadores j 
INNER JOIN Clubes c PN c.Id_Club = j.Id_Club
WHERE EXISTS (
				SELECT * 
				FROM (
						SELECT g.Id_Club 
						FROM General g 
						WHERE g.ganados < 3
					) tp where tp.Id_Club = j.Id_Club
			)
ORDER BY c.nombre, j.nombre 


/**
	ANY
**/
/** 
	3.7 Listar los jugadores que no se encuentren entre los mas viejos de cada club.(no utilizar la función min()). 
	Proyectar nombre del jugador, fecha de nacimiento con formato:dd mmm aaaa y nombre del club.
**/
SELECT j.nombre, datename (dd, j.Fecha_Nac) + ' ' + datename(month, j.Fecha_Nac) + ' ' + datename(year, j.Fecha_Nac), c.nombre Club
FROM Jugadores j 
INNER JOIN clubes c ON c.Id_Club = j.Id_Club
WHERE j.Fecha_Nac > ANY (
							SELECT j1.Fecha_Nac 
							FROM Jugadores j1
							WHERE j1.Id_Club = j.Id_Club
						)


/** 
	3.8 Listar los jugadores de la categoría 84 cuyo club haya marcado más de 10 goles de visitante en algún partido. 
	Proyectar Nombre del Jugador, Categoría y Nombre del Club.
**/
select j84.Nombre, j84.categoria, c.nombre Club
FROM Clubes c INNER JOIN (
							SELECT * 
							FROM Jugadores j 
							WHERE j.categoria = 84
						) j84 ON j84.Id_Club = c.ID_Club 
WHERE c.Id_Club = ANY (
						SELECT DISTINCT p.Id_ClubV 
						FROM Partidos p 
						WHERE p.GolesV > 10
					)
ORDER BY c.Id_Club

/**
	ALL
**/

/** 
	3.9 Listar los jugadores que se encuentren entre los más jóvenes de cada club. (no utilizar max())
**/
SELECT j.TipoDoc, j.NroDoc, j.nombre, j.Fecha_nac, c.nombre Club
FROM Jugadores j 
INNER JOIN Clubes c ON c.Id_Club = j.Id_Club
WHERE j.Fecha_Nac >= ALL (
							SELECT j1.Fecha_Nac 
							FROM Jugadores j1 
							WHERE j1.Id_Club = j.Id_Club
						)
ORDER BY j.Id_Club

/**
	3.10 Listar los Clubes de la categoría 85 que no hayan marcado goles en ningún partido jugando de visitante en las primeras 6 fechas.
**/
SELECT *
FROM Clubes c 
WHERE 0 = ALL (
				SELECT p.GolesV
				FROM Partidos p 
				WHERE (p.Id_ClubV = c.Id_Club) AND (p.nrofecha BETWEEN 1 AND 6) AND (p.categoria = 85)
			)
		
/**
	3.11 Listar los jugadores y el nombre del club con menor diferencia de goles.
**/
SELECT j.tipodoc, j.nrodoc, j.nombre,c.nombre Club
FROM Jugadores j 
INNER JOIN Clubes c ON c.Id_Club=j.Id_Club
WHERE j.Id_Club = ANY (
						SELECT g.Id_Club
						FROM General g
						WHERE g.diferencia <= ALL (
													SELECT g.diferencia FROM general g
												)
					)

-----CUALQUIER OPERADOR-----

/**
	3.12 Determinar el Club y la cantidad de jugadores de los clubes que ganaron más partidos que los que perdieron.
**/
SELECT c.nombre Club, COUNT(*) cant_jug
FROM Clubes c 
INNER JOIN Jugadores j ON j.Id_Club = c.Id_Club
WHERE c.Id_Club = ANY (
						SELECT g.Id_club 
						FROM General g 
						WHERE g.ganados > g.perdidos
					)
GROUP BY c.nombre

/**
	3.13 Listar los 5 números de documento más altos de los jugadores de cada categoría.
**/
SELECT j.nrodoc, j.categoria, j.nombre
FROM Jugadores j
WHERE 5 > (
			SELECT COUNT(*) 
			FROM Jugadores j1 
			WHERE (j1.nrodoc > j.nrodoc) AND (j.categoria = j1.categoria))
GROUP BY j.categoria, j.nrodoc, j.nombre
ORDER BY j.nrodoc DESC

/**
	3.14 Listar el 5a y 6a número de documento más alto de los jugadores de cada club.
	************************
	IMPORTANTE: ¿Esta bien?
	************************
**/
SELECT j.nrodoc, j.Id_Club
FROM Jugadores j 
WHERE 3 > (
			SELECT COUNT(*) 
			FROM Jugadores j1 
			WHERE (j1.nrodoc < j.nrodoc) AND (j1.Id_Club = j.Id_Club))
GROUP BY j.nrodoc, j.Id_Club
ORDER BY j.Id_Club

--inner join clubes c on c.Id_Club=j.Id_Club

-- 3.15 Listar equipo y zona de la categoría 85 que hayan empatado entre la 5o y 7o fecha.

select cl.nombre ClubLocal, cv.nombre ClubVisitante, p1.nrozona
from (partidos p1 inner join clubes cl on cl.Id_Club=p1.Id_ClubL)inner join clubes cv on cv.Id_Club=p1.Id_ClubV
where EXISTS(select * from partidos p where (p.golesV=p.golesL)and(p.categoria=85)and(p.nrofecha between 5 and 7)
	and(p1.Id_Partido=p.Id_Partido))


-- 3.16 Listar los equipos de la zona 1 que marcaron goles en las 5 primeras fechas jugando de visitante.

select *
from (select * from clubes c where c.nrozona=1) cz1
where cz1.Id_Club=any(select p.Id_ClubV from partidos p where ((golesV>0)and(p.nrofecha between 1 and 5)))

-- 3.17 Listar los equipos de la categoría 85 que no hayan ganado de local en la primera fecha.

select *
from clubes c
where EXISTS(select * from partidos p where p.nrofecha=1 and p.categoria=85 and ((c.Id_Club=p.Id_ClubL and golesL<=golesV)or(c.Id_Club=p.Id_ClubV and golesV<=golesL)))

-- 3.18 Cantidad de Jugadores por categoría de los equipos que no participaron en la primera fecha del campeonato.

select count(*) cant_jugadores,j.categoria, c.Id_Club, c.nombre Club
from clubes c inner join jugadores j on j.Id_Club=c.Id_Club
where NOT EXISTS(select * from partidos p where (p.nrofecha=1)and ((p.Id_ClubV=c.Id_Club)or(p.Id_ClubL=c.Id_Club)))
group by c.Id_Club, j.categoria, c.nombre

-- 3.19 Listar los equipos que no posean partidos empatados.

select *
from clubes c
where NOT EXISTS(select * from partidos p where (p.Id_ClubV=c.Id_Club and p.golesV=p.golesL)or
		(p.Id_ClubL=c.Id_Club and p.golesL=p.golesV))

-- 3.20 Listar todos los equipos que finalizaron ganando 2 a 0.

select *
from clubes c
where 	(c.Id_Club=any(select p.Id_ClubL from partidos p where (p.golesL-p.golesV)=2))or
	(c.Id_Club=any(select p.Id_ClubV from partidos p where (p.golesV-p.golesL)=2))

-- 3.21	Identificar a los equipos que participaron en el partido que hubo mayor diferencia de goles

select * from clubes c
where EXISTS
(
       (c.Id_Club=any(select p.Id_ClubL from partidos p where (p.golesL-p.golesV)=(select max(p1.golesL-p1.golesV)from partidos p1 )))or
	(c.Id_Club=any(select p.Id_ClubV from partidos p where (p.golesV-p.golesL)=(select max(p1.golesL-p1.golesV)from partidos p1 )))
)




