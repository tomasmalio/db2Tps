/**
	5.1. Listar los usuarios de la base de datos.
**/
use master

SELECT * FROM sysusers --Para SQL2000

SELECT * FROM syslogins --Para SQL2000

SELECT * FROM sys.database_principals 

SELECT * FROM sys.server_principals

SELECT * FROM sys.sql_logins

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
create procedure proyecta_cantidad_tipo_dato @nombre_tabla varchar(15) as
select count(y.name) from sys.tables t join sys.columns c on t.object_id=c.object_id join sys.types y on y.system_type_id = c.system_type_id where t.name =@nombre_tabla

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
