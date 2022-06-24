package scripts;

import model.ClusterLikelihood;
import model.ClusterPrior;
import utils.MathUtils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;

public class CalculatePosteriorForAllPartitions {
    public static void main(String[] args){
        int[][][][] mkrGrpPartitions = new int[5][][][];
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        int[][][] allPartitionSets5 = getClusterArray(allPartitionSets5File, 52);
        int[][][] allPartitionSets7 = getClusterArray(allPartitionSets7File, 877);
        mkrGrpPartitions[0] = allPartitionSets5;
        mkrGrpPartitions[1] = allPartitionSets7;
        mkrGrpPartitions[2] = allPartitionSets5;
        mkrGrpPartitions[3] = allPartitionSets5;
        mkrGrpPartitions[4] = allPartitionSets5;
        int totalObsCount = 3;
        int totalPartitionCount = 5;

        int[][][] data = new int[5][][];
        int[][] colRange = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};
        for(int i = 0; i < colRange.length; i++){
            data[i] = extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/ex.3obs.dat.csv",
                    colRange[i][0], colRange[i][1], 0, totalObsCount - 1);
        }
        /*for(int i = 0; i < data.length; i++){

            for(int j = 0; j < data[i].length; j++){
                for(int k = 0; k < data[i][j].length; k++){
                    System.out.print(data[i][j][k]+ " ");
                }
                System.out.println();

            }
            System.out.println();

        }*/

        //String allPartitionSets10File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets10.txt";
        String allPartitionSets3File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets3.txt";
        int[][][] partitions = getClusterArray(allPartitionSets3File, totalPartitionCount);
        double alpha = 1.2;
        int setCountMax = 3;


        int[][][] partSet5 = getClusterArray(allPartitionSets5File, 52);
        double[] mdpProbSet5 = new double[52];
        for (int partIndex = 0; partIndex < partSet5.length; partIndex++) {
            mdpProbSet5[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha,
                    5,
                    partSet5[partIndex],
                    5);
        }



        int[][][] partSet7 = getClusterArray(allPartitionSets7File, 877);
        double[] mdpProbSet7 = new double[877];
        for (int partIndex = 0; partIndex < partSet7.length; partIndex++) {
            mdpProbSet7[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha,
                    7,
                    partSet7[partIndex],
                    7);
        }



        double[][] colPriors = new double[5][];
        colPriors[0] = mdpProbSet5;
        colPriors[1] = mdpProbSet7;
        colPriors[2] = mdpProbSet5;
        colPriors[3] = mdpProbSet5;
        colPriors[4] = mdpProbSet5;

        //double[] alphaC = new double[]{0.5, 1.0, 1.5, 2.0, 2.5};
        //double[] betaC = new double[]{2.25, 1.75, 1.25, 0.75, 0.25};
        double[] alphaC = new double[]{0.97, 1.0, 0.98, 1.08, 1.05};
        double[] betaC = new double[]{1.06, 1.07, 1.02, 0.97, 0.95};

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[totalObsCount];
        double[] logTypeLik = new double[partitions.length];

        String clustFile = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets10.txt";

        ArrayList<Integer>[][] allParts10 = MathUtils.getCluster(allPartitionSets3File, totalPartitionCount);

        for(int partIndex = 0; partIndex < allParts10.length; partIndex++){

            for(int setIndex = 0; setIndex < allParts10[partIndex].length; setIndex++){
                for(int eltIndex = 0; eltIndex < allParts10[partIndex][setIndex].size(); eltIndex++){
                    System.out.print(allParts10[partIndex][setIndex].get(eltIndex)+" ");
                }
                System.out.println();
            }
            System.out.println();

        }

        //int setCountMax = 10;
        try {
            PrintWriter logTypeLikWriter = new PrintWriter("/Users/chwu/Documents/research/bfc/ex.obs3.log.type.lik.txt");
            for (int partIndex = 0; partIndex < allParts10.length; partIndex++) {
                subtypeParts = (ArrayList<Integer>[]) new ArrayList[setCountMax];
                for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
                    subtypeParts[setIndex] = new ArrayList<Integer>();
                }
                int[] samples = MathUtils.sample(allParts10[partIndex].length, 0,setCountMax - 1);
                //System.out.println(samples.length+" "+allParts10[partIndex].length+" "+subtypeParts.length);
                for (int setIndex = 0; setIndex < allParts10[partIndex].length; setIndex++) {
                    subtypeParts[samples[setIndex]] = allParts10[partIndex][setIndex];
                }

                logTypeLik[partIndex] = ClusterLikelihood.CalcLogTypeLikelihood(mkrGrpPartitions,
                        colPriors, data, alphaC, betaC, subtypeParts);

                logTypeLikWriter.println(logTypeLik[partIndex]);

                if (partIndex % 1000 == 0) {
                    System.out.println(partIndex);
                }

            }
            logTypeLikWriter.close();
        }catch(Exception e){
            throw new RuntimeException(e);
        }
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



}
