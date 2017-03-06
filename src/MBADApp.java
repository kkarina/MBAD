/**
 * Created by afashokova on 02.02.2017.
 */

public class MBADApp {
    public static void main(String args[]) throws Exception {
        graf g = new graf();
        SqlConnect s = new SqlConnect();
        s.Connetion();
        //s.insertIntoProxOut();
        s.insertIntoEmployee();
        s.closeConnect();

    }
}
