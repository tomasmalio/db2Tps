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

