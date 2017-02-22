/**
 * Created by afashokova on 02.02.2017.
 */

public class MBADApp {
    public static void main(String args[]) throws Exception {
        ReadData readData = new ReadData();
        try {
            readData.readProxOut();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
