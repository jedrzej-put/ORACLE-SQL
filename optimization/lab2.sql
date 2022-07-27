set AUTOCOMMIT OFF;
set SERVEROUTPUT on;
show errors;

BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY');
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_ZESPOLY');
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_ETATY');
END;

SELECT index_name, index_type
FROM user_indexes
WHERE table_name = 'OPT_PRACOWNICY';

SELECT blocks
FROM user_tables
WHERE table_name = 'OPT_PRACOWNICY';

SELECT dbms_rowid.rowid_block_number(rowid) AS blok,
 COUNT(*) AS liczba_rekordow
FROM opt_pracownicy
GROUP BY dbms_rowid.rowid_block_number(rowid)
ORDER BY blok;

SET AUTOTRACE ON;
SET AUTOTRACE ON STATISTICS;
SELECT nazwisko, placa
FROM opt_pracownicy WHERE id_prac = 10;


SET AUTOTRACE OFF;
SELECT nazwisko, placa, ROWID
FROM opt_pracownicy WHERE id_prac = 10;

SELECT nazwisko, placa
FROM opt_pracownicy
WHERE ROWID = 'AABDggAAcAAAM7gAAs';

--METODY DOSTEPU DO INDEKSOW B-DRZEWO
CREATE INDEX opt_id_prac_idx
 ON opt_pracownicy(id_prac);

SELECT index_name, index_type, uniqueness
FROM user_indexes
WHERE table_name = 'OPT_PRACOWNICY';

SELECT column_name, column_position
FROM user_ind_columns
WHERE index_name = 'OPT_ID_PRAC_IDX'
ORDER BY column_position;

BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY');
END;

SELECT nazwisko, placa
FROM opt_pracownicy WHERE id_prac = 10;

DROP INDEX opt_id_prac_idx;

ALTER TABLE opt_pracownicy
 ADD CONSTRAINT opt_prac_pk PRIMARY KEY(id_prac);

SELECT index_name, index_type, uniqueness
FROM user_indexes
WHERE table_name = 'OPT_PRACOWNICY';

--zad1
SELECT nazwisko, placa
FROM opt_pracownicy WHERE id_prac < 10;
--nadal używa OPT_PRAC_PK ale z INDEX_RANGE_SCAN

CREATE INDEX opt_prac_nazw_idx ON opt_pracownicy(nazwisko);

BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY');
END;

SELECT * FROM opt_pracownicy WHERE nazwisko = 'Prac155'; -- opt_prac_nazw_idx uzyty
SELECT * FROM opt_pracownicy WHERE nazwisko LIKE 'Prac155%';-- opt uzyty 2 - access("NAZWISKO" LIKE 'Prac155%') filter("NAZWISKO" LIKE 'Prac155%')
SELECT * FROM opt_pracownicy WHERE nazwisko LIKE '%Prac155%'; -- full access   1 - filter("NAZWISKO" LIKE '%Prac155%' AND "NAZWISKO" IS NOT NULL)

--w 3 bo z % na poczatku nazwisko moze byc wszystkim i indeks nic nie daje
SELECT *
FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%' OR nazwisko LIKE 'Prac255%';

BEGIN
 DBMS_STATS.DELETE_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY');
END;

--cw7
SELECT *
FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%' OR nazwisko LIKE 'Prac255%';

BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY');
END;
SELECT /*+ USE_CONCAT */ *
FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%' OR nazwisko LIKE 'Prac255%';

SELECT *
FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%' OR nazwisko LIKE 'Prac255%';

SELECT * FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%'
UNION ALL
SELECT * FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac255%';
--koszt 15

SELECT * FROM opt_pracownicy
WHERE nazwisko IN ('Prac155','Prac255');

SELECT nazwisko, placa, id_prac
FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%' AND placa > 1000;

DROP INDEX opt_prac_nazw_idx;
CREATE INDEX opt_prac_nazw_placa_idx ON
 opt_pracownicy(nazwisko, placa);

SELECT index_name, table_name, index_type, uniqueness
FROM user_indexes
WHERE index_name = 'OPT_PRAC_NAZW_PLACA_IDX';

SELECT column_name, column_position
FROM user_ind_columns
WHERE index_name = 'OPT_PRAC_NAZW_PLACA_IDX'
ORDER BY column_position;
BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY');
END;

--cw10
SELECT nazwisko, placa, id_prac
FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%' AND placa > 1000;

SELECT nazwisko, placa, id_prac
FROM opt_pracownicy WHERE nazwisko LIKE 'Prac155%';

SELECT nazwisko, placa, id_prac
FROM opt_pracownicy WHERE placa < 200;

SELECT nazwisko, placa
FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%';

SELECT nazwisko, placa
FROM opt_pracownicy
WHERE nazwisko LIKE 'Prac155%';

--zad14
CREATE INDEX opt_prac_placa_dod_idx ON
 opt_pracownicy( PLACA_DOD);
SELECT placa_dod FROM opt_pracownicy WHERE placa_dod IS NULL;
SELECT placa_dod FROM opt_pracownicy WHERE placa_dod IS NOT NULL;
-- dla rekordow gdzie placa_dod is not null zostal utworzony indeks i sa one w drzwie, drugie zapytanie moze je odnalezc po przez przgldaniecie lisci

--zad15
CREATE INDEX opt_prac_plec_placa_idx ON opt_pracownicy (plec, placa);
BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY');
END;
SELECT plec, nazwisko FROM opt_pracownicy p
WHERE placa > 2500;

--zad16
SELECT placa, etat FROM opt_pracownicy
WHERE nazwisko = 'Prac155';

SELECT placa, etat FROM opt_pracownicy
WHERE UPPER(nazwisko) = 'PRAC155';

-- 3 do 17
CREATE INDEX opt_prac_fun_idx ON opt_pracownicy(UPPER(nazwisko));

BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY');
END;

SELECT placa, etat FROM opt_pracownicy
WHERE UPPER(nazwisko) = 'PRAC155';
--  INDEX RANGE SCAN                  | OPT_PRAC_FUN_IDX

--zad17
SELECT nazwisko
FROM opt_pracownicy
WHERE id_prac < 500 AND nazwisko LIKE 'Prac15%';

--METODY DOSTEPOW DO INDEKSOW BITMAPOWYCh
SELECT DISTINCT plec FROM opt_pracownicy;
SELECT DISTINCT etat FROM opt_pracownicy;
CREATE BITMAP INDEX opt_prac_etat_bmp_idx ON opt_pracownicy(etat);
CREATE BITMAP INDEX opt_prac_plec_bmp_idx ON opt_pracownicy(plec);

SELECT index_name, table_name, index_type, uniqueness
FROM user_indexes
WHERE index_name IN
 ('OPT_PRAC_ETAT_BMP_IDX', 'OPT_PRAC_PLEC_BMP_IDX');

 SELECT index_name, column_name, column_position
FROM user_ind_columns
WHERE index_name IN
 ('OPT_PRAC_ETAT_BMP_IDX', 'OPT_PRAC_PLEC_BMP_IDX')
ORDER BY index_name, column_position;

BEGIN
 DBMS_STATS.GATHER_TABLE_STATS(ownname => 'inf145286',
 tabname => 'OPT_PRACOWNICY',
 method_opt => 'FOR COLUMNS plec SIZE auto, etat SIZE auto',
 cascade => TRUE);
END;

SELECT COUNT(*) FROM opt_pracownicy
WHERE plec = 'K' AND etat = 'DYREKTOR';

SELECT COUNT(*) FROM opt_pracownicy
WHERE plec = 'K' AND (etat = 'DYREKTOR' OR etat = 'PROFESOR');

SELECT nazwisko FROM opt_pracownicy
WHERE plec = 'K' AND etat = 'DYREKTOR';

--zad6
SELECT nazwisko FROM opt_pracownicy
WHERE plec = 'K' AND etat IS NULL;

--SORTOWANIE
SELECT id_zesp, nazwa
FROM opt_zespoly
ORDER BY id_zesp;

ALTER TABLE opt_zespoly
 ADD CONSTRAINT opt_zesp_pk PRIMARY KEY(id_zesp);

 ALTER TABLE opt_zespoly DROP CONSTRAINT opt_zesp_pk;

 SELECT id_zesp
FROM opt_zespoly
ORDER BY id_zesp;

SELECT nazwisko, placa
FROM opt_pracownicy WHERE id_prac < 10
ORDER BY id_prac;

SELECT nazwisko, placa
FROM opt_pracownicy WHERE id_prac < 10
ORDER BY id_prac DESC;

SELECT DISTINCT placa_dod
FROM opt_pracownicy;

SELECT placa_dod, COUNT(*)
FROM opt_pracownicy
GROUP BY placa_dod;

SELECT SUM(placa)
FROM opt_pracownicy;