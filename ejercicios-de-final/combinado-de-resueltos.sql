/*1.	Función
Definir una función fn###### que: 
Reciba el nombre de un jugador.
Retorne el nombre y apellido en columnas separadas.  */

drop function fn_ej1
create FUNCTION fn_ej1 (@nombre_ing char(30))
RETURNS @result table 
( 
	nombre_res char (15),
	apellido_res char (15)
)
as	 
begin
	declare @nombre char (30) = @nombre_ing

	insert @result
	select nombre_res from clubes where Id_club = 1
	select apellido_res from clues where Id_club = 3
	--set @ape = 'Manry'
	--select TRIM FROM @nombre_ing
				
return
end

Go

select* from clubes

select * from  fn_ej1 ('pedro')




/* 2.	Procedimiento
Definir un  procedimiento pr###### que: 
Reciba el nombre de un club.
Retorne en dos parámetros de salida la cantidad de goles obtenidos como local y la cantidad de goles como visitante del club correspondiente.
Ejecutar el procedimiento y mostrar el resultado.  */


create procedure pr_ej2
@nombre_club_ingr char(30),
@goles_local smallint output,
@golesv_visitante tinyint output
as
begin
	declare @id_club_ingr smallint

	set @id_club_ingr = (select id_club from clubes c where nombre like @nombre_club_ingr)

	if (@id_club_ingr) is not null
	begin
		print 'El Id_club del Club ingresado es: '
		print @id_club_ingr
		set @goles_local = (select sum (golesl) from partidos p where id_clubl = @id_club_ingr)
		set @golesv_visitante = (select sum (golesv) from partidos p where id_clubv = @id_club_ingr)

		print ''
		print 'La cantidad de Goles del Club como Local es: '
		print @goles_local

		print ''
		print 'La cantidad de Goles del Club como Visitante es: '
		print @golesv_visitante
	end
	else
	begin
		print 'El Club ingresado no Existe, ejecute nuevamente el procedimiento con un Club existente'
	end
end



-- Prueba 1 del Stored Proced con ID_club = 6
declare @goles_local smallint
declare @golesv_visitante smallint
exec pr_ej2 'SAN MARTIN',@goles_local output,@golesv_visitante output 
select @goles_local as CantidadDeGolesDeLocal
select @golesv_visitante as CantidadDeGolesDeVisitante

-- Resultado:
-- Goles de Local = 35
-- Goles de visitante = 22


-- Prueba 1 del Stored Proced con ID_club = 2
declare @goles_local smallint
declare @golesv_visitante smallint
exec pr_ej2 'FATIMA',@goles_local output,@golesv_visitante output 
select @goles_local as CantidadDeGolesDeLocal
select @golesv_visitante as CantidadDeGolesDeVisitante

-- Resultado:
-- Goles de Local = 8
-- Goles de visitante = 7



 /* 3.	Trigger
Definir un trigger tr###### que se accione cuando se ingresan clubes.
Debe determinar el Id_Club del mismo siendo el menor número entero mayor a cero disponible en la tabla.*/

 

create trigger tr_ej3
on clubes
instead of insert
as 
if (select count(*) from inserted ) > 0 
begin
	declare @idclub_ing smallint
	declare @id_club_menor_disponib smallint
	declare @nombre_ing char (30)
	declare @nrozona_ing tinyint
	declare @i tinyint
	--select id_club from inserted

	set @idclub_ing = (select id_club from inserted)
	set @nombre_ing = (select nombre from inserted)
	set @nrozona_ing = (select nrozona from inserted)
	

	
	set @i= 1	-- Declaro el Id_club a determinar como Mayor a cero
		
	while (@i>0 and @i<100)
	begin
		if exists (select * from clubes where id_club = @i) 
		begin
			set  @i= @i+1

		end
		else	  -- Si el numero de ID_CLUB no existe y es mayor a cero, debo colocar ese ID de Club para la insercion.
		
		begin    
			set @id_club_menor_disponib  = @i
			set @i = 0
			--print 'el club No existe con ID_CLUB: ' 
			--print @i
		end
	
	end

	if (@id_club_menor_disponib = @idclub_ing)
	begin
		insert into clubes values (@idclub_ing,@nombre_ing,@nrozona_ing)
	end
	else
	begin
		insert into clubes values (@id_club_menor_disponib,@nombre_ing,@nrozona_ing)
	end
end
	
	
	

-- Prueba 1 del Trigger, con un club que es el proximo ID (4) ES el proximo disponible en la tabla 
select * from clubes
insert into clubes values (2,'DEFENSORES',1)

-- Prueba 2 del Trigger, con un club Cuyo ID (8) NO ES el proximo mayor a cero disponible en la tabla 
insert into clubes values (8,'EXCURSIONISTAS',2)

-- Prueba 3 del Trigger, con un club Cuyo ID (8) es ahora el proximo mayor a cero disponible en la tabla 
insert into clubes values (8,'TALLERES CBA',2)


delete from clubes where id_club = 2
delete from clubes where id_club = 4
delete from clubes where id_club = 8




4.	Vista
Definir una  vista vw###### que:
Proyecte el nombre de los jugadores de la categoría 84 pertenecientes a los clubes que ganaron
 y perdieron la misma cantidad de partidos en dicha categoría.
Debe ser resuelta utilizando correlación.

create view vw_ej4
as
(select id_club, sum(ganados) as Ganados, sum(perdidos) as Perdidos from general g
inner join partidos p on g.id_club = p.id_clubl
where categoria = 84
group by id_club)

-- drop view vw_ej4

create view vw_ej4
as
(select j.nombre, j.id_club from
jugadores j
inner join general g 
on j.id_club = g.id_club
where j.categoria = 84 
and j.id_club in (select (id_club)  from general g
inner join partidos p on g.id_club = p.id_clubl
where categoria = 84 and
ganados = perdidos))


select * from vw_ej4

 
1.	Trigger
Crear un trigger tr###### que se accione cuando se ingresa un jugador.
•	Debe permitir insertar el registro si corresponde al club que menos jugadores tiene en la categoría respectiva.
•	Caso contrario, debe determinar el club del jugador siendo el que menos jugadores tiene en la categoría respectiva, e insertarlo.

create trigger tr1017102 on jugadores
after insert
as
begin
	declare @clubMenosJugadores smallint
	declare @clubJugadorNuevo smallint
	declare @categoriaJugadorNuevo smallint

	select @clubJugadorNuevo = id_club,@categoriaJugadorNuevo = categoria from inserted
	
	select @clubMenosJugadores = id_club from (select id_club,count(*) as cantidadJugadores from jugadores
		where jugadores.categoria = @categoriaJugadorNuevo group by id_club) j1
		where 1 > (select count(*) from (select id_club,count(*) as cantidadJugadores from jugadores
			where jugadores.categoria = @categoriaJugadorNuevo group by id_club) j2
				where j2.cantidadJugadores < j1.cantidadJugadores)

	if @clubJugadorNuevo != @clubMenosJugadores
	begin
		declare @nroDocNuevoJugador int
		SELECT @nroDocNuevoJugador = nroDoc from inserted
		UPDATE jugadores
			set id_club = @clubMenosJugadores
			where nroDoc = @nroDocNuevoJugador
	end
end



/* Pruebas */
INSERT INTO jugadores values ('DNI',29027063,'PRUEBA, TEST2',null,85,16)

2.	Vista
Crear una  vista vw###### que: 
•	Retornar los 10 jugadores más jóvenes de la categoría 84 del club con menos goles convertidos que hayan jugado la mayor cantidad de partidos. 
Mostrar Nombre del Jugador, Nombre del Club y Fecha de Nacimiento con formato (01 Ene 1984).
La consulta debe resolverse en forma correlacionada, y sin utilizar la función max().
create view vw1017102
as
select
		jugaA.nombre as 'Nombre del Jugador' ,
		clubA.nombre as 'Nombre del Club',
		convert(char(12),jugaA.fecha_nac) as 'Fecha de Nacimiento'
	from (
		/* Obtengo los 10 jugadores más jovenes de la categoria 84 */
		select * from jugadores j1 where j1.categoria = 84 and 10 > (select count(*) from jugadores j2
			where j1.fecha_nac < j2.fecha_nac and j2.categoria = 84)) jugaA
	INNER JOIN
		(
		/* Obtengo los clubes que menos goles conviertieron a partir de otra tabla temporal que contiene los clubes que más partidos jugaron */
		select * from (select * from general tg1 where 1 > (select count(*) from general tg2 where tg1.cantidad < tg2.cantidad)) g1
			where 1 > (select count(*) from (select * from general tg1 where 1 > (select count(*) from general tg2 where tg1.cantidad < tg2.cantidad)) g2
				where g2.golesf < g1.golesf)) clubA
	ON
		jugaA.id_club = clubA.id_club

/* Prueba */
select * from vw1017102

3.	Procedimiento
Definir un  procedimiento pr###### que: 
•	Reciba el número de una categoría.
•	Retorne en un parámetro de salida la cantidad de clubes que no tienen la mayor cantidad de partidos ganados en esa categoría.
•	Resolver utilizando outer join.
Ejecutar el procedimiento y mostrar el resultado.
CREATE PROCEDURE pr1039165
  @categoria smallint,
  @cant smallint
AS
SET @cant=(SELECT count(*)
FROM ( SELECT GL.Id_ClubL AS Club, (GanadosL + GanadosV) AS Ganados
       FROM ( SELECT Id_ClubL, count(*) AS GanadosL
              FROM Partidos
              WHERE Categoria=@categoria AND GolesL > GolesV
              GROUP BY Id_ClubL ) GL LEFT OUTER JOIN
            ( SELECT Id_ClubV, count(*) AS GanadosV
              FROM Partidos
              WHERE Categoria=@categoria AND GolesL < GolesV
              GROUP BY Id_ClubV ) GV ON GL.Id_ClubL = GV.Id_ClubV ) G1
WHERE ( SELECT count(*)
		FROM (SELECT GL.Id_ClubL AS Club, (GanadosL + GanadosV) AS Ganados
              FROM ( SELECT Id_ClubL, count(*) AS GanadosL
                     FROM Partidos
                     WHERE Categoria=@categoria AND GolesL > GolesV
                     GROUP BY Id_ClubL ) GL LEFT OUTER JOIN
                   ( SELECT Id_ClubV, count(*) AS GanadosV
                     FROM Partidos
                     WHERE Categoria=@categoria AND GolesL < GolesV
                     GROUP BY Id_ClubV ) GV ON GL.Id_ClubL = GV.Id_ClubV) G2
		WHERE G1.Ganados < G2.Ganados ) > 1 )

  Print 'Cantidad de Clubes que NO tienen la mayor cant. de partidos ganados en la categoría ingresada: '+ convert(char(2),@cant)
GO

EXEC  pr1039165 '85', ''



/**
4.	Procedimiento
Definir un  procedimiento ac###### que: 
•	Reciba el número de una zona.
•	Debe asignar goles, únicamente, a los partidos correspondientes a la última fecha del certamen (nrofecha) y de la zona ingresada.
•	A los clubes locales se les asigna la misma cantidad de goles, que el máximo de goles convertidos por un club visitante de la fecha anterior.
•	A los clubes visitantes se les asigna de a un gol más si corresponde a la categoría 84 y 1 gol menos si corresponde a la categoría 85.
Ejecutar el procedimiento y mostrar el resultado.
**/
create proc as1039165 @zona int
as

  Update Partidos set GolesL = (select Max(GolesV) from Partidos where NroFecha = ((select Max(NroFecha) from Partidos)-1)) 
  where Id_ClubL in (select c.id_club from Clubes c inner join Partidos p 
                     on c.id_club = p.id_clubL
					 where p.NroFecha = (select Max(NroFecha) from Partidos) and p.NroZona = @zona)

  Update Partidos set GolesV = (select Max(GolesV)+1 from Partidos where categoria = 84 and NroFecha = ((select Max(NroFecha) from Partidos)-1)) 
  where Id_ClubV in (select c.id_club from Clubes c inner join Partidos p 
                     on c.id_club = p.id_clubV
					 where p.NroFecha = (select Max(NroFecha) from Partidos) and p.NroZona = @zona)

   Update Partidos set GolesV = (select Max(GolesV)-1 from Partidos where categoria = 85 and NroFecha = ((select Max(NroFecha) from Partidos)-1)) 
  where Id_ClubV in (select c.id_club from Clubes c inner join Partidos p 
                     on c.id_club = p.id_clubV
					 where p.NroFecha = (select Max(NroFecha) from Partidos) and p.NroZona = @zona)
 

  select * from Partidos  
  where Id_ClubL in (select c.id_club from Clubes c inner join Partidos p 
                     on c.id_club = p.id_clubL
					 where p.NroFecha = (select Max(NroFecha) from Partidos) and p.NroZona = @zona)

  select * from Partidos 
  where Id_ClubV in (select c.id_club from Clubes c inner join Partidos p 
                     on c.id_club = p.id_clubV
					 where p.NroFecha = (select Max(NroFecha) from Partidos) and p.NroZona = @zona)

  select * from Partidos 
  where Id_ClubV in (select c.id_club from Clubes c inner join Partidos p 
                     on c.id_club = p.id_clubV
					 where p.NroFecha = (select Max(NroFecha) from Partidos) and p.NroZona = @zona)


 exec as1039165 1
 



/*Ejercicio 1*/
/*Crear una funcion que reciba una cadena de caracteres que representa el nombre de una tabla, otra cadena que representa un tipo de dato 
y que devuelva la cantidad de columnas que poseen ese tipo de datos*/


/*Creacion de la funcion*/
create function FN1015257 (@nombreTabla varchar(30), @tipoDato varchar(30))
returns int
as
begin
	declare @cantColumnas int
	select @cantColumnas= count(*) from sys.sysobjects o inner join 
		(select id,xtype as datatype from sys.syscolumns) c on o.id=c.id inner join 
			(select name, xtype as datatype from sys.systypes) t on t.datatype=c.datatype where o.name=@nombreTabla and t.name=@tipoDato
			return @cantColumnas 
end

/*Prueba de la funcion*/
select dbo.FN1015257('General','char')
select dbo.FN1015257('General','smallint')
select dbo.FN1015257('General','decimal')



/*Ejercicio 2*/
/*Crear un procedimiento que reciba una cadena de caracteres que representa el nombre de un club y un numero que represente una categoria y 
devuelva la cantidad de clubes que hicieron mas puntos, que los puntos obtenidos por el club pasado como parametro en la categoria indicada, 
siempre que no sean clubes que obtuvieron la mejor clasificacion en la geneal. El procedimiento debera corroborar que los parametros ingresados
 sean validos, caso contrario enviar un mensaje. */

 /*Creacion*/
 create procedure PA1015257
	@nombreClub varchar(40),
	@categoria int,
	@cantClubes int output
as
begin
	if(@nombreClub in (select c.Nombre from Clubes c))
	begin
		if(@categoria=84)
		begin
			select @cantClubes=count(*)  from 
				(select * from PosCate184 UNION select * from PosCate284) posiciones1
				where posiciones1.Nombre!=@nombreClub and exists(select * from (select * from PosCate184 UNION select * from PosCate284) posiciones2 
				where posiciones2.puntos>(select posiciones3.Puntos from (select * from PosCate184 UNION select * from PosCate284) posiciones3 where posiciones3.Nombre=@nombreClub) 
				and posiciones2.NOmbre not in (select posiciones4.Nombre from (select * from PosCate184 UNION select * from PosCate284) posiciones4 where  posiciones4.Puntos>=ALL
				 (Select posiciones5.Puntos from (select * from PosCate184 UNION select * from PosCate284) posiciones5) ) and posiciones2.Id_Club=posiciones1.Id_Club)
		end
		if(@categoria=85)
		begin
		select @cantClubes=count(*)  from 
				(select * from PosCate185 UNION select * from PosCate285) posiciones1
				where posiciones1.Nombre!=@nombreClub and exists(select * from (select * from PosCate185 UNION select * from PosCate285) posiciones2 
				where posiciones2.puntos>(select posiciones3.Puntos from (select * from PosCate185 UNION select * from PosCate285) posiciones3 where posiciones3.Nombre=@nombreClub) 
				and posiciones2.NOmbre not in (select posiciones4.Nombre from (select * from PosCate185 UNION select * from PosCate285) posiciones4 where  posiciones4.Puntos>=ALL
				 (Select posiciones5.Puntos from (select * from PosCate185 UNION select * from PosCate285) posiciones5) ) and posiciones2.Id_Club=posiciones1.Id_Club)
		end
		if(@categoria!=85 and @categoria!=84)
		begin
			print('La categoria ingresada no existe.')
		end
	end
	if(@nombreClub not in (select c.Nombre from Clubes c))
	begin
		print('El nombre del club ingresado no existe.')
	end
end
go

--Aqui la correlacion existe al igualar posiciones2.Id_Club con posiciones1.Id_Club, 
--de no existir dicha correlacion, la tabla de posiciones totales, posiciones 2, de adentro, 
--siempre devolveria true y el resultado al ejercicio siempre seria 10, la totalidad de todos los equipos.


/*Prueba*/
DECLARE 
	@nombreClub varchar(40), 
	@categoria int,
	@cantClubes int

set @nombreClub = 'SAN LORENZO'
set @categoria = 85

exec PA1015257 @nombreClub, @categoria, @cantClubes OUTPUT

print ('La cantidad de Clubes encontrados que dentro de la categoria '+CONVERT(VARCHAR,@categoria)+' superen en puntos al club '+CONVERT(VARCHAR,@nombreClub)+
', pero no superen al club con mas puntos de dicha categoria, son: '+CONVERT(VARCHAR,@cantClubes))
go
			
/*Ejercicio 3*/
/*Escribir un procedimiento que reciba una cadena de caracteres que representa un login, 
una cadena que representa a un usuario, una cadena que representa a una tabla y realice las siguientes acciones:
 */
create procedure PB1040182
@login varchar(20),
@user varchar(20),
@table varchar(20)
as
begin
	if exists(select * from sysusers where name = @user)
		delete from sysusers where name = @user
	if not exists(select * from sysobjects where name = @tabla)
		end
	create user @user for login @login
	grant @user select on @table 
	exec sp_helpuser @user
end




 /*Ejercicio 4*/
/*Crear una funcion que reciba un numero entero correspondiente al numero de zona y determine el numero de partido, 
el numero de fecha, el nombre del club local, el nombre del club visitante y los goles a favor y los goles en contra
 y el resultado (el resultado puede ser Ganado, Empatado o Perdido y siempre sera calculado desde el punto de vista del club local) de
 aquellos partidos que tuvieron la mayor diferencia de goles en la zona ordenados por numero de fecha. */

 /*Creacion de la funcion*/

create function FN1015257_2(@zona int)
returns @auxtable
table(numPartido int, 
numFecha int, 
nombreClubL varchar(40), 
nombreClubV varchar(40), 
golesAFavor int, 
golesEnContra int,
resultado varchar(40))
as
begin

	insert @auxtable

	select p.Id_Partido,  p.nrofecha, c1.Nombre as NombreClubLocal, c2.Nombre as NombreClubVisitante, p.GolesL, P.GolesV, 
	CAST(  CASE  WHEN p.GolesL >p.GolesV THEN 'Ganado' WHEN p.GolesL < p.GolesV THEN 'Perdido' WHEN p.GolesL = p.GolesV THEN 'Epatado' end AS varchar(40)) as Resultado 
	from Partidos p inner join CLubes c1 on p.Id_ClubL=c1.Id_Club 
	inner join Clubes c2 on c2.Id_Club=p.Id_ClubV where  p.NroZona=1 and abs(p.GolesL-p.GolesV)>=ALL(select abs(p2.GolesL-p2.GolesV) from Partidos p2 where p2.NroZona=p.NroZona)
	
	return
end

/*Prueba de la funcion.*/

select * from FN1015257_2(1)

--Aqui la correlacion entre la tabla externa y la de los valores a analizar la hago en "on p2.NroZona=p.NroZona"
--Lo mismo, le especifica a la consulta interna, que solo quiero analizar los registros que pertenezcan a la misma zona que la de afuera.


1.	Rule
Definir una rule rl###### que actúe sobre el campo fecha de la tabla partido.
Debe permitir que se actualice únicamente si corresponde a un día sábado o domingo, entre los meses de marzo a noviembre, inclusive.
Crear y asignar la rule.	
CREATE RULE rl10848451 AS (datename(dw, @fecha)='Saturday' OR datename(dw, @fecha)='Sunday') AND datepart(mm, @fecha)>=3 AND datepart(mm, @fecha)<=11
GO

sp_bindrule 'rl10848451', 'Partidos.FechaPartido'
GO


2.	Vista
Definir una  vista vw###### que:
Proyecte el nombre y la zona de los clubes que no participaron en la última fecha de los partidos jugados.
Debe ser resuelta utilizando un join externo.
CREATE VIEW vw10848451 AS
SELECT c.Nombre, c.Nrozona AS Zona FROM Clubes c LEFT OUTER JOIN Partidos p ON (c.Id_Club=p.Id_ClubL AND c.Id_Club=p.Id_ClubV)
	WHERE c.Id_Club NOT IN (SELECT Id_ClubL FROM Partidos p2 WHERE p2.NroFecha=(SELECT max(NroFecha) FROM Partidos))
	AND c.Id_Club NOT IN (SELECT Id_ClubV FROM Partidos p3 WHERE p3.NroFecha=(SELECT max(NroFecha) FROM Partidos))
GO



3.	Procedimiento
Definir un  procedimiento ps###### que:
Reciba una categoría y el nombre de un club.
Devuelva la cantidad de partidos como local y la cantidad de partidos como visitante en los cuales participó el club en esa categoría.
Ambos resultados deben ser retornados en parámetros de salida.
Ejecutar el procedimiento y mostrar el resultado.	
CREATE PROCEDURE ps10848451
@categoria int,
@club varchar(30),
@local int OUTPUT,
@visitante int OUTPUT

AS
SELECT @local=count(*) FROM Partidos p INNER JOIN Clubes c ON p.Id_ClubL=c.Id_Club
	WHERE c.Nombre=@club AND p.categoria=@categoria
SELECT @visitante=count(*) FROM Partidos p INNER JOIN Clubes c ON p.Id_ClubV=c.Id_Club
	WHERE c.Nombre=@club AND p.categoria=@categoria
GO


DECLARE @cantlocal int
DECLARE @cantvisitante int
EXEC ps10848451 84,'FATIMA',@cantlocal OUTPUT,@cantvisitante OUTPUT
PRINT 'Cantidad de partidos jugados como local: '+convert(varchar(30),@cantlocal)
PRINT 'Cantidad de partidos jugados como visitante: '+convert(varchar(30),@cantvisitante)

Procedimiento
Definir una  vista pr###### que:
Reciba en parámetros diferentes:
•	el nombre de zona de los clubes 
•	una categoría
•	dos valores enteros distintos entre 1 y 10.
Devuelva el nombre del club, y el nombre y la fecha de nacimiento de los jugadores más jóvenes que correspondan a los valores ingresados en los parámetros
Por ejemplo el 2ª y el 5ª jugador más joven de los clubes de la zona 2  en la categoría 84.

CREATE PROCEDURE prJugadoresJovenes
	@zona tinyint,
	@cate tinyint,
	@jug1 tinyint,
	@jug2 tinyint
AS

	SELECT j.Nombre, j.Fecha_Nac, c.Nombre FROM Jugadores j join Clubes c on j.Id_Club = c.Id_Club
	WHERE c.Nrozona = @zona and j.Categoria = @cate
	and (SELECT COUNT(*) FROM Jugadores j1 join Clubes c1 on j1.Id_Club = c1.Id_Club
		 WHERE c1.Nrozona = c.Nrozona and j1.Categoria = j.Categoria and j.Fecha_Nac <= j1.Fecha_Nac) in (@jug1, @jug2)
RETURN
GO

exec prJugadoresJovenes 2, 84, 2, 4

Trigger
Definir un trigger tr###### que se accione cuando se ingresan clubes.
Debe asignar el número de zona (NroZona) entre 1 o 2.
Controlar la cantidad de clubes que debe ser la misma en cada zona. Si la cantidad de clubes es impar, la zona 1 es la que se asigna.

CREATE TRIGGER trInsertClub ON Clubes INSTEAD OF INSERT
AS
DECLARE @cantZona1 int
DECLARE @cantZona2 int

SELECT @cantZona1 = isnull(Count(*),0) FROM Clubes WHERE Nrozona = 1
SELECT @cantZona2 = isnull(Count(*),0) FROM Clubes WHERE Nrozona = 2

IF (@cantZona2 < @cantZona1)
	INSERT INTO Clubes SELECT Id_club, Nombre, 2 FROM Inserted
ELSE
	INSERT INTO Clubes SELECT Id_club, Nombre, 1 FROM Inserted
GO
Vista
Definir una  vista vw###### que:
Proyecte el nombre y la zona de los clubes que no participaron en la última fecha de los partidos jugados.
Debe ser resuelta utilizando un join externo.

create view vwClubSinParticipar
as

select c.nombre, c.nrozona from clubes c left join 
(select * from partidos where nrofecha = 
(select max(nroFecha) from partidos)) p 
on (c.Id_club = p.Id_ClubL or c.Id_club = p.Id_ClubV) 
where Id_Partido is null

Procedimiento
Definir un  procedimiento ps###### que:
Reciba una categoría y el nombre de un club.
Devuelva la cantidad de partidos como local y la cantidad de partidos como visitante en los cuales participó el club en esa categoría.
Ambos resultados deben ser retornados en parámetros de salida.
Ejecutar el procedimiento y mostrar el resultado.	

Create Procedure prPartidosJugados 
	@cate tinyint,
	@club varchar(50),
	@jugaLocal tinyint output,
	@jugaVisi  tinyint output
AS

declare @idclub tinyint
select @idclub=id_club from Clubes where Nombre = @club

select @jugaLocal= COUNT(*) from partidos 
where Id_ClubL = @idclub and categoria = @cate
select @jugaVisi = COUNT(*) from partidos 
where Id_ClubV = @idclub and categoria = @cate

return
go


1.	Restricción check
Asignar una restricción check que actúe sobre el campo nombre de la tabla jugadores.
Debe permitir que se actualice únicamente si se compone por nombre y apellido separados por una coma y sin contener caracteres numéricos.
Crear y asignar la restricción a la tabla respectiva.	
ALTER TABLE jugadores ADD CONSTRAINT check_jugadores_nombre 
CHECK (nombre LIKE '%[A-Z]%,%[A-Z]%' AND nombre NOT LIKE '%[0-9]%')

Vista
Definir una  vista vw###### que:
Proyecte el nombre de los jugadores de la categoría 84 pertenecientes a los clubes que ganaron y perdieron la misma cantidad de partidos en dicha categoría.
Debe ser resuelta utilizando correlación.

Create View vwJugadores 
AS

select nombre from jugadores j where categoria = 85 and exists
(select id_club from poscate185 where Ganados = perdidos 
and Id_Club = j.Id_Club
 union
 select id_club from poscate285 where Ganados = perdidos 
and Id_Club = j.Id_Club)
GO

Procedimiento
Definir un  procedimiento ps###### que:
Reciba una categoría y el nombre de un club.
Devuelva la cantidad de goles a favor y la cantidad de goles en contra  en los partidos que participó el club en esa categoría.
Ambos resultados deben ser retornados en parámetros de salida.
Ejecutar el procedimiento y mostrar el resultado.	

Create Procedure prGoles 
	@cate tinyint,
	@club varchar(50),
	@golesf tinyint output,
	@golesc tinyint output
AS

declare @idclub tinyint
select @idclub=id_club from Clubes where Nombre = @club

select @golesf=SUM(f), @golesc=SUM(c) from
(select SUM(golesl) f, sum(golesv) c  from partidos 
where Id_ClubL = @idclub
 union
 select SUM(golesv) f, SUM(Golesl) c  from partidos 
where Id_ClubV = @idclub) t

return
go

11.	Trigger
Definir un trigger tr###### que se accione cuando se ingresan clubes.
Debe asignar el número de zona (NroZona) entre 1 o 2.
Controlar la cantidad de clubes que debe ser la misma en cada zona. Si la cantidad de clubes es impar, la zona 1 es la que se asigna.

CREATE TRIGGER trInsertClub ON Clubes INSTEAD OF INSERT
AS
DECLARE @cantZona1 int
DECLARE @cantZona2 int

SELECT @cantZona1 = isnull(Count(*),0) FROM Clubes WHERE Nrozona = 1
SELECT @cantZona2 = isnull(Count(*),0) FROM Clubes WHERE Nrozona = 2

IF (@cantZona2 < @cantZona1)
	INSERT INTO Clubes SELECT Id_club, Nombre, 2 FROM Inserted
ELSE
	INSERT INTO Clubes SELECT Id_club, Nombre, 1 FROM Inserted
GO



12.	Procedimiento
Reciba en parámetros diferentes:
•	el nombre de zona de los clubes 
•	una categoría
•	dos valores enteros distintos entre 1 y 10.
Devuelva el nombre del club, y el nombre y la fecha de nacimiento de los jugadores más jóvenes que correspondan a los valores ingresados en los parámetros
Por ejemplo el 2ª y el 5ª jugador más joven de los clubes de la zona 2  en la categoría 84.


CREATE PROCEDURE prJugadoresJovenes
	@zona tinyint,
	@cate tinyint,
	@jug1 tinyint,
	@jug2 tinyint
AS

SELECT j.Nombre, j.Fecha_Nac, c.Nombre 
FROM Jugadores j join Clubes c on j.Id_Club = c.Id_Club
	WHERE c.Nrozona = @zona and j.Categoria = @cate
	and (SELECT COUNT(*) FROM Jugadores j1 join Clubes c1 
on j1.Id_Club = c1.Id_Club
WHERE c1.Nrozona = c.Nrozona and j1.Categoria = j.Categoria and j.Fecha_Nac <= j1.Fecha_Nac) in (@jug1, @jug2)
RETURN
GO








21.	Vista
Definir una  vista vw###### que:
Proyecte el nombre y la zona de los clubes que no participaron en la última fecha de los partidos jugados.
Debe ser resuelta utilizando un join externo.

create view vwClubSinParticipar
as

select c.nombre, c.nrozona from clubes c left join 
(select * from partidos where nrofecha = 
(select max(nroFecha) from partidos)) p 
on (c.Id_club = p.Id_ClubL or c.Id_club = p.Id_ClubV) 
where Id_Partido is null

22.	Procedimiento
Definir un  procedimiento ps###### que:
Reciba una categoría y el nombre de un club.
Devuelva la cantidad de partidos como local y la cantidad de partidos como visitante en los cuales participó el club en esa categoría.
Ambos resultados deben ser retornados en parámetros de salida.
Ejecutar el procedimiento y mostrar el resultado.	

Create Procedure prPartidosJugados 
	@cate tinyint,
	@club varchar(50),
	@jugaLocal tinyint output,
	@jugaVisi  tinyint output
AS

declare @idclub tinyint
select @idclub=id_club from Clubes where Nombre = @club

select @jugaLocal= COUNT(*) from partidos 
where Id_ClubL = @idclub and categoria = @cate
select @jugaVisi = COUNT(*) from partidos 
where Id_ClubV = @idclub and categoria = @cate

return
go

13.	Trigger
Definir un trigger tr###### que se accione cuando se modifica el club al que pertenecen los jugadores.
•	La modificación del club se interpreta como un  intercambio entre clubes, de modo que si los jugadores del club 1 se modifican al club 2, los jugadores del club 2 deben pasar al club 1.
•	La modificación se realiza intercambiando la misma cantidad de jugadores entre los 2 clubes de la misma zona y en la misma categoría.

create trigger tr_upda_Juga on jugadores instead of update
as
	if update (id_club) 
	begin
	    declare @dclub int, @iclub int, @d84 int, @i84 int, @d85 int, @i85 int
	    select distinct @dclub = id_club from deleted
	    select distinct @iclub = id_club from inserted
	    select @d84 = count(*) from deleted where categoria = 84
    select @i84 = count(*) from jugadores where id_club = @iclub and categoria = 84
	if(@d84 < @i84)	
			begin
				update jugadores set Id_Club = @dclub
				from jugadores j  
				where j.categoria = 84 and j.Id_CLub = @iClub
			and @d84 > (select count(*) from jugadores j1 
where j1.categoria = j.categoria and j1.Id_club = j.Id_Club and j1.nrodoc > j.nrodoc)
				
				update jugadores set Id_Club = i.Id_Club
				from jugadores j join inserted i on j.nrodoc = i.nrodoc 
				where j.categoria = 84
			end  
	end		
go

14.	Vista
Definir una vista vw###### que: 
•	Retorne el nombre de los clubes con más goles convertidos y que no hayan ganado la mayor cantidad de partidos. 
La consulta debe resolverse utilizando outer join.
create view mas_golesF
as

select * from
	(select g.* from general g left join 
	(select id_club from general where ganados = 
(select MAX(ganados) from General)) gm
	on gm.Id_Club = g.id_club where gm.Id_Club is null) g
where GolesF = (select Max(GolesF) from General where Ganados < 
(select MAX(ganados) from General)) 

15.	Función
Definir una función fn###### que: 
Reciba una categoría.
Retorne la descripción de los clubes que no participaron en los partidos  que hubo la mayor diferencia de goles en dicha categoría.
La resolución debe efectuarse en una consulta correlacionada.

select * from clubes c
where not exists
(select * from partidos p where categoria = 84 and abs(golesl-golesv) =
(select max(dife) from (select abs(golesl-golesv) dife from partidos where categoria = 84) x)
and (c.id_club = p.id_clubl or c.id_club = p.id_clubv))
1.	Vista
Definir una  vista vw###### que:
Proyecte el nombre y la zona de los clubes que no ganaron en la fecha que se convirtieron la menor cantidad de goles.
Debe ser resuelta utilizando join externo.

select distinct c.* 
from clubes c left join

(select * from partidos where nrofecha = 

	(select nrofecha from partidos p group by nrofecha
		having sum(golesl+golesv) =

			(select min(goles) from 
				
				(select sum(golesl+golesv) goles from partidos group by nrofecha) gf))) p

on c.id_club = p.id_clubl or c.id_club = p.id_clubv
where id_partido is null 
or ((c.id_club = p.id_clubl and golesl <= golesv) or (c.id_club = p.id_clubv and golesl >= golesv))


2.	Trigger
Definir un trigger  tr###### que se accione cuando se actualice el campo fechaPartido de la tabla partidos.
Debe permitir que se actualice únicamente si corresponde a un día sábado a los partidos de la categoría 84 y domingo a los de la categoría 85 del año en curso. 

set @fechapartido = (select distict fechapartido from inserted)

update partidos
set fechapartido = @fechapartido
from partidos p join inserted i on p.id_partido = i.id_partido
where ((i.categoria = 84 and datename(dw,i.fechapartido) = 'Sábado') 
	or (i.categoria = 85 and datename(dw,i.fechapartido) = 'Domingo'))

select id_partido from inserted where (categoria = 84 and datename('dw',fechapartido) = 'sabado') OR (categoria = 85 and datename('dw',fechapartido) = 'domingo')

1.	Vista
Definir una  vista vw###### que:
Proyecte el nombre y la zona de los clubes que no participaron en la última fecha de los partidos jugados.
Debe ser resuelta utilizando un join externo.

select distinct c.* 
from clubes c left join
(select * from partidos where nrofecha = (select nrofecha
from partidos p
group by nrofecha
having sum(golesl+golesv) =
(select min(goles) from (select sum(golesl+golesv) goles from partidos group by nrofecha) gf))) p
on c.id_club = p.id_clubl or c.id_club = p.id_clubv
where id_partido is null or (c.id_club = p.id_clubl and golesl <= golesv or (c.id_club = p.id_clubv and golesl >= golesv))

16.	Función
Definir una función fn###### que: 
Reciba en parámetros diferentes:
•	el número de zona de los clubes. 
•	una categoría.
•	dos valores enteros distintos entre 1 y 10.
Devuelva el nombre del club y el nombre y la fecha de nacimiento de los jugadores más jóvenes que correspondan a los valores ingresados en los parámetros
Por ejemplo el 2ª y el 5ª jugador más joven de los clubes de la zona 2  en la categoría 84.

select * from jugadores j where categoria = 85 and id_club in (select id_club from clubes where nrozona = 1)
and (select count(*) from jugadores j1 where categoria = 85 and id_club in (select id_club from clubes where nrozona = 1)
and j.fecha_nac < j1.fecha_nac) in (2,4)
order by fecha_nac desc


17.	Trigger
Definir un trigger tr###### que se accione cuando se eliminan jugadores.
Para clubes de la zona 1 se eliminan solamente jugadores de la categoría 84.
Para clubes de la zona 2 se eliminan solamente jugadores de la categoría 85.
Unicamente debe permitirlo cuando existan más de once jugadores en la categoría del club al que pertenecen.

delete jugadores 
from deleted d join clubes c on d.id_club = c.id_club
where ((categoria=85 and nrozona = 2) or (categoria=84 and nrozona=1))
and (select count(*) from jugadores j where j.id_club=d.id_club and j.categoria=d.categoria) > 11

18.	Vista
Definir una  vista vw###### que:
Proyecte el nombre y la zona de los clubes que no participaron en la última fecha de los partidos jugados.
Debe ser resuelta utilizando un join externo.

select distinct c.* from clubes c left join (select * from partidos where nrofecha =(select max(nrofecha) from partidos)) p on c.id_club = p.id_clubl or c.id_club = p.id_clubv where id_partido is null 



1.	Rule
Definir una rule rl###### que actúe sobre el campo fecha de la tabla partido.
Debe permitir que se actualice únicamente si corresponde a un día sábado o domingo, entre los meses de marzo a noviembre, inclusive.
Crear y asignar la rule.	
create rule rl1028354
as

(datepart(DW,@fechaPartido) =  1 or datepart(DW,@fechaPartido) = 7 ) and datepart(mm,@fechaPartido) between 3 and 11


sp_bindrule 'rl1028354', 'Partidos.FechaPartido'

2.	Vista
Definir una  vista vw###### que:
Proyecte el nombre y la zona de los clubes que no participaron en la última fecha de los partidos jugados.
Debe ser resuelta utilizando un join externo.

create view vw1028354
as

select c.nombre, c.nrozona  from clubes c
where not exists (
			select * from partidos p
			where ((p.nrofecha = (select max (nrofecha) from partidos) and c.Id_Club = p.Id_ClubV)
			      or 
				  (p.nrofecha = (select max (nrofecha) from partidos) and c.Id_Club = p.Id_ClubL )
				  
				  )
)

3.	Procedimiento
Definir un  procedimiento ps###### que:
Reciba una categoría y el nombre de un club.
Devuelva la cantidad de partidos como local y la cantidad de partidos como visitante en los cuales participó el club en esa categoría.
Ambos resultados deben ser retornados en parámetros de salida.
Ejecutar el procedimiento y mostrar el resultado.	

create procedure ps1028354
@categoria int,
@club varchar(30),
@cantidadLocal int output,
@cantidadVisitante int output
as

declare @idClub int

set @idClub = (select id_club from clubes where nombre like @club)

set @cantidadLocal = 0
set @cantidadVisitante = 0


if (@idClub is not null)
begin

	select @cantidadLocal = count(*) from partidos p
	where p.Id_ClubL = @idClub and p.categoria = @categoria

	select @cantidadVisitante = count(*) from partidos p
	where p.Id_ClubV = @idClub and p.categoria = @categoria

end



declare @resLocal int
declare @resVisitante int

exec ps1028354 84,'almafuerte',@resLocal output,@resVisitante output

select @resLocal as CantidadLocal,@resVisitante as CantidadVisitante

-- Ejecucion
CantidadLocal	CantidadVisitante
3	4


--= Ejercicio 1
Crear una vista que 
Retorne la diferencia de edad expresada en días entre el jugador mas joven de la categoría 85 y el mas viejo de la categoría 84 de cada club
La consulta debe ser resuelta correlacionando

create view vw_ej1
as
select  datediff(d, (select min(fecha_Nac) from jugadores where id_club = c.id_club and categoria = 84), 
					(select max(fecha_nac) from jugadores where id_club = c.id_club and categoria = 85)) as diferencia from clubes c
--
--= Ejercicio 1 - Codigo de prueba
select * from vw_ej1

--= Ejercicio 2

19.	Procedimiento
Crear un  procedimiento pr###### que: 
•	Reciba el valor de una Categoría (84 o 85).
•	Reciba el número de Zona (1 o 2).
•	Retorne en un parámetro de output el nombre del Club de la zona correspondiente que tenga la menor cantidad de jugadores en la categoría especificada.
Ejecutar el procedimiento y mostrar el resultado.
create procedure ejercicio2
@categoria int = 0,
@zona int = 0,
@resultado varchar(30) output

as

declare @error bit = 0

if @categoria < 84 or @categoria > 85
begin
print 'categoria inválida'
set @error = 1
end
if @zona < 1 or @zona > 2
begin
print 'zona inválida'
set @error = 1
end

if @error = 1
begin
return
end

select c.nombre, count(c.nombre) as cant
from jugadores j
inner join clubes c
on j.id_club = c.id_club
where j.categoria = @categoria and c.nrozona = @zona

group by c.nombre

having count(c.nombre) <= all

(
select count(c.nombre) as cant
from jugadores j
inner join clubes c
on j.id_club = c.id_club
where j.categoria = @categoria and c.nrozona = @zona

group by c.nombre
)
--
Para probar:
declare @resultado varchar(30)
exec ejercicio2 84, 1, @resultado output
print @resultado

/**
Ejercicio 3
20.	Definir un trigger que se accione cuando se elimina un jugador.
•	No se elimina, sino que se asigna al club que tenga la menor cantidad de jugadores en la categoría y pertenezca a la zona correspondiente al jugador.
•	No debe permitir la acción si interviene más de un jugador en la misma.
•	No debe permitir la acción si corresponde al club con la menor cantidad de jugadores en la categoría de la zona respectiva.
**/

drop trigger tr_ej3

create trigger tr_ej3
on jugadores
instead of delete
as
--declaro variables de soporte para facilitar calculos
declare @nrozona smallint,@categoria smallint, @clubId smallint, @rowsAffected smallint

set @categoria = (select categoria from deleted)
set @clubId = (select id_club from deleted)
set @nrozona = (select nrozona from clubes where id_club = @clubId)

--verifico cuantos jugadores fueron eliminados para cumplir la una condicion requerida
set @rowsAffected = (select count(*) from deleted)
if (@rowsAffected > 1)
begin
	print 'No está permitido eliminar más de una jugador a la vez'
	rollback transaction
end

--la magia de SQL, para encontrar el club con la menor cantidad de jugadores uso el procedure del ejercicio 2
declare @nombreClub varchar(30), @idClubMenorCantidadJugadores smallint
exec pr_ej2 @categoria, @nrozona, @nombreClub output
set @idClubMenorCantidadJugadores = (select id_club from clubes where nombre = @nombreClub)

if (@idClubMenorCantidadJugadores = @clubId)
begin
	print 'El jugador ya pertenece al club con la menor cantidad de jugadores en la categoria'
	rollback transaction
end

update jugadores set id_club = @idClubMenorCantidadJugadores where nrodoc = (select nrodoc from deleted) and tipodoc = (select tipodoc from deleted)
go




/*
Ejercicio 3 - Codigo de prueba
*/
declare @nombreClub varchar(30)
exec pr_ej2 84, 2, @nombreClub output
print @nombreClub
--categoria 84 zona 2, menor club Fatima ID 16
--para realizar la prueba, fue exitosa. De San Lorenzo (id 5) se fue a Fatima id 16. Misma categoria y zona
delete jugadores where nrodoc = 30724661--ejecutando esto de nuevo da error por pertenecer ya al club de meno cantidad de jugadores
--

/*
Ejercicio 4

Definir un procedimiento que
Reciba el nombre de la tabla referencial y la tabla referenciada
Determinar la existencia de la restricción referencial asociado a las tablas
Si existe deshabilitar la restricción dinámicamente
Ejecutar el procedimiento
*/
drop procedure pr_ej4

create procedure pr_ej4
@tablaReferencial varchar(128), @tablaReferenciada varchar(128)
as
--variables de soporte
declare @constraintName varchar(128), @parentObjectId int, @referencedObjectId int, @dropConstraintQuery varchar(500)

--verifico que las tablas ingresadas existan
if not exists (select object_id from sys.tables where name = @tablaReferencial)
begin
	print 'No existe una tabla con el nombre indicado '+@tablaReferencial
	return -1
end
if not exists (select object_id from sys.tables where name = @tablaReferenciada)
begin
	print 'No existe una tabla con el nombre indicado '+@tablaReferenciada
	return -1
end

--obtengo los object ids de las tablas para verificar si existe la foreign key
set @parentObjectId = (select object_id from sys.tables where name = @tablaReferencial)
set @referencedObjectId = (select object_id from sys.tables where name = @tablaReferenciada)

--valido cuantas FK hay, si son mas de una el codigo romperia por lo que retorno y listop
if 1 < (select count(*) from sys.foreign_keys where parent_object_id = @parentObjectId and referenced_object_id = @referencedObjectId)
begin
	print 'Existe más de una foreign key en '+@tablaReferencial+' apuntando a '+@tablaReferenciada + '. No se realizaron cambios'
	return -1 
end 

if exists (select object_id from sys.foreign_keys where parent_object_id = @parentObjectId and referenced_object_id = @referencedObjectId)
begin
	set @constraintName = (select name from sys.foreign_keys where parent_object_id = @parentObjectId and referenced_object_id = @referencedObjectId)
	--update sys.foreign_keys set is_disabled = 1 where object_id = @objectId-- no se pueden editar ad hoc las sys tables
	set @dropConstraintQuery = concat('ALTER TABLE ',@tablaReferencial,' DROP CONSTRAINT ',@constraintName)
	print @dropConstraintQuery--para validar el alter generado lo imprimo
	exec (@dropConstraintQuery)
	print 'Existia una foreign key en '+@tablaReferencial+' apuntando a '+@tablaReferenciada + ' y fue deshabilitada satisfactoriamente'
	return 0
end
print 'No existe una foreign key en '+@tablaReferencial+' apuntando a '+@tablaReferenciada
go
--

/**
Ejercicio 4 - Codigo de prueba
**/
exec pr_ej4 'jugadores', 'clubes' --existia y la borró :(
exec pr_ej4 'partidos', 'clubes' --existe

select * from sys.foreign_keys
select * from sys.tables
--tabla		object id
--partidos	965578478
--club		885578193
--jugadores 917578307
--


/**
BONUS
Proyecte los datos de los clubes que no participaron en la fecha que se convirtieron mas goles
*/
create view vw_xxxxxx

as 

select c.Nombre
from clubes c
left join partidos p on c.Id_Club in (p.Id_ClubL, p.Id_ClubV)
and p.nrofecha = (select nrofecha from partidos p group by nrofecha having sum(golesl + golesv) >= all (select goles = sum(golesl + golesv) from partidos p group by nrofecha))
where p.Id_Partido is null


/*
1.	Función
Definir una función fn###### que: 
Reciba el nombre de un jugador.
Retorne el nombre y apellido en columnas separadas. 
*/
CREATE FUNCTION fn121854 (@nombre varchar(20))
RETURNS TABLE
AS RETURN (
SELECT	SUBSTRING(@nombre,1,CHARINDEX (' ',@nombre)) as Nombre, 
		SUBSTRING(@nombre,CHARINDEX (' ',@nombre)+1,20) as Apellido )
GO

SELECT * FROM fn121854('MARTIN LARZABAL');

/*
1.	Procedimiento
Definir un  procedimiento pr###### que: 
Reciba el nombre de un club.
Retorne en dos parámetros de salida la cantidad de goles obtenidos como local y la cantidad de goles como visitante del club correspondiente.
Ejecutar el procedimiento y mostrar el resultado.
*/
CREATE PROCEDURE pr121854
@club VARCHAR(20)
AS
BEGIN
SELECT (SELECT sum(golesL) FROM partidos where id_clubL=(SELECT id_club FROM Clubes WHERE nombre LIKE @club)) as GolesL,
		(SELECT sum(golesV) FROM partidos where id_clubV=(SELECT id_club FROM Clubes WHERE nombre LIKE @club)) as GolesV
RETURN
END
GO

exec pr121854 'SAN LORENZO';

/*
1.	Trigger
Definir un trigger tr###### que se accione cuando se ingresan clubes.
Debe determinar el Id_Club del mismo siendo el menor número entero  mayor a cero disponible en la tabla.
*/
CREATE TRIGGER tr121854 ON Clubes
INSTEAD OF INSERT
AS
DECLARE @id int
SET @id = (SELECT max(id_club) from clubes)+1
DECLARE @Nombre varchar(20)
SET @Nombre = (SELECT Nombre FROM Inserted)
DECLARE @NroZona int
SET @NroZona = (SELECT nroZona FROM Inserted)
INSERT INTO Clubes VALUES (@id,@Nombre,@NroZona)
GO

1.	Vista
Definir una  vista vw###### que:
Proyecte el nombre de los jugadores de la categoría 84 pertenecientes a los clubes que ganaron y perdieron la misma cantidad de partidos en dicha categoría.
Debe ser resuelta utilizando correlación.
CREATE VIEW vw121854
AS
SELECT nombre FROM Jugadores
WHERE categoria = 85 and id_club = (SELECT id_Club FROM 
(SELECT * FROM poscate185 UNION ALL SELECT * FROM poscate285) Cate85
WHERE ganados = perdidos)
GO

SELECT * FROM vw121854;
GO




/*Reciba el nombre de un club.
Retorne en dos parámetros de salida la cantidad de goles obtenidos como local y la cantidad de goles como visitante del club correspondiente.
Ejecutar el procedimiento y mostrar el resultado.
*/
CREATE PROCEDURE GOLES 
@NOMBRE AS VARCHAR(100),
@GOLESL AS INT OUTPUT,
@GOLESV AS INT OUTPUT
AS
DECLARE @IDCLUB AS SMALLINT
--Busco el CLUB
SELECT @IDCLUB=ID_CLUB FROM CLUBES WHERE NOMBRE=@NOMBRE
SELECT @GOLESL=SUM(GOLESL) FROM PARTIDOS WHERE ID_CLUBL=@IDCLUB
SELECT @GOLESV=SUM(GOLESV) FROM PARTIDOS WHERE ID_CLUBV=@IDCLUB
GO

DECLARE @GOLESL INT
DECLARE @GOLESV INT
DECLARE @NOMBRE AS VARCHAR(100) = 'FERRO C. OESTE'
EXEC GOLES @NOMBRE, @GOLESL OUTPUT, @GOLESV OUTPUT
PRINT 'EL CLUB ' + @NOMBRE + ' TIENE GOLES DE LOCAL ' + CAST(@GOLESL AS VARCHAR(100)) + ' Y DE VISITANTE: ' + CAST(@GOLESV AS VARCHAR(100))


/*3.	Trigger
Definir un trigger tr###### que se accione cuando se ingresan clubes.
Debe determinar el Id_Club del mismo siendo el menor número entero  mayor a cero disponible en la tabla.*/

ALTER TRIGGER IDCLUB
ON CLUBES
INSTEAD OF INSERT
AS
DECLARE @NOMBRE AS VARCHAR(100)
DECLARE @NROZONA AS TINYINT
DECLARE @CONTADOR AS INT
DECLARE @IDINSERTAR AS SMALLINT --Para insertar
SELECT @NOMBRE=NOMBRE,@NROZONA=NROZONA FROM INSERTED

--Busco el Maximo para empezar a contar
IF (SELECT ID_CLUB FROM INSERTED) > (SELECT MAX(ID_CLUB) FROM CLUBES)+1
BEGIN
	SELECT @CONTADOR = (SELECT ID_CLUB FROM INSERTED)
END	
	ELSE
	SELECT @CONTADOR = (SELECT MAX(ID_CLUB) FROM CLUBES)+1

WHILE @CONTADOR >= 1
BEGIN
	IF NOT EXISTS(SELECT 1 FROM CLUBES WHERE ID_CLUB=@CONTADOR)
	BEGIN
		set @idinsertar=@CONTADOR
		set @CONTADOR=@CONTADOR-1
	END
	ELSE
	set @CONTADOR=@CONTADOR-1
end
PRINT 'El id a insertar será ' + cast(@IDINSERTAR AS VARCHAR(100))
INSERT INTO CLUBES
VALUES (@IDINSERTAR,@NOMBRE,@NROZONA)
GO


/*4.	Vista
Definir una  vista vw###### que:
Proyecte el nombre de los jugadores de la categoría 84 pertenecientes a los clubes que ganaron y perdieron la misma 
cantidad de partidos en dicha categoría.
Debe ser resuelta utilizando correlación.*/

ALTER VIEW JUGADORES84 AS
SELECT NOMBRE,CATEGORIA,(SELECT NOMBRE FROM CLUBES C WHERE C.ID_CLUB=J.ID_CLUB) AS CLUB, 
(SELECT COUNT(*) FROM PARTIDOS P WHERE (P.ID_CLUBL=J.ID_CLUB AND P.GOLESL>P.GOLESV) OR (P.ID_CLUBV=J.ID_CLUB AND P.GOLESV>P.GOLESL) and P.Categoria=84) AS ganados,
(SELECT COUNT(*) FROM PARTIDOS P WHERE (P.ID_CLUBL=J.ID_CLUB AND P.GOLESL<P.GOLESV) OR (P.ID_CLUBV=J.ID_CLUB AND P.GOLESV<P.GOLESL) and P.Categoria=84) AS perdidos,
(select NroZona from Clubes C where C.Id_Club=J.Id_Club) as NroZona
FROM JUGADORES J
WHERE CATEGORIA=84
and ((SELECT COUNT(*) FROM PARTIDOS P WHERE (P.ID_CLUBL=J.ID_CLUB AND P.GOLESL>P.GOLESV) OR (P.ID_CLUBV=J.ID_CLUB AND P.GOLESV>P.GOLESL)  and P.Categoria=84)
=
(SELECT COUNT(*) FROM PARTIDOS P WHERE (P.ID_CLUBL=J.ID_CLUB AND P.GOLESL<P.GOLESV) OR (P.ID_CLUBV=J.ID_CLUB AND P.GOLESV<P.GOLESL)  and P.Categoria=84))
go

select * from JUGADORES84


/*5.	Rule
Definir una rule rl###### que actúe sobre el campo fecha de la tabla partido.
Debe permitir que se actualice únicamente si corresponde a un día sábado o domingo, entre los meses de marzo a noviembre, inclusive.
Crear y asignar la rule.	*/

CREATE RULE FECHA_PARTIDO
AS
DATEPART(DW,@FECHA) IN (1,6) AND DATEPART(MM,@FECHA) IN (3,4,5,6,7,8,9,10,11)
GO

SP_BINDRULE 'FECHA_PARTIDO','PARTIDOS.FECHAPARTIDO'

SELECT * FROM PARTIDOS

INSERT INTO PARTIDOS
VALUES(1,1,1,84,1,2,1,1,GETDATE()-2)


/*6.	Rol
Crear el rol ro###### y asignarles los siguientes privilegios
No permitir eliminaciones en la tabla partidos.
Poder actualizar únicamente los resultados de los partidos (goles) y la fecha del partido.*/

CREATE ROLE PRIVILEGIOS
GO
DENY DELETE ON PARTIDOS TO PRIVILEGIOS
GO
GRANT UPDATE(GOLESV) ON PARTIDOS TO PRIVILEGIOS
GO
GRANT UPDATE(GOLESL) ON PARTIDOS TO PRIVILEGIOS
GO
GRANT UPDATE(FECHAPARTIDO) ON PARTIDOS TO PRIVILEGIOS
GO


/*7. Procedimiento
Definir un  procedimiento pr###### que: 
Reciba el nombre de un club y un patrón de caracteres.
Retorne en dos parámetros de salida la cantidad de jugadores de la categoría 84 y de la 85, 
cuyo nombre corresponda con el patrón y pertenezcan al club ingresado.
Ejecutar el procedimiento y mostrar el resultado.*/

CREATE PROCEDURE CANTIDADJUGADORES
@NOMBRE AS CHAR(30),
@PATRON AS VARCHAR(30),
@JUGADORES84 AS INT OUTPUT,
@JUGADORES85 AS INT OUTPUT
AS
DECLARE @IDCLUB AS SMALLINT
SELECT @IDCLUB=ID_CLUB FROM CLUBES WHERE NOMBRE = @NOMBRE
SELECT @JUGADORES84=COUNT(1) FROM JUGADORES
WHERE ID_CLUB=@IDCLUB
AND NOMBRE LIKE '%'+@PATRON+'%'
AND CATEGORIA=84
SELECT @JUGADORES85=COUNT(1) FROM JUGADORES
WHERE ID_CLUB=@IDCLUB
AND NOMBRE LIKE '%'+@PATRON+'%'
AND CATEGORIA=85
GO


DECLARE @JUGADORES84 AS INT
DECLARE @JUGADORES85 AS INT
DECLARE @NOMBRE AS varchar(30) = 'FERRO C. OESTE'
DECLARE @PATRON AS varchar(30) = ''
EXEC CANTIDADJUGADORES @NOMBRE, @PATRON, @JUGADORES84 OUTPUT, @JUGADORES85 OUTPUT
PRINT 'Club: ' + @NOMBRE + ' y los jugadores con el patron ' + @PATRON + ' son de la cat. 84: ' + cast(@JUGADORES84 as varchar(100))
+ ' y de la cat. 85: ' + cast(@JUGADORES85 as varchar(100))
go
select * from jugadores
where Id_Club=(Select Id_Club from Clubes where Clubes.Nombre='FERRO C. OESTE')








/*8.	Función
Definir una función fc###### que: 
Reciba el nombre de un club y el número de una categoría.
Retorne la diferencia en días entre el jugador más joven y el más viejo en ese club y esa categoría. */

ALTER FUNCTION DIFERENCIADIAS (@NOMBRECLUB AS VARCHAR(100), @CATEGORIA AS INT)
RETURNS INT
AS
BEGIN
DECLARE @JOVEN AS DATETIME
DECLARE @VIEJO AS DATETIME
DECLARE @DIFERENCIA AS INT

SELECT @JOVEN=MAX(FECHA_NAC), @VIEJO=MIN(FECHA_NAC)
FROM JUGADORES J
JOIN CLUBES C ON C.ID_CLUB=J.ID_CLUB AND C.NOMBRE=@NOMBRECLUB
WHERE J.CATEGORIA=@CATEGORIA

SELECT @DIFERENCIA=DATEDIFF(DD,@VIEJO,@JOVEN)

RETURN @DIFERENCIA
END

SELECT NOMBRE,DBO.DIFERENCIADIAS(NOMBRE,84) FROM CLUBES

--Retorne el nombre y apellido en columnas separadas. 
ALTER FUNCTION NOMBREAPELLIDO (@NOMBREJUGADOR AS CHAR(30))
RETURNS @NOMBREAPELLIDOTABLE TABLE (NOMBRE VARCHAR(100), APELLIDO VARCHAR(100))
AS
BEGIN
DECLARE @POSICION AS INT
DECLARE @APELLIDO AS VARCHAR(100)
DECLARE @NOMBRE AS VARCHAR(100)
DECLARE @LARGO AS INT

SELECT @POSICION=CHARINDEX(',',@NOMBREJUGADOR)
SELECT @LARGO=LEN(@NOMBREJUGADOR)
--Substring (Campo,Desde,largo) Se agrega mas 2 por la coma y espacio.
SELECT @NOMBRE = SUBSTRING(@NOMBREJUGADOR,@POSICION+2,@LARGO), @APELLIDO = substring(@nombrejugador,0,@posicion) 
--Otra forma del apellido: LEFT(@NOMBREJUGADOR,@POSICION-1)
--
--Se hace por tabla porque hay que devolver dos campos
INSERT INTO @NOMBREAPELLIDOTABLE (NOMBRE,APELLIDO)
	VALUES(@NOMBRE,@APELLIDO)
RETURN
END
GO

SELECT *
FROM DBO.NOMBREAPELLIDO('PEREZ, PEPITO')


/*
Ejercicio 2
Definir un procedimiento pr###### que:
Reciba el nombre de un club.
Retorne en dos parámetros de salida la cantidad de goles obtenidos como local y la cantidad de goles
como visitante del club correspondiente.
Ejecutar el procedimiento y mostrar el resultado.*/

create procedure Ejercicio2PracticaParcialv5
@club VARCHAR (20)
as

select (select sum (partidos.golesL) from Partidos where partidos.Id_ClubL = 
(select clubes.Id_Club from Clubes where clubes.Nombre like @club)) as GolesLocales, (select sum (partidos.golesV) from Partidos
where partidos.id_clubV = (select clubes.Id_Club from Clubes where clubes.nombre like @club)) as GolesVisita

 
 exec Ejercicio2PracticaParcialv5 'FATIMA'

CREATE VIEW ejercicio4V1
as
(select Jugadores.Nombre as Jugadores
from Jugadores where jugadores.Categoria=84  and jugadores.Id_Club =
(select general.Id_Club from General where general.ganados=general.perdidos)) 

select * from ejercicio4V1


ALTER PROCEDURE GOLES
@NOMBRECLUB AS VARCHAR(100),
@GOLESLOCAL INT OUTPUT,
@GOLESVISITANTE INT OUTPUT
AS
DECLARE @IDCLUB SMALLINT
--Me guardo el Id del club
SELECT @IDCLUB=ID_CLUB FROM CLUBES WHERE CLUBES.Nombre=@NOMBRECLUB
--Cuento goles locales
--PRINT @IDCLUB
SELECT @GOLESLOCAL=sum(isnull(GolesL,0))
FROM PARTIDOS P
where P.Id_ClubL=@IDCLUB
PRINT @GOLESLOCAL
--Cuento goles visitantes
SELECT @GOLESVISITANTE=sum(isnull(GolesV,0))
FROM PARTIDOS P
where P.Id_ClubV=@IDCLUB
go


--Ejecuto
declare @GOLESL INT
declare @GOLESV INT
exec GOLES @NOMBRECLUB='FERRO C. OESTE', @GOLESLOCAL=@GOLESL OUTPUT, @GOLESVISITANTE=@GOLESV OUTPUT
PRINT 'Goles Local del equipo: ' + cast(@GOLESL as varchar) + ' y goles Visitante del equipo: ' + cast(@GOLESV as varchar)


alter trigger IDCLUB
ON CLUBES
INSTEAD OF INSERT
AS
IF (SELECT ID_CLUB FROM inserted) = (SELECT MAX(ID_CLUB)+1 FROM Clubes)
	BEGIN
	PRINT 'SE INSERTARÁ'
	INSERT INTO Clubes
	SELECT ID_CLUB, NOMBRE, NROZONA FROM inserted
	END
	ELSE
	BEGIN
	ROLLBACK TRANSACTION
	PRINT 'SE ROMPIÓ TODO'
	END
go


select * from Clubes

insert into Clubes
values(49,'QUILMES A','1')
