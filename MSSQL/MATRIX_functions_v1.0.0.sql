USE Matrix
GO

CREATE FUNCTION get_clearance_expiration(@date_of_issue date, @hierarchy int)
RETURNS date
AS
BEGIN
    DECLARE @number_of_years int
	SELECT @number_of_years =
		CASE @hierarchy
			WHEN 200 THEN 10
			WHEN 300 THEN 7
			WHEN 400 THEN 5
			ELSE 100
		END
    RETURN DATEADD(DAY, -1, DATEADD(YEAR, @number_of_years, @date_of_issue));
END;