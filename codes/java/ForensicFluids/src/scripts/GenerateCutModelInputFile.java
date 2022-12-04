package scripts;

import utils.Randomizer;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;

public class GenerateCutModelInputFile {
    public static void main(String[] args){
        try{

            String bodyFluid = "smn";
            String dataDirPath = "/Users/chwu/Documents/research/bfc/data/loocvCut/" + bodyFluid + "/";
            File dataDir = new File(dataDirPath);
            File[] files = dataDir.listFiles();
            ArrayList<String> filenames = new ArrayList<String>();
            for(int fileIndex =0; fileIndex < files.length; fileIndex++){
                if(files[fileIndex].getName().contains("_train_")){
                    filenames.add(files[fileIndex].getName());
                }

            }
            Collections.sort(filenames);



            String templateFilePath = "/Users/chwu/Documents/research/bfc/data/loocvCut/" + bodyFluid + "/loocvCut_" + bodyFluid + "_input_template.txt";
            String trainFileName = "";
            String line = "";
            long seedAdditive_ = 0;
            for(int fileIndex  = 0; fileIndex< filenames.size(); fileIndex++){
                trainFileName = filenames.get(fileIndex);
                String[] temp = trainFileName.replace(".csv", "").split("_");
                //String patternIndex = temp[temp.length - 1];
                System.out.println(trainFileName);
                BufferedReader templReader = new BufferedReader(new FileReader(templateFilePath));



                String inputFilePath = "/Users/chwu/Documents/research/bfc/data/loocvCut/" + bodyFluid +"/loocvCut_"+ bodyFluid +"_input_"+temp[temp.length - 1] + ".txt";
                PrintWriter inputWriter = new PrintWriter(inputFilePath);
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
                        String logFileName = trainFileName.replace("_train_", "_").replace(".csv", ".log");
                        logFileName = logFileName.replace("loocvTrain", "loocvCut");
                        line = line.replace("[logFile]", logFileName);

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
