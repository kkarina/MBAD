/**
 * Created by afashokova on 01.03.2017.
 */
import java.sql.*;
import com.opencsv.CSVReader;
import java.io.FileReader;


public class InsertIntoTables {
    private static final String url = "jdbc:postgresql://localhost:5432/postgres";
    private static final String user = "postgres";
    private static final String password = "123";
    private static Connection con;
    private static Statement stmt;


    public Connection Connetion() {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        try {
            con = DriverManager.getConnection(url, user, password);
            return con;
        } catch (SQLException sqlEx)  {
            sqlEx.printStackTrace();

        }
        return con;
    }

    public void insertIntoProxOut() throws Exception {
        String query;
        CSVReader reader = new CSVReader(new FileReader("data/proxout.csv"), ' ');
        reader.readNext();
        stmt = con.createStatement();
        String[] stringOfData;
        while ((stringOfData = reader.readNext()) != null){
            query = "insert into mbad.proxout" +
                    "(\"timestamp\", employee_id, zone) " +
                    "values ('" + stringOfData[0] +' '+ stringOfData[1] + "' ,'" + stringOfData[2] + "' ,'" +stringOfData[3] +"');";
            try {
                stmt.executeUpdate(query);
            } catch (SQLException e){
                e.printStackTrace();
                }
            //System.out.println(query);
        }
    }

    public void insertIntoEmployee() throws Exception {
        String query;
        CSVReader reader = new CSVReader(new FileReader("data/EmployeeList.csv"), ',');
        reader.readNext();
        stmt = con.createStatement();
        String[] stringOfData;
        while ((stringOfData = reader.readNext())!=null) {
            query = "insert into mbad.employee " +
                    "(id, department, office) " +
                    "values ('" + stringOfData[0] + "', '" + stringOfData[1] + "', '" +stringOfData[2] + "');";
            try{
                stmt.executeUpdate(query);
            } catch (SQLException e){
                e.printStackTrace();
            }
        }
    }

    public void insertIntoIdZone() throws Exception {
        String query;
        CSVReader reader = new CSVReader(new FileReader("data/id_zone.csv"), ' ');
        stmt = con.createStatement();
        String[] stringOfData;
        int i = 0;
        while ((stringOfData = reader.readNext()) != null){
            query = "insert into mbad.zone_id" +
                    "(id, zone) " +
                    "values ('" + i + "', '"+stringOfData[0] +"');";
            try {
                stmt.executeUpdate(query);
            } catch (SQLException e){
                e.printStackTrace();
            }
            i++;
        }
    }


    public Connection closeConnect() throws Exception {
        try {
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }


}
