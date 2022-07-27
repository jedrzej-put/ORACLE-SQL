/*

 * To change this license header, choose License Headers in Project Properties.

 * To change this template file, choose Tools | Templates

 * and open the template in the editor.

 */

package lab_jdbc;



/**

 *

 * @author DELL

 */

import java.sql.*;

import java.util.Properties;

import java.util.logging.Level;

import java.util.logging.Logger;



public class Lab_JDBC {



    /**

     * @param args the command line arguments

     */

    public static void main(String[] args) throws SQLException {

        // TODO code application logic here

        Connection conn = null;

        String connectionString =

        "jdbc:oracle:thin:@//admlab2.cs.put.poznan.pl:1521/"+

        "dblab02_students.cs.put.poznan.pl";

        Properties connectionProps = new Properties();

        connectionProps.put("user", "inf145286");

        connectionProps.put("password", "inf145286");

        try {

        conn = DriverManager.getConnection(connectionString,

        connectionProps);

        System.out.println("Połączono z bazą danych");

        } catch (SQLException ex) {

        Logger.getLogger(Lab_JDBC.class.getName()).log(Level.SEVERE,

        "Nie udało się połączyć z bazą danych", ex);

        System.exit(-1);

        } 

        

        

        ///====================================================================

//        try (Statement stmt = conn.createStatement();

//            ResultSet rs = stmt.executeQuery(

//            "select  rpad(id_prac, 5) AS res_id_prac, rPAD(nazwisko,25) AS res_nazwisko, placa_pod " +

//            "from pracownicy");) 

//        {

//            while (rs.next()) {

//                System.out.println(rs.getString("res_id_prac") + " " + rs.getString("res_nazwisko") + " " +

//                rs.getFloat(3));

//            }

//        } catch (SQLException ex) {

//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());

//        }

         

        //zad1

        System.out.println("\nzad1");

        try (Statement stmt1 = conn.createStatement();

            ResultSet rs1 = stmt1.executeQuery(

            "select  COUNT(*) AS liczba_pracownikow FROM pracownicy");

             

            Statement stmt2 = conn.createStatement();

            ResultSet rs2 = stmt2.executeQuery(

            "select  (SELECT nazwa FROM zespoly z WHERE z.id_zesp=p.id_zesp) AS nazwa_zespolu, COUNT(*) AS counter " +

            "from pracownicy  p GROUP BY id_zesp");

            ) 

        {

            rs1.next();

            System.out.println("Zatrudniono " + rs1.getString("liczba_pracownikow") + " pracownikow, w tym");

            while (rs2.next()) {

                System.out.println(rs2.getString("counter") + " w zespole "+ rs2.getString("nazwa_zespolu") );

            }

            rs1.close();

            stmt1.close();

            rs2.close();

            stmt2.close();

        } catch (SQLException ex) {

            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());

        }



        //zad2

        System.out.println("\nzad2");

         try (Statement stmt= conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,

                ResultSet.CONCUR_READ_ONLY);

            ResultSet rs = stmt.executeQuery(

            "SELECT nazwisko, (placa_pod + COALESCE(PLACA_DOD, 0)) AS pensja FROM PRACOWNICY WHERE etat='ASYSTENT' ORDER BY (placa_pod + COALESCE(PLACA_DOD, 0)) DESC");

            ) 

        {

            rs.last();

            System.out.println("zad2a Najmniej zarabia pracownik: " + rs.getString("nazwisko") + " : " + rs.getString("pensja") );

            rs.relative(-2); //ustaw na trzeciego od końca

            System.out.println("zad2b Trzeci najmniej zarabiajacy pracownik: " + rs.getString("nazwisko") + " : " + rs.getString("pensja") );

            rs.absolute(-2);

            System.out.println("zad2c Przedostatni najmniej zarabiajacy pracownik: " + rs.getString("nazwisko") + " : " + rs.getString("pensja") );

            stmt.close();

            rs.close();

        } catch (SQLException ex) {

            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());

        }

         

        //zad3

        System.out.println("\nzad3");

        try (Statement stmt1= conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,

            ResultSet.CONCUR_READ_ONLY);

            Statement stmt2 = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,

            ResultSet.CONCUR_UPDATABLE);

            ResultSet rs1 = stmt1.executeQuery("SELECT seq_id_prac.NEXTVAL AS newIdPrac  FROM (SELECT level from dual connect by level < 4)");) 

        {   

            int [] zwolnienia={150, 200, 230};

            String [] zatrudnienia={"Kandefer", "Rygiel", "Boczar"};

            

            //usuwanie

            for(int i=0;i<3;i++){

//                int changes = stmt2.executeUpdate(String.format("DELETE FROM pracownicy WHERE id_prac = %d", zwolnienia[i]));

            }

            //wstawianie

            for(int i=0;i<3;i++){

//                rs1.next();

//                int a = rs1.getInt("newIdPrac");

//                int changes = stmt2.executeUpdate(String.format("INSERT INTO pracownicy(id_prac,nazwisko) VALUES( %d,\'%s\')", a,zatrudnienia[i]));

            }

            stmt1.close();

            rs1.close();

            stmt2.close();

        } catch (SQLException ex) {

            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());

        }

         

        System.out.println("\nzad4");

        //zad4

        //zad4a

//        conn.setAutoCommit(false);

//        

//        try (Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,

//            ResultSet.CONCUR_UPDATABLE))

//        {

//            //zad4b

//            ResultSet rs = stmt.executeQuery("SELECT nazwa FROM etaty");

//            while(rs.next()){

//                System.out.println(rs.getString("nazwa"));

//            }

//            //zad4c

//            stmt.executeUpdate("INSERT INTO etaty(nazwa,placa_min,placa_max) VALUES('nowyEtat',100,200)");

//            

//            //zad4d

//            rs = stmt.executeQuery("SELECT nazwa FROM etaty");

//            while(rs.next()){

//                System.out.println(rs.getString("nazwa"));

//            }

//            //nowy etat pojawił się w bazie

//            

//            //zad4e

//            conn.rollback();

//            //zad4f

//            rs = stmt.executeQuery("SELECT nazwa FROM etaty");

//            while(rs.next()){

//                System.out.println(rs.getString("nazwa"));

//            }

//            //po wycofaniu transakcji nowyEtat zniknał z bazy

//            

//            //zad4g

//            stmt.executeUpdate("INSERT INTO etaty(nazwa,placa_min,placa_max) VALUES('nowyEtat',100,200)");

//            

//            //zad4h

//            conn.commit();

//            

//            //zad4i

//            rs = stmt.executeQuery("SELECT nazwa FROM etaty");

//            while(rs.next()){

//                System.out.println(rs.getString("nazwa"));

//            }

//            stmt.close();

//            rs.close();

//            

//        }catch (SQLException ex) {

//            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());

//        }

//        conn.rollback();

        

        

        //zad5

        //wstawianie pracownikow

//        String [] nazwiska={"Woźniak", "Dąbrowski", "Kozłowski"};

//        int [] place={400, 1000, 600};

//        String []etaty={"ASYSTENT", "PROFESOR", "ADIUNKT"};

//        

//        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO pracownicy(id_prac,nazwisko,placa_pod,etat) VALUES( ?,?,?,?)");

//        

//        for(int i=0; i<3; i++){

//            try (   Statement stmt1= conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,

//                    ResultSet.CONCUR_READ_ONLY);

//                    ResultSet rs1 = stmt1.executeQuery("SELECT seq_id_prac.NEXTVAL AS newIdPrac  FROM (SELECT level from dual connect by level < 4)");) 

//            {

//                

//                rs1.next();

//                int a = rs1.getInt("newIdPrac");

//                pstmt.setInt(1, a);//ustaw id

//                pstmt.setString(2, nazwiska[i]);//ustaw nazwisko

//                pstmt.setInt(3, place[i]);//ustaw place

//                pstmt.setString(4, etaty[i]);//ustaw etat

//                pstmt.executeUpdate();

//                stmt1.close();

//                rs1.close();

//            }catch (SQLException ex) {

//                System.out.println("Błąd wykonania polecenia: " + ex.getMessage());

//            }

//        }

//        pstmt.close();

        

        System.out.println("\nzad6");

        //zad6

//        // Wylaczenie automatycznych commitow

//        conn.setAutoCommit(false);

//        // Zmienne do testowania

//        int id = 4000;

//        String nazwisko = "Kowalskki";

//        int placa = 1000;

//        String etat = "PROFESOR";

//        // Wyrazenie SQL do wstawiania pracownika

//        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO pracownicy(id_prac, nazwisko, placa_pod, etat) VALUES(?,?,?,?)");

//        

//        long start = System.nanoTime();

//        

//        // sekwencyjny

//        for(int i = 0; i < 2000; i++){

//            pstmt.setInt(1, (id++));

//            pstmt.setString(2, nazwisko);

//            pstmt.setInt(3, placa);

//            pstmt.setString(4, etat);

//            pstmt.executeUpdate();

//        }

//        long czas = System.nanoTime() - start;

//        System.out.println("operacja sekwencyjna : " + czas);

//        start = System.nanoTime();

//        // Kod wsadowy

//        for(int i = 0; i < 2000; i++){

//            pstmt.setInt(1, id++);

//            pstmt.setString(2, nazwisko);

//            pstmt.setInt(3, placa);

//            pstmt.setString(4, etat);

//            pstmt.addBatch();

//        }

//        pstmt.executeBatch();

//        czas = System.nanoTime() - start;

//        System.out.println("operacja wsadowa: " + czas);

//      operacja sekwencyjna trwała: 43254442300

//      operacja wsadowa trwała: 74238700

         

        //zad7

        System.out.println("\nzad7");



//        CREATE OR REPLACE FUNCTION Lnn(

//            pID IN PRACOWNICY.ID_PRAC%TYPE,

//            pLastName OUT PRACOWNICY.NAZWISKO%TYPE

//        ) RETURN NUMBER IS

//        vRes NUMBER;

//        BEGIN

//            SELECT UPPER(SUBSTR(NAZWISKO, 1, 1)) || LOWER(SUBSTR(NAZWISKO, 2)) 

//            INTO pLastName

//            FROM PRACOWNICY

//            WHERE ID_PRAC = pID;

//            IF SQL%NOTFOUND THEN

//                vRes := 0;

//            ELSE

//                vRes := 1;

//            END IF;

//            RETURN vRes;

//        END;

        try (CallableStatement stmt = conn.prepareCall(

        "{? = call Lnn(?, ?)}")){

            stmt.setInt(2, 100);

            stmt.registerOutParameter(1, Types.INTEGER);

            stmt.registerOutParameter(3, Types.VARCHAR);

            

            stmt.execute();

            int check = stmt.getInt(1);

            if (check == 1){

                String result = stmt.getString(3);

                System.out.println(result);

            }else if (check == 0){

                System.out.println("Złe ID pracownika!");

            }

        }catch (SQLException ex) {

            System.out.println("Błąd wykonania polecenia: " + ex.getMessage());

        }



        // zamykanie połaczenia z baza

        try {

            conn.close();

        } 

        catch (SQLException ex) {

            Logger.getLogger(Lab_JDBC.class.getName()).log(Level.SEVERE, null, ex);

        }

        System.out.println("Zakonczono polaczenie");

    }

    

}

