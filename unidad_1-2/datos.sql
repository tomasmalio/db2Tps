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
INSERT INTO Estudio (id, nombre_estudio,estado)
VALUES (1, 'Resonancia magnética','activo'), (2, 'Ecograma','activo'), (3, 'Colonoscopia','activo'), (4, 'Tomografía','activo');
	
-- Especialidad_Estudio
INSERT INTO Especialidad_Estudio (id_estudio, id_especialidad)
VALUES (1, 21), (2, 3), (3, 4), (4, 21);

-- Medico
INSERT INTO Medico (matricula, nombre_medico, apellido_medico, sexo, estado)
VALUES (310, 'Ricardo', 'Alberti','m','activo'),
(311, 'Juan', 'Sosa','m','activo'),
(312, 'Sol', 'Nuñez','f','activo'),
(313, 'Patricia', 'Fernandez','f','activo'),
(314, 'Cristian', 'Garcia','m','activo'),
(315, 'Fernando', 'Martinez','m','activo'),
(316, 'Maria', 'Lopez','f','activo'),
(317, 'Amparo', 'Vinias','f','activo'),
(318, 'Enrique', 'Somaruga','m','activo'),
(319, 'Josefina', 'Cirone','f','activo');

-- Medico_Especialidad
INSERT INTO Medico_Especialidad (id_medico, id_especialidad)
VALUES (319, 27),
(317, 30),
(317, 28),
(319, 5),
(318, 31),
(312, 7),
(312, 11),
(314, 15),
(314, 9),
(311, 20);

-- Instituto
INSERT INTO Instituto (id, nombre_instituto, direccion, estados)
VALUES (500,'Hospital Britanico De Buenos Aires','Perdriel 74','s'),
(501,'Hostital Durand','Av Diaz Velez 5044','n'),
(502,'Hospital Pirovano','Monroe 3555','n'),
(503,'Sociedad Italiana De Beneficencia','Juramento 2741','s'),
(504,'Mejores Hospitales Sa','Gallo 1360','s'),
(505,'Medicina Uba Hospital De Clinicas Fac De','Paraguay 2250','n'),
(506,'Alicia M Sambuelli','Av Caseros 2061','s'),
(507,'Carlos G Campos','Comb D L Pozos 1881','s'),
(508,'Rosa M Bologna','Comb D L Pozos 1881','s'),
(509,'Centro De Investigaciones Endocrinologicas','Ambrosio Cramer 4601','s');

-- Instituto_Estudio
INSERT INTO Instituto_Estudio (id_instituto, id_estudio, precio)
VALUES (501,1,350),
(509,4,3650),
(505,2,455),
(502,3,789),
(503,1,800),
(507,4,1750),
(508,3,2550),
(504,2,4000);

-- Paciente
INSERT INTO Paciente (dni, nombre, apellido, sexo, fecha_nacimiento)
VALUES (38524798, 'Cesar','Rodriguez','m','1986-08-05'),
(38524797, 'Maria','Zara','f','1988-12-23'),
(38524796, 'Luis','Diaz','m','1977-04-12'),
(38524795, 'Micaela','Sanchez','f','1994-06-17'),
(38524794, 'Matias','Hernandez','m','1965-10-01');

-- Obra Social
INSERT INTO ObraSocial (id, nombre, categoria)
VALUES (1,'OSDE','pp'),
(2,'Sancor Salud','pp'),
(3,'Medicus','pp'),
(4,'Galeno','pp'),
(5,'Medife','pp'),
(6,'Swiss Medical','pp'),
(7,'OSECAC','os'),
(8,'Union Personal','os'),
(9,'IOMA','os'),
(10,'Luis Pasteur','os'),
(11,'OSDEPYM','os'),
(12,'OSMEDICA','os'),
(13,'Accord Salud','pp');

-- Plan
INSERT INTO Planes (id, id_obra_social, estado)
VALUES (1,'13','si'),
(12,'2','no'),
(10,'5','si'),
(3,'6','no'),
(7,'10','si'),
(5,'11','si'),
(4,'7','si'),
(9,'8','no'),
(2,'1','si');

-- Paciente plan
INSERT INTO Paciente_Plan (dni_paciente, id_plan)
VALUES (38524798, 1),
(38524797, 3),
(38524796, 12),
(38524795, 5),
(38524794, 2)

-- Plan Estudio
INSERT INTO Plan_Estudio (id_plan, id_estudio, cobertura)
VALUES (1, 1, 50),
(2, 1, 50),
(12, 2, 30),
(3, 4, 10),
(10, 3, 80)

-- Registro
INSERT INTO Registro (id, id_estudio, id_instituto, matricula_medico, dni_paciente, fecha_estudio)
VALUES (1, 1, 500, 310, 38524799, '2017-05-29'), 
(2, 1, 520, 319, 38524797, '2017-05-15'),
(3, 2, 530, 312, 38524798, '2017-06-18'),
(4, 4, 520, 315, 38524794, '2017-07-02')
