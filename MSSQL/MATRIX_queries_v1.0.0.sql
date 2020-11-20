USE MATRIX
GO

SELECT CONCAT_WS(' ', tmr.short_name, tp.first_name, UPPER(tp.last_name)) AS person,
	tsct.full_name AS ClearanceType,
	tss.full_name AS SecurityState,
	tsc.full_name AS SecurityClassification,
	vgnsc.issuer AS ClearanceIssuer,
	vgnsc.serial_number AS ClearanceSerialNumber,
	vgnsc.date_of_issue AS ClearanceDateOfIssue,
	vgnsc.expiration_date AS ClearanceExpirationDate
FROM viw_get_newest_security_clearance AS vgnsc
	LEFT JOIN tbl_person AS tp ON vgnsc.id_person = tp.id_person
	LEFT JOIN tbl_security_classification AS tsc ON vgnsc.id_security_classification = tsc.id_security_classification
	LEFT JOIN tbl_security_state AS tss ON vgnsc.id_security_state = tss.id_security_state
	LEFT JOIN tbl_security_clearance_type AS tsct ON vgnsc.id_security_clearance_type = tsct.id_security_clearance_type
	LEFT JOIN tbl_military_rank AS tmr ON tp.id_military_rank = tmr.id_military_rank
WHERE vgnsc.expiration_date <= DATEADD(YEAR, 6, GETDATE())
ORDER BY tp.last_name