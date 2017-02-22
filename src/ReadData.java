


import com.opencsv.CSVReader;
import java.io.FileReader;



public class ReadData {

    public void readProxOut() throws Exception {
        String prox = ("C:\\Users\\Afashokova\\IdeaProjects\\MBAD\\data\\proxOut-MC2.csv");
        char csvSplitBy = ',';
        CSVReader reader = new CSVReader(new FileReader(prox), csvSplitBy);
        String[] stringOfData;
        while ((stringOfData = reader.readNext()) != null) {
            stringOfData[1]=stringOfData[2];
            stringOfData[2] = stringOfData[3]+'-'+ stringOfData[4].trim();

            //вывод
            for (int i=0; i<3; i++)
                System.out.format("%s", stringOfData[i]);
            System.out.println();

        }
    }

    public void readEmployeeList() throws Exception {
        String employee = ("C:\\Users\\Afashokova\\IdeaProjects\\MBAD\\data\\Копия Employee List.csv");
        CSVReader reader = new CSVReader(new FileReader(employee), ';');
        String[] stringOfData;
        while ((stringOfData = reader.readNext())!=null){
            char firstLetter = stringOfData[1].charAt(0);
            stringOfData[0] = (firstLetter + stringOfData[0]+' ').toLowerCase();
            stringOfData[1] = stringOfData[2] + ' ';
            stringOfData[2] = stringOfData[3];
            stringOfData[3] = "";
            for (int i=0; i<3; i++)
                System.out.format("%s", stringOfData[i]);
            System.out.println();

        }
    }
}