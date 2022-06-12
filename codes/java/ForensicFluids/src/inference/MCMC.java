package inference;

import model.ClusterPrior;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

public class MCMC {
    public static void main(String[] args){
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        int[][][][] mkrGrpPartitions = getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double[][] colPriors = getColPriors(3, allPartitionSets5File, allPartitionSets7File,10,10);
        double[] alphaC = new double[]{0.5, 1.0, 1.5, 2.0, 2.5};
        double[] betaC = new double[]{2.25, 1.75, 1.25, 0.75, 0.25};

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[10];
        subtypeParts[0] = new ArrayList<>(Arrays.asList(0,5));
        subtypeParts[1] = new ArrayList<>(Arrays.asList(1,6));
        subtypeParts[2] = new ArrayList<>(Arrays.asList(2,7));
        subtypeParts[3] = new ArrayList<>(Arrays.asList(3,8));
        subtypeParts[4] = new ArrayList<>(Arrays.asList(4,9));

    }

    private static double SingleRowMove(ArrayList<Integer>[] subtypesList){
        Random random = new Random();
        int setMaxCount = subtypesList.length;

        ArrayList<Integer> currNonEmptySet = new ArrayList<>();
        ArrayList<Integer> propNonEmptySet = new ArrayList<>();
        for(int setIndex = 0; setIndex < setMaxCount; setIndex++){
            int currSetSize = subtypesList[setIndex].size();
            if(currSetSize > 0){
                currNonEmptySet.add(setIndex);
                propNonEmptySet.add(setIndex);
            }
        }
        int currNonEmptySetIndex = random.nextInt(currNonEmptySet.size());
        int currSetIndex = currNonEmptySet.get(currNonEmptySetIndex);
        int currSetSize = subtypesList[currSetIndex].size();
        int currSetEltIndex = subtypesList[currSetIndex].get(random.nextInt(currSetSize));
        int propSetIndex = random.nextInt(subtypesList.length - 1);
        propSetIndex = propSetIndex < currSetIndex? propSetIndex : propSetIndex + 1;
        int obs = subtypesList[currSetIndex].remove(currSetEltIndex);
        subtypesList[propSetIndex].add(obs);
        if(subtypesList[currSetIndex].size() == 0){
            propNonEmptySet.remove(currNonEmptySetIndex);
        }
        if(subtypesList[propSetIndex].size() == 1){
            propNonEmptySet.add(propSetIndex);
        }
        double logHR = Math.log( currNonEmptySet.size() * currSetSize) /
                (propNonEmptySet.size() * subtypesList[propSetIndex].size());
        return logHR;
    }

    private static int[][][][] getMkerGroupPartitions(String allPartSets5File,
                                               String allPartSets7File){
        int[][][][] mkrGrpParts = new int[5][][][];
        int[][][] allPartitionSets5 = getClusterArray(allPartSets5File, 52);
        int[][][] allPartitionSets7 = getClusterArray(allPartSets7File, 877);
        mkrGrpParts[0] = allPartitionSets5;
        mkrGrpParts[1] = allPartitionSets7;
        mkrGrpParts[2] = allPartitionSets5;
        mkrGrpParts[3] = allPartitionSets5;
        mkrGrpParts[4] = allPartitionSets5;

        return mkrGrpParts;

    }

    private static int[][][] getClusterArray(String file, int lineCount){
        try{

            BufferedReader clustReader = new BufferedReader(new FileReader(file));
            String line = "";
            String[] clustStr;
            String[] obsInClust;
            int[][][] clusts = new int[lineCount][][];

            for(int lineIndex = 0; lineIndex < lineCount; lineIndex++){

                line = clustReader.readLine().trim();
                line = line.substring(1, line.length() - 1);

                if(line.contains("], [")){
                    clustStr = line.split("\\], \\[");
                }else{
                    clustStr = new String[]{line};
                }


                clusts[lineIndex] = new int[clustStr.length][];
                for(int clustIndex = 0; clustIndex < clustStr.length; clustIndex++){
                    obsInClust = clustStr[clustIndex].replaceAll("\\[|\\]", "").split(", ");

                    clusts[lineIndex][clustIndex] = new int[obsInClust.length];
                    for(int obsIndex = 0; obsIndex < obsInClust.length; obsIndex++){

                        clusts[lineIndex][clustIndex][obsIndex] = Integer.parseInt(obsInClust[obsIndex]) - 1;

                    }
                }
            }

            clustReader.close();

            return clusts;

        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }

    public static int[][][] getData(String file){
        int[][][] data = new int[5][][];
        int[][] colRange = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};
        for(int i = 0; i < colRange.length; i++){
            data[i] = extractData(file,colRange[i][0], colRange[i][1], 0, 9);
        }
        return data;
    }

    public static int[][] extractData(String file, int startCol, int endCol, int rowStart, int rowEnd){
        try{
            BufferedReader dataReader = new BufferedReader(new FileReader(file));
            String line = dataReader.readLine();
            String[] elts;
            int[][] data = new int[rowEnd - rowStart + 1][endCol - startCol + 1];
            int counter = 0;
            while((line = dataReader.readLine()) != null){
                elts = line.split(",");
                for(int colIndex = 0; colIndex < data[counter].length; colIndex++){
                    data[counter][colIndex] = Integer.parseInt(elts[startCol + colIndex]);
                }
                counter++;
            }
            dataReader.close();
            return data;

        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }

    public static double[][] getColPriors(double alpha,
                                          String allPartSets5File,
                                          String allPartSets7File,
                                          int maxSetCount,
                                          int totalObsCount){

        int[][][] partSet5 = getClusterArray(allPartSets5File, 52);
        double[] mdpProbSet5 = new double[52];
        for (int partIndex = 0; partIndex < partSet5.length; partIndex++) {
            mdpProbSet5[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha,
                    maxSetCount,
                    partSet5[partIndex],
                    totalObsCount);
        }

        int[][][] partSet7 = getClusterArray(allPartSets7File, 877);
        double[] mdpProbSet7 = new double[877];
        for (int partIndex = 0; partIndex < partSet7.length; partIndex++) {
            mdpProbSet7[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha,
                    maxSetCount,
                    partSet7[partIndex],
                    totalObsCount);
        }



        double[][] colPriors = new double[5][];
        colPriors[0] = mdpProbSet5;
        colPriors[1] = mdpProbSet7;
        colPriors[2] = mdpProbSet5;
        colPriors[3] = mdpProbSet5;
        colPriors[4] = mdpProbSet5;

        return colPriors;
    }

}
