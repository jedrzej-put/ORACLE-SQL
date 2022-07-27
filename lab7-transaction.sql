--zad1

SELECT * FROM PRACOWNICY;

SET AUTOCOMMIT OFF;



--zad2

UPDATE PRACOWNICY SET etat='ADIUNKT' WHERE nazwisko='MATYSIAK';

--zad3

DELETE FROM PRACOWNICY WHERE etat='ASYSTENT';

--zad4

SELECT * FROM PRACOWNICY;--zmiany sie dokonaly

--zad5

ROLLBACK;--zmiany zostaly anulowane



--DDL

--zad1

UPDATE pracownicy SET PLACA_POD=PLACA_POD*1.1 WHERE etat='ADIUNKT';

--zad2

ALTER TABLE pracownicy MODIFY placa_dod NUMBER(7,2);

--zad3

ROLLBACK;



--punkty bezpieczenstwa

--zad1

UPDATE PRACOWNICY SET placa_dod=placa_dod+200 WHERE nazwisko='MORZY';

--zad2

SAVEPOINT S1;

--zad3

UPDATE PRACOWNICY SET placa_dod=100 WHERE nazwisko='BIALY';

--zad4

SAVEPOINT S2;

--zad5

DELETE FROM pracownicy WHERE nazwisko='JEZIERSKI';

--zad6

ROLLBACK TO S1;--operacje PO!!!! S1 zostaly wycofane

SELECT * FROM pracownicy;--

--zad7

ROLLBACK TO S2;--wycofanie nie zadzialalo

--zad8

ROLLBACK;

--zad9

--zakonczenie polaczenia

--zad1

SELECT * FROM PRACOWNICY;

SET AUTOCOMMIT OFF;



--zad2

UPDATE PRACOWNICY SET etat='ADIUNKT' WHERE nazwisko='MATYSIAK';

--zad3

DELETE FROM PRACOWNICY WHERE etat='ASYSTENT';

--zad4

SELECT * FROM PRACOWNICY;--zmiany sie dokonaly

--zad5

ROLLBACK;--zmiany zostaly anulowane



--DDL

--zad1

UPDATE pracownicy SET PLACA_POD=PLACA_POD*1.1 WHERE etat='ADIUNKT';

--zad2

ALTER TABLE pracownicy MODIFY placa_dod NUMBER(7,2);

--zad3

ROLLBACK;



--punkty bezpieczenstwa

--zad1

UPDATE PRACOWNICY SET placa_dod=placa_dod+200 WHERE nazwisko='MORZY';

--zad2

SAVEPOINT S1;

--zad3

UPDATE PRACOWNICY SET placa_dod=100 WHERE nazwisko='BIALY';

--zad4

SAVEPOINT S2;

--zad5

DELETE FROM pracownicy WHERE nazwisko='JEZIERSKI';

--zad6

ROLLBACK TO S1;--operacje PO!!!! S1 zostaly wycofane

SELECT * FROM pracownicy;--

--zad7

ROLLBACK TO S2;--wycofanie nie zadzialalo

--zad8

ROLLBACK;

--zad9