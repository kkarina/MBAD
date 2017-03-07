/**
 * Created by afashokova on 02.02.2017.
 */


public class MBADApp {
    public static void main(String args[]) throws Exception {
        graf g = new graf();
        /*InsertIntoTables s = new InsertIntoTables();
        s.Connetion();
        s.insertIntoProxOut();
        s.insertIntoEmployee();
        s.insertIntoIdZone();
        s.closeConnect();
*/
        g.NearestPath(0,4);
    }
}

