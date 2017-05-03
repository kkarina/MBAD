/**
 * Created by afashokova on 02.02.2017.
 */


public class MBADApp {
    public static void main(String args[]) throws Exception {
        //graf g = new graf();
        InsertIntoTables s = new InsertIntoTables();
        s.Connetion();
        //s.insertIntoProxOut();
        //s.InsertIntoAvgDuration();
        //s.insertIntoEmployee();
        //s.insertIntoIdZone();
        //s.selectFromProxOut();
        //s.GetAvgDuration();
        //s.GetAvgTime();
        s.GetAvgByDep();
        s.GetAvgByTimeDep();
        //g.NearestPath(0,4);
    }
}

