USE MATRIX
GO

SELECT CONCAT_WS(' ', tmr.short_name, tp.first_name, tp.last_name) AS Person,
	tp.pesel AS PESEL,
	tidt.full_name AS DokumentTożsamości,
	tid.serial_number AS NumerSeryjny,
	tid.expiration_date AS DataWażności
FROM tbl_person AS tp
	LEFT JOIN tbl_military_rank AS tmr ON tp.id_military_rank = tmr.id_military_rank
	LEFT JOIN tbl_identity_document AS tid ON tp.id_person = tid.id_person
	LEFT JOIN tbl_identity_document_type AS tidt ON tid.id_identity_document_type = tidt.id_identity_document_type
ORDER BY tp.id_person, tidt.id_identity_document_type, tid.expiration_date DESC

SELECT *
FROM tbl_identity_document AS tid
	INNER JOIN tbl_identity_document_type AS tidt ON tid.id_identity_document_type = tidt.id_identity_document_type
ORDER BY tid.id_person, tid.id_identity_document_type, tid.expiration_date DESC

SELECT DISTINCT id_person, id_identity_document_type
FROM tbl_identity_document


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