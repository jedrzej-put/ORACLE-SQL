--zad1
DECLARE
    CURSOR cPracownicy IS
        SELECT *
        FROM Pracownicy
        WHERE etat='ASYSTENT'
        ORDER BY nazwisko;
    vPracownik pracownicy%ROWTYPE;
BEGIN
    OPEN cPracownicy;
    LOOP
        FETCH cPracownicy INTO vPracownik;
        EXIT WHEN cPracownicy%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vPracownik.nazwisko ||' pracuje od '|| vPracownik.zatrudniony);
    END LOOP;
    CLOSE cPracownicy;
END;

--zad2
DECLARE
    CURSOR cPracownicy IS
        SELECT * FROM (
            SELECT *
            FROM Pracownicy
            ORDER BY (placa_pod + COALESCE(placa_dod,0))DESC
        ) WHERE ROWNUM <=3;

BEGIN
    FOR vPracownik IN cPracownicy LOOP
        DBMS_OUTPUT.PUT_LINE(cPracownicy%ROWCOUNT|| ' : ' ||vPracownik.nazwisko);
    END LOOP;
END;


--zad3
DECLARE
    CURSOR cPracownicy IS
        SELECT *
        FROM Pracownicy
        ORDER BY nazwisko
        FOR UPDATE OF placa_pod;
BEGIN
    FOR vPracownik IN cPracownicy LOOP
        IF to_char(to_date(to_number(to_char(vPracownik.zatrudniony, 'j')),'j'),'d')=2 THEN
            -- Zwiększ pensję profesorowiz poniedzialeku o 20%
            UPDATE Pracownicy
                SET placa_pod = placa_pod * 1.2
            WHERE CURRENT OF cPracownicy;
        END IF;
    END LOOP;
END;

SELECT nazwisko,placa_pod,zatrudniony FROM pracownicy WHERE to_char(to_date(to_number(to_char(zatrudniony, 'j')),'j'),'d')=2 ;

--zad4
DECLARE
    CURSOR cPracownicyZespoly IS
        SELECT nazwisko, etat, PLACA_DOD, nazwa
        FROM Pracownicy JOIN ZESPOLY USING(id_zesp)
        ORDER BY nazwisko
        FOR UPDATE OF nazwisko;
BEGIN
    FOR vPracownik IN cPracownicyZespoly LOOP
        IF  vPracownik.nazwa='ALGORYTMY' THEN
            UPDATE Pracownicy
                SET placa_dod = placa_dod + 100
            WHERE CURRENT OF cPracownicyZespoly;
        ELSIF vPracownik.nazwa='ADMINISTRACJA' THEN
            UPDATE Pracownicy
                SET placa_dod = placa_dod + 150
            WHERE CURRENT OF cPracownicyZespoly;
        ELSIF vPracownik.etat LIKE 'STAZYSTA' THEN
            DELETE FROM PRACOWNICY
            WHERE CURRENT OF cPracownicyZespoly;
        END IF;
    END LOOP;
END;
SELECT nazwisko, placa_dod, etat, nazwa FROM PRACOWNICY JOIN ZESPOLY USING(id_zesp);

--zad5
CREATE OR REPLACE PROCEDURE PokazPracownikowEtatu(pEtat IN CHAR) IS
    CURSOR cPracownicy(pTmp CHAR) IS
        SELECT nazwisko, etat
        FROM Pracownicy
        --WHERE  pEtat=ETAT
        ORDER BY nazwisko
        FOR UPDATE;
BEGIN
    FOR vPracownik IN cPracownicy(pEtat) LOOP
        IF  vPracownik.etat=pEtat THEN
        DBMS_OUTPUT.PUT_LINE(vPracownik.nazwisko);
        END IF;
    END LOOP;
END PokazPracownikowEtatu;
EXEC PokazPracownikowEtatu('PROFESOR');

--zad6
CREATE OR REPLACE PROCEDURE RaportKadrowy IS
    CURSOR cEtat IS
        SELECT nazwa
        FROM ETATY
        ORDER BY nazwa
        FOR UPDATE;

    CURSOR cPracownicy(pEtat CHAR) IS
        SELECT nazwisko, placa_pod, placa_dod,etat
        FROM Pracownicy
        ORDER BY nazwisko
        FOR UPDATE;
    vSumSalary  pracownicy.placa_pod%TYPE;
    vCounter POSITIVE;
BEGIN
    FOR vEtat IN cEtat LOOP
        vSumSalary := 0;
        vCounter := 1;
        DBMS_OUTPUT.PUT_LINE('Etat: '||vEtat.nazwa);
        DBMS_OUTPUT.PUT_LINE('-----------------------');

        FOR vPracownik IN cPracownicy(vEtat.nazwa) LOOP
            IF  vPracownik.etat = vEtat.nazwa THEN
                DBMS_OUTPUT.PUT_LINE(vCounter || '. ' || vPracownik.nazwisko || ', pensja: ' || (vPracownik.placa_pod + COALESCE(vPracownik.placa_dod, 0)) );
                vCounter := vCounter + 1;
                vSumSalary := vSumSalary + vPracownik.placa_pod + COALESCE(vPracownik.placa_dod, 0);
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE( 'Liczba pracowników: ' || vCounter);
       
        IF vCounter > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Średnia pensja: ' || vSumSalary/(vCounter-1));
        ELSE
            DBMS_OUTPUT.PUT_LINE('BRAK');
        END IF;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END RaportKadrowy;
EXEC RaportKadrowy;


zad7
CREATE OR REPLACE PACKAGE IntZespoly IS
PROCEDURE addT(b  IN CHAR, c IN CHAR);
PROCEDURE delT(idT IN NUMBER);
PROCEDURE delTByName(nameT IN CHAR);
PROCEDURE updateT(idT IN NUMBER, nameT IN CHAR, adressT IN CHAR);
FUNCTION getID (nameT IN CHAR)
    RETURN NUMBER;
FUNCTION getName (idT IN NUMBER)
    RETURN CHAR;
FUNCTION getAddress (idT IN NUMBER)
    RETURN CHAR;
END IntZespoly;
--
CREATE SEQUENCE seqIdZesp START WITH 60 INCREMENT BY 10;
CREATE OR REPLACE PACKAGE BODY IntZespoly IS
PROCEDURE addT( b  IN CHAR, c IN CHAR) IS
    BEGIN
        INSERT INTO ZESPOLY(ID_ZESP, NAZWA, ADRES)
        VALUES(seqIdZesp.NEXTVAL, b, c);
        IF SQL%FOUND THEN
            DBMS_OUTPUT.PUT_LINE ('Dodanych rekordów: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie udalo się dodać zespolu !');
        END IF;
    END;
PROCEDURE delT(idT IN NUMBER) IS
    BEGIN
        DELETE FROM ZESPOLY WHERE ID_ZESP=idT;
        IF SQL%FOUND THEN
            DBMS_OUTPUT.PUT_LINE ('Usuniętych rekordów: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie udalo się usunąć zespolu !');
        END IF;
    END;
PROCEDURE delTByName(nameT IN CHAR) IS
    BEGIN
        DELETE FROM ZESPOLY WHERE NAZWA=nameT;
        IF SQL%FOUND THEN
            DBMS_OUTPUT.PUT_LINE ('Usuniętych rekordów: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie udalo się usunąć zespolu !');
        END IF;
    END;
PROCEDURE updateT(idT IN NUMBER, nameT IN CHAR, adressT IN CHAR) IS
    BEGIN
        UPDATE ZESPOLY z
        SET z.NAZWA = nameT, z.ADRES = adressT WHERE ID_ZESP=idT;
        IF SQL%FOUND THEN
            DBMS_OUTPUT.PUT_LINE ('Zmodyfikowanych rekordów: '|| SQL%ROWCOUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE ('Nie udalo się zmodyfiikować zespolu !');
        END IF;
    END;
FUNCTION getID (nameT IN CHAR)
    RETURN NUMBER IS
    res NUMBER;
    BEGIN
        SELECT ID_ZESP INTO res FROM ZESPOLY WHERE nameT=NAZWA;
    RETURN res;
    END getID;
FUNCTION getName (idT IN NUMBER)
    RETURN CHAR IS
    res CHAR;
    BEGIN
        SELECT NAZWA INTO res FROM ZESPOLY WHERE idT=ID_ZESP;
    RETURN res;
    END getName;
FUNCTION getAddress (idT IN NUMBER)
    RETURN CHAR IS
    res CHAR;
    BEGIN
        SELECT ADRES INTO res FROM ZESPOLY WHERE idT=ID_ZESP;
    RETURN res;
    END getAddress;
END IntZespoly;

BEGIN
    INTZESPOLY.ADDT('bec', 'hha');
END;
BEGIN
    INTZESPOLY.DELTBYNAME('bec');
END;
SELECT * FROM ZESPOLY;






--zad8
CREATE OR REPLACE PACKAGE IntZespoly IS
PROCEDURE addT(b  IN CHAR, c IN CHAR);
PROCEDURE delT(idT IN NUMBER);
PROCEDURE delTByName(nameT IN CHAR);
PROCEDURE updateT(idT IN NUMBER, nameT IN CHAR, adressT IN CHAR);
FUNCTION getID (nameT IN CHAR)
    RETURN NUMBER;
FUNCTION getName (idT IN NUMBER)
    RETURN CHAR;
FUNCTION getAddress (idT IN NUMBER)
    RETURN CHAR;

--deklaracja wyjatkow
exIdZespNotExist EXCEPTION;
exNameZespNotExist EXCEPTION;
exIdZespDup EXCEPTION;
PRAGMA EXCEPTION_INIT(exIdZespNotExist, -1111);
PRAGMA EXCEPTION_INIT(exNameZespNotExist, -1112);
PRAGMA EXCEPTION_INIT(exIdZespDup, -1113);
vCheck NUMBER := 0;
VTmp NUMBER := 0;
END IntZespoly;
--
CREATE SEQUENCE seqIdZesp START WITH 60 INCREMENT BY 10;
CREATE OR REPLACE PACKAGE BODY IntZespoly IS
PROCEDURE addT( b  IN CHAR, c IN CHAR) IS
    BEGIN
    vTmp := seqIdZesp.NEXTVAL;
        SELECT COUNT(*) INTO vCheck FROM ZESPOLY WHERE id_zesp = vTmp;
            IF vCheck>0 THEN
                RAISE exIdZespDup;
            END IF;
        INSERT INTO ZESPOLY(ID_ZESP, NAZWA, ADRES)
        VALUES(seqIdZesp.CURRVAL, b, c);
    END;
PROCEDURE delT(idT IN NUMBER) IS
    BEGIN
        SELECT COUNT(*) INTO vCheck FROM ZESPOLY WHERE id_zesp = idT;
            IF vCheck=0 THEN
                RAISE exIdZespNotExist;
            END IF;
        DELETE FROM ZESPOLY WHERE ID_ZESP=idT;
    END;
PROCEDURE delTByName(nameT IN CHAR) IS
    BEGIN
        SELECT COUNT(*) INTO vCheck FROM ZESPOLY WHERE NAZWA=nameT;
        IF vCheck=0 THEN
            RAISE exNameZespNotExist;
        END IF;
        DELETE FROM ZESPOLY WHERE NAZWA=nameT;
    END;
PROCEDURE updateT(idT IN NUMBER, nameT IN CHAR, adressT IN CHAR) IS
    BEGIN
        SELECT COUNT(*) INTO vCheck FROM ZESPOLY WHERE id_zesp = idT;
        IF vCheck=0 THEN
            RAISE exIdZespNotExist;
        END IF;
        UPDATE ZESPOLY z
        SET z.NAZWA = nameT, z.ADRES = adressT WHERE ID_ZESP=idT;
    END;
FUNCTION getID (nameT IN CHAR)
    RETURN NUMBER IS
    res NUMBER;
    BEGIN
        SELECT COUNT(*) INTO vCheck FROM ZESPOLY WHERE NAZWA=nameT;
            IF vCheck=0 THEN
                RAISE exNameZespNotExist;
            END IF;
        SELECT ID_ZESP INTO res FROM ZESPOLY WHERE nameT=NAZWA;
    RETURN res;
    END getID;
FUNCTION getName (idT IN NUMBER)
    RETURN CHAR IS
    res CHAR;
    BEGIN
        SELECT COUNT(*) INTO vCheck FROM ZESPOLY WHERE id_zesp = idT;
                IF vCheck=0 THEN
                    RAISE exIdZespNotExist;
                END IF;
        SELECT NAZWA INTO res FROM ZESPOLY WHERE idT=ID_ZESP;
    RETURN res;
    END getName;
FUNCTION getAddress (idT IN NUMBER)
    RETURN CHAR IS
    res CHAR;
    BEGIN
        SELECT COUNT(*) INTO vCheck FROM ZESPOLY WHERE id_zesp = idT;
                IF vCheck=0 THEN
                    RAISE exIdZespNotExist;
                END IF;
        SELECT ADRES INTO res FROM ZESPOLY WHERE idT=ID_ZESP;
    RETURN res;
    END getAddress;

END IntZespoly;

--test
BEGIN
    -- INTZESPOLY.UPDATET(IDT  => 14 /*IN NUMBER*/,
    --                    NAMET  => 'sds' /*IN CHAR*/,
    --                    ADRESST  => 'sdsd' /*IN CHAR*/);
    INTZESPOLY.DELTBYNAME('bec');
EXCEPTION
    WHEN INTZESPOLY.exIdZespNotExist THEN
        DBMS_OUTPUT.PUT_LINE('Podano ID nieistniejącego zespołu!'||SQLCODE);
    WHEN INTZESPOLY.exNameZespNotExist THEN
        DBMS_OUTPUT.PUT_LINE('Podano nazwę nieistniejącego zespołu!'||SQLCODE);
    WHEN INTZESPOLY.exIdZespDup THEN
        DBMS_OUTPUT.PUT_LINE('Duplikacja ID zesp!');
END;


SELECT * FROM ZESPOLY;