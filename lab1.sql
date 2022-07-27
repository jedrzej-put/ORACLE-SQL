-- zad1 zad2

DECLARE

  vTekst VARCHAR2(100) :='Witaj, świecie!';

  vLiczba Number(22,3) := 1000.456;

BEGIN

  vTekst := vTekst || ' Witaj, nowy dniu';

  vLiczba := vLiczba + POWER(10,15);

  DBMS_OUTPUT.PUT_LINE('Zmienna vTekst:' || vtekst);

  DBMS_OUTPUT.PUT_LINE('Zmienna vLiczba:' || vliczba);

END;


-- zad3

DECLARE

  vLiczba1 Number(9,7) := 10.2356000;

  vLiczba2 Number(8,7) := 0.0000001;

  vLiczba3 NUMBER;

BEGIN

  vLiczba3 := vLiczba1 + vLiczba2;

  DBMS_OUTPUT.PUT_LINE('Wynik dodawania '||vLiczba1 || ' i ' || vLiczba2 || ': ' ||vLiczba3);

END;


-- zad4

DECLARE

  cPI CONSTANT Number(3,2) := 3.14;

   radius NUMBER := 5;

   circle Number;

   area Number;

BEGIN

  circle := 2*cpi*radius;

  area := cpi*radius*radius;

  DBMS_OUTPUT.PUT_LINE('Obwód kola o promieniu '||radius || ': ' || circle);

  DBMS_OUTPUT.PUT_LINE('Pole kola o promieniu '||radius || ': ' || area);

END;


-- zad5

DECLARE

  vNazwisko Pracownicy.nazwisko%TYPE;

  vEtat Pracownicy.etat%TYPE;

BEGIN

  SELECT nazwisko, etat INTO vNazwisko, vEtat FROM Pracownicy  p WHERE   (p.placa_pod + COALESCE(p.placa_dod, 0))=(SELECT MAX(pp.placa_pod + COALESCE(pp.placa_dod, 0)) FROM Pracownicy pp);

  DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik: ' || vNazwisko);

  DBMS_OUTPUT.PUT_LINE('Pracuje jako :'|| vEtat);

END;


-- zad6

DECLARE

  vPracownik Pracownicy%ROWTYPE;

BEGIN

  SELECT * INTO vPracownik FROM Pracownicy  p WHERE   (p.placa_pod + COALESCE(p.placa_dod, 0))=(SELECT MAX(pp.placa_pod + COALESCE(pp.placa_dod, 0)) FROM Pracownicy pp);

  DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik: ' || vPracownik.nazwisko);

  DBMS_OUTPUT.PUT_LINE('Pracuje jako :'|| vPracownik.etat);

END;


-- zad7

DECLARE

  SUBTYPE tPieniadze IS

    Number;

    ans tPieniadze;

BEGIN

  SELECT 12*(p.placa_pod + COALESCE(p.placa_dod, 0)) INTO ans FROM Pracownicy  p WHERE p.nazwisko LIKE 'SLOWINSKI';

  DBMS_OUTPUT.PUT_LINE('Pracownik SLOWINSKI zarabia rocznie: ' || ans);

END;


-- zad8

DECLARE

   sec CONSTANT Number := 25;

   tmp Number;

   

BEGIN

  LOOP

    IF sec = TO_CHAR(SYSDATE,'ss')  THEN

        EXIT;

    END IF;

  END LOOP;

  

  

  dbms_output.put_line('nadeszla 25 sekunda');

END;


-- zad9

DECLARE

   tmp Number:= 10;

   vSilnia Number:=1;

   

BEGIN

  FOR ind IN 1..tmp LOOP

    vSilnia := vSilnia*ind;

  END LOOP;

  

  

  dbms_output.put_line('silnia 10:'|| vSilnia);

END;

-- zad10

--zad10

DECLARE

num_start number;

num_end number;

str_business varchar2(80);

date_buss date;

tmp varchar2(100);

tmp2 varchar2(100);

BEGIN

num_start := to_number(to_char (to_date('2001-01-01','yyyy-mm-dd'), 'j'));

num_end := to_number(to_char (to_date('2100-12-31','yyyy-mm-dd'), 'j'));


for cur_r in num_start..num_end loop

    str_business := to_char(to_date(cur_r,'j'),'dd-mm-yyyy');

    date_buss := to_date(cur_r, 'j');

    tmp := EXTRACT( day FROM date_buss);

    tmp2 := to_char(date_buss,'d');

    IF tmp2 = 5 AND tmp = 13 THEN

        DBMS_OUTPUT.put_line(str_business);

    END IF;

end loop;

dbms_output.put_line('koniec');

END;