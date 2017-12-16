/**
 * Creación de tablas
 * 
 * Considerando la tabla de jugadores existente generar las tablas de titulares y suplentes 
 * que permita registrar cuales jugadores son titulares y cuales suplenetes del club al que pertenecen.
 * Se deberá implementar las restricciones de entidad, dominio e integridad referencial 
 * que correspondan, indicando estructura y comportamiento.
 *
 **/
create table Titulares (
	Tipodoc Char(3),
	Nrodoc Integer,
	Primary Key (Tipodoc, Nrodoc),
	Constraint titulares_pk_jugadores Foreign Key (Tipodoc, Nrodoc) references jugadores(Tipodoc, Nrodoc)
)

create table Suplentes (
	Tipodoc Char(3),
	Nrodoc Integer,
	Primary Key (Tipodoc, Nrodoc),
	Constraint suplentes_pk_jugadores Foreign Key (Tipodoc, Nrodoc) references jugadores(Tipodoc, Nrodoc)
)

/**
 * Generar tabla dínamica
 **/
CREATE PROCEDURE pr_crear_tabla
@tabla varchar(128)
as
    -- Variables de soporte
    declare @objectId int, @createTableQuery varchar(500), @primaryKeyColumns varchar(500), @lengthQuery varchar(3)
   
    -- Obtengo el object id de las tabla jugadores
    set @objectId = (select object_id from sys.tables where name = 'Jugadores')
    
    -- variables para el cursor
    declare @nombre varchar(128), @tipoDato varchar(128), @maxLength varchar(4)
    
    -- Cursor para recorrer las columnas de la clave compuesta de jugadores
    -- Query a todas las columnas del sistema, unidas con los tipos de datos filtradas por el index para la PK de jugadores
    -- es para conseguir el nombre y el tipo de dato y crear la PK de suplentes/titulares
    -- resultado: 1 -> NroDoc, Integer | 2 -> Tipodoc, char
    declare cursor_composicion_clave_primaria cursor for
    	SELECT c.name, t.name, c.max_length 
    	FROM sys.all_columns c
    	INNER JOIN sys.types t ON c.system_type_id = t.system_type_id
    	WHERE 
    		c.object_id = @objectId 
    		AND c.column_id IN (
    				SELECT column_id 
    				FROM sys.index_columns 
    				WHERE object_id = @objectId
    			)
    
    SET @createTableQuery = 'CREATE TABLE '+ @tabla+ ' ('
    SET @primaryKeyColumns = ''
    
    open cursor_composicion_clave_primaria
    fetch next FROM cursor_composicion_clave_primaria into @nombre, @tipoDato, @maxLength
    
    WHILE @@FETCH_STATUS = 0
    	BEGIN
			SET @lengthQuery = ''
            IF (@tipoDato in('varchar', 'char'))
            BEGIN
				SET @lengthQuery = '('+@maxLength+')'
            END
            SET @createTableQuery = @createTableQuery +  @nombre + ' ' + @tipoDato + @lengthQuery + ' not null,'
            SET @primaryKeyColumns = @primaryKeyColumns + @nombre + ','
            fetch next FROM cursor_composicion_clave_primaria into @nombre, @tipoDato, @maxLength
    	END
    close cursor_composicion_clave_primaria
    deallocate cursor_composicion_clave_primaria

    -- Eliminamos la ultima coma
    SET @primaryKeyColumns = substring(@primaryKeyColumns,1, len(@primaryKeyColumns) -1)
	SET @createTableQuery = @createTableQuery + ' primary key (' + @primaryKeyColumns + '))'
    PRINT @createTableQuery
    exec (@createTableQuery)
    RETURN 0
GO




/**
 * 2. Función
 *
 * Definir una función fn###### que:
 * 		+ Reciba un id_Club, una categoría y un número entero n
 *		+ Devolver los n jugadores más viejos de ese club en esa categoria
 *		+ La resolución debe efectuarse en una consulta correlacionada. Sin utilizar la cláusula top.
 **/
CREATE FUNCTION fn1037546 (@id_Club smallint, @categoria tinyint, @n int)
	RETURNS TABLE
	AS
	RETURN (
		SELECT *
		FROM Jugadores jj
		WHERE jj.Nrodoc IN (
							SELECT j.Nrodoc
							FROM Jugadores j 
							WHERE j.id_Club = @id_Club AND j.Categoria = @categoria 
							ORDER BY j.Fecha_Nac ASC
							OFFSET 0 ROWS
							FETCH NEXT @n ROWS ONLY 
						)
	)

/** 
	VER OTRA FORMA
**/
create function dbo.fn_jugadores (@n int, @equipo varchar(30), @categoria int)
returns table
as
return (
	SELECT * 
	FROM Jugadores j 
	WHERE 
		j.id_club = (
						SELECT id_club 
						FROM Clubes 
						WHERE nombre = @equipo
					) 
		AND j.categoria = @categoria 
		AND @n > (
					SELECT COUNT(*) 
					FROM Jugadores j2 
					WHERE j.fecha_nac > j2.fecha_nac 
					AND j2.id_club = (
										SELECT id_club 
										FROM clubes 
										WHERE nombre = @equipo
									) 
					AND j2.categoria = @categoria
				)
	)
GO
/** 
	EOF / VER OTRA FORMA
**/



/**
 * 3. Trigger
 *
 * Definir una trigger fn###### que se accione al eliminar suplentes, debiendo controlar:
 * 		+ Si se quita un jugador como suplente, el mismo debe registrarse como titular.
 *		+ No permitir eliminar jugadores de distinto club y categoría en la misma eliminación.
 * No utilizar cursores.
 *
 **/

CREATE TRIGGER tr1037546
ON Suplentes
FOR DELETE
AS
	declare @id_club_ant smallint
	declare @categoria_ant Tinyint
	declare @id_club_nuevo smallint
	declare @categoria_nuevo Tinyint


	IF ((SELECT COUNT(*) FROM Deleted) > 1)
		BEGIN
			SET @id_club_nuevo 		= (SELECT TOP 1 j.Id_Club FROM Deleted d INNER JOIN Jugadores j ON j.Nrodoc = d.Nrodoc)
			SET @categoria_nuevo 	= (SELECT TOP 1 j.Categoria FROM Deleted d INNER JOIN Jugadores j ON j.Nrodoc = d.Nrodoc)
			SET @id_club_ant 		= (SELECT TOP 2 j.Id_Club FROM Inserted i INNER JOIN Jugadores j ON j.Nrodoc = i.Nrodoc)
			SET @categoria_ant 		= (SELECT TOP j.Categoria FROM Inserted i INNER JOIN Jugadores j ON j.Nrodoc = i.Nrodoc)
			
			IF ((@id_club_nuevo = @id_club_ant) AND (@categoria_nuevo = @categoria_ant))
				BEGIN
					INSERT INTO Titulares (Tipodoc, Nrodoc) (SELECT Tipodoc, Nrodoc FROM Deleted)
				END
			ELSE
				BEGIN
					INSERT INTO Suplentes (Tipodoc, Nrodoc) (SELECT Tipodoc, Nrodoc FROM Deleted)
				END
		END
	ELSE
		BEGIN
			INSERT INTO Titulares (Tipodoc, Nrodoc) (SELECT Tipodoc, Nrodoc FROM Deleted)
		END 
GO


/**
 * 4. Transacción
 *
 * Crear un store procedure st###### donde se definan los siguientes procedimientos,
 * conformando una única transacción.
 *		+ Establecer en cada categoría de cada club hasta un máximo de 11 jugadores como titulares,
 *		los restantes como suplentes (se debe invocar la función del punto 2).
 *		+ Incorporar como suplente para cada categoría de cada club aljugador titular (de ese club
 *		y categoría) que posea el nombre más corto en cantidad de caracteres.
 *		+ Proyectar todos los jugadores suplentes
 *		+ Deshacer la última actualización
 *		+ Finalizar la transacción.
 * Los menesajes de error deben mostrarse con la función raiserror.

 **/
CREATE PROCEDURE st1037546 





