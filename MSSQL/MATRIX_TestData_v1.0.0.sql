USE MATRIX
GO

--insert persons
INSERT INTO tbl_person (id_nation, id_sex, id_military_rank, first_name, last_name, pesel, date_of_birth)
VALUES (
	'B3F817B5-F216-EB11-995E-000C295890EE', --nation
	'E153D5C5-FB16-EB11-995E-000C295890EE', --sex
	'47E7336E-FA16-EB11-995E-000C295890EE', --military rank
	'Kajser',
	'Soze',
	'00000000001',
	CONVERT(date, '1978-04-04')
)
GO

INSERT INTO tbl_person (id_nation, id_sex, id_military_rank, first_name, last_name, pesel, date_of_birth)
VALUES (
	'CAF817B5-F216-EB11-995E-000C295890EE', --nation
	'E153D5C5-FB16-EB11-995E-000C295890EE', --sex
	'66E7336E-FA16-EB11-995E-000C295890EE', --military rank
	'John',
	'Doe',
	NULL,
	CONVERT(date, '1980-05-04')
)
GO

INSERT INTO tbl_person (id_nation, id_sex, id_military_rank, first_name, last_name, pesel, date_of_birth)
VALUES (
	'AAF817B5-F216-EB11-995E-000C295890EE', --nation
	'E253D5C5-FB16-EB11-995E-000C295890EE', --sex
	NULL, --military rank
	'Maria',
	'Skłodowska-Curie',
	'00000000002',
	CONVERT(date, '1968-11-04')
)
GO

INSERT INTO tbl_person (id_nation, id_sex, id_military_rank, first_name, last_name, pesel, date_of_birth)
VALUES (
	'AAF817B5-F216-EB11-995E-000C295890EE', --nation
	'E153D5C5-FB16-EB11-995E-000C295890EE', --sex
	'66E7336E-FA16-EB11-995E-000C295890EE', --military rank
	'Józef',
	'Piłsudski',
	'00000000003',
	CONVERT(date, '1920-05-04')
)
GO

--insert identity documents
INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	'C47DD798-B629-EB11-9965-000C2907CAFC', --person
	'C8C28E99-F716-EB11-995E-000C295890EE', --id type
	'127/2010',
	CONVERT(date, '2000-05-04'),
	CONVERT(date, '2010-05-04'),
	'Prezydent m. Warszawa'
)

INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	'C47DD798-B629-EB11-9965-000C2907CAFC', --person
	'C8C28E99-F716-EB11-995E-000C295890EE', --id type
	'127/2010',
	CONVERT(date, '2005-05-04'),
	CONVERT(date, '2015-05-04'),
	'Prezydent m. Warszawa'
)

INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	'C77DD798-B629-EB11-9965-000C2907CAFC', --person
	'C8C28E99-F716-EB11-995E-000C295890EE', --id type
	'3/1920',
	CONVERT(date, '1920-05-04'),
	CONVERT(date, '1930-05-04'),
	'Prezydent m. Warszawa'
)

INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	'C77DD798-B629-EB11-9965-000C2907CAFC', --person
	'C8C28E99-F716-EB11-995E-000C295890EE', --id type
	'18/1925',
	CONVERT(date, '1925-05-04'),
	CONVERT(date, '1935-05-04'),
	'Prezydent m. Warszawa'
)

INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	'C77DD798-B629-EB11-9965-000C2907CAFC', --person
	'C7C28E99-F716-EB11-995E-000C295890EE', --id type
	'12/1926',
	CONVERT(date, '1926-05-04'),
	CONVERT(date, '1936-05-04'),
	'Prezydent m. Warszawa'
)

--insert security clearances
INSERT INTO tbl_security_clearance (id_person, id_security_clearance_type, )