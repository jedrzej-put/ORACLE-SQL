set SERVEROUTPUT on;
show errors;

SELECT nazwisko, nazwa
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp);

EXPLAIN PLAN FOR
SELECT nazwisko, nazwa
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp);
SELECT * FROM TABLE(dbms_xplan.display());

EXPLAIN PLAN
SET STATEMENT_ID = 'zap_2_145286' FOR
SELECT etat, ROUND(AVG(placa),2)
FROM opt_pracownicy
GROUP BY etat ORDER BY etat;
SELECT *
FROM TABLE(dbms_xplan.display(statement_id => 'zap_2_145286',format => 'BASIC'));

--zad1
SELECT *
FROM TABLE(dbms_xplan.display(statement_id => 'zap_2_145286',format => 'TYPICAL'));

--zad2
SELECT *
FROM TABLE(dbms_xplan.display(statement_id => 'zap_2_145286',format => 'ALL'));

---cz2
SELECT etat, ROUND(AVG(placa),2)
FROM opt_pracownicy
GROUP BY etat ORDER BY etat;
SET AUTOTRACE ON EXPLAIN;
SET AUTOTRACE ON STATISTICS;
SET AUTOTRACE ON;
SET AUTOTRACE OFF;

SELECT nazwa, COUNT(*)
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp)
GROUP BY nazwa
ORDER BY nazwa;
SELECT * FROM TABLE(dbms_xplan.display_cursor());

SELECT sql_text, sql_id,
to_char(last_active_time, 'yyyy.mm.dd hh24:mi:ss')
as last_active_time,
parsing_schema_name
FROM v$sql
WHERE sql_text LIKE
'SELECT nazwa%opt_pracownicy JOIN opt_zespoly%ORDER BY nazwa'
AND sql_text NOT LIKE '%v$sql%';


--z1
SELECT  /*q3_inf145286  */*
FROM opt_pracownicy
ORDER BY placa + COALESCE(placa_dod, 0) DESC
FETCH FIRST 1 ROWS ONLY;

SELECT /* q4_inf145286 */ plec,COUNT(*), AVG(placa + COALESCE(placa_dod, 0)) FROM OPT_PRACOWNICY GROUP BY PLEC;

--zad2
SELECT sql_id
FROM v$sql
WHERE sql_text LIKE '%q3_inf145286%'
AND sql_text NOT LIKE '%v$sql%';

SELECT sql_id
FROM v$sql
WHERE sql_text LIKE '%q4_inf145286%'
AND sql_text NOT LIKE '%v$sql%';

--zad3
SELECT *
FROM TABLE(dbms_xplan.display_cursor(
sql_id => '3fjw4xatssj15',
format => 'BASIC +ROWS +BYTES'));

SELECT *
FROM TABLE(dbms_xplan.display_cursor(
sql_id => 'gwz3mz1hk24tz',
format => 'BASIC +ROWS +BYTES +PREDICATE'));

SELECT *
FROM TABLE(dbms_xplan.display_cursor(
sql_id => '3fjw4xatssj15', format => 'BASIC'));

--zad4
INSERT INTO /* q5_inf145286 */OPT_PRACOWNICY (ID_PRAC, NAZWISKO) VALUES (11111,'11111');
DELETE FROM/* q6_inf145286 */ OPT_PRACOWNICY WHERE ID_PRAC=11111;
--zad5
commit;
--zad6
SELECT sql_id
FROM v$sql
WHERE sql_text LIKE '%q5_inf145286%'
AND sql_text NOT LIKE '%v$sql%';

SELECT sql_id
FROM v$sql
WHERE sql_text LIKE '%q6_inf145286%'
AND sql_text NOT LIKE '%v$sql%';

SELECT *
FROM TABLE(dbms_xplan.display_cursor(
sql_id => '751gayy5xk56f', format => 'BASIC'));

SELECT *
FROM TABLE(dbms_xplan.display_cursor(
sql_id => 'f49q9kj96gsz9', format => 'BASIC'));