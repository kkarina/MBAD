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
    private static Statement stmt, st;
    private static ResultSet rs;


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

    public void selectFromProxOut() throws Exception {
        String query = "select t.*, (t.next_time - t.\"timestamp\") time_difference\n" +
                "from\n" +
                "(\n" +
                "select p.*,\n" +
                " LEAD(\"timestamp\") OVER(partition by employee_id ORDER BY null) next_time\n" +
                "from mbad.proxout p\n" +
                ")t\n" +
                ";";
        stmt = con.createStatement();
        //st= con. createStatement();

        try {
            rs  = stmt.executeQuery(query);
            while(rs.next())
                System.out.println(rs.getString("employee_id")+rs.getString("timestamp")+"   " + rs.getString("time_difference"));

         /*   rs.next();
            String sequence = "";
            String employee  = rs.getString("employee_id");
            Timestamp Tstart= rs.getTimestamp("Tstart");
            do {
                 if (rs.getString("duration").compareTo("00:02:00") <=0){
                     if (sequence != rs.getString("zone1"))
                         sequence = sequence + rs.getString("zone1") + rs.getString("zone2") + ", ";
                     else
                         sequence = rs.getString("zone1") + rs.getString("zone2") + ", ";
                 }
                 else {
                     query = "insert into mbad.sequences (employee_id, tstart, tend, sequence, duration)" +
                             "values ('" + employee + "', '" + Tstart + "', '" +
                             rs.getTimestamp("Tend") + "', '" + sequence.replaceAll("\\s+", " ") + "', '" +
                             rs.getString("duration") + "');";
                     Tstart= rs.getTimestamp("Tend");
                     st.executeUpdate(query);
                     sequence = rs.getString("zone2");
                 }

             //employee = rs.getString("employee_id");


             }while (rs.next());*/

        }catch (SQLException e) { e.printStackTrace();
        }


    }
}
