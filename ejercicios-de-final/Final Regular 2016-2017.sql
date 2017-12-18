/*
1 - Resolver mediante la utilizacion de cursores
Generar un listado con los datos existentes de los partidos de la base de jugadores, conforme a las siguientes caracteristicas:
a - Debe corresponder a los partidos de referentes a la fecha (nº de fecha), en la que se convirtieron la mayor cantidad de goles.
b - Indicar la cantidad de goles convertidos por cada club en esa fecha, discriminados por categoria.
c - La nomina de clubes que convirtieron goles debe ordenarse de mayor a menor por cantidad total de goles entre ambas categorias.
d - Los resultados a mostrar debe respetar el siguiente formato:
Fecha con mayor cantidad de goles convertidos.
  Nº fecha:(nº)           Cantidad de goles: (total de la fecha) 
  
  Goles convertidos por los clubes ordenados de mayor a menor.
  Club:(nombre)           Total de goles:(total del club)
        Categoria 84: (subtotal de la categoria)
        Categoria 85: (subtotal de la categoria)
*/

--a - Debe corresponder a los partidos de referentes a la fecha (nº de fecha), en la que se convirtieron la mayor cantidad de goles.

declare @cant_goles_locales int = 0
declare @cant_goles_visitantes int = 0
declare @cant_goles_fecha_max int = 0
declare @cant_goles_fecha_total int = 0

declare @nro_fecha tinyint = 0
declare @nro_fecha_max tinyint = 0
declare @leyenda_salida varchar(4000)
set @leyenda_salida = 'Fecha con mayor cantidad de goles convertidos.'

declare cursor_cant_goles cursor forward_only
for
select nrofecha,sum(GolesL)golesLocal,sum(golesv)golesVisitante from partidos group by nrofecha

open cursor_cant_goles
fetch next from cursor_cant_goles into @nro_fecha,@cant_goles_locales,@cant_goles_visitantes

if(@@fetch_status<>0)
	Print('Error al obtener los goles por fecha')

while(@@fetch_status=0)
begin
	if(@cant_goles_locales + @cant_goles_visitantes >= @cant_goles_fecha_max)
		begin
			set @cant_goles_fecha_max = @cant_goles_locales + @cant_goles_visitantes
			set @nro_fecha_max = @nro_fecha
		end
	set @cant_goles_fecha_total = @cant_goles_locales + @cant_goles_visitantes
	fetch next from cursor_cant_goles into @nro_fecha,@cant_goles_locales,@cant_goles_visitantes
end

close cursor_cant_goles
deallocate cursor_cant_goles


--b - Indicar la cantidad de goles convertidos por cada club en esa fecha, discriminados por categoria.
declare @Nombre_club varchar(500)
declare @cant_goles_club int
declare @categoria int

create table #temp_goles_club_categoria(nombre_club varchar(255),categoria varchar(50),cantidadGoles int)

declare cant_goles_cursor_parteb cursor forward_only 
for
	select Nombre,SUM(GolesL)cantGoles,Categoria from Clubes c inner join Partidos p on (p.Id_ClubL=c.Id_Club) where p.NroFecha = @nro_fecha_max
	GROUP by Nombre,Categoria
	UNION
	select Nombre,SUM(GolesV)cantGoles,Categoria from Clubes c inner join Partidos p on (p.Id_ClubV=c.Id_Club) where p.NroFecha = @nro_fecha_max
	GROUP by Nombre,Categoria

open cant_goles_cursor_parteb
fetch next from cant_goles_cursor_parteb into @Nombre_club,@cant_goles_club,@categoria

if(@@FETCH_STATUS<>0)
	raiserror('Error al obtener los goles convertidos',9,1)

while(@@FETCH_STATUS = 0)
	begin

	insert into #temp_goles_club_categoria(nombre_club,categoria,cantidadGoles)values(@Nombre_club,@categoria,@cant_goles_club)

	fetch next from cant_goles_cursor_parteb into @Nombre_club,@cant_goles_club,@categoria
	end
close cant_goles_cursor_parteb
deallocate cant_goles_cursor_parteb


--c - La nomina de clubes que convirtieron goles debe ordenarse de mayor a menor por cantidad total de goles entre ambas categorias.

declare @n_club varchar(50)
declare @totalPorClub int
declare cursor_orden_clubes cursor forward_only
for 
select nombre_club,sum(cantidadGoles)as totalGolesPorClub from #temp_goles_club_categoria group by nombre_club order by totalGolesPorClub desc

open cursor_orden_clubes
fetch next from cursor_orden_clubes into @n_club,@totalPorClub

if(@@FETCH_STATUS<>0)
	raiserror('Error al obtener el orden a mostrar',8,1)

while(@@FETCH_STATUS = 0)
	begin
	
	set @leyenda_salida = concat(@leyenda_salida,'Nº fecha:('+convert(varchar(50),@nro_fecha_max)+')           Cantidad de goles: ('+convert(varchar(50),@cant_goles_fecha_total)+')  Goles convertidos por los clubes ordenados de mayor a menor.') 
	set @leyenda_salida = concat(@leyenda_salida,CHAR(13)) 
	set @leyenda_salida = concat(@leyenda_salida,'Club:('+@n_club+') Total de goles:('+convert(varchar(50),@totalPorClub)+')')
  
	
		declare cant_goles_cursor_partec cursor forward_only 
			for
				select Nombre,SUM(GolesL)cantGoles,Categoria from Clubes c inner join Partidos p on (p.Id_ClubL=c.Id_Club) where p.NroFecha = @nro_fecha_max
				GROUP by Nombre,Categoria
				UNION
				select Nombre,SUM(GolesV)cantGoles,Categoria from Clubes c inner join Partidos p on (p.Id_ClubV=c.Id_Club) where p.NroFecha = @nro_fecha_max
				GROUP by Nombre,Categoria

		open cant_goles_cursor_partec
		fetch next from cant_goles_cursor_partec into @Nombre_club,@cant_goles_club,@categoria
		if(@@FETCH_STATUS<>0)
	raiserror('Error al obtener los goles convertidos',9,1)

while(@@FETCH_STATUS = 0)
	begin
	if(@categoria=84 and @n_club=@Nombre_club)
	set @leyenda_salida = concat(@leyenda_salida,'Categoria 84: '+convert(varchar(50),@cant_goles_club))
    if(@categoria=85 and @n_club=@Nombre_club)
	set @leyenda_salida = concat(@leyenda_salida,'Categoria 85: '+convert(varchar(50),@cant_goles_club))

	fetch next from cant_goles_cursor_partec into @Nombre_club,@cant_goles_club,@categoria
	end
close cant_goles_cursor_partec
deallocate cant_goles_cursor_partec
  

	fetch next from cursor_orden_clubes into @n_club,@totalPorClub
	end

print @leyenda_salida

close cursor_orden_clubes
deallocate cursor_orden_clubes
drop table #temp_goles_club_categoria



/*
2 - Implementar una unica transaccion que invoque una funcion y actualice y proyecte la tabla de partidos, conforme a siguiente detalle:
a - Definir una función escalar que retorne en nº de fecha donde se registraron la menor cantidad de empates entre los clubes de la zona 2.
Debe resolverse por correlacionada.
b - Iniciar una transaccion que actualice todos los partidos de la zona 2 correspondiente a la fecha retornada por la funcion, agregando un
gol a cada club visitante en la categoria 85.
c - Modificar la tabla poscate285 en funcion de los goles agregados en el punto b. Debiendo:
  I - Actualizar la cantidad de partidos ganados, empatados y perdidos de los clubes afectados.
  II - Actualizar la cantidad de goles (a favor) y golesC (en contra) de los mismos.
  III - Actualizar los puntos de dichos clubes teniendo en cuenta 3 puntos por partido ganado y 1 punto por partido empatado.
d - Proyectar la tabla poscate285 luego de ser actualizada.
e - Deshacer el punto c y confirmar el punto b de la transaccion antes de finalizarla.

Debe controlar las salidas por error mostrando un mensaje identificatorio del error. 
No utilizar cursores.
*/

/*
3 - Definir un desencadenador que se accione cuando se modifica el club al que pertenecen los jugadores.
a - La modificacion del club se interpreta como un intercambio entre clubes, de modo que si los jugadores del club1 se modifican al 
club2, los jugadores del club2 pasan al club1.
b - La modificacion se realiza intercambiando la misma cantidad de jugadores entre los dos clubes de la misma zona y en la misma 
categoria.
c - Si la cantidad a intercambiar no es posible satisfacerla, se ajusta a la cantidad correcta para realizar el intercambio.
No utilizar cursores.
*/

