package scripts;

import utils.Randomizer;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;

public class GenerateLOOCVTrainInputFile {
    public static void main(String[] args){
        try{
            String dataDirPath = "/Users/chwu/Documents/research/bfc/data/loocvTrain/cvf/";
            File dataDir = new File(dataDirPath);
            File[] files = dataDir.listFiles();
            ArrayList<String> filenames = new ArrayList<String>();
            for(int fileIndex =0; fileIndex < files.length; fileIndex++){
                if(files[fileIndex].getName().contains("_train_")){
                    filenames.add(files[fileIndex].getName());
                }

            }
            Collections.sort(filenames);
            String loocvTrainData = "";



            String templateFilePath = "/Users/chwu/Documents/research/bfc/data/loocvTrain/cvf/loocvTrain_cvf_input_template.txt";
            String trainFileName = "";
            String line = "";
            long seedAdditive_ = 0;
            for(int fileIndex  = 0; fileIndex< filenames.size(); fileIndex++){
                trainFileName = filenames.get(fileIndex);
                String[] temp = trainFileName.replace(".csv", "").split("_");
                //String patternIndex = temp[temp.length - 1];
                System.out.println(trainFileName);
                BufferedReader templReader = new BufferedReader(new FileReader(templateFilePath));



                PrintWriter inputWriter = new PrintWriter(
                        "/Users/chwu/Documents/research/bfc/data/loocvTrain/cvf/loocvTrain_cvf_input_"+temp[temp.length - 1]+".txt");
                while((line = templReader.readLine()) != null){
                    if(line.contains("[seed]")){
                        long seed = System.currentTimeMillis() + seedAdditive_;
                        seedAdditive_ =+ Randomizer.nextInt();
                        line = line.replace("[seed]", "" + seed);
                    }
                    if(line.contains("[loocvTrainData]")){
                        line = line.replace("[loocvTrainData]", trainFileName);
                    }
                    if(line.contains("[loocvUnknown]")){
                        line = line.replace("[loocvUnknown]", trainFileName.replace("_train_", "_unknown_"));
                    }
                    if(line.contains("[logFile]")){
                        line = line.replace("[logFile]", trainFileName.replace("_train_", "_").replace(".csv", ".log"));
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
