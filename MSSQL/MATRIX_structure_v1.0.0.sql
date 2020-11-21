CREATE DATABASE MATRIX
GO

USE MATRIX
GO

-- tables
CREATE TABLE tbl_nation(
	id_nation uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	polish_name nvarchar(64) NOT NULL,
	english_name nvarchar(64) NOT NULL,
	alpha2_code nvarchar(2) NOT NULL,
	alpha3_code nvarchar(3) NOT NULL,
	numeric_code smallint NOT NULL,
	iso_code nvarchar(32) NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_sex(
	id_sex uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	full_name nvarchar(64) NULL,
	symbol nvarchar(1) NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)


CREATE TABLE tbl_nato_rank(
	id_nato_rank uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	short_name nvarchar(8) NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_military_rank(
	id_military_rank uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_nato_rank uniqueidentifier NOT NULL REFERENCES tbl_nato_rank(id_nato_rank),
	full_name nvarchar(64) NOT NULL,
	short_name nvarchar(32) NOT NULL,
	is_polish bit NOT NULL,
	hierarchy smallint NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
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
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_identity_document_type(
	id_identity_document_type uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	full_name nvarchar(64) NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_identity_document(
	id_identity_document uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_person uniqueidentifier NOT NULL REFERENCES tbl_person(id_person) ON DELETE CASCADE,
	id_identity_document_type uniqueidentifier NOT NULL REFERENCES tbl_identity_document_type(id_identity_document_type),
	serial_number nvarchar(32) NOT NULL,
	date_of_issue date NOT NULL,
	expiration_date date,
	issuer nvarchar(128) NOT NULL, 
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_security_state(
	id_security_state uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	full_name nvarchar(64) NOT NULL,
	short_name nvarchar(16) NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_security_classification(
	id_security_classification uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_security_state uniqueidentifier NOT NULL REFERENCES tbl_security_state(id_security_state),
	full_name nvarchar(64) NULL,
	short_name nvarchar(16) NOT NULL,
	hierarchy smallint NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_security_clearance_type(
	id_security_clearance_type uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	full_name nvarchar(64) NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_security_clearance(
	id_security_clearance uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_person uniqueidentifier NOT NULL REFERENCES tbl_person(id_person) ON DELETE CASCADE,
	id_security_clearance_type uniqueidentifier NOT NULL REFERENCES tbl_security_clearance_type(id_security_clearance_type),
	serial_number nvarchar(32) NOT NULL,
	date_of_issue date NOT NULL,
	issuer nvarchar(128) NOT NULL,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)

CREATE TABLE tbl_clearance_classification(
	id_clearance_classification uniqueidentifier NOT NULL DEFAULT (newsequentialid()) PRIMARY KEY,
	id_security_clearance uniqueidentifier NOT NULL REFERENCES tbl_security_clearance(id_security_clearance) ON DELETE CASCADE,
	id_security_classification uniqueidentifier NOT NULL REFERENCES tbl_security_classification(id_security_classification),
	expiration_date date,
	is_active bit NOT NULL DEFAULT 1,
	creation_time datetime NOT NULL DEFAULT (getdate())
)
GO

--indexes
CREATE INDEX idx_nation_polish_name ON tbl_nation(polish_name);
CREATE INDEX idx_military_rank_hierarchy ON tbl_military_rank(hierarchy);
CREATE INDEX idx_person_last_name ON tbl_person(last_name);
CREATE INDEX idx_person_pesel ON tbl_person(pesel);
CREATE UNIQUE INDEX idx_person_pesel_unique ON tbl_person(pesel);

--views
CREATE VIEW viw_get_newest_identity_document
AS
WITH cte_identity_document AS(
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY id_person, id_identity_document_type ORDER BY expiration_date DESC) AS row_no
	FROM tbl_identity_document)
SELECT id_identity_document,
	id_identity_document_type,
	id_person, serial_number,
	date_of_issue, expiration_date,
	issuer, is_active,
	creation_time
FROM cte_identity_document
WHERE row_no = 1
GO

CREATE VIEW viw_get_newest_security_clearance
AS
WITH cte_security_clearance AS (
	SELECT tcc.id_security_clearance,
		tsc.id_person,
		tsc.id_security_clearance_type,
		tsc.serial_number,
		tsc.date_of_issue,
		tsc.issuer,
		tcc.id_clearance_classification,
		tcc.id_security_classification,
		tscl.id_security_state,
		tcc.expiration_date,
		ROW_NUMBER() OVER(PARTITION BY tsc.id_person, tsc.id_security_clearance_type, tscl.id_security_state, tcc.id_security_classification ORDER BY tcc.expiration_date DESC) AS row_no
	FROM tbl_security_clearance AS tsc
		INNER JOIN tbl_clearance_classification AS tcc ON tsc.id_security_clearance = tcc.id_security_clearance
		INNER JOIN tbl_security_classification AS tscl ON tcc.id_security_classification = tscl.id_security_classification
		INNER JOIN tbl_person AS tp ON tsc.id_person = tp.id_person
)
SELECT id_security_clearance,
	id_person,
	id_security_clearance_type,
	serial_number, date_of_issue,
	issuer,
	id_clearance_classification,
	id_security_classification,
	id_security_state,
	expiration_date
FROM cte_security_clearance
WHERE row_no = 1
GO