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


/*4.21. Definir una función que devuelva los estudios y la cantidad de veces que se repitieron para un mismo paciente a partir de una cantidad mínima que se especifique y dentro de un determinado período de tiempo.
INPUT: cantidad mínima, fecha desde, fecha hasta.
OUTPUT: Tabla que proyecte el paciente, el estudio y la cantidad.*/


/*4.22. Definir una función que devuelva los médicos que ordenaron repetir un mismo estudio a un mismo paciente en los últimos días.
INPUT: cantidad de días.
OUTPUT: Tabla que proyecte el estudio repetido, nombre y fechas de realización, identificación del paciente y del médico.*/


/*4.23. Definir una función que devuelva una cadena de caracteres en letras minúsculas con la letra inicial de cada palabra en mayúscula.
INPUT: string inicial.
OUTPUT: stringconvertido.*/


/*4.24. Definir una función que devuelva las obras sociales que cubren un determinado estudio en todos los planes que tiene y que se realizan en algún instituto registrado en la base.
INPUT: nombre del estudio.
OUTPUT: Tabla que proyecta la obra social y la categoría.*/


/*4.25. Definir una función que proyecte un descuento adicional a los afiliados de una obra social, del 5% a los estudios de cardiología y del 7% a los de gastroenterología, para aquellos que no tienen cubierto el 100% del estudio.
INPUT: sigla de la obra social.
OUTPUT: Tabla que proyecte los datos del paciente, del estudio y el monto neto del descuento.*/

