--zad1

CREATE OR REPLACE PROCEDURE  NowyPracownik(

    nIdPrac IN NUMBER,

    nNazwisko IN CHAR,

    nNazwaZespolu IN CHAR,

    nNazwiskoSzefa IN CHAR,

    nPlaca_pod IN NUMBER,

    nDataZatrudnienia IN DATE DEFAULT SYSDATE(),

    nEtat IN CHAR DEFAULT 'STAZYSTA'

) IS

BEGIN 

INSERT INTO  PRACOWNICY(ID_PRAC, NAZWISKO, ID_ZESP,ID_SZEFA,  PLACA_POD, ZATRUDNIONY,ETAT)

    VALUES( nIdPrac,

        nNazwisko,

        (SELECT ID_ZESP FROM ZESPOLY WHERE ID_ZESP=nNazwaZespolu),

        (SELECT ID_SZEFA FROM PRACOWNICY WHERE nazwisko=nNazwiskoSzefa),

        nPlaca_pod,

        nDataZatrudnienia,

        nEtat

    );

END NowyPracownik;


--zad2

CREATE OR REPLACE FUNCTION PlacaNetto(

    pensjaBrutto IN NUMBER,

    podatek IN NUMBER DEFAULT 20

) RETURN NUMBER IS

    res NUMBER;

BEGIN

    res := pensjaBrutto*(100-podatek)/100;

    RETURN res;

END;

 SELECT nazwisko, placa_pod AS BRUTTO,

 PlacaNetto(placa_pod, 35) AS NETTO

 FROM Pracownicy WHERE etat = 'PROFESOR' ORDER BY nazwisko;


 --zad3

 CREATE OR REPLACE FUNCTION SILNIA(

     num IN NUMBER

) RETURN NUMBER IS

    res NUMBER;

BEGIN

    res :=1;

    FOR x IN 1..num LOOP

        res := res*x;

    END LOOP;

    RETURN res;

END;

SELECT Silnia(8) FROM Dual;


--zad4

 CREATE OR REPLACE FUNCTION SILNIA_REK(

     num IN NUMBER

) RETURN NUMBER IS

    res NUMBER;

BEGIN

    IF num=0 THEN

        RETURN 1;

    ELSE 

        RETURN  SILNIA_REK(num-1)*num;

    END IF;

END;

SELECT Silnia_REK(8) FROM Dual;


--zad5

CREATE OR REPLACE FUNCTION IleLat(

    zat IN DATE

) RETURN NUMBER IS   

    res NUMBER;

BEGIN

    res := FLOOR((SYSDATE-zat)/365);

    RETURN res;

END;

SELECT nazwisko,zatrudniony,IleLat(ZATRUDNIONY) FROM PRACOWNICY WHERE placa_pod>1000 ORDER BY nazwisko;


--zad6

CREATE OR REPLACE PACKAGE Konwersja IS

 Function Cels_To_Fahr (cels NUMBER) 

    RETURN NUMBER;

 Function Fahrs_To_Cels (fahrs NUMBER) 

    RETURN NUMBER;

END Konwersja;


CREATE OR REPLACE PACKAGE BODY Konwersja IS

 Function Cels_To_Fahr (cels NUMBER) 

    RETURN NUMBER IS

    BEGIN

        RETURN 9/5*cels+32;

    END Cels_To_Fahr;

 Function Fahrs_To_Cels (fahrs NUMBER) 

    RETURN NUMBER IS

    BEGIN

        RETURN 5/9*(fahrs-32);

    END Fahrs_To_Cels;

END Konwersja;

SELECT Konwersja.Fahrs_To_Cels(212) AS CELSJUSZ FROM Dual;

 SELECT Konwersja.Cels_To_Fahr(0) AS FAHRENHEIT FROM Dual;


 --zad7

 CREATE OR REPLACE PACKAGE Zmienne IS

 PROCEDURE ZwiekszLicznik;

 PROCEDURE ZmniejszLicznik;

 FUNCTION PokazLicznik

    RETURN NUMBER;

END Zmienne;


CREATE OR REPLACE PACKAGE BODY Zmienne IS

    vLicznik NUMBER;

 PROCEDURE ZwiekszLicznik IS

    BEGIN

    vLicznik := vLicznik + 1;

    END;

PROCEDURE ZmniejszLicznik IS

    BEGIN

    vLicznik := vLicznik - 1;

    END;

FUNCTION PokazLicznik 

    RETURN NUMBER IS

    BEGIN

        RETURN vLicznik;

    END;

BEGIN

    vLicznik := 1;

    DBMS_OUTPUT.PUT_LINE('zaincjalizowano');

END Zmienne;


--zad8

 CREATE OR REPLACE PACKAGE IntZespoly IS

PROCEDURE addT(a IN NUMBER, b  IN CHAR, c IN CHAR);

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

CREATE OR REPLACE PACKAGE BODY IntZespoly IS

PROCEDURE addT(a IN NUMBER, b  IN CHAR, c IN CHAR) IS

    BEGIN

        INSERT INTO ZESPOLY(ID_ZESP, NAZWA, ADRES)

        VALUES(a, b, c);

    END;

PROCEDURE delT(idT IN NUMBER) IS

    BEGIN

        DELETE FROM ZESPOLY WHERE ID_ZESP=idT;

    END;

PROCEDURE delTByName(nameT IN CHAR) IS

    BEGIN

        DELETE FROM ZESPOLY WHERE NAZWA=nameT;

    END;

PROCEDURE updateT(idT IN NUMBER, nameT IN CHAR, adressT IN CHAR) IS

    BEGIN

        UPDATE ZESPOLY z

        SET z.NAZWA = nameT, z.ADRES = adressT WHERE ID_ZESP=idT;

    END;

FUNCTION getID (nameT IN CHAR) 

    RETURN NUMBER IS

    res NUMBER;

    BEGIN

        SELECT ID_ZESP INTO res FROM ZESPOLY WHERE nameT=NAZWA; 

    RETURN res;

    END;

FUNCTION getName (idT IN NUMBER)

    RETURN CHAR IS

    res CHAR;

    BEGIN

        SELECT NAZWA INTO res FROM ZESPOLY WHERE idT=ID_ZESP;

    RETURN res;

    END;

FUNCTION getAddress (idT IN NUMBER)

    RETURN CHAR IS

    res CHAR;

    BEGIN

        SELECT ADRES INTO res FROM ZESPOLY WHERE idT=ID_ZESP;

    RETURN res;

    END;

END IntZespoly;


--zad9

SELECT object_name, status FROM User_Objects WHERE object_type = 'PROCEDURE' ORDER BY object_name;

SELECT object_name, status FROM User_Objects WHERE object_type = 'FUNCTION' ORDER BY object_name;

SELECT object_name, object_type, status FROM User_Objects WHERE object_type IN ('PACKAGE', 'PACKAGE BODY') ORDER BY object_name;


SELECT text FROM User_Source WHERE name = 'NOWYPRACOWNIK' AND type = 'PROCEDURE' ORDER BY line;


--zad10

DROP PROCEDURE SILNIA;

DROP PROCEDURE Silnia_REK;

DROP FUNCTION IleLat;


--zad11

DROP PACKAGE BODY Konwersja;

DROP PACKAGE Konwersja;