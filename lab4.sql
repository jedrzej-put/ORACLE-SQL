set SERVEROUTPUT on;

show errors;


--zad1

CREATE TABLE DziennikOperacji(

    id_operacji NUMBER(6) GENERATED ALWAYS AS IDENTITY,

    data_realizacji DATE NOT NULL,

    typ_operacji CHAR(66) NOT NULL CONSTRAINT c1 CHECK(typ_operacji IN('UPDATE', 'INSERT', 'DELETE','ALTER')),

    nazwa_tabeli CHAR(7) NOT NULL CONSTRAINT c2 CHECK(nazwa_tabeli IN('zespoly')),

    liczba_rekordow NUMBER(5) NOT NULL CONSTRAINT c3 CHECK(liczba_rekordow >= 0),

    CONSTRAINT pk_DziennikOperacji PRIMARY KEY(id_operacji)

);

--wyzwalacz

CREATE OR REPLACE TRIGGER LogujOperacje 

    AFTER INSERT OR DELETE OR UPDATE ON ZESPOLY

DECLARE

 vKomunikat VARCHAR(50);

 vLicznik NUMBER(5);

BEGIN

CASE

 WHEN INSERTING THEN

 vKomunikat := 'INSERT';

 WHEN DELETING THEN

 vKomunikat := 'DELETE';

 WHEN UPDATING THEN

 vKomunikat := 'UPDATE!';

END CASE;

SELECT COUNT(*) INTO vLicznik FROM ZESPOLY; 

 INSERT INTO DziennikOperacji(data_realizacji, typ_operacji, nazwa_tabeli,liczba_rekordow)

 VALUES(CURRENT_DATE, vKomunikat, 'zespoly', vLicznik);

END;


--test

BEGIN

    INTZESPOLY.ADDT('as','pik');

END;

SELECT * FROM DziennikOperacji;




--zad2a

CREATE OR REPLACE TRIGGER PokazPlace

 BEFORE UPDATE OF placa_pod ON Pracownicy

 FOR EACH ROW

 WHEN (OLD.placa_pod <> NEW.placa_pod OR NEW.placa_pod IS NULL)

BEGIN

 DBMS_OUTPUT.PUT_LINE('Pracownik ' || :OLD.nazwisko);

 DBMS_OUTPUT.PUT_LINE('Płaca przed modyfikacją: ' || :OLD.placa_pod);

 DBMS_OUTPUT.PUT_LINE('Płaca po modyfikacji: ' || :NEW.placa_pod);

END;

--zad2b

CREATE OR REPLACE TRIGGER PokazPlace

 BEFORE UPDATE OF placa_pod ON Pracownicy

 FOR EACH ROW

 WHEN (OLD.placa_pod <> NEW.placa_pod OR (OLD.placa_pod IS NULL AND NEW.placa_pod IS NOT NULL))

BEGIN

 DBMS_OUTPUT.PUT_LINE('Pracownik ' || :OLD.nazwisko);

 DBMS_OUTPUT.PUT_LINE('Płaca przed modyfikacją: ' || :OLD.placa_pod);

 DBMS_OUTPUT.PUT_LINE('Płaca po modyfikacji: ' || :NEW.placa_pod);

END;


BEGIN

    NOWYPRACOWNIK(NNAZWISKO  => 'as121' /*IN VARCHAR2*/,

                  NNAZWAZESPOLU  => 'ALGORYTMY' /*IN VARCHAR2*/,

                  NNAZWISKOSZEFA  => 'MORZY' /*IN VARCHAR2*/,

                  NPLACA_POD  => NULL /*IN NUMBER(6,2)*/);

END;

SELECT * FROM PRACOWNICY;


--zad3

CREATE OR REPLACE TRIGGER UzupelnijPlace

 BEFORE INSERT OR UPDATE OF placa_pod  OR UPDATE OF placa_dod ON Pracownicy

 FOR EACH ROW

 WHEN (NEW.etat IS NOT NULL)

DECLARE

 vPlacaMin Etaty.placa_min%TYPE;

BEGIN

 SELECT placa_min

 INTO vPlacaMin

 FROM Etaty WHERE nazwa = :NEW.etat;

 IF :NEW.placa_pod IS NULL  THEN

    :NEW.placa_pod := vPlacaMin;

 END IF;

 IF :NEW.placa_dod IS NULL  THEN

    :NEW.placa_dod := 0;

 END IF;

END;


--zad4

CREATE OR REPLACE TRIGGER UzupelnijID

 BEFORE INSERT  ON Zespoly

 FOR EACH ROW

 WHEN (NEW.id_zesp IS NULL)

BEGIN

    :NEW.id_zesp := SEQ_ZESP.nextval;

END;


--zad5

CREATE OR REPLACE VIEW Szefowie(szef, liczba_pracownikow) AS

    SELECT (SELECT p.nazwisko FROM pracownicy p WHERE p.id_prac = pp.id_szefa) AS szef, COUNT(*) 

    FROM PRACOWNICY pp GROUP BY pp.id_szefa ORDER BY szef; 


SELECT * FROM Szefowie;

 SELECT * FROM Pracownicy WHERE id_prac = 140 OR id_szefa = 140;

 DELETE FROM Szefowie WHERE szef='WEGLARZ';


--wyzwalacz

 CREATE OR REPLACE TRIGGER ZamiastDelete 

 INSTEAD OF DELETE ON Szefowie

 DECLARE

    vSzef PRACOWNICY.ID_PRAC%TYPE;

    CURSOR cPracownicy(xIdSzefa NUMBER) IS 

        SELECT id_prac FROM PRACOWNICY

        WHERE id_szefa = xIdSzefa;

    vTmp NUMBER;

BEGIN

    SELECT id_prac INTO vSzef FROM pracownicy WHERE :OLD.szef = nazwisko;

    

    FOR vPrac IN cPracownicy(vSzef) LOOP

        SELECT COUNT(*) INTO vTmp FROM pracownicy WHERE vPrac.id_prac=id_szefa;

        IF vTmp>0 THEN 

            RAISE_APPLICATION_ERROR( -20001, 'Jeden z podwładnych

usuwanego pracownika jest szefem innych pracowników. Usuwanie anulowane!');

        END IF;

        DELETE FROM pracownicy WHERE vPrac.id_prac = id_prac;

    END LOOP;

    DELETE FROM pracownicy WHERE vSzef = id_prac;

END;

SELECT * FROM PRACOWNICY;

SELECT * FROM Szefowie;


--test

BEGIN

    NOWYPRACOWNIK(NNAZWISKO  => 'qwer2' /*IN VARCHAR2*/,

                  NNAZWAZESPOLU  => 'ALGORYTMY' /*IN VARCHAR2*/,

                  NNAZWISKOSZEFA  => 'qwer1' /*IN VARCHAR2*/,

                  NPLACA_POD  => NULL /*IN NUMBER(6,2)*/);

END;


SELECT * FROM PRACOWNICY;

SELECT * FROM Szefowie;

 SELECT * FROM pracownicy

 WHERE id_prac = 140 OR id_szefa = 140;

DELETE  FROM Szefowie WHERE szef='MORZY';


--zad6

DROP TRIGGER LogujOperacje;

ALTER TABLE ZESPOLY ADD liczba_pracownikow NUMBER;

UPDATE ZESPOLY z1 

    SET LICZBA_PRACOWNIKOW

        =(SELECT t2.counter 

        FROM (SELECT p.id_zesp, COUNT(*) AS counter FROM pracownicy  p GROUP BY p.id_zesp) t2

        WHERE z1.id_zesp = t2.id_zesp);

 SELECT * FROM Zespoly;

 --wyzwalacz

 CREATE OR REPLACE TRIGGER PoPoleceniu

 AFTER INSERT OR DELETE OR UPDATE OF id_zesp ON Pracownicy

 FOR EACH ROW

BEGIN

    CASE

    WHEN INSERTING THEN

        UPDATE zespoly SET LICZBA_PRACOWNIKOW=LICZBA_PRACOWNIKOW + 1 WHERE :NEW.id_zesp = id_zesp; 

    WHEN DELETING THEN

        UPDATE zespoly SET LICZBA_PRACOWNIKOW=LICZBA_PRACOWNIKOW - 1 WHERE :OLD.id_zesp = id_zesp; 

    WHEN UPDATING THEN

        UPDATE zespoly SET LICZBA_PRACOWNIKOW=LICZBA_PRACOWNIKOW + 1 WHERE :NEW.id_zesp = id_zesp; 

        UPDATE zespoly SET LICZBA_PRACOWNIKOW=LICZBA_PRACOWNIKOW - 1 WHERE :OLD.id_zesp = id_zesp;

 END CASE;

END;

SELECT * FROM ZESPOLY;

 INSERT INTO Pracownicy(id_prac, nazwisko, id_zesp, id_szefa)

 VALUES(300,'NOWY PRACOWNIK',40,120);

 UPDATE Pracownicy SET id_zesp = 10 WHERE id_zesp = 30



 --zad7

 ALTER TABLE PRACOWNICY DROP CONSTRAINT FK_ID_SZEFA;

 ALTER TABLE PRACOWNICY ADD CONSTRAINT FK_ID_SZEFA FOREIGN KEY(id_szefa) REFERENCES pracownicy(id_prac) ON DELETE CASCADE;

 

CREATE OR REPLACE TRIGGER UsunPrac

BEFORE DELETE ON Pracownicy

FOR EACH ROW

BEGIN

    DBMS_OUTPUT.PUT_LINE(:Old.nazwisko);

END;

DELETE FROM PRACOWNICY WHERE NAZWISKO='MORZY';

--after szef na koncu

--before szef na poczatku


ROLLBACK;

SELECT * FROM PRACOWNICY;


--zad8

ALTER TABLE PRACOWNICY ENABLE ALL TRIGGERS;

 SELECT trigger_name, trigger_type, triggering_event, table_name,

 when_clause,status

 FROM User_Triggers

 WHERE table_name IN ('PRACOWNICY')

 ORDER BY table_name, trigger_name;

 SELECT trigger_name,table_name, status FROM USER_TRIGGERS;


--zad9 

SELECT trigger_name, status, table_name

FROM User_Triggers

WHERE table_name IN ('PRACOWNICY', 'ZESPOLY') 

ORDER BY table_name, trigger_name;


DECLARE 

    vTmp VARCHAR(100);

    CURSOR cTrigg IS 

        SELECT trigger_name, status, table_name

        FROM User_Triggers

        WHERE table_name IN ('PRACOWNICY', 'ZESPOLY') 

        ORDER BY table_name, trigger_name;

BEGIN

    FOR trig IN cTrigg LOOP

        vTmp := 'DROP TRIGGER ' || trig.trigger_name;

        EXECUTE IMMEDIATE (vTmp);

    END LOOP;

END;