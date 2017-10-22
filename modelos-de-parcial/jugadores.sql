Create Table Clubes 
(	Id_Club smallint,
	Nombre char(30),
	Nrozona tinyint,
	Primary Key (Id_Club))
GO

Create table Jugadores
(	Tipodoc	Char(3),
	Nrodoc	Integer,
	Nombre	Char(30),
	Fecha_Nac	Datetime,
	Categoria         Tinyint,
	Id_Club     	smallint,
	Primary Key (Tipodoc, Nrodoc),
	Constraint  Pertenece_Al_Club Foreign Key (Id_Club) references Clubes(Id_Club))

GO
create table Partidos
(	Id_Partido      smallint not null,
        NroFecha	tinyint,
	NroZona	tinyint,
	Categoria	tinyint,
	Id_ClubL	smallint null,
	Id_ClubV	smallint null,
	GolesL		smallint null,
	GolesV		smallint null,
	FechaPartido 	datetime null,
	Constraint PK_Partido Primary Key (Id_Partido),
	Constraint Club_Local Foreign Key (Id_ClubL) references Clubes (id_Club),
	Constraint Club_Visitante Foreign Key (Id_ClubV) references Clubes (id_Club))
GO
Insert into Clubes Values (23,'BOCA-J. HERNANDEZ',1) 
GO
Insert into Clubes Values (19,'DEF. DE GLEW',1) 
GO
Insert into Clubes Values (13,'LOS ANDES',1) 
GO
Insert into Clubes Values (6,'SAN MARTIN',1) 
GO
Insert into Clubes Values (3,'FERRO C. OESTE',1) 
GO
Insert into Clubes Values (1,'E.F.I.L.Z.A',1) 
GO
Insert into Clubes Values (24,'ALMAFUERTE',2) 
GO
Insert into Clubes Values (17,'CIRC.S.LONGCHAMPS',2) 
GO
Insert into Clubes Values (16,'FATIMA',2) 
GO
Insert into Clubes Values (7,'ESCUELA DE FUTBOL PALERMO',2) 
GO
Insert into Clubes Values (5,'SAN LORENZO',2) 
GO
Insert Into Partidos Values (284,1,1,84,1,6,0,4,Null)
Go
Insert Into Partidos Values (286,1,1,85,1,6,2,1,Null)
Go
Insert Into Partidos Values (306,1,1,84,3,23,4,4,Null)
Go
Insert Into Partidos Values (308,1,1,85,3,23,3,0,Null)
Go
Insert Into Partidos Values (328,1,1,84,13,19,1,0,Null)
Go
Insert Into Partidos Values (330,1,1,85,13,19,5,2,Null)
Go
Insert Into Partidos Values (394,2,1,84,13,1,2,0,Null)
Go
Insert Into Partidos Values (396,2,1,85,13,1,1,3,Null)
Go
Insert Into Partidos Values (416,2,1,84,19,3,0,2,Null)
Go
Insert Into Partidos Values (418,2,1,85,19,3,3,2,Null)
Go
Insert Into Partidos Values (438,2,1,84,23,6,2,1,Null)
Go
Insert Into Partidos Values (440,2,1,85,23,6,3,3,Null)
Go
Insert Into Partidos Values (504,3,1,84,1,23,1,1,Null)
Go
Insert Into Partidos Values (506,3,1,85,1,23,1,1,Null)
Go
Insert Into Partidos Values (526,3,1,84,6,19,6,1,Null)
Go
Insert Into Partidos Values (528,3,1,85,6,19,5,0,Null)
Go
Insert Into Partidos Values (548,3,1,84,3,13,1,2,Null)
Go
Insert Into Partidos Values (550,3,1,85,3,13,0,1,Null)
Go
Insert Into Partidos Values (614,4,1,84,3,1,0,1,Null)
Go
Insert Into Partidos Values (616,4,1,85,3,1,1,4,Null)
Go
Insert Into Partidos Values (636,4,1,84,13,6,0,1,Null)
Go
Insert Into Partidos Values (638,4,1,85,13,6,3,3,Null)
Go
Insert Into Partidos Values (658,4,1,84,19,23,1,4,Null)
Go
Insert Into Partidos Values (660,4,1,85,19,23,0,1,Null)
Go
Insert Into Partidos Values (724,5,1,84,1,19,2,2,Null)
Go
Insert Into Partidos Values (726,5,1,85,1,19,3,0,Null)
Go
Insert Into Partidos Values (746,5,1,84,23,13,0,1,Null)
Go
Insert Into Partidos Values (748,5,1,85,23,13,0,1,Null)
Go
Insert Into Partidos Values (768,5,1,84,6,3,2,0,Null)
Go
Insert Into Partidos Values (770,5,1,85,6,3,5,5,Null)
Go
Insert Into Partidos Values (834,6,1,84,6,1,5,2,Null)
Go
Insert Into Partidos Values (836,6,1,85,6,1,4,2,Null)
Go
Insert Into Partidos Values (856,6,1,84,23,3,3,1,Null)
Go
Insert Into Partidos Values (858,6,1,85,23,3,1,1,Null)
Go
Insert Into Partidos Values (878,6,1,84,19,13,1,1,Null)
Go
Insert Into Partidos Values (880,6,1,85,19,13,0,1,Null)
Go
Insert Into Partidos Values (944,7,1,84,1,13,1,1,Null)
Go
Insert Into Partidos Values (946,7,1,85,1,13,4,2,Null)
Go
Insert Into Partidos Values (966,7,1,84,3,19,2,7,Null)
Go
Insert Into Partidos Values (968,7,1,85,3,19,5,0,Null)
Go
Insert Into Partidos Values (988,7,1,84,6,23,3,1,Null)
Go
Insert Into Partidos Values (990,7,1,85,6,23,5,3,Null)
Go
Insert Into Partidos Values (054,8,1,84,23,1,1,1,Null)
Go
Insert Into Partidos Values (056,8,1,85,23,1,1,0,Null)
Go
Insert Into Partidos Values (076,8,1,84,19,6,2,4,Null)
Go
Insert Into Partidos Values (078,8,1,85,19,6,1,5,Null)
Go
Insert Into Partidos Values (098,8,1,84,13,3,3,1,Null)
Go
Insert Into Partidos Values (100,8,1,85,13,3,4,0,Null)
Go
Insert Into Partidos Values (164,9,1,84,1,3,0,0,Null)
Go
Insert Into Partidos Values (166,9,1,85,1,3,0,0,Null)
Go
Insert Into Partidos Values (186,9,1,84,6,13,0,0,Null)
Go
Insert Into Partidos Values (188,9,1,85,6,13,0,0,Null)
Go
Insert Into Partidos Values (208,9,1,84,23,19,0,0,Null)
Go
Insert Into Partidos Values (210,9,1,85,23,19,0,0,Null)
Go
Insert Into Partidos Values (384,1,2,84,16,7,0,3,Null)
Go
Insert Into Partidos Values (386,1,2,85,16,7,1,4,Null)
Go
Insert Into Partidos Values (406,1,2,84,24,17,0,3,Null)
Go
Insert Into Partidos Values (408,1,2,85,24,17,2,4,Null)
Go
Insert Into Partidos Values (494,2,2,84,5,16,6,0,Null)
Go
Insert Into Partidos Values (496,2,2,85,5,16,1,1,Null)
Go
Insert Into Partidos Values (516,2,2,84,17,7,4,2,Null)
Go
Insert Into Partidos Values (518,2,2,85,17,7,4,0,Null)
Go
Insert Into Partidos Values (604,3,2,84,16,17,1,13,Null)
Go
Insert Into Partidos Values (606,3,2,85,16,17,3,2,Null)
Go
Insert Into Partidos Values (626,3,2,84,24,5,1,0,Null)
Go
Insert Into Partidos Values (628,3,2,85,24,5,1,11,Null)
Go
Insert Into Partidos Values (714,4,2,84,24,16,3,1,Null)
Go
Insert Into Partidos Values (716,4,2,85,24,16,2,2,Null)
Go
Insert Into Partidos Values (736,4,2,84,5,7,2,2,Null)
Go
Insert Into Partidos Values (738,4,2,85,5,7,4,1,Null)
Go
Insert Into Partidos Values (824,5,2,84,17,5,3,0,Null)
Go
Insert Into Partidos Values (826,5,2,85,17,5,2,3,Null)
Go
Insert Into Partidos Values (846,5,2,84,7,24,4,2,Null)
Go
Insert Into Partidos Values (848,5,2,85,7,24,5,1,Null)
Go
Insert Into Partidos Values (934,6,2,84,7,16,4,1,Null)
Go
Insert Into Partidos Values (936,6,2,85,7,16,2,0,Null)
Go
Insert Into Partidos Values (956,6,2,84,17,24,6,0,Null)
Go
Insert Into Partidos Values (958,6,2,85,17,24,6,0,Null)
Go
Insert Into Partidos Values (044,7,2,84,16,5,1,7,Null)
Go
Insert Into Partidos Values (046,7,2,85,16,5,2,4,Null)
Go
Insert Into Partidos Values (066,7,2,84,7,17,7,1,Null)
Go
Insert Into Partidos Values (154,8,2,84,17,16,0,1,Null)
Go
Insert Into Partidos Values (156,8,2,85,17,16,0,1,Null)
Go
Insert Into Partidos Values (176,8,2,84,5,24,4,1,Null)
Go
Insert Into Partidos Values (264,9,2,84,16,24,0,0,Null)
Go
Insert Into Partidos Values (266,9,2,85,16,24,0,0,Null)
Go
Insert Into Partidos Values (999,9,2,84,7,5,0,0,Null)
Go
Insert Into Partidos Values (288,9,2,85,7,5,0,0,Null)
Go
set dateformat dmy
Go
Insert Into Jugadores Values ( 'DNI',31531124,'CHAPARRO, CRISTIAN','7/12/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30885642,'HERRERA, DANIEL','12/3/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31297900,'MORETTI, PABLO','29/12/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30800519,'ROMERO, MAURICIO','1/5/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30816148,'BARRIL, PABLO','14/3/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30819573,'BAIGORRIA, SERGIO','2/2/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30888538,'DIAZ, JESUS','13/3/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31239205,'CANALES, JUAN','19/8/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30667193,'OLIVERA, JOSE','2/1/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30616697,'ESPINOZA, JAVIER','9/3/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30952992,'RODRIGUEZ, ALFREDO','11/10/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31079744,'CASTRO, MARIO','14/6/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31797902,'TORRES, GABRIEL','20/10/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31899211,'NOVIELLI, MIGUEL','6/11/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31740027,'CARUSO, MAURICIO','2/7/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31617728,'PICCHI, ARIEL','11/6/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31687570,'CALIVA, JORGE','1/6/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31953929,'GENOVESE, LUCAS','14/11/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31827019,'MARTINEZ, WALTER','9/8/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31763069,'GATTO, CRISTIAN','1/8/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31684432,'RODRIGUEZ, JUAN','15/6/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31444272,'SALINAS, MATIAS','23/1/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31362192,'NAVARRO, FEDERICO','16/1/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31443543,'ALBORNOZ, RUBEN','12/4/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31282335,'DI BELLO, MATIAS','5/2/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31899301,'CARUSO, ARIEL','12/11/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',32427681,'ROMERO, LUIS MIGUEL','17/10/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31068100,'ACOSTA, CESAR','29/7/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31044653,'PERINI, CRISTIAN','27/8/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30915703,'BLANCO, ALEJANDRO','16/4/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30877449,'AGUIRRE, MIGUEL','11/4/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30734108,'PETRINO, RICARDO','13/2/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30894100,'SOTO, DANIEL','28/3/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30733857,'ABAD, JUAN','8/1/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31048088,'DA CRUZ, JUAN','30/7/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31031997,'DEMARCO, JORGE','6/7/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31679610,'ABAD, JORGE','28/7/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31823856,'ARIAS, ALFREDO','22/11/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',32321771,'CASTELLANO, LEONARDO','7/12/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31679346,'CORREA, SERGIO','7/6/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31485323,'CISTERNA, MAURO','10/5/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31687543,'MIGUEL, PABLO','3/6/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31828884,'CAAMAÑO, LEANDRO','23/8/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31794737,'AGUILAR, CARLOS','12/12/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',32033307,'CANTERO, DAVID','24/12/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',30877950,'PASSARDI, LEANDRO','4/6/84',84,6) 
Go
Insert Into Jugadores Values ( 'PPE',496513,'DE LA CRUZ, JOSE','31/3/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30877686,'CANDIA, MARIO','19/4/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31369974,'FLORES, GASTON','28/12/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30877687,'CANDIA, LUIS','19/4/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30877157,'ZIGGIOTTO, JUAN','5/1/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30778776,'GARCIA, JAVIER','30/1/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31154386,'ARANDA, LEANDRO','14/7/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30940246,'BARRERA, FERNANDO','19/8/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31369811,'ACOSTA, SANDRO','3/11/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30669045,'ACOSTA, RODRIGO','31/1/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30956418,'MALDONADO, CRISTIAN','7/4/84',84,6) 
Go
Insert Into Jugadores Values ( 'CI',13230978,'BANEGAS, MAURICIO','30/9/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31253658,'BRACCI, JUAN','18/11/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31532332,'GAUTO, ALAN','21/4/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31914268,'ARIAS, EDUARDO','11/10/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31559243,'GALEANO, JULIO','9/1/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31462466,'SPINELLI, MAURO','4/3/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31954002,'PIRALLI, LUIS','6/12/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31048852,'DA SILVEIRA, RICARDO','5/2/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31780661,'CORDOBA, RUBEN','8/7/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31101353,'SGANGONE, HERNAN','13/2/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31532491,'VIDAL, LUCIANO','7/5/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31659338,'GIACHERO, NICOLAS','19/5/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',30940992,'GARCIA, NICOLAS','13/1/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',30647320,'GIORDANO, LUCAS','17/1/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31101152,'BURGOS, JUAN','30/1/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31251270,'COTS, JUAN','26/9/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31679461,'MOLINARO, ALEJANDRO','21/6/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31484542,'VARELA, ULISES','9/4/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31262291,'GEREZ, NICOLAS','11/11/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',30980277,'MUÑOZ, ARTURO','19/5/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',30780521,'BEGUET, ADRIAN','3/2/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31177539,'IMASAKA, RUBEN','25/9/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',30868883,'GARCIA, MATIAS','8/1/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31283679,'SUELDO, NESTOR','9/11/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31189490,'BARRIOS, DIEGO','28/1/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31731313,'CANO, IVAN','25/5/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31650048,'FARFAN, FEDERICO','17/8/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31978771,'FLEITAS, MANUEL','26/9/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31293173,'GIGLIO, PABLO','14/1/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31470110,'LOPEZ, WALTER','11/3/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31374667,'MAGUNA, NESTOR','11/1/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31325403,'SANTILLAN, MARIO','30/1/85',85,3) 
Go
Insert Into Jugadores Values ( 'PB',6710,'SOSA, NICOLAS','11/3/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31764083,'VAÑOS, LEANDRO','28/8/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31293846,'VENERE, LUCAS','15/1/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31916459,'GONZALEZ, CRISTIAN','17/10/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31076883,'BOLZAN, ARIEL','6/6/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',30866787,'GUTIERREZ, FACUNDO','24/1/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31156237,'MOGARTE, MARIANO','4/9/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31727824,'PEREYRA, JULIAN','29/7/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',30978557,'TOMMASI, JAVIER','7/4/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31089925,'IRALA, DIEGO','20/7/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31303098,'MARTINO, ARIEL','24/11/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31206293,'ANTOLINI, FERNANDO','2/9/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30963512,'SIMAL, MAXIMILIANO','8/9/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30868066,'SANDOVAL, LEANDRO','26/2/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30825207,'AYALA, MARCELO','5/3/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30887560,'VALVERDE, MARTIN','19/3/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30999823,'SANTILLAN, GUILLERMO','12/6/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31119776,'MENDEZ, CRISTIAN','20/9/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30944056,'BANEGAS, HECTOR','18/4/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31262084,'NUÑEZ, FEDERICO','3/11/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31046783,'TOLOZA, GABRIEL','2/8/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30825333,'MEDINA, CRISTIAN','9/3/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30887782,'CARDOZO, ESTEBAN','15/4/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31175339,'ALARCON, GUIDO','3/9/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30934025,'CHUECO, JULIAN','5/4/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30999814,'ACUÑA, CHRISTIAN','12/6/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30924892,'PIPERNO, FRANCO','23/3/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31051570,'PEREZ, CARLOS','22/7/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31415472,'CEJAS, JOSE','18/12/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30724661,'FILHO, MARCELO','6/1/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30874405,'ZALAZAR, ADRIAN','15/8/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',30978891,'CASTAGNINO, MARTIN','12/5/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31146862,'RODAS, ALEJANDRO ','1/12/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31085023,'SANCHEZ, FABIO','16/11/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31422494,'ALVES, CARLOS','24/12/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',34434565,'SANTILLAN, RODOLFO','13/3/84',84,5) 
Go
Insert Into Jugadores Values ( 'CPA',3992034,'GARCETE, FELIPE','12/8/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31148637,'PEREIRA, GUSTAVO','4/2/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31444783,'ZANA, LUCAS','17/2/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31702872,'ZAPPIA, ADRIAN','20/7/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31722822,'YANTORNO, EMMANUEL','26/7/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31835104,'FERNANDEZ, PABLO','12/9/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31445952,'FILIPPO, PABLO','3/3/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31937829,'AYALA, JULIO','17/11/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31525606,'MARTINEZ, WILSON','15/3/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',32017931,'VADELL, EVER','17/11/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31443726,'ACEDO, MATIAS','31/7/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',32023517,'FERNANDEZ, GUSTAVO','26/12/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31732852,'ACOSTA, MARTIN','10/8/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31655879,'BLASI, CHRISTIAN','9/8/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31651101,'LAITAN, HECTOR','10/6/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31362542,'AYALA, JUAN','13/1/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31293422,'LAROCA, MARIANO','8/2/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31438889,'BONELLI, GABRIEL','21/1/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31684629,'ROTONDO, DAMIAN','17/6/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31694134,'ZARATE, MAURO','31/8/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31554353,'VALLEJO, GASTON','28/5/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31448330,'ELBERLING,  RAFAEL','7/3/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31835006,'LUQUE, JAVIER','22/8/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31523780,'CORO, JUAN','12/3/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31507283,'ACOSTA, GERARDO','14/3/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31470086,'OJEDA, MATIAS','27/2/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31594205,'VILLAN, EZEQUIEL','8/5/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31984119,'BENITEZ, DIEGO','20/11/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31447637,'PASCUAL, HERNAN','21/1/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',30915309,'LEMOS, RICARDO','13/6/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',31067691,'GALVAN, ENRIQUE','19/6/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31239857,'GONZALEZ, PABLO','2/12/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31435473,'OJEDA, LUIS','16/12/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31051154,'RASO, MARCELO','20/8/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',31829754,'BECERRA, GERMAN','19/9/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',30940697,'MILANO, OSCAR ','30/11/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30905984,'TORRES, NELSON','15/7/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30852718,'ALMUA, DIEGO','7/5/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31175591,'MOLINA, CLAUDIO','9/8/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',31761910,'GALAN, SEBASTIAN','29/5/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31658901,'SEGADE, CARLOS','13/4/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',32896032,'VICTORIA, CRISTIAN','9/11/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',30979256,'FRANZESE, SEBASTIAN','4/5/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',30885376,'COPES, HERNAN','25/2/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',30895528,'SABATE, FEDERICO','1/1/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',31070675,'MARINO, FERNANDO','23/7/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',31290326,'RUIZ DIAZ, HEBER','17/11/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',31075563,'PALMIERI, FERNANDO','10/9/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',30444780,'CHAPARRO, NESTOR','1/3/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',30963413,'RODRIGUEZ, ESTEBAN','24/8/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',31059330,'AUGIMERI, SEBASTIAN','21/6/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',31688313,'GOMEZ, JESUS','1/7/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31963810,'DIAMANTI, SEBASTIAN','16/12/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31684859,'GONZALEZ, ALBERTO','5/6/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31522488,'VARDARO, GUSTAVO','3/3/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31469780,'ALVES, LEANDRO','14/2/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31925317,'ANDRADE, JUAN','20/9/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31641882,'DURANTI, SERGIO','4/5/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31655331,'BERNAVIDE, ENRIQUE','23/6/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31732592,'MORO, NICOLAS','13/6/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',32011816,'PEREYRA, MATIAS','23/12/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31410200,'CORDEIRO, NICOLAS','16/4/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31252865,'REYNOSO, JONATHAN','24/10/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30830380,'MOSQUERA, PABLO','16/3/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31091370,'MAIDANA, JUAN','10/7/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30925587,'FRANCO, HORACIO','19/4/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30895059,'CANCINO, FABIAN','28/3/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30896121,'FARIAS, CARLOS','6/4/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31446959,'LUNA, JOSE','2/12/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31014591,'CORBALAN, PABLO','8/6/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30934542,'PINTOS, GONZALO','11/4/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31175753,'MENDIETA, FACUNDO','9/10/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',92858411,'OJEDA, VICTOR','12/3/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30945083,'MONTILLO, WALTER','14/4/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31190710,'ACOSTA, RODRIGO','8/10/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31064763,'ESCOBAR, DAVID','27/4/84',84,13) 
Go
Insert Into Jugadores Values ( 'CPA',3449614,'BRITEZ, BLAS','28/2/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30934496,'FERNANDEZ, DIEGO','18/6/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30991525,'RUIZ, DANIEL','15/8/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31065192,'GOMEZ, EDUARDO','5/8/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31224796,'ALMIRON, SEBASTIAN','15/1/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31504264,'LIGORE, PABLO','16/2/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31447163,'VILLALBA, DIEGO','20/4/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31740292,'ZANGARI, JUAN','30/8/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31525744,'SANTAGATI, FERNANDO','29/3/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31452868,'GONZALEZ, RICARDO','25/3/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31493697,'AQUINO, CRISTIAN','9/3/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31470203,'MONTENEGRO, CRISTIAN','19/4/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31740204,'DEBUT, EZEQUIEL','13/8/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31726628,'PEREYRA, LUCAS','30/7/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31899344,'OSORIO, JUAN','23/11/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',32060217,'RAMIREZ, ESTEBAN','3/12/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31611099,'RODRIGUEZ, MARTIN','4/5/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',30722035,'MONGES, EMILIANO','2/3/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30314545,'ATILIO, JORGE','6/5/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',93017064,'HURACHI, RONALD','13/6/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',93277649,'GARCETE, BERNANRDO','21/3/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31203748,'MADONA, PABLO','31/8/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',92996584,'PENAYO, HECTOR','24/7/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31203944,'CORNEJO, WALTER','2/1/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31980128,'MELNIK, NELSON','29/9/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31089613,'BACCA, DANIEL','7/7/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30834125,'LOPEZ, SEBASTIAN','28/1/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30825023,'DUFOUR, LUCAS','10/2/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30933374,'CUZZUPI, JOSE ','24/4/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30722275,'STACUL, RICARDO','26/4/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31064776,'ESCUDERO, LUCAS','27/6/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31172132,'PARED, FRANCISCO','6/12/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31422665,'ZARZA, JONATHAN','31/12/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31160665,'MAZZA, FRANCISCO','1/8/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',32323512,'LAURO, JUAN','16/10/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31447688,'APCARIAN, NICOLAS','17/1/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31445193,'VENA, JORGE','6/2/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31522903,'BARON, ANDRES','21/5/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31873098,'MENDOZA, ELIAN','14/10/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31826577,'PIÑEYRO, DANIEL','21/10/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31791449,'ZABALA, LUIS','4/8/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',30993765,'IACOVELLI, JOSE','24/7/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31443297,'MERCADO, MARCELO','6/3/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31723944,'AYALA, DANIEL','13/7/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31693297,'ZARATE, FABIAN','17/9/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31931085,'CARLOS, GONZALO','14/11/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31655310,'DI MARZO, GERMAN','19/6/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31508748,'OJEDA, LUIS','17/6/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31522118,'TOLOZA, GONZALO','1/3/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31497645,'PACHECO, DANIEL','1/5/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31926641,'MENDEZ, MAURICIO','15/10/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31265334,'COVATTI, JAVIER','27/12/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31752065,'REYES, ESTEBAN','17/8/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31540143,'MORENO, DANIEL','5/1/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31528233,'MENDIOLA, ALEJANDRO','2/4/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31177285,'SANTILLAN, SERGIO','7/1/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',32022251,'AUSCARRIAGA, NICOLAS','16/4/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',30940688,'BENCE, MATIAS','21/11/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30667543,'ROMERO, RUBEN','3/1/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',30819675,'GAZYCH, GERMAN','22/2/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31531402,'MOLINA, MARIANO','28/4/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',30893446,'PEREZ, RICARDO','20/7/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30882921,'ALONSO, SEBASTIAN','26/7/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30853507,'ARIAS, MARIANO','22/4/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30888690,'PEGORARO, PABLO','13/3/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31504301,'MOLINA, EZEQUIEL','3/3/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',30956410,'ACEVEDO, PABLO','23/3/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31333140,'VILLAGRA, ORLANDO','27/10/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',30746040,'AYALA, PABLO','25/1/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31164685,'VILLANUEVA, EMANUEL','30/8/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',33982267,'OTERO, FEDERICO','12/2/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31423497,'VITO, FERNANDO','28/12/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31160841,'MERCADO, CLAUDIO','20/8/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',30877163,'MASTROMATTEO, PABLO','2/3/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31369860,'FELIU, LUIS','17/11/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',30667668,'VILLAFAÑE, ENRIQUE','24/1/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31049660,'ORTIZ, GONZALO','24/8/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31049673,'GONZALEZ, ARIEL','5/9/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31434433,'LOPEZ, HUMBERTO','7/2/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',30706611,'REY, JUAN','21/8/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',31780732,'TORRES, PABLO','3/8/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',32334715,'GRELA, JUAN','11/5/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',31266433,'CANIZA, ARIEL','4/1/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',31679668,'REGHENZANI, DIEGO','5/5/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',32121419,'TOLEDO, CRISTIAN','22/12/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',92873990,'FLORES, GUSTAVO','22/2/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',34095284,'DIAZ, LUCAS','2/9/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31822079,'BAZZINI, DAMIAN','28/8/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',38670209,'CEBALLE, RUBEN','4/4/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31013841,'TORRES,CRISTIAN','10/11/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31068106,'OJEDA, SEBASTIAN','7/7/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',92850459,'SALINAS, GUSTAVO','25/5/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31165272,'PIEDRAS, DARIO','12/8/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31060370,'ORLANDO, CLAUDIO','22/5/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30939638,'DIMURO, SERGIO','5/4/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',92956906,'ROJAS, LUIS','5/9/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30677633,'SALERNO, LEANDRO','9/1/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30829463,'NUÑEZ, CHRISTIAN','24/2/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30852097,'OCAMPO, BRUNO','21/3/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31010669,'FLORES, DIEGO','4/6/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31154203,'RUIZ, DANIEL','15/7/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31601682,'NUÑEZ, JUAN','17/3/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31926589,'LAPADULA, MIGUEL','22/10/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31541351,'VALENTE, ADRIAN','3/1/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31964136,'GONZALES, MAXIMILIANO','12/11/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31661298,'CANIO, JUAN','10/6/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31878322,'MARTINO, CRISTIAN','18/10/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31507901,'LOPEZ, DIEGO','27/2/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31507343,'ASTURI, AXEL','5/3/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31824844,'CALISTA, JOSE','17/9/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31036765,'FIGUEROA, SEBASTIAN','27/1/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31079668,'ALBORNOZ, MAXIMILIANO','28/6/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31206885,'MARECO, NESTOR','31/3/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30734279,'FARIAS, ALEJANDRO','10/4/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30734053,'RAMIREZ, DARIO','16/2/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30877045,'FIORAVANTI, EDUARDO','15/2/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30600888,'CANONICO, RODOLFO','1/1/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30610075,'OLIVER, CARLOS','29/1/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31074890,'ARANCIBIA, GUILLERMO','2/10/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31059799,'TOLOZA, CRISTIAN','29/5/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31673879,'GRAZIANO, RODRIGO','18/6/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31832667,'CAVIEDES, LEANDRO','4/11/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31494082,'RUIZ DIAZ, ALBERTO','12/3/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31362419,'AGUADA, PABLO','29/2/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',30669003,'DIAZ, MARCELO','27/1/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31463055,'EISELE, CRISTIAN','15/3/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31532215,'ROMANO, CARLOS','19/4/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31563375,'LARRAGUETA, JONATAN','31/7/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31780625,'AQUINO, ADOLFO','3/6/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31462559,'AGUIRRE, ALEJANDRO','15/3/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',30868857,'MENGOCHEA, OSCAR','21/6/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31244038,'ZARATE, VICTOR','26/9/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31253023,'SANCHEZ, LEANDRO','25/10/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',30724804,'CRUZ, PABLO','13/1/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',30944156,'PURCHEL, MARTIN','10/5/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',92920447,'GARCETE, EDGAR','10/4/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',30732736,'MEDINA, CRISTIAN','23/4/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31983595,'RODA, ARIEL','12/1/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',30940938,'PEREZ, EZEQUIEL','29/12/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',30912099,'PETAGNA, GABRIEL','28/3/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',32937172,'BAGNATO, JOSE','18/9/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',29988738,'MARTINEZ, JUAN','7/4/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',30744673,'RIGGIO, JOSE','12/1/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',31727145,'MANFREDI, FABIAN','10/8/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31077218,'DE LIMA, HECTOR','11/2/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31583762,'CARDONA, CLAUDIO','2/5/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31592238,'KAMIZATO, SILVANO','6/5/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31465499,'TORRES, JOAN','23/6/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',31750166,'MARASCO, CRISTIAN','10/7/85',85,16) 
Go
Insert Into Jugadores Values ( 'DNI',30745281,'OLAS, JORGE GUSTAVO','21/1/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31878252,'MELGAR, CARLOS','11/10/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31750377,'POLANCO, FEDERICO','18/9/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',32063815,'FERREIRA, ARIEL','10/12/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',30825297,'SOLER, SEBASTIAN','13/3/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',30915728,'FERNANDEZ, ANGEL','21/4/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',30868895,'BALBASTRO, LUIS','11/6/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31344494,'MARCIAL, ALBERTO','20/12/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',30733306,'CARDOZO, MIGUEL','9/2/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31068337,'ACOSTA, JOSE','3/9/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31166536,'DALIO, GUILLERMO','23/7/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31289788,'GONZALEZ, JUAN','14/11/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',30897326,'CHAVEZ, MARTIN','12/5/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',30609972,'MENDEZ, MATIAS','9/1/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31144455,'NETO, RICARDO','20/9/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31058401,'ZAMORA, CRISTIAN','28/6/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',30816380,'ROBAINA, CRISTIAN','16/2/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31046277,'FERNANDEZ, GABRIEL','10/8/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31306950,'FERREIRA, GUSTAVO','13/11/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31560740,'JUAREZ, WALTER','24/2/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31930956,'CANTERO, RICARDO','4/10/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31655289,'GUZMAN, GONZALO','22/6/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31790853,'DUEÑAS, MIGUEL','8/7/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31986107,'CHAVEZ, JAVIER','23/11/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31877837,'RUIZ, JUAN','11/9/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31679937,'CAMPOS, MANUEL','25/7/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31935192,'SMOLJANOVICH, JUAN','26/10/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31824833,'GUZMAN, ARIEL','28/9/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31650975,'SANTILLAN, FEDERICO','11/7/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31504270,'SOTELO, EDUARDO','28/2/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31695234,'ROSALES, MARIANO','6/7/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31991476,'ALCARAZ, LEANDRO','21/10/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',30882938,'ORTEGA, DANIEL','14/8/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30734206,'GOMEZ, GASTON','11/3/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',31089850,'CARDOZO, CRISTIAN','29/7/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',31163453,'URQUIZA, JOSE','16/8/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30693556,'ZALAZAR, GABRIEL','3/2/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30734099,'MAGUNA, CRISTIAN','17/1/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',31333789,'ROMERO, JULIO','9/4/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30834066,'MACANGONE, LEANDRO','26/12/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30829123,'OSSO, GUSTAVO','11/1/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30877610,'RAMOS, PABLO','24/4/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',31171864,'CHAVEZ, LUIS','29/12/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',31352392,'SILVA, SILVIO','29/7/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30669025,'LOPEZ, ANDRES','14/2/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',30893026,'GANDOLFO, JUAN','1/2/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',31497835,'GUTIERREZ, JUAN','11/12/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',31790980,'PAZ, MARIO','4/8/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31827226,'ACOSTA, MATIAS','20/9/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31794740,'SAUCEDO, SERGIO','20/11/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31654849,'MARTINEZ, LUIS','30/6/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31563320,'ORTIZ, MARIO','9/6/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31717335,'VITALE, ALEJANDRO','11/7/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',30108780,'FLORES, SERGIO','5/2/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31934579,'AGUIRRE, ANGEL','20/11/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31563274,'LUNA, MIGUEL','10/5/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31791255,'RODRIGUEZ, LUIS','11/8/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',34490949,'CACERES, CRISTIAN','23/4/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',32264074,'GONZALEZ, ALEJANDRO','29/8/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',30895270,'GARCIA, ESTEBAN','20/4/84',84,6) 
Go
Insert Into Jugadores Values ( 'DNI',31032143,'FERNANDEZ, SEBASTIAN','12/7/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31899200,'PINCINI, MATIAS','5/11/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31895478,'OCAMPO, SEBASTIAN','20/10/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31781643,'PIZARRO, DANIEL','17/9/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31797782,'RODRIGUEZ, DAMIAN','29/9/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31781455,'BARRIONUEVO, PABLO','22/8/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31423007,'VELAZQUEZ, MATIAS','24/12/84',84,5) 
Go
Insert Into Jugadores Values ( 'DNI',32151683,'ABRUSCIA, NESTOR','23/12/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31422653,'CAMINO, MARCELO','6/12/84',84,16) 
Go
Insert Into Jugadores Values ( 'DNI',32091252,'SCHUSTER, JONATHAN','19/12/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31555426,'LOPEZ, GUSTAVO','1/11/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',30912544,'LLERA, MAXIMILIANO','26/4/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31177633,'SANTOS, JOSE','2/11/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30814171,'ROBLES, MATIAS','2/2/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31026604,'SANCHEZ, CRISTIAN','15/5/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31190620,'CASCO, ANGEL','30/7/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31237306,'ACOSTA, JUAN','11/11/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31190723,'ECHUDE, LUIS','8/10/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31424219,'GARAY, NORBERTO','25/2/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31617676,'BELUZZO, MARCELO','28/5/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31661807,'PALACIOS, RAUL','10/7/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31791104,'OJEDA, OSCAR','19/8/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31494656,'SOTELO, ALBERTO','13/4/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31654748,'DIAZ, JOSE','5/6/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31636023,'MEMBRIN, CRISTIAN','20/1/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31446652,'ROMERO, DAVID','10/3/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31332412,'SAN MARTIN, SEBASTIAN','27/1/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',31694062,'RAMIREZ, HUMBERTO','24/9/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',30724625,'AGUIRRE, JAVIER','2/1/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',30708216,'SPOTORNO, ROBERTO','2/3/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31032398,'MARTIN, JOSE','20/7/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30830509,'HERNANDEZ, MATIAS','24/3/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30877960,'ROA, DIEGO','21/6/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31265405,'PEREZ, PABLO','10/1/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31434487,'ARCE, DARIO','4/2/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',32121665,'GUTIERREZ, ELIAS','13/12/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',31107356,'GAUTO, SERGIO','15/8/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31153947,'MANCUELLO, GABRIEL','23/8/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31880199,'IBARRA, RAFAEL','6/6/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',30945474,'CASTEL, JULIAN','15/12/84',84,19) 
Go
Insert Into Jugadores Values ( 'DNI',31605423,'BOGADO, BRUNO','14/8/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',30161468,'GONZALEZ, EMMANUEL','5/11/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31563360,'LENTINI, GERMAN','13/7/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',32962619,'MELLETI, CLAUDIO','7/10/85',85,19) 
Go
Insert Into Jugadores Values ( 'DNI',31070616,'GONZALEZ, LEONARDO','10/7/84',84,3) 
Go
Insert Into Jugadores Values ( 'DNI',31681421,'MOREIRA, CRISTIAN','17/8/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31772732,'BENITEZ, GABRIEL','17/5/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31617553,'ROLANDO, DARIO','3/5/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31349798,'VIZGARRA, MATIAS','17/2/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31424955,'CHAILE, HORACIO','18/1/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',31352315,'GODOY, MAXIMILIANO','27/1/85',85,24) 
Go
Insert Into Jugadores Values ( 'DNI',30306216,'RIVAS, NICOLAS','18/3/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31333768,'VILLALBA, RAMON','8/12/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31343296,'SOSA, RICARDO','2/12/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30911689,'ALMADA, RUBEN','11/4/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',30797973,'TORRES, CARLOS','19/10/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31059876,'MARTINEZ, FRANCISCO','5/5/84',84,17) 
Go
Insert Into Jugadores Values ( 'DNI',31532192,'DI BELLA, LEONARDO','6/3/85',85,17) 
Go
Insert Into Jugadores Values ( 'DNI',30852285,'VEGA, WALTER','2/5/84',84,7) 
Go
Insert Into Jugadores Values ( 'DNI',31460929,'SILVA, RICARDO','3/2/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31465130,'ACUÑA, CARLOS','30/1/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',31926684,'GONZALEZ, MAXIMILIANO','27/10/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',30012288,'RODRIGUEZ, RAMIRO','23/4/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31740346,'MEDINA, ESTEBAN','10/8/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',31876635,'CARDOZO, ANTONIO','26/9/85',85,1) 
Go
Insert Into Jugadores Values ( 'DNI',30702760,'BLANCO, PABLO','31/1/84',84,1) 
Go
Insert Into Jugadores Values ( 'DNI',31462365,'TORRES, LUCAS','21/1/85',85,6) 
Go
Insert Into Jugadores Values ( 'DNI',92725945,'MONTIEL, PAULO','3/4/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30662769,'SUAREZ, JUAN','12/1/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',31624895,'DIEGUEZ,SEBASTIAN','22/4/85',85,7) 
Go
Insert Into Jugadores Values ( 'DNI',30877105,'GILES, CARLOS','29/1/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31829143,'IREN, RAUL','16/12/84',84,24) 
Go
Insert Into Jugadores Values ( 'DNI',31781489,'LEPORE, ADRIAN','3/9/85',85,13) 
Go
Insert Into Jugadores Values ( 'DNI',92876004,'MORALES, DANIEL','30/4/84',84,13) 
Go
Insert Into Jugadores Values ( 'DNI',30963661,'GARCETTE, ANDRES','8/6/84',84,23) 
Go
Insert Into Jugadores Values ( 'DNI',31937171,'BAGNATO, CLAUDIO','18/9/85',85,5) 
Go
Insert Into Jugadores Values ( 'DNI',31732663,'TROTTA, JOSE','21/7/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31422016,'GALEANO, CARLOS','27/1/85',85,23) 
Go
Insert Into Jugadores Values ( 'DNI',31774039,'OSTOISCH, EMANUEL','22/5/85',85,3) 
Go
Insert Into Jugadores Values ( 'DNI',31727399,'GONZALEZ, SEBASTIAN','18/8/85',85,3) 
Go	

Create Table PosCate184
(	Id_Club 	smallint,
	Nombre 		char(30),
	Cantidad 	smallint null,
	Ganados		smallint null,
	Empatados 	smallint null,
	Perdidos 	smallint null,
	GolesF		smallint null,
	GolesC		smallint null,
	Diferencia 	smallint null,
	Puntos		smallint null,
	Promedio 	dec(4,2) null,
	Primary Key (Id_Club),
	Foreign Key (Id_club) References Clubes )
GO
Create Table PosCate284
(	Id_Club 	smallint,
	Nombre 		char(30),
	Cantidad 	smallint null,
	Ganados		smallint null,
	Empatados 	smallint null,
	Perdidos 	smallint null,
	GolesF		smallint null,
	GolesC		smallint null,
	Diferencia 	smallint null,
	Puntos		smallint null,
	Promedio 	dec(4,2) null,
	Primary Key (Id_Club),
	Foreign Key (Id_club) References Clubes )
GO
Create Table PosCate185
(	Id_Club 	smallint,
	Nombre 		char(30),
	Cantidad 	smallint null,
	Ganados		smallint null,
	Empatados 	smallint null,
	Perdidos 	smallint null,
	GolesF		smallint null,
	GolesC		smallint null,
	Diferencia 	smallint null,
	Puntos		smallint null,
	Promedio 	dec(4,2) null,
	Primary Key (Id_Club),
	Foreign Key (Id_club) References Clubes ) 
GO
Create Table PosCate285
(	Id_Club 	smallint,
	Nombre 		char(30),
	Cantidad 	smallint null,
	Ganados		smallint null,
	Empatados 	smallint null,
	Perdidos 	smallint null,
	GolesF		smallint null,
	GolesC		smallint null,
	Diferencia 	smallint null,
	Puntos		smallint null,
	Promedio 	dec(4,2) null,
	Primary Key (Id_Club),
	Foreign Key (Id_club) References Clubes ) 
GO
Create Table General
(	Id_Club 	smallint,
	Nombre 		char(30),
	Cantidad 	smallint null,
	Ganados		smallint null,
	Empatados 	smallint null,
	Perdidos 	smallint null,
	GolesF		smallint null,
	GolesC		smallint null,
	Diferencia 	smallint null,
	Puntos		smallint null,
	Promedio 	dec(4,2) null,
	Primary Key (Id_Club),
	Foreign Key (Id_club) References Clubes )
GO

Insert into PosCate184 (Id_Club, Nombre) (Select Id_Club, Nombre from Clubes where Nrozona = 1)
Insert into PosCate284 (Id_Club, Nombre) (Select Id_Club, Nombre from Clubes where Nrozona = 2)
Insert into PosCate185 (Id_Club, Nombre) (Select Id_Club, Nombre from Clubes where Nrozona = 1)
Insert into PosCate285 (Id_Club, Nombre) (Select Id_Club, Nombre from Clubes where Nrozona = 2)
Insert into General    (Id_Club, Nombre) (Select Id_Club, Nombre from Clubes) 

update PosCate184 set Cantidad = 0, Ganados = 0, Empatados = 0, Perdidos =0, GolesF = 0, GolesC =0, Diferencia =0, Promedio = 0.0, Puntos = 0 
update PosCate184 set Cantidad = Cantidad + (select count(Id_ClubL) from Partidos where Categoria = 84 and Id_ClubL = PosCate184.Id_Club)
update PosCate184 set Cantidad = Cantidad + (select count(Id_ClubV) from Partidos where Categoria = 84 and Id_ClubV = PosCate184.Id_Club)

update PosCate284 set Cantidad = 0, Ganados = 0, Empatados = 0, Perdidos =0, GolesF = 0, GolesC =0, Diferencia =0, Promedio = 0.0, Puntos = 0 
update PosCate284 set Cantidad = Cantidad + (select count(Id_ClubL) from Partidos where Categoria = 84 and Id_ClubL = PosCate284.Id_Club)
update PosCate284 set Cantidad = Cantidad + (select count(Id_ClubV) from Partidos where Categoria = 84 and Id_ClubV = PosCate284.Id_Club)

update PosCate185 set Cantidad = 0, Ganados = 0, Empatados = 0, Perdidos =0, GolesF = 0, GolesC =0, Diferencia =0, Promedio = 0.0, Puntos = 0  
update PosCate185 set Cantidad = Cantidad + (select count(Id_ClubL) from Partidos where Categoria = 85 and Id_ClubL = PosCate185.Id_Club)
update PosCate185 set Cantidad = Cantidad + (select count(Id_ClubV) from Partidos where Categoria = 85 and Id_ClubV = PosCate185.Id_Club)

update PosCate285 set Cantidad = 0, Ganados = 0, Empatados = 0, Perdidos =0, GolesF = 0, GolesC =0, Diferencia =0, Promedio = 0.0, Puntos = 0  
update PosCate285 set Cantidad = Cantidad + (select count(Id_ClubL) from Partidos where Categoria = 85 and Id_ClubL = PosCate285.Id_Club)
update PosCate285 set Cantidad = Cantidad + (select count(Id_ClubV) from Partidos where Categoria = 85 and Id_ClubV = PosCate285.Id_Club) 


update PosCate184 set Ganados = Ganados + (select count(Id_ClubL) from Partidos where Categoria = 84 and Id_ClubL = PosCate184.Id_Club and GolesL > GolesV)
update PosCate184 set Ganados = Ganados + (select count(Id_ClubV) from Partidos where Categoria = 84 and Id_ClubV = PosCate184.Id_Club and GolesV > GolesL)
update PosCate184 set Empatados = Empatados + (select count(Id_ClubL) from Partidos where Categoria = 84 and Id_ClubL = PosCate184.Id_Club and GolesL = GolesV)
update PosCate184 set Empatados = Empatados + (select count(Id_ClubV) from Partidos where Categoria = 84 and Id_ClubV = PosCate184.Id_Club and GolesV = GolesL)
update PosCate184 set Perdidos = Perdidos + (select count(Id_ClubL) from Partidos where Categoria = 84 and Id_ClubL = PosCate184.Id_Club and GolesL < GolesV)
update PosCate184 set Perdidos = Perdidos + (select count(Id_ClubV) from Partidos where Categoria = 84 and Id_ClubV = PosCate184.Id_Club and GolesV < GolesL)

update PosCate185 set Ganados = Ganados + (select count(Id_ClubL) from Partidos where Categoria = 85 and Id_ClubL = PosCate185.Id_Club and GolesL > GolesV)
update PosCate185 set Ganados = Ganados + (select count(Id_ClubV) from Partidos where Categoria = 85 and Id_ClubV = PosCate185.Id_Club and GolesV > GolesL)
update PosCate185 set Empatados = Empatados + (select count(Id_ClubL) from Partidos where Categoria = 85 and Id_ClubL = PosCate185.Id_Club and GolesL = GolesV)
update PosCate185 set Empatados = Empatados + (select count(Id_ClubV) from Partidos where Categoria = 85 and Id_ClubV = PosCate185.Id_Club and GolesV = GolesL)
update PosCate185 set Perdidos = Perdidos + (select count(Id_ClubL) from Partidos where Categoria = 85 and Id_ClubL = PosCate185.Id_Club and GolesL < GolesV)
update PosCate185 set Perdidos = Perdidos + (select count(Id_ClubV) from Partidos where Categoria = 85 and Id_ClubV = PosCate185.Id_Club and GolesV < GolesL)

update PosCate284 set Ganados = Ganados + (select count(Id_ClubL) from Partidos where Categoria = 84 and Id_ClubL = PosCate284.Id_Club and GolesL > GolesV)
update PosCate284 set Ganados = Ganados + (select count(Id_ClubV) from Partidos where Categoria = 84 and Id_ClubV = PosCate284.Id_Club and GolesV > GolesL)
update PosCate284 set Empatados = Empatados + (select count(Id_ClubL) from Partidos where Categoria = 84 and Id_ClubL = PosCate284.Id_Club and GolesL = GolesV)
update PosCate284 set Empatados = Empatados + (select count(Id_ClubV) from Partidos where Categoria = 84 and Id_ClubV = PosCate284.Id_Club and GolesV = GolesL)
update PosCate284 set Perdidos = Perdidos + (select count(Id_ClubL) from Partidos where Categoria = 84 and Id_ClubL = PosCate284.Id_Club and GolesL < GolesV)
update PosCate284 set Perdidos = Perdidos + (select count(Id_ClubV) from Partidos where Categoria = 84 and Id_ClubV = PosCate284.Id_Club and GolesV < GolesL)

update PosCate285 set Ganados = Ganados + (select count(Id_ClubL) from Partidos where Categoria = 85 and Id_ClubL = PosCate285.Id_Club and GolesL > GolesV)
update PosCate285 set Ganados = Ganados + (select count(Id_ClubV) from Partidos where Categoria = 85 and Id_ClubV = PosCate285.Id_Club and GolesV > GolesL)
update PosCate285 set Empatados = Empatados + (select count(Id_ClubL) from Partidos where Categoria = 85 and Id_ClubL = PosCate285.Id_Club and GolesL = GolesV)
update PosCate285 set Empatados = Empatados + (select count(Id_ClubV) from Partidos where Categoria = 85 and Id_ClubV = PosCate285.Id_Club and GolesV = GolesL)
update PosCate285 set Perdidos = Perdidos + (select count(Id_ClubL) from Partidos where Categoria = 85 and Id_ClubL = PosCate285.Id_Club and GolesL < GolesV)
update PosCate285 set Perdidos = Perdidos + (select count(Id_ClubV) from Partidos where Categoria = 85 and Id_ClubV = PosCate285.Id_Club and GolesV < GolesL)

update PosCate184 set GolesF = GolesF + (select sum(GolesL) from Partidos where Categoria = 84 and Id_ClubL = PosCate184.Id_Club)
update PosCate184 set GolesF = GolesF + (select sum(GolesV) from Partidos where Categoria = 84 and Id_ClubV = PosCate184.Id_Club)
update PosCate184 set GolesC = GolesC + (select sum(GolesV) from Partidos where Categoria = 84 and Id_ClubL = PosCate184.Id_Club)
update PosCate184 set GolesC = GolesC + (select sum(GolesL) from Partidos where Categoria = 84 and Id_ClubV = PosCate184.Id_Club)
update PosCate184 set Diferencia = GolesF - GolesC
update PosCate184 set Puntos = Ganados * 3 + Empatados * 1
update PosCate184 set Promedio =(Puntos * 1.0) / Cantidad 

update PosCate284 set GolesF = GolesF + (select sum(GolesL) from Partidos where Categoria = 84 and Id_ClubL = PosCate284.Id_Club)
update PosCate284 set GolesF = GolesF + (select sum(GolesV) from Partidos where Categoria = 84 and Id_ClubV = PosCate284.Id_Club)
update PosCate284 set GolesC = GolesC + (select sum(GolesV) from Partidos where Categoria = 84 and Id_ClubL = PosCate284.Id_Club)
update PosCate284 set GolesC = GolesC + (select sum(GolesL) from Partidos where Categoria = 84 and Id_ClubV = PosCate284.Id_Club)
update PosCate284 set Diferencia = GolesF - GolesC
update PosCate284 set Puntos = Ganados * 3 + Empatados * 1
update PosCate284 set Promedio = (Puntos* 1.0)/ Cantidad 

update PosCate285 set GolesF = GolesF + (select sum(GolesL) from Partidos where Categoria = 85 and Id_ClubL = PosCate285.Id_Club)
update PosCate285 set GolesF = GolesF + (select sum(GolesV) from Partidos where Categoria = 85 and Id_ClubV = PosCate285.Id_Club)
update PosCate285 set GolesC = GolesC + (select sum(GolesV) from Partidos where Categoria = 85 and Id_ClubL = PosCate285.Id_Club)
update PosCate285 set GolesC = GolesC + (select sum(GolesL) from Partidos where Categoria = 85 and Id_ClubV = PosCate285.Id_Club)
update PosCate285 set Diferencia = GolesF - GolesC
update PosCate285 set Puntos = Ganados * 3 + Empatados * 1
update PosCate285 set Promedio = (Puntos* 1.0)/Cantidad 

update PosCate185 set GolesF = GolesF + (select sum(GolesL) from Partidos where Categoria = 85 and Id_ClubL = PosCate185.Id_Club)
update PosCate185 set GolesF = GolesF + (select sum(GolesV) from Partidos where Categoria = 85 and Id_ClubV = PosCate185.Id_Club)
update PosCate185 set GolesC = GolesC + (select sum(GolesV) from Partidos where Categoria = 85 and Id_ClubL = PosCate185.Id_Club)
update PosCate185 set GolesC = GolesC + (select sum(GolesL) from Partidos where Categoria = 85 and Id_ClubV = PosCate185.Id_Club)
update PosCate185 set Diferencia = GolesF - GolesC
update PosCate185 set Puntos = Ganados * 3 + Empatados * 1
update PosCate185 set Promedio =(Puntos*1.0) / Cantidad 
go

create view trabajo as 
(
select Id_Club, Cantidad, Ganados, Empatados, Perdidos, GolesF, GolesC from poscate184
union all 
select Id_Club, Cantidad, Ganados, Empatados, Perdidos, GolesF, GolesC from poscate185
union all
select Id_Club, Cantidad, Ganados, Empatados, Perdidos, GolesF, GolesC from poscate284
union all
select Id_Club, Cantidad, Ganados, Empatados, Perdidos, GolesF, GolesC from poscate285 ) 

go 

update general set cantidad  = (select sum(cantidad)  from trabajo where trabajo.id_club = general.id_club)
update general set ganados   = (select sum(ganados)   from trabajo where trabajo.id_club = general.id_club)
update general set empatados = (select sum(empatados) from trabajo where trabajo.id_club = general.id_club)
update general set perdidos  = (select sum(perdidos)  from trabajo where trabajo.id_club = general.id_club)
update general set golesf    = (select sum(golesf)    from trabajo where trabajo.id_club = general.id_club)
update general set golesc    = (select sum(golesc)    from trabajo where trabajo.id_club = general.id_club)

update general set diferencia = golesf - golesc
update general set puntos = ganados * 3 + empatados * 1
update general set promedio = convert(dec(4,2),puntos) / convert(dec(4,2),cantidad) 
go

drop view trabajo 
go


