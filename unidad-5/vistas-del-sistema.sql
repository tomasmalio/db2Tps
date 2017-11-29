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
select name from systypes;

/**
	5.3. Listar el nombre de los índices existentes en la base de datos.
**/
SELECT DISTINCT t.name FROM sys.indexes i 
INNER JOIN sys.tables t ON i.object_id = t.object_id 