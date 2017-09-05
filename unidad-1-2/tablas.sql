/**
 *	tipos de datos
 **/

--Se crea el tipo de dato id
sp_addtype 'id', 'smallint' , 'not null'

-- Se crea el tipo de dato estado
sp_addtype 'estado', 'char (10)' , 'not null'

-- Se crea el tipo de dato sigla
sp_addtype 'sigla', 'varchar(8)', 'not null'

-- Se crea el tipo de dato dni
sp_addtype 'dni', 'varchar(8)', 'not null'


/**
 *	TABLAS
 **/
 
-- Especialidad
create table Especialidad 
( 
	id smallint not null primary key, 
	nombre_especialidad varchar(50) not null
)
GO

-- Estudio
create table Estudio 
( 
	id smallint not null primary key, 
	nombre_estudio varchar(50) not null
)
GO

-- Tabla generada por la relación Especialidad - Estudio 
create table Especialidad_Estudio 
( 
	id_estudio smallint not null, 
	id_especialidad smallint not null,
	constraint fk_estudio_id foreign key (id_estudio) references Estudio(id),
	constraint fk_especialidad_id foreign key (id_especialidad) references Especialidad(id),
	constraint pk_estudio_especialidad primary key NONCLUSTERED (id_estudio, id_especialidad)
)
GO

-- Medico
create table Medico 
( 
	matricula smallint not null primary key, 
	nombre_medico varchar(50) not null,
	apellido_medico varchar(50) not null,
	sexo char,
	estado estado,
	check (sexo in ('m','f'))
)
GO

-- Tabla generada por la relación Medico - Especialidad 
create table Medico_Especialidad
(
	id_medico smallint not null,
	id_especialidad smallint not null,
	constraint fk_medico_matricula foreign key (id_medico) references Medico(matricula),
	constraint fk_especialidad_id foreign key (id_especialidad) references Especialidad(id),
	constraint pk_medico_especialidad primary key NONCLUSTERED (id_medico, id_especialidad)
)
GO

-- Instituto
create table Instituto
(
	id smallint not null primary key,
	nombre_instituto varchar(50) not null,
	direccion varchar(50) not null,
	estado char, check (estado in ('si', 'no'))
)
GO

-- Tabla generada por la relación Instituto - Estudio
create table Instituto_Estudio
(
	id_instituto smallint not null,
	id_estudio smallint not null,
	precio decimal(10,2) not null,
	check (precio <= 5000),
	constraint fk_instituto_id foreign key (id_instituto) references Instituto(id),
	constraint fk_estudio_id foreign key (id_estudio) references Estudio(id),
	constraint pk_instituto_estudio primary key NONCLUSTERED (id_instituto, id_estudio)
)
GO

-- Paciente
create table Paciente 
(
	dni varchar(8) not null primary key,
	nombre varchar(50) not null,
	apellido varchar(50) not null,
	sexo char, 
	fecha_nacimiento date,
	check ((datediff(yyyy, fecha_nacimiento, GETDATE()) > 21) && (datediff(yyyy, fecha_nacimiento, GETDATE()) < 80)),
	check (sexo in ('m','f')),
	check (dni like '%[^0-9]%'),
)
GO

-- Obra Social
create table ObraSocial 
(
	id smallint not null primary key,
	nombre varchar(50) not null,
	categoria char,
	check (categoria in ('os', 'pp'))
)
GO

-- Plan
/* [IMPORTANTE] El numero del plan no tiene que ser menor o igual a 12? */
create table Plan 
(
	id smallint not null primary key,
	id_obra_social smallint not null,
	estado char, check (estado in ('si', 'no')),
	constraint fk_obrasocial_id foreign key (id_obra_social) references ObraSocial(id)
)
GO

-- Tabla generada por la relación Paciente - Plan
create table Paciente_Plan 
(
	dni_paciente varchar(8) not null,
	id_plan smallint not null,
	constraint fk_paciente_dni foreign key (dni_paciente) references Paciente(dni),
	constraint fk_plan_id foreign key (id_plan) references Plan(id),
	constraint pk_paciente_plan primary key NONCLUSTERED (dni_paciente, id_plan)
)
GO

-- Tabla generada por la relación Plan - Estudio
create table Plan_Estudio 
(
	id_plan smallint not null,
	id_estudio smallint not null,
	cobertura decimal(3,0) not null,
	constraint fk_plan_dni foreign key (id_plan) references Plan(id),
	constraint fk_estudio_id foreign key (id_estudio) references Estudio(id),
	constraint pk_plan_estudio primary key NONCLUSTERED (id_plan, id_estudio)
)
GO

-- Registro
create table Registro 
(
	id smallint not null primary key,
	id_estudio smallint not null,
	id_instituto smallint not null,
	matricula_medico smallint not null,
	dni_paciente varchar(8) not null,
	fecha_estudio date,
	check ((datediff(mm, fecha_estudio, GETDATE()) > 30) && datename(dd, 1, GETDATE())),
	constraint fk_estudio_id foreign key (id_estudio) references Estudio(id),
	constraint fk_instituto_id foreign key (id_instituto) references Instituto(id),
	constraint fk_medico_matricula foreign key (matricula_medico) references Medico(matricula),
)
GO
