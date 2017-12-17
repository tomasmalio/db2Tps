/**
 * 
 * 1) Generar una tabla (Goles) que permita persistir los goles convertidos por los jugadores.
 * 
 * a. Determinar los atributos necesarios para identificar al partido y a los jugadores que
 * convirtieron los goles en una fecha, club (local o visitante) y categoría respectiva.
 *
 **/

CREATE TABLE Goles (
	Id_Partido      smallint not null,
	NroFecha		tinyint not null,
	Tipodoc			char(3) not null,
	Nrodoc 			Integer not null,
	Id_Club			smallint not null,
	Categoria		Tinyint not null,
	CantidadGoles	smallint not null,
	Primary Key (Id_Partido, NroFecha, Nrodoc),
	Constraint  goles_fk_jugador Foreign Key (Tipodoc, Nrodoc) references Jugadores(Tipodoc, Nrodoc),
	Constraint  goles_fk_club Foreign Key (Id_Club) references Clubes(Id_Club)
)
GO


/**
 * 
 * 2) Implementar una única transacción que defina y organice las siguientes unidades de un proceso:
 *
 * a. Asignación de goles a jugadores.
 * 		+ Definir un cursor que recorra todos los partidos por fecha (atributo NroFecha) 
 * 		asignando cada gol a un jugador distinto antes de repetir el mismo jugador.
 * 		+ La determinación del jugador debe realizarse definiendo e invocando una función 
 * 		fn_###### que cumpla con los siguientes requisitos:
 * 			o Debe pertenecer al club y la categoría respectiva al partido correspondiente.
 *			o Debe ser el jugador que menos goles tenga, si hay más de uno, la selección es aleatoria.
 * 
 * b. Proyección de los jugadores del club, que tenga la menor cantidad de jugadores sin convertir goles.
 *		+ La identificación de los jugadores debe realizarse definiendo e invocando una función ng_######.
 * 			o Que retorne el nombre del jugador y el nombre del club.
 * 
 * c. Actualización del resultado de los partidos de la última fecha (atributo NroFecha).
 * 		+ Para los partidos de la categoría 84:
 *			o Asignar 3 goles a los clubes locales y 0 gol a los visitantes.
 * 		+ Para los partidos de la categoría 85:
 *			o Asignar 2 goles a los clubes locales y 1 gol a los visitantes.
 *		+ Resolver definiendo e invocando un procedimiento pr_###### que actualice la tabla partidos.
 * 
 * d. Asignación de los goles actualizados en el punto anterior a los jugadores correspondientes.
 * 		+ Resolver conforme a las restricciones definidas en el punto a de la transacción.
 * 
 * e. Deshacer los puntos c y d, de la transacción, y finalizarla.
 *
 **/

/**
 *
 * 3. Definir un desencadenador (trigger tr_######) cuando se eliminen filas de la tabla Goles.
 * a. Se debe asignar el gol eliminado a otro jugador perteneciente al mismo club y categoría, y 
 * en el mismo partido.
 * b. Resolver sin utilizar cursores.
 *
 **/
