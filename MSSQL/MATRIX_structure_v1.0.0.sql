CREATE DATABASE MATRIX
GO

USE MATRIX
GO

CREATE TABLE tbl_nation(
	id_nation uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	polish_name nvarchar(64) NOT NULL,
	english_name nvarchar(64) NOT NULL,
	alpha2_code nvarchar(2) NOT NULL,
	alpha3_code nvarchar(3) NOT NULL,
	numeric_code smallint NOT NULL,
	iso_code nvarchar(32) NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_sex(
	id_sex uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	full_name nvarchar(64) NULL,
	symbol nvarchar(1) NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)


CREATE TABLE tbl_nato_rank(
	id_nato_rank uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	short_name nvarchar(8) NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_military_rank(
	id_military_rank uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_nato_rank uniqueidentifier NOT NULL REFERENCES tbl_nato_rank(id_nato_rank),
	full_name nvarchar(64) NOT NULL,
	short_name nvarchar(32) NOT NULL,
	is_polish bit NOT NULL,
	hierarchy smallint NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_person(
	id_person uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_nation uniqueidentifier NOT NULL REFERENCES tbl_nation(id_nation),
	id_sex uniqueidentifier NOT NULL REFERENCES tbl_sex(id_sex),
	id_military_rank uniqueidentifier REFERENCES tbl_military_rank(id_military_rank),
	first_name nvarchar(128) NOT NULL,
	last_name nvarchar (128) NOT NULL,
	pesel nvarchar (11),
	date_of_birth date,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_identity_document_type(
	id_identity_document_type uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	full_name nvarchar(64) NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_identity_document(
	id_identity_document uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_person uniqueidentifier NOT NULL REFERENCES tbl_person(id_person),
	id_identity_document_type uniqueidentifier NOT NULL REFERENCES tbl_identity_document_type(id_identity_document_type),
	serial_number nvarchar(32) NOT NULL,
	date_of_issue date NOT NULL,
	expiration_date date,
	issuer nvarchar(128) NOT NULL, 
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_security_state(
	id_security_state uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	full_name nvarchar(64) NOT NULL,
	short_name nvarchar(16) NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_security_classification(
	id_security_classification uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_security_state uniqueidentifier NOT NULL REFERENCES tbl_security_state(id_security_state),
	full_name nvarchar(64) NULL,
	short_name nvarchar(16) NOT NULL,
	hierarchy smallint NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_security_clearance_type(
	id_security_clearance_type uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	full_name nvarchar(64) NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)

CREATE TABLE tbl_security_clearance(
	id_security_clearance uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_person uniqueidentifier NOT NULL REFERENCES tbl_person(id_person),
	id_security_clearance_type uniqueidentifier NOT NULL REFERENCES tbl_security_clearance_type(id_security_clearance_type),
	id_security_classification uniqueidentifier NOT NULL REFERENCES tbl_security_classification(id_security_classification),
	serial_number nvarchar(32) NOT NULL,
	date_of_issue date NOT NULL,
	expiration_date date,
	issuer nvarchar(128) NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate()),
)