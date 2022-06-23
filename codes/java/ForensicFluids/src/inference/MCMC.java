package inference;

import model.ClusterLikelihood;
import model.ClusterPrior;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

public class MCMC {
    final private static Random random = new Random();

    public static void main(String[] args){
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        int[][][][] mkrGrpPartitions = getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double[][] colPriors = getColPriors(3, allPartitionSets5File, allPartitionSets7File,10,10);
        double[] alphaC = new double[]{0.5, 1.0, 1.5, 2.0, 2.5};
        double[] betaC = new double[]{2.25, 1.75, 1.25, 0.75, 0.25};

        int[][][] data = new int[5][][];
        int[][] colRange = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};
        for(int i = 0; i < colRange.length; i++){
            data[i] = extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/ex.10obs.dat.csv",
                    colRange[i][0], colRange[i][1], 0, 9);
        }

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[10];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>(Arrays.asList(setIndex));
        }

        MCMC estSubtype = new MCMC(subtypeParts, mkrGrpPartitions, colPriors,alphaC, betaC, 3.0,data,100);
        estSubtype.run();

    }


    private ArrayList<Integer>[] subtypeList;
    private ArrayList<Integer>[] storedSubtypeList;
    private int[][][][] mkrGrpPartitions;
    private double[][] colPriors;
    private double[] alphaC;
    private double[] betaC;
    private int[][][] data;
    private double alpha;
    private int totalObsCount;
    private int chainLength;
    public MCMC(ArrayList<Integer>[] subtypeList, int[][][][] mkrGrpPartitions,
                double[][] colPriors, double[] alphaC, double[] betaC,
                double alpha, int[][][] data, int chainLength){
        this.subtypeList = subtypeList;
        storedSubtypeList = (ArrayList<Integer>[]) new ArrayList[this.subtypeList.length];
        this.mkrGrpPartitions = mkrGrpPartitions;
        this.colPriors = colPriors;
        this.alphaC = alphaC;
        this.betaC = betaC;
        this.alpha = alpha;
        this.data = data;
        totalObsCount = 0;
        this.chainLength = chainLength;


        for(int setIndex = 0; setIndex < this.subtypeList.length; setIndex++){
            //System.out.println("setIndex: "+subtypeList[setIndex]);
            totalObsCount+= this.subtypeList[setIndex].size();
        }
        store();

    }

    protected void run(){
        double currLogLik = ClusterLikelihood.CalcLogTypeLikelihood(mkrGrpPartitions,
                colPriors, data, alphaC, betaC, subtypeList);
        double currLogPost = currLogLik + ClusterPrior.calcLogMDPDensity(
                alpha, subtypeList.length, subtypeList, totalObsCount);
        double logHR, propLogLik, propLogPost, logMHR;
        for(int stepIndex = 0; stepIndex < chainLength; stepIndex++){
            logHR = AssignSingleRow.SingleRowMove(subtypeList);
            propLogLik = ClusterLikelihood.CalcLogTypeLikelihood(mkrGrpPartitions,
                    colPriors, data, alphaC, betaC, subtypeList);
            propLogPost = propLogLik + ClusterPrior.calcLogMDPDensity(
                    alpha, subtypeList.length, subtypeList, totalObsCount);
            logMHR = propLogPost  - currLogPost + logHR;

            if( Math.log(random.nextDouble()) < logMHR){
                currLogPost = propLogPost;
            }else{
                restore();
            }
        }


    }

    private void store(){

        for(int subtypeIndex = 0; subtypeIndex < storedSubtypeList.length; subtypeIndex++){
            storedSubtypeList[subtypeIndex] = new ArrayList<Integer>();
            for(int eltIndex = 0; eltIndex < subtypeList[subtypeIndex].size(); eltIndex++){
                storedSubtypeList[subtypeIndex].add(subtypeList[subtypeIndex].get(eltIndex));
            }
        }

    }

    private void restore(){
        ArrayList<Integer>[] temp = subtypeList;
        subtypeList = storedSubtypeList;
        storedSubtypeList = temp;

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
