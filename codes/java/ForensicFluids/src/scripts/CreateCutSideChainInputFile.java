package scripts;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;

public class CreateCutSideChainInputFile {
    public static void main(String args[]){
        try{
            String type = "smn";
            String templatePath = "/Users/chwu/Documents/research/bfc/analysis/2023_02_18/loocvCut_side_" + type + "_input_template.txt";
            String mainSeqInputPath = "/Users/chwu/Documents/research/bfc/paper/analysis/CutModel/"+ type + "_1/loocvCut_"+ type + "_1_input_seq.txt";
            String mainInputFolderPath = "/Users/chwu/Documents/research/bfc/paper/analysis/CutModel/"+ type + "_1/";
            BufferedReader templateReader;
            BufferedReader mainSeqReader = new BufferedReader(new FileReader(mainSeqInputPath));
            String templateLine = "";
            String mainSeqLine = "";
            String[] mainSeqElts;
            int num;
            BufferedReader mainInputReader;

            String seed;

            String sideInputFolderPath = "/Users/chwu/Documents/research/bfc/analysis/2023_02_18/"+ type + "_1/";
            PrintWriter sideInputWriter;

            while((mainSeqLine = mainSeqReader.readLine()) != null){
                mainInputReader = new BufferedReader(new FileReader(mainInputFolderPath + mainSeqLine.trim()));
                seed = mainInputReader.readLine().split("\t")[1];


                mainSeqElts = mainSeqLine.split("_");
                num = Integer.parseInt(mainSeqElts[mainSeqElts.length - 1].replace(".txt", ""));
                sideInputWriter = new PrintWriter(sideInputFolderPath + "loocvCut_side_" + type + "_input_"+num+".txt");
                templateReader = new BufferedReader(new FileReader(templatePath));

                while((templateLine = templateReader.readLine()) != null){
                    if(templateLine.contains("[seed]")){
                        templateLine = templateLine.replace("[seed]", seed);
                    }

                    if(templateLine.contains("[bft]")){
                        templateLine = templateLine.replace("[bft]", type);
                    }

                    if(templateLine.contains("[num]")){
                        templateLine = templateLine.replace("[num]", ""+num);
                    }

                    sideInputWriter.println(templateLine);

                }
                templateReader.close();
                sideInputWriter.close();



            }

            mainSeqReader.close();

        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }
}
