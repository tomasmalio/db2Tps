--CURSORES
--6.1. Definir un Cursor:
--Que liste la ficha de los pacientes de los últimos seis meses conforme al siguiente formato de salida:
--Datos del paciente.
--Identificación del médico.
--Detalle de los estudios realizados.

DECLARE @dni varchar(8), @nombre varchar(50), @apellido varchar(50),@sexo char(1),@matricula_medico smallint
DECLARE lista_pacientes CURSOR 
FOR Select p.dni, p.nombre, p.apellido, p.sexo, r.matricula_medico
from dbo.Registro r inner join paciente p on r.dni_paciente= p.dni where datediff(MM, r.fecha_estudio, getdate())<=6

OPEN lista_pacientes
FETCH NEXT FROM lista_pacientes into @dni , @nombre , @apellido ,@sexo ,@matricula_medico 
WHILE @@FETCH_STATUS = 0
   BEGIN
			PRINT @dni +' - '+ @nombre +' - '+ @apellido +' - '+ @sexo +' - '+ convert(varchar(50),@matricula_medico)
		   FETCH NEXT FROM lista_pacientes 
   END
CLOSE lista_pacientes
DEALLOCATE lista_pacientes



--6.2. Definir un Cursor:
--Que liste el detalle de los planes que cubren un determinado estudio identificando el porcentaje cubierto y la obra social, según formato:
--Estudio.
--Obra social.
--Plan y Cobertura (ordenado en forma decreciente).
--select * from Planes p join Plan_Estudio pe on p.id = pe.id_plan join Estudio e on e.id = pe.id_estudio

   DECLARE @nombre_estudio varchar(50), @id_os smallint, @id_plan smallint, @cobertura decimal(3,0)

   DECLARE Cursor_planes CURSOR FORWARD_ONLY READ_ONLY
   FOR select e.nombre_estudio, p.id_obra_social, p.id,pe.cobertura from Planes p join Plan_Estudio pe on p.id = pe.id_plan join Estudio e on e.id = pe.id_estudio
   OPEN Cursor_planes
   FETCH NEXT FROM Cursor_planes INTO @nombre_estudio, @id_os, @id_plan, @cobertura 
   
   IF @@FETCH_STATUS <> 0 
		PRINT 'NO TIENE planes que cubren un determinado estudio'
   ELSE
		PRINT '==  TIENE planes que cubren un determinado estudio =='     
	
	DECLARE @mensaje varchar(255)
   WHILE @@FETCH_STATUS = 0
   BEGIN
	print @nombre_estudio + convert(varchar(25),@id_os) +','+  convert(varchar(25),@id_plan) +','+  convert(varchar(3),@cobertura) 
	 
	  FETCH NEXT FROM Cursor_planes INTO @nombre_estudio, @id_os, @id_plan, @cobertura 
   END

   CLOSE Cursor_planes
   DEALLOCATE Cursor_planes
   GO


-- 6.3.  Crear una StoredProcedure que defina un Cursor:
--Que liste el resumen mensual de los importes a cargo de una obra social.
--INPUT: nombre de la obra social, mes y año a liquidar.
--Obra social
--Nombre del Instituto
--Detalle del estudio
--Subtotal del Instituto
--Total de la obra social

create procedure sp_cursor_resumen_mensual @nombre_obra_social varchar(50),@mes int,@anio int
as

 DECLARE @nombre_instituto varchar(50),@detalle_estudio varchar(50), @nombre_os varchar(50), @subtotalinstituo decimal(10), @totalOS decimal(10) = 0

   DECLARE Cursor_resumen CURSOR FORWARD_ONLY READ_ONLY
   FOR select i.nombre_instituto ,e.nombre_estudio,o.nombre,sum(precio)as[subtotal x instituto] from ObraSocial o join Planes p on p.id_obra_social=o.id
join Plan_Estudio pe on pe.id_plan = p.id
join Instituto_Estudio ie on ie.id_estudio = pe.id_estudio
join Estudio e on ie.id_estudio= e.id join Instituto i on i.id = ie.id_instituto
join Registro r on r.id_estudio = e.id
where o.nombre=@nombre_obra_social and datepart(mm, r.fecha_estudio) = @mes and datepart(YY, fecha_estudio) = @anio group by i.nombre_instituto,o.nombre,e.nombre_estudio
   OPEN Cursor_resumen
   FETCH NEXT FROM Cursor_resumen INTO @nombre_instituto, @detalle_estudio, @nombre_os, @subtotalinstituo
   
   IF @@FETCH_STATUS <> 0 
		PRINT 'NO TIENE planes que cubren un determinado estudio'
   ELSE
		PRINT '==  TIENE planes que cubren un determinado estudio =='     
	
	DECLARE @mensaje varchar(255)
   WHILE @@FETCH_STATUS = 0
   BEGIN
  set @totalOS = convert(varchar(50),@subtotalinstituo) + @totalOS
		PRINT @nombre_instituto
		PRINT @detalle_estudio
		PRINT @nombre_os
		PRINT convert(varchar(50),@subtotalinstituo)
		
	
	 FETCH NEXT FROM Cursor_resumen INTO @nombre_instituto, @detalle_estudio, @nombre_os, @subtotalinstituo
   END
   PRINT 'El total de la OS fue :'+convert(varchar(50),@totalOS)
   CLOSE Cursor_resumen
   DEALLOCATE Cursor_resumen
   GO

   EXEC sp_cursor_resumen_mensual 'OSDE',5,2017
   
/*
6.4. Crear una Stored Procedure que defina un Cursor:
Que devuelva una tabla de referencias cruzadas que represente el importe mensual abonado a
cada instituto en los últimos n meses.
INPUT: entero que representa los n meses anterioes.
Mes año Mes año Mes año Mes año Total Inst.
Inst. A - - $ $
Inst. B $ $ - $
Total $ $ $ $
*/

CREATE PROCEDURE importe_mensual_abonado
@n int=0
AS
declare cursor1 cursor global scroll
FOR 
SELECT ie.precio, i.nombre_instituto, r.id_Estudio, h.fecha_estudio FROM Registro r 
				INNER JOIN Instituto_Estudio ie ON r.id_estudio = ie.id_estudio AND r.id_instituto = ie.id_instituto
				IINER JOIN Instituto i ON r.id_instituto = i.id
WHERE r.fecha_estudio BETWEEN Getdate()-8 AND Getdate()
ORDER BY r.id_instituto, r.fecha_estudio

declare @CPrecio int, @CPrecio_acum_inst int, @CPrecio_acum_mes int, @CInstituto varchar(40), 
	@CInstituto_old varchar(40), @CFecha smalldatetime, @CFecha_old smalldatetime,  
	@CEstudio varchar(40), @message varchar(200)
SET @CPrecio_acum_inst=0
SET @CPrecio_acum_mes=0
SET @message=''

OPEN cursor1
FETCH NEXT FROM cursor1 INTO @CPrecio, @CInstituto, @CEstudio, @CFecha
IF @@fetch_status<>0
	PRINT 'Sin registros de estudios realizados en los ultimos '+@n+'meses'
ELSE 
@CInstituto_old=@CInstituto
@CFecha_old=@CFecha
WHILE (@@fetch_status=0 AND @CInstituto=@CInstituto_old)
 BEGIN
	SET @CInstituto_old=@CInstituto
	SET @CPrecio_Acum_inst=0
   WHILE (@@fetch_status=0 AND @CFecha=@CFecha_old)
   BEGIN 
	SET @CPrecio_Acum_mes=@CPrecio_Acum_mes+@CPrecio
	SET @CPrecio_Acum_inst=@CPrecio_Acum_inst+@CPrecio
	FETCH NEXT FROM Cursor1 INTO @CPrecio, @CInstituto, @CEstudio, @CFecha
   END
	SET @message=@message+convert(varchar(10),@CPrecio_Acum_mes)
	PRINT Space(20)+'Mes: '+Convert(varchar(10),@CFecha)
	PRINT Space(10)+'Instituto: '+@CInstituto+space(5)+
 END
	PRINT 'TOTAL DE LA OBRA SOCIAL: $'+convert(varchar(20),@CPrecio_acum_obra) 
	PRINT ''
END

CLOSE cursor1
DEALLOCATE cursor1
GO

exec importe_mensual_abonado

SELECT * FROM Registro

/*
6.5. Definir un Cursor:
Que actualiceel campo observaciones de la tabla historias con las siguientes indicaciones:
Repetir estudio: si el mismo se realizó en el segundo instituto registrado en la tabla (orden
alfabético).
Diagnóstico no confirmado: si el mismo se realizó en cualquier otro instituto y fue
solicitado por el tercer médico de la tabla (orden alfabético).
*/

DECLARE @idinstituto integer, @matricula varchar(30), @dni integer,
	@fecha datetime, @idestudio integer
	
DECLARE ctualizarobservaciones CURSOR  
FOR
SELECT r.dni_paciente, r.id_instituto, r.id_estudio, r.matricula_medico, r.fecha_estudio
	FROM Registro r
FOR UPDATE OF r.observaciones

OPEN Cursor_actualizarobservaciones
FETCH NEXT FROM Cursor_actualizarobservaciones 
	INTO @dni, @idinstituto, @idestudio, @matricula, @fecha
	 IF @@FETCH_STATUS <> 0 
   BEGIN
        PRINT space(20)+'SIN REGISTROS'
   END
  WHILE @@FETCH_STATUS = 0
  BEGIN
	FETCH NEXT FROM Cursor_actualizarobservaciones 
	INTO @dni, @idinstituto, @idestudio, @matricula, @fecha
  END

CLOSE Cursor_actualizarobservaciones 
DEALLOCATE Cursor_actualizarobservaciones
GO

SELECT matricula
	FROM Medico 
	WHERE 1 = (SELECT COUNT(*) FROM Medico m 
		WHERE m.apellido_medico > Medico.apellido_medico)

DECLARE @SegundoInstituto

SELECT @SegundoInstituto = (SELECT i.id
				FROM Registro r
				INNER JOIN Instituto i ON ( i.id = r.id_instituto)
				WHERE 2 = (SELECT COUNT(*) FROM Instituto
					   WHERE i.nombre_instituto < institutos.nombre_instituto)
				GROUP BY i.id
				ORDER BY i.id
			   )
 
declare @currentespecialidad integer, @idestudio integer, @idespecialidad integer,
	@porcentaje float 

DECLARE actualizar_precio CURSOR  
FOR
SELECT ie.id_estudio, ee.id_especialidad
	FROM Instituto_Estudio ie
	INNER JOIN Especialidad_Estudio ee ON (ee.id_estudio = ie.idestudio)
	ORDER BY ee.ide_especialidad
FOR UPDATE of ie.precio

OPEN Cursor_actualizarprecio
FETCH NEXT FROM Cursor_actualizarprecio INTO @idestudio, @idespecialidad

	 IF @@FETCH_STATUS <> 0 
   BEGIN
        PRINT space(20)+'Sin regristros de estudios'
   END
   ELSE
   BEGIN
	SET @porcentaje = 0.98
	SET @currentespecialidad = @idespecialidad
   END
	 WHILE @@FETCH_STATUS = 0
	   BEGIN
		IF (@currentespecialidad = @idespecialidad)
		BEGIN		
			UPDATE Instituto_Estudio SET precio = precio + (precio * (1 - @porcentaje))
			WHERE CURRENT OF Cursor_actualizarprecio
		END
		ELSE
		BEGIN
			SET @porcentaje = @porcentaje - 0.02
			UPDATE Instituto_Estudio SET precio = precio + (precio * (1 - @porcentaje))
			WHERE CURRENT OF Cursor_actualizarprecio
		END
		FETCH NEXT FROM Cursor_actualizarprecio INTO @idestudio, @idespecialidad
	END

CLOSE Cursor_actualizarprecio 
DEALLOCATE Cursor_actualizarprecio
GO

/*
6.6. Definir un Cursor:
Que actualiceel campo precio de la tabla precios incrementando en un 2% los mismos para
cada estudio de distinta especialidad a las restantes.
Ej.: 1º especialidad un 2%, 2º especialidad un 4%, ...
*/

CREATE PROCEDURE Actualizar_precios (@estudio VARCHAR(55), @incremento FLOAT)
AS
BEGIN
	DECLARE @idEstudio AS INT
	DECLARE @idInstituto AS INT
	DECLARE @Precio AS FLOAT
	DECLARE @PrecioNuevo AS FLOAT
	DECLARE @mensaje AS VARCHAR(600)

	DECLARE Estudio_x_Instituto CURSOR
	FOR
	SELECT ie.id_estudio, ie.id_instituto, ie.precio
	FROM Estudio e
	INNER JOIN Instituto_Estudio ie ON ie.id_estudio = e.id
	WHERE e.nombre_estudio = @estudio

	OPEN Estudio_x_Instituto

	FETCH NEXT
	FROM Estudio_x_Instituto
	INTO @idEstudio, @idInstituto, @Precio

	IF @@FETCH_STATUS <> 0
	BEGIN
		PRINT space(20) + 'NO EXISTE COBERTURA PARA EL ESTUDIO'
	END
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @PrecioNuevo = @Precio + ((@Precio * @incremento) / 100)
		SET @mensaje = convert(VARCHAR(20), @idEstudio) + space(20 - DATALENGTH(convert(VARCHAR(20), @idEstudio))) + @idInstituto + space(20 - DATALENGTH(@idInstituto)) + ' $ Anterior  ' + convert(VARCHAR(20), @Precio) + space(20 - DATALENGTH(convert(VARCHAR(20), @Precio))) + ' $ nuevo  ' + convert(VARCHAR(20), @PrecioNuevo) + space(20 - DATALENGTH(convert(VARCHAR(20), @PrecioNuevo)))
		PRINT @mensaje
		FETCH NEXT
		FROM Estudio_x_Instituto
		INTO @idEstudio, @idInstituto, @Precio
	END
	CLOSE Estudio_x_Instituto
	DEALLOCATE Estudio_x_Instituto
END
GO
