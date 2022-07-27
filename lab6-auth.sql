SELECT * FROM pracownicy;
//zad1
//145402
SELECT * FROM inf145402.pracownicy;

//zad2
GRANT SELECT ON pracownicy TO inf145402;

//zad3
SELECT * FROM inf145402.pracownicy;

//zad4
GRANT UPDATE(placa_pod,placa_dod) ON pracownicy TO inf145402;

//zad5
UPDATE inf145402.pracownicy SET placa_pod=2*placa_pod;//tak
UPDATE inf145402.pracownicy SET placa_pod=2000  WHERE nazwisko='MORZY';//tak
UPDATE inf145402.pracownicy SET placa_dod=700;//tak

//zad6
CREATE SYNONYM pracDominika FOR inf145402.PRACOWNICY;
UPDATE pracDominika SET placa_dod=800;
COMMIT;

//zad7
SELECT * FROM pracDominika;

//zad8
select owner, table_name, grantee, grantor, privilege
from user_tab_privs;
select table_name, grantee, grantor, privilege
from user_tab_privs_made;
select owner, table_name, grantor, privilege
from user_tab_privs_recd;
select owner, table_name, column_name, grantee, grantor, privilege
from user_col_privs;
select table_name, column_name, grantee, grantor, privilege
from user_col_privs_made;
select owner, table_name, column_name, grantor, privilege
from user_col_privs_recd;

//zad9
REVOKE UPDATE  ON PRACOWNICY FROM inf145402;
UPDATE pracDominika SET placa_dod=800;//brak uprawnien
//zad10
CREATE ROLE ROLA_145402 IDENTIFIED BY 001;
GRANT SELECT, UPDATE ON PRACOWNICY TO ROLA_145402;
//zad11
GRANT ROLA_145402 TO inf145402;
SELECT * FROM pracDominika;//nie dziala bez wlaczenia roli
//zad12
SET ROLA_145286;
select granted_role, admin_option from user_role_privs
where username = 145286;
select role, owner, table_name, column_name, privilege
from role_tab_privs;
//zad13
REVOKE ROLA_145402 FROM PRACOWNICY;
SELECT * FROM pracDominika;
//zad14
SELECT * FROM pracDominika;//nie dziala
//zad15
UPDATE pracDominika SET placa_pod = 1000 WHERE nazwisko='MORZY';//nie dzila bo brak roli
//zad16
GRANT ROLA_145402 TO inf145402;
UPDATE pracDominika SET placa_pod = 1000 WHERE nazwisko='MORZY';//nie dzila bo rola nie wlaczona
//zad17
UPDATE pracDominika SET placa_pod = 1000 WHERE nazwisko='MORZY';//dziala po ponownym dolaczeniu
//zad18
REVOKE  UPADATE ON pracownicy FROM ROLA_145402;
UPDATE pracDominika SET placa_pod = 1000 WHERE nazwisko='MORZY';//nie dziala, rola nie ma przywoiileju
//zad19
DROP ROLA_145402;
//zad20
SELECT * FROM user_sys_privs;
GRANT SELECT ON PRACOWNICY TO inf145402 WITH GRANT OPTION;
GRANT SELECT ON pracDominika TO inf145280;//uzytkownik C;
//zad21
select owner, table_name, grantee, grantor, privilege
from user_tab_privs;
select table_name, grantee, grantor, privilege
from user_tab_privs_made;
select owner, table_name, grantor, privilege
from user_tab_privs_recd;
select owner, table_name, column_name, grantee, grantor, privilege
from user_col_privs;
select table_name, column_name, grantee, grantor, privilege
from user_col_privs_made;
select owner, table_name, column_name, grantor, privilege
from user_col_privs_recd;
//zad22
REVOKE SELECT ON pracownicy FROM inf145280;//nie moge odebrac
REVOKE SELECT ON PRACOWNICY FROM inf145402;//odbieram kaskadowo
//zad23
CREATE VIEW prac20 (nazwisko,placa_pod) AS SELECT nazwisko,placa_pod FROM PRACOWNICY WHERE id_zesp=20;

GRANT SELECT,UPDATE ON prac20 TO inf145402;
SELECT * FROM PRACOWNICY;
UPDATE inf145402.prac20 SET placa_pod=1000 WHERE nazwisko='MORZY';

//zad24
CREATE OR REPLACE FUNCTION funLiczEtaty
    RETURN NUMBER IS
    vTMP NUMBER;
BEGIN
    SELECT  COUNT(*) INTO vTMP FROM etaty;
    RETURN vTMP;
END;
GRANT EXECUTE ON funLiczEtaty TO inf145402;
//zad25
SELECT inf145402.funLiczEtaty FROM dual;
SELECT COUNT(*) FROM inf145402.etaty;

//zad26
CREATE OR REPLACE FUNCTION funLiczEtaty
    RETURN NUMBER AUTHID CURRENT_USER  IS
    vTMP NUMBER;
BEGIN
    SELECT  COUNT(*) INTO vTMP FROM etaty;
    RETURN vTMP;
END;

//zad27
SELECT inf145402.funLiczEtaty FROM dual;//tak rozni sie bo dziala na mojej relacji

//zad28
INSERT INTO etaty VALUES('WYKLADOWCA', 1000,2000);
SELECT * FROM etaty;
COMMIT;

//zad29
SELECT inf145402.funLiczEtaty FROM dual;

//zad30
CREATE  TABLE test  (id number(2), tekst varchar2(20));
INSERT INTO test VALUES (1,'pierwszy');
INSERT INTO test VALUES (2, 'drugi');
CREATE OR REPLACE PROCEDURE procPokazTest AUTHID CURRENT_USER IS
    vRes CHAR;
BEGIN
    FOR vRes IN (SELECT tekst FROM test) LOOP
        DBMS.OUTPUT.PUTLINE(vRes.tekst);
    END LOOP;
END;
GRANT EXECUTE ON procPokazTest TO inf145402;
GRANT SELECT ON test TO inf145402;
--zad31
DROP TABLE test;
EXECUTE inf145402.procPokazTest;//nie mozna bo relacja nie istnieje, mozna zmienic definiowanie procedury lub stworzyc lokalna relacje test
SET SERVEROUTPUT ON;
COMMIT;
SELECT * FROM test;

--zad32
CREATE TABLE info_dla_znajomych (nazwa VARCHAR2(20) NOT NULL,
info VARCHAR2(200) NOT NULL);
INSERT INTO info_dla_znajomych VALUES('nazwa1','info1');
CREATE VIEW info4u(nazwa, info) AS
    SELECT nazwa,info
    FROM info_dla_znajomych
    WHERE nazwa=(SELECT user FROM dual);
GRANT SELECT ON info4u TO PUBLIC;
SELECT * FROM inf145402.info4u;