SET AUTOTRACE OFF;
--1
BEGIN
DBMS_STATS.DELETE_TABLE_STATS(ownname => 'inf145286',
tabname => 'OPT_PRACOWNICY');
END;

--2
SELECT num_rows, last_analyzed, avg_row_len, blocks
FROM user_tables
WHERE table_name = 'OPT_PRACOWNICY';

SELECT column_name, num_distinct, low_value, high_value
FROM user_tab_col_statistics
WHERE table_name = 'OPT_PRACOWNICY';

SELECT index_name, num_rows, leaf_blocks, last_analyzed
FROM user_indexes
WHERE table_name = 'OPT_PRACOWNICY';

--zad3
BEGIN
DBMS_STATS.GATHER_TABLE_STATS(
ownname=>'inf145286', tabname => 'OPT_PRACOWNICY');
END;

BEGIN
DBMS_STATS.GATHER_TABLE_STATS(
ownname=>'inf145286', tabname => 'OPT_PRACOWNICY',
estimate_percent => 40);
END;

SELECT num_rows, last_analyzed, avg_row_len, blocks, sample_size
FROM user_tables
WHERE table_name = 'OPT_PRACOWNICY';

--zad6
SET AUTOTRACE ON;
SELECT * FROM opt_pracownicy WHERE nazwisko LIKE 'Prac155%';

--zad8
BEGIN
DBMS_STATS.GATHER_TABLE_STATS(
ownname=>'inf145286', tabname => 'OPT_PRACOWNICY',
cascade => TRUE);
END;

--HISTOGRAMY
SELECT column_name, num_distinct, low_value, high_value,
num_buckets, histogram
FROM user_tab_col_statistics
WHERE table_name = 'OPT_PRACOWNICY'
ORDER BY column_name;

SELECT endpoint_number, endpoint_value, endpoint_repeat_count
FROM user_histograms
WHERE table_name = 'OPT_PRACOWNICY'
AND column_name = 'ETAT'
ORDER BY endpoint_number;

SELECT num_distinct, num_buckets, histogram
FROM user_tab_col_statistics
WHERE table_name = 'OPT_PRACOWNICY'
AND column_name = 'PLACA_DOD';

SELECT placa_dod, COUNT(*)
FROM opt_pracownicy
GROUP BY placa_dod;

SELECT num_distinct, num_buckets, histogram
FROM user_tab_col_statistics
WHERE table_name = 'OPT_PRACOWNICY'
AND column_name = 'PLACA_DOD';

SELECT index_name, num_rows, leaf_blocks, last_analyzed
FROM user_indexes
WHERE table_name = 'OPT_PRACOWNICY';

--zad4
BEGIN
DBMS_STATS.DELETE_INDEX_STATS( ownname => 'inf145286', indname => 'OPT_PRAC_PLACA_DOD_IDX');
END;
DROP INDEX opt_prac_placa_dod_idx;
CREATE BITMAP INDEX opt_prac_placa_dod_bmp_idx
ON opt_pracownicy(placa_dod);

--zad5
SELECT * FROM opt_pracownicy WHERE placa_dod = 100; --acess full msli ze odfiltruje 5000
SELECT * FROM opt_pracownicy WHERE placa_dod = 999;--acess full mslyli ze odfiltruje 5000

--zad6
BEGIN
DBMS_STATS.GATHER_TABLE_STATS(
ownname => 'inf145286', tabname => 'OPT_PRACOWNICY',
method_opt => 'FOR COLUMNS placa_dod SIZE AUTO');
END;


SELECT num_distinct, num_buckets, histogram
FROM user_tab_col_statistics
WHERE table_name = 'OPT_PRACOWNICY'
AND column_name = 'PLACA_DOD';

--po utworzeniu histogramu optymalizator ma widza jak dobierac metoda wykonania polecen
--FREQUENCY
SELECT * FROM opt_pracownicy WHERE placa_dod = 100; --access full, wie ze pobierze 9999
SELECT * FROM opt_pracownicy WHERE placa_dod = 999; --przez index szuka tylko 1