package scripts;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class RemoveElementsFromSetsInLogFile {
    public static void main(String[] args){
        String inputFile = "/Users/chwu/Documents/research/bfc/analysis/2023_02_09/loocvCut_cvf_86.log";
        String outputFile = "/Users/chwu/Documents/research/bfc/analysis/2023_02_09/loocvCut_mUnkn_5.log";
        
        try{
            BufferedReader inputReader = new BufferedReader(new FileReader(inputFile));
            PrintWriter outputWriter = new PrintWriter(outputFile);
            String inputLine = inputReader.readLine();
            String[] inputElt = inputLine.split("\t");
            int inputClusterColIndex = findColIndex(inputElt, "typeList");
            int inputStateColIndex = findColIndex(inputElt, "STATE");
            int[][] eltsIDToBeRemoved = new int[][]{{58}, {30}, {79}, {64}, {85}};
            int[] exptdTypeCounts = new int[]{58, 30, 79, 64, 85};

            String inputCluster;
            List<String> inputSets, sideSets;
            int typeCount;
            outputWriter.println(inputElt[inputStateColIndex] + "\t" + inputElt[inputClusterColIndex]);
            while((inputLine = inputReader.readLine()) != null) {
                inputElt = inputLine.split("\t");

                inputCluster = inputElt[inputClusterColIndex].trim();
                String[] inputClusterElts = inputCluster.split(" ");
                String m = "";

                for (int typeIndex = 0; typeIndex < inputClusterElts.length; typeIndex++) {

                    inputClusterElts[typeIndex] = inputClusterElts[typeIndex].substring(1, inputClusterElts[typeIndex].length() - 1);
                    for (int setIndex = 0; setIndex < eltsIDToBeRemoved[typeIndex].length; setIndex++) {
                        inputClusterElts[typeIndex] =
                                inputClusterElts[typeIndex].replace(eltsIDToBeRemoved[typeIndex][setIndex] + ",", "");
                        inputClusterElts[typeIndex] =
                                inputClusterElts[typeIndex].replace("," + eltsIDToBeRemoved[typeIndex][setIndex], "");
                        inputClusterElts[typeIndex] =
                                inputClusterElts[typeIndex].replace(",[" + eltsIDToBeRemoved[typeIndex][setIndex] + "]", "");
                    }
                    inputClusterElts[typeIndex] = "["+inputClusterElts[typeIndex]+"]";
                    typeCount = countElements(inputClusterElts[typeIndex]);
                    if(typeCount != exptdTypeCounts[typeIndex]){
                        System.err.println(inputClusterElts[typeIndex]);
                        throw new RuntimeException(typeCount+ " "+exptdTypeCounts[typeIndex]);
                    }

                    if(typeIndex > 0){
                        m += " ";
                    }
                    m += inputClusterElts[typeIndex];


                }
                outputWriter.println(inputElt[inputStateColIndex] + "\t" + m);
            }
            outputWriter.close();


            inputReader.close();


        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }


    private static int findColIndex(String[] header, String target){

        for(int colIndex = 0; colIndex < header.length; colIndex++){
            if(header[colIndex].trim().equals(target)){
                return colIndex;
            }
        }

        return -1;
    }

    private static int countElements(String typeClusterStr){
        typeClusterStr = typeClusterStr.replace("],[", "], [");
        typeClusterStr = typeClusterStr.substring(1, typeClusterStr.length() - 1);
        String[] sets = typeClusterStr.split(", ");
        int count = 0;
        for(String set:sets){
            count += set.substring(1, set.length() - 1).split(",").length;
        }

        return count;

    }
}
