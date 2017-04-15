/**
 * Created by afashokova on 01.03.2017.
 */

import com.opencsv.CSVReader;

import java.io.FileReader;
import java.sql.*;
import java.text.DecimalFormat;


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
        CSVReader reader = new CSVReader(new FileReader("data/prox.csv"), ';');
        reader.readNext();
        stmt = con.createStatement();
        String[] stringOfData;
        String duration;
        while ((stringOfData = reader.readNext()) != null) {

            if (stringOfData[3].trim().isEmpty())
            duration = "0";
            else duration = stringOfData[3].trim();

            query = "insert into mbad.proxout" +
                    "(employee_id,zone,wd,duration,time) " +
                    "values ('" + stringOfData[0].trim() + "','" + stringOfData[1].trim() + "' ,'" + stringOfData[2].trim() + "' ,'" + duration + "' ,'" + stringOfData[4].trim() +"');";
            try {
                stmt.executeUpdate(query);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            //System.out.println(query);
        }
    }

    public void InsertIntoAvgDuration() throws Exception {
        String query;
        CSVReader reader = new CSVReader(new FileReader("data/avgDuration.csv"), ';');
        reader.readNext();
        stmt = con.createStatement();
        String[] stringOfData;
        String avgDuration, numberOfVisit, sko;
        while ((stringOfData = reader.readNext()) != null) {
            if (stringOfData[3].trim().isEmpty())
                avgDuration = "0";
            else avgDuration = stringOfData[3].trim();
            if (stringOfData[4].trim().isEmpty())
                numberOfVisit = "0";
            else numberOfVisit = stringOfData[4].trim();
            if (stringOfData[5].trim().isEmpty())
                sko = "0";
            else sko = stringOfData[5].trim();
            Double skoByAvg;
            if (Integer.parseInt(avgDuration)!= 0)
            skoByAvg = Double.parseDouble(sko) / Double.parseDouble(avgDuration);
            else
            skoByAvg = 0.;
            String formattedDouble = new DecimalFormat("#0.000").format(skoByAvg);
            query = "insert into mbad.avgduration" +
                    "(employee_id,zone,wd,avgDuration,numberofvisit,sko,sko_by_avg ) " +
                    "values ('" + stringOfData[0].trim() + "','" + stringOfData[1].trim() + "' ,'" +
                    stringOfData[2].trim() + "' ,'" + avgDuration + "' ,'" + numberOfVisit +"' ,'" + sko + "' ,'" +skoByAvg+"');";
            try {
                stmt.executeUpdate(query);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            //System.out.println(query);
        }
    }

  /*  public void insertIntoEmployee() throws Exception {
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
*/
    /*public void insertIntoIdZone() throws Exception {
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
    }*/


    public Connection closeConnect() throws Exception {
        try {
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

  /*  public void selectFromProxOut() throws Exception {
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
*/

    }

