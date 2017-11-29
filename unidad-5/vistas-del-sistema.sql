/**
	5.1. Listar los usuarios de la base de datos.
**/
use master

SELECT * FROM sysusers

/**
	5.2. Listar los tipos de datos creados.
**/
SELECT name FROM systypes

/**
	5.3. Listar el nombre de los índices existentes en la base de datos.
**/
SELECT DISTINCT t.name 
FROM sys.indexes i 
INNER JOIN sys.tables t ON i.object_id = t.object_id 

/**
	5.4. Proyectar las restricciones vinculadas a los índices anteriores.
**/
SELECT
  [schema] = OBJECT_SCHEMA_NAME([object_id]),
  [table]  = OBJECT_NAME([object_id]),
  [index]  = name, 
  is_unique_constraint,
  is_unique,
  is_primary_key
FROM sys.indexes
/**
	5.5. Crear un procedimiento que reciba el nombre de un índice y proyecte las columnas con su respectivo tipo de tato que lo conforman.
**/
create procedure proyecta_tipo_dato @nombre_indice varchar(15) as
select * from sys.indexes i inner join sys.columns c on i.object_id=c.object_id join sys.types y on y.system_type_id = c.system_type_id  where i.name= @nombre_indice


/**
	5.6. Crear un procedimiento que reciba el nombre de una tabla y proyecte la cantidad de cada tipo de dato de su estructura.
**/
CREATE PROCEDURE sp_cantidad_cada_tipode_dato 
	@nombreTabla varchar(50)
AS
	BEGIN
	SELECT DATA_TYPE 'tipoDato',count(*)
	FROM information_schema.columns
	WHERE TABLE_NAME = @nombreTabla
	GROUP BY DATA_TYPE
END

/**
	5.7. Identificar los procedimientos y triggers existentes en la base.
**/
SELECT name AS procedure_name   
    ,SCHEMA_NAME(schema_id) AS schema_name  
    ,type_desc  
    ,create_date  
    ,modify_date  
FROM sys.procedures;  
GO  

SELECT name as trigger_name
    ,type_desc  
    ,create_date  
    ,modify_date  
FROM sys.triggers;  
GO  

/**
	5.8. Crear un procedimiento que reciba el nombre de una tabla. 
	Proyectar las restricciones foreignkey de la tabla indicando nombre de la restricción, columnas y tipo de datos que la componen, nombre de la tabla referenciada y columna referenciada.
**/
CREATE PROCEDURE sp_proyectar_info_de_tabla
	@nombre_tabla varchar(50)
AS
BEGIN
	SELECT c.name, fk.constraint_column_id, ty.name
	FROM sys.tables t
	INNER JOIN sys.foreign_key_columns fk ON fk.parent_object_id = t.object_id
	INNER JOIN sys.columns c ON fk.parent_object_id = c.object_id AND fk.parent_column_id = c.column_id
	INNER JOIN sys.types ty ON ty.system_type_id = c.system_type_id
	WHERE t.name = @nombre_tabla

END

/**
	5.9. Crear un procedimiento que reciba un tipo de dato. 
	Indicar la cantidad de columnas de tablas con ese tipo de dato.
**/

CREATE PROCEDURE sp_indicar_columnas_con_mismo_tipo_dato
	@tipo_de_dato tipoDeDato
AS
BEGIN
	SELECT COUNT(*) 
	FROM sys.columns cols
	INNER JOIN sys.types type ON type.system_type_id = cols.system_type_id
	WHERE type.name = @tipoDeDato
END

/**
	5.10. Crear un procedimiento que reciba el nombre de una tabla y elimine en forma dinámica el 1° trigger encontrado vinculado a la tabla.
**/
create procedure elimina_dinamica_1er_trigger @nombre_tabla varchar(15) as

declare @trigger_a_borrar varchar(20)
select top 1 @trigger_a_borrar = t1.name from sys.tables t inner join sys.triggers t1 on t.object_id=t1.parent_id where t.name=@nombre_tabla
declare @comando varchar(500);
set @comando = concat('drop trigger'+ @trigger_a_borrar,'on database')
exec (@comando)
