--zadanie  1
SELECT * FROM opt_pracownicy WHERE id_prac = 900;
--zadanie  2
SELECT /*+ FULL(opt_pracownicy) */ *
FROM opt_pracownicy WHERE id_prac = 900;
--zadanie 3
SELECT /*+ FULL(opt_pracownicy) */ *
FROM opt_pracownicy p
WHERE id_prac = 900;
SELECT /*+ FULL(p) */ *
FROM opt_pracownicy p
WHERE id_prac = 900;
--zadanie 4
SELECT /*+ NO_INDEX(opt_pracownicy) */ *
FROM opt_pracownicy
WHERE id_prac = 900;
SELECT /*+ NO_INDEX(opt_pracownicy opt_prac_pk) */ *
FROM opt_pracownicy
WHERE id_prac = 900;
--zadanie 5
SELECT nazwisko, etat FROM opt_pracownicy;
SELECT /*+ INDEX(opt_pracownicy) */ nazwisko, etat
FROM opt_pracownicy;
--zadanie  6
SELECT /*+ INDEX_COMBINE(opt_pracownicy) */ nazwisko, etat
FROM opt_pracownicy;
--zadanie  7
SELECT placa
FROM opt_pracownicy
WHERE plec = 'K';
SELECT /*+ INDEX_FFS(opt_pracownicy) */ placa
FROM opt_pracownicy
WHERE plec = 'K';

--zadanie  8
SELECT /*+ INDEX_SS(opt_pracownicy) */ placa
FROM opt_pracownicy
WHERE plec = 'K';

--zadanie  9
SELECT /*+ INDEX_JOIN(opt_pracownicy
 opt_prac_pk opt_prac_nazw_placa_idx) */
 nazwisko
FROM opt_pracownicy
WHERE id_prac < 1000 AND placa = 1500; 

--Wskazówki w zapytaniach z połączeniami
--zadanie adanie 1
SELECT p.nazwisko, z.nazwa, e.placa_min, e.placa_max
FROM opt_pracownicy p JOIN opt_zespoly z USING(id_zesp)
 JOIN opt_etaty e ON p.etat = e.nazwa;
--zadanie  2
SELECT /*+ LEADING(p e) */ 
 p.nazwisko, z.nazwa, e.placa_min, e.placa_max
FROM opt_pracownicy p JOIN opt_zespoly z USING(id_zesp)
 JOIN opt_etaty e ON p.etat = e.nazwa;
--zadanie adanie 3 samodzilene
SELECT /*+ LEADING(z e) */ 
 p.nazwisko, z.nazwa, e.placa_min, e.placa_max
FROM opt_pracownicy p JOIN opt_zespoly z USING(id_zesp)
 JOIN opt_etaty e ON p.etat = e.nazwa;
 
--------------------------------------------------------------------------------
---------
| Id  | Operation             | Name           | Rows  | Bytes | Cost (%CPU)|
 Time     |
--------------------------------------------------------------------------------
---------
|   0 | SELECT STATEMENT      |                | 10000 |   527K|    29   (0)|
 00:00:01 |
|*  1 |  HASH JOIN            |                | 10000 |   527K|    29   (0)|
 00:00:01 |
|   2 |   MERGE JOIN CARTESIAN|                |    60 |  1980 |    12   (0)|
 00:00:01 |
|   3 |    TABLE ACCESS FULL  | OPT_ZESPOLY    |     5 |    90 |     3   (0)|
 00:00:01 |
|   4 |    BUFFER SORT        |                |    12 |   180 |     9   (0)|
 00:00:01 |
|   5 |     TABLE ACCESS FULL | OPT_ETATY      |    12 |   180 |     2   (0)|
 00:00:01 |
|   6 |   TABLE ACCESS FULL   | OPT_PRACOWNICY | 10000 |   205K|    17   (0)|
 00:00:01 |
--------------------------------------------------------------------------------
---------

--zadanie  4
SELECT p.nazwisko, z.nazwa, e.placa_min, e.placa_max
FROM opt_pracownicy p JOIN opt_etaty e ON p.etat = e.nazwa
 JOIN opt_zespoly z USING(id_zesp);
 
 SELECT /*+ ORDERED */ 
 p.nazwisko, z.nazwa, e.placa_min, e.placa_max
FROM opt_pracownicy p JOIN opt_etaty e ON p.etat = e.nazwa
 JOIN opt_zespoly z USING(id_zesp);
 --zadanie adanie 5 samodzilene
SELECT /*+ ORDERED */ 
 p.nazwisko, z.nazwa, e.placa_min, e.placa_max
FROM  opt_zespoly z CROSS JOIN opt_etaty e  JOIN opt_pracownicy p  ON p.etat = e.nazwa AND z.id_zesp=p.id_zesp;
 --Transformacje
 --zadanie 1
 SELECT id_prac, id_zesp
FROM opt_pracownicy JOIN opt_zespoly;
--zadanie 2
SELECT nazwisko
FROM opt_pracownicy
WHERE id_zesp IN
 (SELECT id_zesp FROM opt_zespoly WHERE nazwa = 'Bazy Danych');

--zadanie  3
SELECT nazwisko, srednia
FROM opt_pracownicy JOIN 
 (SELECT AVG(placa) AS srednia, id_zesp FROM opt_pracownicy
 GROUP BY id_zesp) z USING(id_zesp)
WHERE placa > srednia;

SELECT /*+ MERGE(z) */ nazwisko, srednia
FROM opt_pracownicy JOIN 
 (SELECT AVG(placa) AS srednia, id_zesp FROM opt_pracownicy
 GROUP BY id_zesp) z USING(id_zesp)
WHERE placa > srednia;

--zadanie  4
SELECT /*+ NO_QUERY_TRANSFORMATION */
id_prac, id_zesp
FROM opt_pracownicy JOIN opt_zespoly USING(id_zesp);

-------------------------------------------------------------------------------
-------
| Id  | Operation           | Name           | Rows  | Bytes | Cost (%CPU)|
 Time     |
--------------------------------------------------------------------------------
-------
|   0 | SELECT STATEMENT    |                | 10000 |   253K|    20   (0)|
 00:00:01 |
|   1 |  VIEW               |                | 10000 |   253K|    20   (0)|
 00:00:01 |
|*  2 |   HASH JOIN         |                | 10000 |    97K|    20   (0)|
 00:00:01 |
|   3 |    TABLE ACCESS FULL| OPT_ZESPOLY    |     5 |    15 |     3   (0)|
 00:00:01 |
|   4 |    TABLE ACCESS FULL| OPT_PRACOWNICY | 10000 | 70000 |    17   (0)|
 00:00:01 |
--------------------------------------------------------------------------------
-------

 Predicate Information (identified by operation id):
 ---------------------------------------------------

    2 - access("OPT_PRACOWNICY"."ID_ZESP"="OPT_ZESPOLY"."ID_ZESP")

STATISTICS-----------------------------------------------------------
      2039 recursive calls
       152 db block gets
      2430 consistent gets
        45 physical reads
     10672 redo size
    218848 bytes sent via SQL*Net to client
     23998 bytes received via SQL*Net from client
        60 SQL*Net roundtrips to/from client
        42 sorts (memory)
         0 sorts (disk)
10 rows selected.

SELECT /*+ NO_QUERY_TRANSFORMATION */ 
nazwisko FROM opt_pracownicy
WHERE id_zesp IN
 (SELECT id_zesp FROM opt_zespoly WHERE nazwa = 'Bazy Danych');

-------------------------------------------------------------------------------
------
| Id  | Operation          | Name           | Rows  | Bytes | Cost (%CPU)| Time
     |
--------------------------------------------------------------------------------
------
|   0 | SELECT STATEMENT   |                |  2000 | 24000 |    32   (0)|
 00:00:01 |
|*  1 |  FILTER            |                |       |       |            |
     |
|   2 |   TABLE ACCESS FULL| OPT_PRACOWNICY | 10000 |   117K|    17   (0)|
 00:00:01 |
|*  3 |   TABLE ACCESS FULL| OPT_ZESPOLY    |     1 |    18 |     3   (0)|
 00:00:01 |
--------------------------------------------------------------------------------
------

 Predicate Information (identified by operation id):
 ---------------------------------------------------

    1 - filter( EXISTS (SELECT 0 FROM "OPT_ZESPOLY" "OPT_ZESPOLY" WHERE
               "ID_ZESP"=:B1 AND "NAZWA"='Bazy Danych'))
    3 - filter("ID_ZESP"=:B1 AND "NAZWA"='Bazy Danych')

STATISTICS-----------------------------------------------------------
      1624 recursive calls
       129 db block gets
      2370 consistent gets
        45 physical reads
      9304 redo size
    190115 bytes sent via SQL*Net to client
     18016 bytes received via SQL*Net from client
        45 SQL*Net roundtrips to/from client
        36 sorts (memory)
         0 sorts (disk)
10 rows selected.
no rows selected


