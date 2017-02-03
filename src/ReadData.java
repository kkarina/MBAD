/**
 * Created by afashokova on 02.02.2017.
 */



import com.opencsv.CSVReader;
import java.io.FileReader;

public class ReadData {

    public void readProxOut() throws Exception {
        String prox = ("C:\\Users\\Afashokova\\IdeaProjects\\MBAD\\data\\proxOut-MC2.csv");
        char csvSplitBy = ',';
        CSVReader reader = new CSVReader(new FileReader(prox), csvSplitBy);
        String[] stringOfData;
        while ((stringOfData = reader.readNext()) != null) {
           stringOfData[3] = stringOfData[3]+'-'+ stringOfData[4].trim();
           stringOfData[4] = "";
            //вывод
            for (String e : stringOfData)
                System.out.format("%s", e);
            System.out.println();

        }
    }

    public void readEmployeeList() throws Exception {
        String employee = ("C:\\Users\\Afashokova\\IdeaProjects\\MBAD\\data\\Копия Employee List.csv");
        CSVReader reader = new CSVReader(new FileReader(employee), ';');
        String[] stringOfData;
        while ((stringOfData = reader.readNext())!=null){
            for (int i = 0; i<3; i++)
                stringOfData[i] = stringOfData[i]+ ' ';
            for (String e : stringOfData)
                System.out.format("%s", e);
            System.out.println();

        }
    }
}