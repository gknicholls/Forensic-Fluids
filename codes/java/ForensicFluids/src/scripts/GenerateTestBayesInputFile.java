package scripts;

import utils.Randomizer;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;

public class GenerateTestBayesInputFile {
    public static void main(String[] args){
        try{


            String dataDirPath = "/Users/chwu/Documents/research/bfc/data/test/2022_09_22/unknown/";
            File dataDir = new File(dataDirPath);
            File[] files = dataDir.listFiles();




            String templateFilePath = "/Users/chwu/Documents/research/bfc/analysis/2023_02_24/test_bayes_input_template.txt";
            String unknownFileName = "";
            String line = "";
            long seedAdditive_ = 0;
            for(int fileIndex  = 0; fileIndex< files.length; fileIndex++){
                unknownFileName = files[fileIndex].getName();
                String[] temp = unknownFileName.replace(".csv", "").split("_");
                //String patternIndex = temp[temp.length - 1];
                System.out.println(unknownFileName);
                BufferedReader templReader = new BufferedReader(new FileReader(templateFilePath));



                String inputFilePath = "/Users/chwu/Documents/research/bfc/analysis/2023_02_27/test_bayes_input_"+temp[temp.length - 1] + ".txt";
                PrintWriter inputWriter = new PrintWriter(inputFilePath);
                while((line = templReader.readLine()) != null){
                    if(line.contains("[seed]")){
                        long seed = System.currentTimeMillis() + seedAdditive_;
                        seedAdditive_ =+ Randomizer.nextInt();
                        line = line.replace("[seed]", "" + seed);
                    }

                    if(line.contains("[loocvUnknown]")){
                        line = line.replace("[loocvUnknown]", unknownFileName);
                    }
                    if(line.contains("[logFile]")){
                        line = line.replace("[logFile]",
                                unknownFileName.replace(".csv", ".log").replace("2022_09_22_unknown", "2022_09_22_bayes"));

                    }

                    inputWriter.println(line);


                }

                inputWriter.close();
                templReader.close();
            }



        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }
}
