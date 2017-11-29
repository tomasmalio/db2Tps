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

/**
	5.5. Crear un procedimiento que reciba el nombre de un índice y proyecte las columnas con su respectivo tipo de tato que lo conforman.
**/

/**
	5.6. Crear un procedimiento que reciba el nombre de una tabla y proyecte la cantidad de cada tipo de dato de su estructura.
**/
/**
	5.7. Identificar los procedimientos y triggers existentes en la base.
**/
/**
	5.8. Crear un procedimiento que reciba el nombre de una tabla. Proyectar las restricciones foreignkey de la tabla indicando nombre de la restricción, columnas y tipo de datos que la componen, nombre de la tabla referenciada y columna referenciada.
**/
/**
	5.9. Crear un procedimiento que reciba un tipo de dato. Indicar la cantidad de columnas de tablas con ese tipo de dato.
**/
/**
	5.10. Crear un procedimiento que reciba el nombre de una tabla y elimine en forma dinámica el 1° trigger encontrado vinculado a la tabla.
**/