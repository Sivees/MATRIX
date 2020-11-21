USE MATRIX
GO

SELECT CONCAT_WS(' ', tnr.short_name, tp.first_name, UPPER(tp.last_name)) AS Person,
	tn.polish_name AS Nation,
	ts.full_name AS Sex
FROM tbl_person AS tp
	LEFT JOIN tbl_nation AS tn ON tp.id_nation = tn.id_nation
	LEFT JOIN tbl_sex AS ts ON tp.id_sex = ts.id_sex
	LEFT JOIN tbl_military_rank AS tmr ON tp.id_military_rank = tmr.id_military_rank
	LEFT JOIN tbl_nato_rank AS tnr ON tmr.id_nato_rank = tnr.id_nato_rank
GO

WITH cte_person AS (
	SELECT COUNT(id_person) AS sex_count,
		id_sex
	FROM tbl_person
	GROUP BY id_sex
)
SELECT ts.full_name,
	cp.sex_count
FROM cte_person AS cp
	INNER JOIN tbl_sex AS ts ON cp.id_sex = ts.id_sex
GO

SELECT CONCAT_WS(' ', tmr.short_name, tp.first_name, UPPER(tp.last_name)) AS Person,
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
--WHERE vgnsc.expiration_date <= DATEADD(YEAR, 6, GETDATE())
ORDER BY tp.last_name, tsct.id_security_clearance_type, tss.id_security_state, tsc.hierarchy DESC
GO