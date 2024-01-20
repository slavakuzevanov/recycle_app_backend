
CREATE TABLE Achievements
(
	achievement_id       INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
	condition_to_achieve VARCHAR(100) NOT NULL
);



ALTER TABLE Achievements
ADD PRIMARY KEY (achievement_id);



CREATE TABLE Administrator
(
	administrator_id     INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
	surname              VARCHAR(45) NOT NULL,
	name                 VARCHAR(45) NOT NULL,
	patronymic           VARCHAR(45) NULL,
	email                VARCHAR(30) NOT NULL
);



ALTER TABLE Administrator
ADD PRIMARY KEY (administrator_id);



CREATE TABLE Basket_to_recycling_point
(
	basket_id            INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
	user_id              INTEGER NULL,
	session_id           INTEGER NULL,
	scaned_material_id   INTEGER NULL,
	partner_id           INTEGER NULL,
	recycling_point_id   INTEGER NULL
);



ALTER TABLE Basket_to_recycling_point
ADD PRIMARY KEY (basket_id);



CREATE TABLE Materials_in_session
(
	user_id              INTEGER NOT NULL,
	session_id           INTEGER NOT NULL,
	scaned_material_id   INTEGER NOT NULL,
	material_type_id     INTEGER NULL
);



ALTER TABLE Materials_in_session
ADD PRIMARY KEY (user_id,session_id,scaned_material_id);



CREATE TABLE Partner
(
	partner_id           INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
	administrator_id     INTEGER NOT NULL,
	phone                VARCHAR(20) NOT NULL,
	email                VARCHAR(30) NOT NULL,
	country              VARCHAR(20) NOT NULL,
	physical_legal       boolean NOT NULL,
	address              VARCHAR(45) NOT NULL
);



ALTER TABLE Partner
ADD PRIMARY KEY (partner_id);



CREATE TABLE Recycling_material
(
	material_type_id     INTEGER NOT NULL,
	instruction          VARCHAR(300) NOT NULL
);



ALTER TABLE Recycling_material
ADD PRIMARY KEY (material_type_id);



CREATE TABLE Recycling_point
(
	partner_id           INTEGER NOT NULL,
	recycling_point_id   INTEGER NOT NULL,
	latitide             DECIMAL NULL,
	longitude            DECIMAL NULL
);



ALTER TABLE Recycling_point
ADD PRIMARY KEY (partner_id,recycling_point_id);



CREATE TABLE recycling_point_materials
(
	partner_id           INTEGER NOT NULL,
	recycling_point_id   INTEGER NOT NULL,
	material_type_id     INTEGER NOT NULL
);



ALTER TABLE recycling_point_materials
ADD PRIMARY KEY (partner_id,recycling_point_id,material_type_id);



CREATE TABLE "User"
(
	user_id              INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
	surname              VARCHAR(45) NULL,
	name                 VARCHAR(45) NOT NULL,
	email                VARCHAR(30) NOT NULL,
	password             VARCHAR(30) NOT NULL,
	phone                VARCHAR(20),
	country              VARCHAR(20)
);



ALTER TABLE "User"
ADD PRIMARY KEY (user_id);



CREATE TABLE User_achievements
(
	user_id              INTEGER NOT NULL,
	achievement_id       INTEGER NOT NULL,
	dt                   DATE NOT NULL
);



ALTER TABLE User_achievements
ADD PRIMARY KEY (user_id,achievement_id);



CREATE TABLE User_session
(
	user_id              INTEGER NOT NULL,
	session_id           INTEGER NOT NULL,
	dt                   DATE NOT NULL
);



ALTER TABLE User_session
ADD PRIMARY KEY (user_id,session_id);



ALTER TABLE Basket_to_recycling_point
ADD CONSTRAINT R_16 FOREIGN KEY (user_id, session_id, scaned_material_id) REFERENCES Materials_in_session (user_id, session_id, scaned_material_id);



ALTER TABLE Basket_to_recycling_point
ADD CONSTRAINT R_17 FOREIGN KEY (partner_id, recycling_point_id) REFERENCES Recycling_point (partner_id, recycling_point_id);



ALTER TABLE Materials_in_session
ADD CONSTRAINT R_14 FOREIGN KEY (user_id, session_id) REFERENCES User_session (user_id, session_id);



ALTER TABLE Materials_in_session
ADD CONSTRAINT R_15 FOREIGN KEY (material_type_id) REFERENCES Recycling_material (material_type_id);



ALTER TABLE Partner
ADD CONSTRAINT R_3 FOREIGN KEY (administrator_id) REFERENCES Administrator (administrator_id);



ALTER TABLE Recycling_point
ADD CONSTRAINT R_4 FOREIGN KEY (partner_id) REFERENCES Partner (partner_id);



ALTER TABLE recycling_point_materials
ADD CONSTRAINT R_12 FOREIGN KEY (partner_id, recycling_point_id) REFERENCES Recycling_point (partner_id, recycling_point_id);



ALTER TABLE recycling_point_materials
ADD CONSTRAINT R_13 FOREIGN KEY (material_type_id) REFERENCES Recycling_material (material_type_id);



ALTER TABLE User_achievements
ADD CONSTRAINT R_1 FOREIGN KEY (user_id) REFERENCES "User" (user_id);



ALTER TABLE User_achievements
ADD CONSTRAINT R_2 FOREIGN KEY (achievement_id) REFERENCES Achievements (achievement_id);



ALTER TABLE User_session
ADD CONSTRAINT R_5 FOREIGN KEY (user_id) REFERENCES "User" (user_id);