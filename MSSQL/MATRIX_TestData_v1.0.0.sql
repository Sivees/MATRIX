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
	'USA00000001',
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
	(SELECT id_person FROM tbl_person WHERE pesel = '00000000002'), --person
	'C8C28E99-F716-EB11-995E-000C295890EE', --id type
	'127/2010',
	CONVERT(date, '2000-05-04'),
	CONVERT(date, '2010-05-04'),
	'Prezydent m. Warszawa'
)

INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	(SELECT id_person FROM tbl_person WHERE pesel = '00000000002'), --person
	'C8C28E99-F716-EB11-995E-000C295890EE', --id type
	'127/2010',
	CONVERT(date, '2005-05-04'),
	CONVERT(date, '2015-05-04'),
	'Prezydent m. Warszawa'
)

INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	(SELECT id_person FROM tbl_person WHERE pesel = '00000000003'), --person
	'C8C28E99-F716-EB11-995E-000C295890EE', --id type
	'3/1920',
	CONVERT(date, '1920-05-04'),
	CONVERT(date, '1930-05-04'),
	'Prezydent m. Warszawa'
)

INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	(SELECT id_person FROM tbl_person WHERE pesel = '00000000003'), --person
	'C8C28E99-F716-EB11-995E-000C295890EE', --id type
	'18/1925',
	CONVERT(date, '1925-05-04'),
	CONVERT(date, '1935-05-04'),
	'Prezydent m. Warszawa'
)

INSERT INTO tbl_identity_document (id_person, id_identity_document_type, serial_number, date_of_issue, expiration_date, issuer)
VALUES (
	(SELECT id_person FROM tbl_person WHERE pesel = '00000000003'), --person
	'C7C28E99-F716-EB11-995E-000C295890EE', --id type
	'12/1926',
	CONVERT(date, '1926-05-04'),
	CONVERT(date, '1936-05-04'),
	'Prezydent m. Warszawa'
)

--insert security clearances
INSERT INTO tbl_security_clearance (id_person, id_security_clearance_type, serial_number, date_of_issue, issuer)
VALUES (
	(SELECT id_person FROM tbl_person WHERE pesel = '00000000002'), --person
	'EF75A0CD-FE16-EB11-995E-000C295890EE',
	'78/2015',
	CONVERT(date, '2005-05-04'),
	'Agencja Bezpieczeństwa Wewnętrznego'
)

INSERT INTO tbl_clearance_classification (id_security_clearance, id_security_classification, expiration_date)
VALUES (
	(SELECT id_security_clearance FROM tbl_security_clearance WHERE serial_number = '78/2015'),
	'88B3561F-FE16-EB11-995E-000C295890EE',
	(SELECT DATEADD(DAY, -1, DATEADD(YEAR, 5, date_of_issue)) FROM tbl_security_clearance)
)

INSERT INTO tbl_clearance_classification (id_security_clearance, id_security_classification, expiration_date)
VALUES (
	(SELECT id_security_clearance FROM tbl_security_clearance WHERE serial_number = '78/2015'),
	'87B3561F-FE16-EB11-995E-000C295890EE',
	(SELECT DATEADD(DAY, -1, DATEADD(YEAR, 7, date_of_issue)) FROM tbl_security_clearance)
)

INSERT INTO tbl_clearance_classification (id_security_clearance, id_security_classification, expiration_date)
VALUES (
	(SELECT id_security_clearance FROM tbl_security_clearance WHERE serial_number = '78/2015'),
	'86B3561F-FE16-EB11-995E-000C295890EE',
	(SELECT DATEADD(DAY, -1, DATEADD(YEAR, 7, date_of_issue)) FROM tbl_security_clearance)
)

---