USE MATRIX
GO

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