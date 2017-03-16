/**
 * Created by afashokova on 01.03.2017.
 */

import com.opencsv.CSVReader;

import java.io.FileReader;
import java.sql.*;


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
        } catch (SQLException sqlEx) {
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
        while ((stringOfData = reader.readNext()) != null) {
            query = "insert into mbad.proxout" +
                    "(\"timestamp\", employee_id, zone) " +
                    "values ('" + stringOfData[0] + ' ' + stringOfData[1] + "' ,'" + stringOfData[2] + "' ,'" + stringOfData[3] + "');";
            try {
                stmt.executeUpdate(query);
            } catch (SQLException e) {
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
        while ((stringOfData = reader.readNext()) != null) {
            query = "insert into mbad.employee " +
                    "(id, department, office) " +
                    "values ('" + stringOfData[0] + "', '" + stringOfData[1] + "', '" + stringOfData[2] + "');";
            try {
                stmt.executeUpdate(query);
            } catch (SQLException e) {
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
        while ((stringOfData = reader.readNext()) != null) {
            query = "insert into mbad.zone_id" +
                    "(id, zone) " +
                    "values ('" + i + "', '" + stringOfData[0] + "');";
            try {
                stmt.executeUpdate(query);
            } catch (SQLException e) {
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
        String query = "SELECT x.timestamp as Tstart, y.timestamp as Tend, (y.timestamp - x.timestamp) as duration, x.employee_id, x.zone as zone1, y.zone as zone2\n" +
                " FROM mbad.proxout x \n" +
                " join mbad.proxout y\n" +
                " on x.employee_id = y.employee_id  \n" +
                " and y.timestamp = (select min(y2.timestamp) \n" +
                "             from mbad.proxout y2 \n" +
                "             where x.employee_id=y2.employee_id and x.timestamp<y2.timestamp);";


        try {
            stmt = con.createStatement();
            st = con.createStatement();
            rs = stmt.executeQuery(query);
            rs.next();
            String sequence = "";
            String employee = rs.getString("employee_id");
            Timestamp Tstart = rs.getTimestamp("Tstart");
            do {
                if (employee.compareTo(rs.getString("employee_id")) == 0){
                if ((rs.getString("duration").compareTo("00:02:00") <= 0)){
                    if (sequence.compareTo(rs.getString("zone1"))!=0)
                            sequence = sequence + rs.getString("zone1") + rs.getString("zone2") + ", ";
                    else
                        sequence = rs.getString("zone1") + rs.getString("zone2") + ", ";}
                     else {

                    query = "insert into mbad.sequences (employee_id, tstart, tend, sequence, duration)" +
                            "values ('" + employee + "', '" + Tstart + "', '" +
                            rs.getTimestamp("Tend") + "', '" + sequence.replaceAll("\\s+", " ").replaceAll(" ,", ",").trim() + "', '" +
                            rs.getString("duration") + "');";
                    Tstart = rs.getTimestamp("Tend");
                    st.executeUpdate(query);
                    sequence = rs.getString("zone2");
                    employee = rs.getString("employee_id");
                }
                    else
                }




            } while (rs.next());

        } catch (SQLException e) {
            e.printStackTrace();
        }


    }
}
