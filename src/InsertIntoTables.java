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

    public void CloseConnection() throws SQLException {
        rs.close();
        stmt.close();
        con.close();

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
            if (Integer.parseInt(avgDuration) != 0)
                skoByAvg = Double.parseDouble(sko) / Double.parseDouble(avgDuration);
            else
                skoByAvg = 0.;
            String formattedDouble = new DecimalFormat("#0.000").format(skoByAvg);
            query = "insert into mbad.avgduration" +
                    "(employee_id,zone,wd,avgDuration,numberofvisit,sko,sko_by_avg ) " +
                    "values ('" + stringOfData[0].trim() + "','" + stringOfData[1].trim() + "' ,'" +
                    stringOfData[2].trim() + "' ,'" + avgDuration + "' ,'" + numberOfVisit + "' ,'" + sko + "' ,'" + skoByAvg + "');";
            try {
                stmt.executeUpdate(query);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void GetAvgDuration() throws Exception {
        String query1, query2;
        st = con.createStatement();
        stmt = con.createStatement();
        query1 = " DELETE FROM mbad.avgduration;\n" +
                "  INSERT INTO mbad.avgduration (employee_id, zone, wd, avgduration, numberofvisit, sko, number_of_sample, sko_by_avg)\n" +
                "    SELECT\n" +
                "      t.*,\n" +
                "      CASE WHEN avgduration != 0\n" +
                "        THEN round(sko / avgduration, 3)\n" +
                "      WHEN avgduration = 0\n" +
                "        THEN 0\n" +
                "      END AS sko_by_avg\n" +
                "\n" +
                "    FROM\n" +
                "      (SELECT DISTINCT\n" +
                "         employee_id,\n" +
                "         zone,\n" +
                "         wd,\n" +
                "         round(avg(duration)\n" +
                "               OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                "                 ORDER BY NULL)) AS avgduration,\n" +
                "         count(zone)\n" +
                "         OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                "           ORDER BY NULL)        AS numberofvisit,\n" +
                "         round(stddev_pop(duration)\n" +
                "               OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                "                 ORDER BY NULL)) AS sko,\n" +
                "         number_of_sample\n" +
                "\n" +
                "       FROM mbad.proxout) t;";
        try {
            stmt.execute(query1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        query2 = "SELECT max(sko_by_avg)FROM mbad.avgduration ";

        rs = stmt.executeQuery(query2);
        rs.next();
        rs.getString(1);
        int k = 1;
        double i = Double.parseDouble(rs.getString(1));
        while (i >= 0.5) {
            stmt.execute("SELECT mbad.get_number_of_sample();" +
                    " DELETE FROM mbad.avgduration;\n" +
                    "  INSERT INTO mbad.avgduration (employee_id, zone, wd, avgduration, numberofvisit, sko, number_of_sample, sko_by_avg)\n" +
                    "    SELECT\n" +
                    "      t.*,\n" +
                    "      CASE WHEN avgduration != 0\n" +
                    "        THEN round(sko / avgduration, 3)\n" +
                    "      WHEN avgduration = 0\n" +
                    "        THEN 0\n" +
                    "      END AS sko_by_avg\n" +
                    "\n" +
                    "    FROM\n" +
                    "      (SELECT DISTINCT\n" +
                    "         employee_id,\n" +
                    "         zone,\n" +
                    "         wd,\n" +
                    "         round(avg(duration)\n" +
                    "               OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                    "                 ORDER BY NULL)) AS avgduration,\n" +
                    "         count(zone)\n" +
                    "         OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                    "           ORDER BY NULL)        AS numberofvisit,\n" +
                    "         round(stddev_pop(duration)\n" +
                    "               OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                    "                 ORDER BY NULL)) AS sko,\n" +
                    "         number_of_sample\n" +
                    "\n" +
                    "       FROM mbad.proxout) t;");
            System.out.println(i);
            k = k + 2;
            rs = stmt.executeQuery(query2);
            rs.next();
            i = Double.parseDouble(rs.getString(1));
        }


    }

    public void GetAvgTime() throws Exception {
        String query1, query2;
        st = con.createStatement();
        stmt = con.createStatement();
        query1 = " DELETE FROM mbad.avgtime;\n" +
                "  INSERT INTO mbad.avgtime (employee_id, zone, wd, avgtime, numberofvisit, sko, number_of_sample, sko_by_avg)\n" +
                "    SELECT\n" +
                "      t.*,\n" +
                "      CASE WHEN avgtime != 0\n" +
                "        THEN round(sko / avgtime, 3)\n" +
                "      WHEN avgtime = 0\n" +
                "        THEN 0\n" +
                "      END AS sko_by_avg\n" +
                "\n" +
                "    FROM\n" +
                "      (SELECT DISTINCT\n" +
                "         employee_id,\n" +
                "         zone,\n" +
                "         wd,\n" +
                "         round(avg(time )\n" +
                "               OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                "                 ORDER BY NULL)) AS avgtime,\n" +
                "         count(zone)\n" +
                "         OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                "           ORDER BY NULL)        AS numberofvisit,\n" +
                "         round(stddev_pop(time)\n" +
                "               OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                "                 ORDER BY NULL)) AS sko,\n" +
                "         number_of_sample\n" +
                "\n" +
                "       FROM mbad.proxout) t;";
        try {
            stmt.execute(query1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        query2 = "SELECT max(sko_by_avg)FROM mbad.avgtime ";

        rs = stmt.executeQuery(query2);
        rs.next();
        rs.getString(1);
        int k = 1;
        double i = Double.parseDouble(rs.getString(1));
        while (i >= 0.2) {
            stmt.execute("SELECT mbad.get_number_of_sample_by_time();" +
                    " DELETE FROM mbad.avgtime;\n" +
                    "  INSERT INTO mbad.avgtime (employee_id, zone, wd, avgtime, numberofvisit, sko, number_of_sample, sko_by_avg)\n" +
                    "    SELECT\n" +
                    "      t.*,\n" +
                    "      CASE WHEN avgtime != 0\n" +
                    "        THEN round(sko / avgtime, 3)\n" +
                    "      WHEN avgtime = 0\n" +
                    "        THEN 0\n" +
                    "      END AS sko_by_avg\n" +
                    "\n" +
                    "    FROM\n" +
                    "      (SELECT DISTINCT\n" +
                    "         employee_id,\n" +
                    "         zone,\n" +
                    "         wd,\n" +
                    "         round(avg(time)\n" +
                    "               OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                    "                 ORDER BY NULL)) AS avgtime,\n" +
                    "         count(zone)\n" +
                    "         OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                    "           ORDER BY NULL)        AS numberofvisit,\n" +
                    "         round(stddev_pop(time)\n" +
                    "               OVER (PARTITION BY employee_id, zone, wd, number_of_sample\n" +
                    "                 ORDER BY NULL)) AS sko,\n" +
                    "         number_of_sample\n" +
                    "\n" +
                    "       FROM mbad.proxout) t;");
            System.out.println(i);
            k = k + 2;
            rs = stmt.executeQuery(query2);
            rs.next();
            i = Double.parseDouble(rs.getString(1));
        }
        rs.close();
        stmt.close();
        con.close();


    }


    public void GetAvgByDep() throws Exception {
        String query1, query2;
        st = con.createStatement();
        stmt = con.createStatement();
        query1 = " DELETE FROM mbad.avgduration_dep;\n" +
                "INSERT INTO mbad.avgduration_dep (department, zone, wd, avgduration, numberofvisit, sko, number_of_sample, sko_by_avg)\n" +
                "  SELECT\n" +
                "    t.*,\n" +
                "    CASE WHEN avgduration != 0\n" +
                "      THEN round(sko / avgduration, 3)\n" +
                "    WHEN avgduration = 0\n" +
                "      THEN 0\n" +
                "    END AS sko_by_avg\n" +
                "\n" +
                "  FROM\n" +
                "    (SELECT DISTINCT\n" +
                "       department,\n" +
                "       zone,\n" +
                "       wd,\n" +
                "       round(avg(duration)\n" +
                "             OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                "               ORDER BY NULL)) AS avgduration,\n" +
                "       count(zone)\n" +
                "       OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                "         ORDER BY NULL)        AS numberofvisit,\n" +
                "       round(stddev_pop(duration)\n" +
                "             OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                "               ORDER BY NULL)) AS sko,\n" +
                "       number_of_sample\n" +
                "\n" +
                "     FROM mbad.proxout) t;";
        try {
            stmt.execute(query1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        query2 = "SELECT max(sko_by_avg)FROM mbad.avgduration_dep ";

        rs = stmt.executeQuery(query2);
        rs.next();
        rs.getString(1);
        int k = 1;
        double i = Double.parseDouble(rs.getString(1));
        while (i > 0.5) {
            stmt.execute("select mbad.get_number_of_sample_dep();\n" +
                    "DELETE FROM mbad.avgduration_dep;\n" +
                    "INSERT INTO mbad.avgduration_dep (department, zone, wd, avgduration, numberofvisit, sko, number_of_sample, sko_by_avg)\n" +
                    "  SELECT\n" +
                    "    t.*,\n" +
                    "    CASE WHEN avgduration != 0\n" +
                    "      THEN round(sko / avgduration, 3)\n" +
                    "    WHEN avgduration = 0\n" +
                    "      THEN 0\n" +
                    "    END AS sko_by_avg\n" +
                    "\n" +
                    "  FROM\n" +
                    "    (SELECT DISTINCT\n" +
                    "       department,\n" +
                    "       zone,\n" +
                    "       wd,\n" +
                    "       round(avg(duration)\n" +
                    "             OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                    "               ORDER BY NULL)) AS avgduration,\n" +
                    "       count(zone)\n" +
                    "       OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                    "         ORDER BY NULL)        AS numberofvisit,\n" +
                    "       round(stddev_pop(duration)\n" +
                    "             OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                    "               ORDER BY NULL)) AS sko,\n" +
                    "       number_of_sample\n" +
                    "\n" +
                    "     FROM mbad.proxout) t;\n");
            System.out.println(i);
            k = k + 2;
            rs = stmt.executeQuery(query2);
            rs.next();
            i = Double.parseDouble(rs.getString(1));
        }

    }

    public void GetAvgByTimeDep() throws Exception{
        String query1, query2;
        st = con.createStatement();
        stmt = con.createStatement();
        query1 = "DELETE FROM mbad.avgtime_dep;\n" +
                "INSERT INTO mbad.avgtime_dep (department, zone, wd, avgtime, numberofvisit, sko, number_of_sample, sko_by_avg)\n" +
                "  SELECT\n" +
                "    t.*,\n" +
                "    CASE WHEN avgtime != 0\n" +
                "      THEN round(sko / avgtime, 3)\n" +
                "    WHEN avgtime = 0\n" +
                "      THEN 0\n" +
                "    END AS sko_by_avg\n" +
                "\n" +
                "  FROM\n" +
                "    (SELECT DISTINCT\n" +
                "       department,\n" +
                "       zone,\n" +
                "       wd,\n" +
                "       round(avg(time)\n" +
                "             OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                "               ORDER BY NULL)) AS avgtime,\n" +
                "       count(zone)\n" +
                "       OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                "         ORDER BY NULL)        AS numberofvisit,\n" +
                "       round(stddev_pop(time)\n" +
                "             OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                "               ORDER BY NULL)) AS sko,\n" +
                "       number_of_sample\n" +
                "     FROM mbad.proxout) t;\n";
        try {
            stmt.execute(query1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        query2 = "SELECT max(sko_by_avg)FROM mbad.avgtime_dep ";

        rs = stmt.executeQuery(query2);
        rs.next();
        rs.getString(1);
        int k = 1;
        double i = Double.parseDouble(rs.getString(1));
        while (i >0.2) {
            stmt.execute("SELECT mbad.get_number_of_sample_by_time_dep();" +
                    "DELETE FROM mbad.avgtime_dep;\n" +
                    "INSERT INTO mbad.avgtime_dep (department, zone, wd, avgtime, numberofvisit, sko, number_of_sample, sko_by_avg)\n" +
                    "  SELECT\n" +
                    "    t.*,\n" +
                    "    CASE WHEN avgtime != 0\n" +
                    "      THEN round(sko / avgtime, 3)\n" +
                    "    WHEN avgtime = 0\n" +
                    "      THEN 0\n" +
                    "    END AS sko_by_avg\n" +
                    "\n" +
                    "  FROM\n" +
                    "    (SELECT DISTINCT\n" +
                    "       department,\n" +
                    "       zone,\n" +
                    "       wd,\n" +
                    "       round(avg(time)\n" +
                    "             OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                    "               ORDER BY NULL)) AS avgtime,\n" +
                    "       count(zone)\n" +
                    "       OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                    "         ORDER BY NULL)        AS numberofvisit,\n" +
                    "       round(stddev_pop(time)\n" +
                    "             OVER (PARTITION BY department, zone, wd, number_of_sample\n" +
                    "               ORDER BY NULL)) AS sko,\n" +
                    "       number_of_sample\n" +
                    "     FROM mbad.proxout) t;\n");
            System.out.println(i);
            k = k + 2;
            rs = stmt.executeQuery(query2);
            rs.next();
            i = Double.parseDouble(rs.getString(1));
        }
        rs.close();
        stmt.close();
        con.close();

    }


public void DeleteZones() throws Exception {
    String query1;
    st = con.createStatement();
    stmt = con.createStatement();
    query1 = "select employee_id, zone, date, wd, time, duration, department, motif  from mbad.logs_motif\n" +
            "            order  by employee_id, date, time";
    try {
        rs = stmt.executeQuery(query1);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    String motif = "";
    while (rs.next()) {
        if (motif.contains("сквозная зона") && motif.equals(rs.getString(8))){
            st.execute("delete from mbad.logs_motif " +
                    "where employee_id = '" + rs.getString(1) + "'" +
                    "and zone  = '" + rs.getString(2) + "' " +
                    "and date = '" + rs.getString(3) + "' " +
                    "and time =  '" + rs.getString(5) + "' " +
                    "and motif = '" + rs.getString(8) + "'");
            System.out.println(motif+ " " + rs.getString(8));

        }
        else
        motif = rs.getString(8);
    }

}}
