/*4.18. Definir una función que devuelva la edad de un paciente.
INPUT: fecha de nacimiento.
OUTPUT: edad expresada en años cumplidos.*/

CREATE FUNCTION fn_paciente_edad (@fecha_nac datetime)
RETURNS int
AS 
BEGIN
  declare @fecha_actual datetime = getdate(), @edad int = datediff(dd, @fecha_nac, @fecha_actual)/365.25
  RETURN @edad
END
 

/*4.19. Definir las siguientes funciones para obtener:
INPUT: nombre del estudio.
OUTPUT: mayor precio del estudio.
menor precio del estudio.
precio promedio del estudio.*/

CREATE FUNCTION fn_precio_menor (@instituto varchar(50))
RETURNS float
AS
BEGIN
  declare @precio = SELECT min(ie.precio) FROM Instituto_Estudio ie 
  INNER JOIN Instituto i
  ON ie.id_instituto = i.id
  WHERE i.nombre_instituto = @instituto
  RETURN @precio
END

CREATE FUNCTION fn_precio_promedio (@instituto varchar(50))
RETURNS float
AS
BEGIN
  declare @precio = SELECT avg(ie.precio) FROM Instituto_Estudio ie 
  INNER JOIN Instituto i
  ON ie.id_instituto = i.id
  WHERE i.nombre_instituto = @instituto
  RETURN @precio
END


/*4.20. Definir una función que devuelva los n institutos más utilizados por especialidad.
INPUT: nombre de la especialidad, cantidad máxima de institutos.
OUTPUT: Tabla de institutos (n primeros ).*/

CREATE FUNCTION fn_institutos_especialidad (@espec varchar(50), @cant int)
RETURNS TABLE
AS
BEGIN
  RETURN (SELECT i.nombre_instituto, COUNT(*) AS cantidad FROM Instituto_Estudio ie
  INNER JOIN Especialidad e
  ON ie.id_estudio = e.id
  INNER JOIN Instituto i
  ON i.id = ie.id_instituto
  WHERE e.nombre_especialidad = @espec
  GROUP BY i.nombre_instituto, cantidad
  HAVING COUNT (i.nombre_instituto) <= @cant)
END


/*4.21. Definir una función que devuelva los estudios y la cantidad de veces que se repitieron para un mismo paciente a 
partir de una cantidad mínima que se especifique y dentro de un determinado período de tiempo.
INPUT: cantidad mínima, fecha desde, fecha hasta.
OUTPUT: Tabla que proyecte el paciente, el estudio y la cantidad.*/

CREATE FUNCTION fn_paciente_estudios (@min int, @desde datetime, @hasta datetime)
RETURNS TABLE
AS
BEGIN
  RETURN (SELECT p.nombre, e.nombre_estudio, COUNT(*) AS cantidad FROM Registro r
  INNER JOIN Paciente p
  ON r.dni_paciente = p.dni
  INNER JOIN Estudio e
  ON e.id = r.id_estudio
  WHERE r.fecha_estudio BETWEEN @desde AND @hasta
  GROUP BY p.nombre, e.nombre_estudio
  HAVING COUNT (*) >= @min)
END


/*4.22. Definir una función que devuelva los médicos que ordenaron repetir un mismo estudio a un mismo paciente en los últimos días.
INPUT: cantidad de días.
OUTPUT: Tabla que proyecte el estudio repetido, nombre y fechas de realización, identificación del paciente y del médico.*/

CREATE FUNCTION fn_medico_paciente (@dias int)
RETURNS TABLE
AS
BEGIN
  RETURN (SELECT e.nombre_estudio, r.fecha_estudio, p.dni, m.nombre_medico FROM Registro r
  INNER JOIN Estudio e
  ON r.id_estudio = e.id
  INNER JOIN Paciente p
  ON p.dni = r.dni_paciente
  INNER JOIN Medico m
  ON m.matricula = r.matricula_medico
  WHERE fecha_estudio > DATEADD (dd, @dias, getdate())
  GROUP BY e.nombre_estudio, r.fecha_estudio, p.dni, m.nombre_medico
  HAVING COUNT(*) > 1)
END
          
          
/*4.23. Definir una función que devuelva una cadena de caracteres en letras minúsculas con la letra inicial de cada palabra en mayúscula.
INPUT: string inicial.
OUTPUT: stringconvertido.*/

CREATE FUNCTION fn_mayusculas_minusculas (@cadena varchar(50))
RETURNS varchar(100)
AS
BEGIN
  declare @convertido varchar(100) 
  declare @caracter varchar(1) 
  declare @cont int 
  SET @cont = 2 
  SET @convertido = upper(substring(@cadena,1,1)) 
  WHILE (@cont < len(@cadena)+1) 
  BEGIN 
    upper(substring(@cadena,@cont+1,1)) 
    SET @caracter = substring(@cadena,@cont,1) 
    IF @caracter = ' ' 
    BEGIN 
      SET @convertido = @convertido + ' ' + 
      SET @cont = @cont + 2 
    END 
    ELSE 
      BEGIN 
      SET @convertido = @convertido + lower(@caracter) 
      SET @cont = @cont + 1 
      END 
  END 
RETURN @convertido
END


/*4.24. Definir una función que devuelva las obras sociales que cubren un determinado estudio en todos los planes que tiene
y que se realizan en algún instituto registrado en la base.
INPUT: nombre del estudio.
OUTPUT: Tabla que proyecta la obra social y la categoría.*/

CREATE FUNCTION fn_obra_social (@estudio varchar(50))
RETURN TABLE
AS
BEGIN
  RETURN (SELECT os.nombre, os.categoria FROM 

/*4.25. Definir una función que proyecte un descuento adicional a los afiliados de una obra social, del 5% a los estudios de cardiología y del 7% a los de gastroenterología, para aquellos que no tienen cubierto el 100% del estudio.
INPUT: sigla de la obra social.
OUTPUT: Tabla que proyecte los datos del paciente, del estudio y el monto neto del descuento.*/

