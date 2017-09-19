/*

*/

-- 4.1
CREATE PROCEDURE pr_IngresarPrecio
	@nomEstudio varchar(50) not null,
	@nombreInstituto varchar(50) not null,
	@precio money not null,
AS
	DECLARE @id_estudio int, @id_instituto int 
	
	SELECT @id_estudio = e.id FROM Estudio e WHERE e.nombre_estudio = @nombEstudio
	if (@id_estudio isnull)
		begin
			SET @id_estudio isnull ((SELECT MAX(e.id) FROM Estudio), 0) + 1
			INSERT INTO Estudio (id, nombre_estudio,estado) VALUES @id_estudio, @nombEstudio
		end

	
	SELECT @id_estudio = e.id FROM Instituto i WHERE i.nombre_instituto = @nombEstudio
	if (@id_instituto isnull)
		begin
			SET @id_instituto isnull ((SELECT MAX(i.id) FROM Instituto ), 0) + 1
			INSERT INTO Estudio (id, nombre_estudio,estado) VALUES @id_estudio, @nombEstudio
		end



	if exists (SELECT 1 FROM Instituto_Estudio ie WHERE ie.id_estudio = @id_estudio AND ie.id_instituto = @id_instituto)
		begin
			UPDATE Instituto_Estudio SET precio = @precio
			WHERE id_estudio = @id_estudio AND id_instituto = @id_instituto
		end
	else
		begin
			INSERT INTO Instituto_Estudio (id_instituto, id_estudio, precio) 
			VALUES (@id_instituto, @id_estudio, @precio)
		end
	return
GO

