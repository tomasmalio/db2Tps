/**
 *	DATOS
 **/
 -- Especialidad
INSERT INTO Especialidad (id, nombre_especialidad)
VALUES (1, 'Alergología'),
(2, 'Anestesiología y reanimación'),
(3, 'Cardiología'),
(4, 'Gastroenterología'),
(5, 'Endocrinología'),
(6, 'Geriatría'),
(7, 'Hematología y hemoterapia'),
(8, 'Infectología'),
(9, 'Medicina aeroespacial'),
(10, 'Medicina del deporte'),
(11, 'Medicina del trabajo'),
(12, 'Medicina de urgencias'),
(13, 'Medicina familiar y comunitaria'),
(14, 'Medicina física y rehabilitación'),
(15, 'Medicina intensiva'),
(16, 'Medicina interna'),
(17, 'Medicina legal y forense'),
(18, 'Medicina preventiva y salud pública'),
(19, 'Nefrología'),
(20, 'Neumología'),
(21, 'Neurología'),
(22, 'Nutriología'),
(23, 'Oftalmología'),
(24, 'Oncología médica'),
(25, 'Oncología radioterápica'),
(26, 'Pediatría'),
(27, 'Psiquiatría'),
(28, 'Rehabilitación'),
(29, 'Reumatología'),
(30, 'Toxicología'),
(31, 'Urología');

-- Estudio
INSERT INTO Estudio (id, nombre_estudio)
VALUES (1, 'Resonancia magnética'), (2, 'Ecograma'), (3, 'Colonoscopia'), (4, 'Tomografía');
	
-- Especialidad_Estudio
INSERT INTO Especialidad_Estudio (id_estudio, id_especialidad)
VALUES (1, 21), (2, 3), (3, 4), (4, 21);

--Medicos
INSERT INTO Medicos (matricula, nombre_medico, apellido_medico, sexo)
VALUES (310, 'Ricardo', 'Alberti','m'),
(311, 'Juan', 'Sosa','m'),
(312, 'Sol', 'Nuñez','f'),
(313, 'Patricia', 'Fernandez','f'),
(314, 'Cristian', 'Garcia','m'),
(315, 'Fernando', 'Martinez','m'),
(316, 'Maria', 'Lopez','f'),
(317, 'Amparo', 'Vinias','f'),
(318, 'Enrique', 'Somaruga','m'),
(319, 'Josefina', 'Cirone','f');
