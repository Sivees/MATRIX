USE Matrix
GO

CREATE INDEX idx_nation_polish_name ON tbl_nation(polish_name);
CREATE INDEX idx_military_rank_hierarchy ON tbl_military_rank(hierarchy);
CREATE INDEX idx_person_last_name ON tbl_person(last_name);
CREATE INDEX idx_person_pesel ON tbl_person(pesel);