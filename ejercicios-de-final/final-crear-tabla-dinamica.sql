/**
 * Procedimiento dínamico
 * 
 * Considerando la tabla jugadores existente generar las tablas de titulares y suplentes
 * que permita registrar cuales jugadores son titulares y cuales suplentes del club
 * al que pertenecen
 *
 * Se deberán implementar las restricciones de entidad, dominio e integridad referencial
 * correspondan, indicando estructura y compartamiento.
 *
 * La creación de la tabla debe defenirse en un procedimiento que debe:
 *      + Componer y ejecutar la sentencia CREATE TABLE dinámicamente, debiendo definir
 *          las estricciones correspondientes.
 *      + Recuperar desde el catálogo la estructura de las claves respectivas.
 *
 * Definir un store procedure sc###### que reciba el nombre de la tabla a crear:
 *      + Debe obtener la descripción de la clave primaria de la tabla jugadores (nombre
 *          de las columnas y tipos de datos).
 *      + Crear dinámicamente la tabla enviada como parámetro.
 *      + Indicar dinámicamente (puede ser en la misma sentencia) la clave primaria.
 *      + Indicar dinámicamente (puede ser en la misma sentencia) la clave foránea.
 * 
 * La creación de ambas tablas debe ser invocando el procedimiento anterior. 
 *
 **/
CREATE PROCEDURE sr1037546
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

EXEC sr1037546 ('Titulares')
GO
EXEC sr1037546 ('Suplentes')
GO