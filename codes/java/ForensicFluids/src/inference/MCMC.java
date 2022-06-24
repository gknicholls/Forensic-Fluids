package inference;

import model.ClusterLikelihood;
import model.ClusterPrior;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Random;

public class MCMC {
    public static final int SET5_SIZE = 5;
    public static final int SET7_SIZE = 7;
    public static final int SET5_PARTITION_COUNT = 52;
    public static final int SET7_PARTITION_COUNT = 877;
    public static final int MARKER_GROUP_COUNT = 5;
    final private static Random random = new Random();

    public static void main(String[] args){
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        int[][][][] mkrGrpPartitions = getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alphaCol = 1.2;
        double alphaRow = 20.0;
        double[][] colPriors = getColPriors(alphaCol, allPartitionSets5File, allPartitionSets7File);
        double[] alphaC = new double[]{0.97, 1.0, 0.98, 1.08, 1.05};
        double[] betaC = new double[]{1.06, 1.07, 1.02, 0.97, 0.95};
        //double[] alphaC = new double[]{1.0, 1.0, 1.0, 1.0, 1.0};
        //double[] betaC = new double[]{1.0, 1.0, 1.0, 1.0, 1.0};
        int totalObsCount = 3;

        int[][][] data = new int[MARKER_GROUP_COUNT][][];
        int[][] colRange = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};
        for(int i = 0; i < colRange.length; i++){
            data[i] = extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/ex.3obs.dat.csv",
                    colRange[i][0], colRange[i][1], 0, totalObsCount-1);
        }

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[totalObsCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>(Arrays.asList(setIndex));
        }

        MCMC estSubtype = new MCMC(subtypeParts, mkrGrpPartitions, colPriors,
                alphaC, betaC, alphaRow, data,1000);
        try{
            PrintStream logWriter = new PrintStream("/Users/chwu/Documents/research/bfc/output/testBFC_3obsv.log");
            estSubtype.run(logWriter, 1);
            logWriter.close();
        }catch (Exception e){
            throw new RuntimeException(e);
        }


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

    protected void run(PrintStream output, int logEvery){
        double currLogLik = ClusterLikelihood.CalcLogTypeLikelihood(mkrGrpPartitions,
                colPriors, data, alphaC, betaC, subtypeList);
        double currLogPrior = ClusterPrior.calcLogMDPDensity(
                alpha, subtypeList.length, subtypeList, totalObsCount);
        double currLogPost = currLogLik + currLogPrior;
        double logHR, propLogLik, propLogPrior, propLogPost, logMHR;

        output.println("STATE\tPosterior\tLog-likelihood\tLog-prior\tPartition\tstoredPartition\tPropPartiton\tlogHR\tlogMHR\tdraw");
        log(output, currLogPost, currLogLik, currLogPrior, 0, printCluster(subtypeList), printCluster(storedSubtypeList),0, 0, 0);
        for(int stepIndex = 0; stepIndex < chainLength; stepIndex++){
            store();
            String storedClust = printCluster(storedSubtypeList);
            //System.out.println(stepIndex+":"+printCluster(subtypeList)+" "+storedClust);
            //logHR = AssignSingleRow.SingleRowMove(subtypeList);

            logHR = RandomPartitionMove.randomPartition(subtypeList);
            propLogLik = ClusterLikelihood.CalcLogTypeLikelihood(mkrGrpPartitions,
                    colPriors, data, alphaC, betaC, subtypeList);
            propLogPrior = ClusterPrior.calcLogMDPDensity(
                    alpha, subtypeList.length, subtypeList, totalObsCount);
            propLogPost = propLogLik + propLogPrior;
            logMHR = propLogPost  - currLogPost + logHR;
            String propClust = printCluster(subtypeList);


            double draw = Math.log(random.nextDouble());
            if( logMHR >= 0.0 || draw < logMHR ){

                currLogPost = propLogPost;
                currLogPrior = propLogPrior;
                currLogLik = propLogLik;
            }else{
                restore();
            }
            /*if(accepted){
                System.out.println("accepted "+ currLogLik+" "+ currLogPrior);
            }*/

            if(((stepIndex + 1)%logEvery) == 0){
                //System.out.println("log "+ currLogLik+" "+ currLogPrior);
                log(output, currLogPost, currLogLik, currLogPrior, stepIndex + 1, propClust, storedClust, logHR, logMHR, draw );
            }


        }


    }

    private void log(PrintStream output, double posterior, double likelihood, double prior, int state, String propClust, String storedClust, double logHR, double logMHR, double draw){

        output.println(state + "\t" + posterior + "\t" + likelihood + "\t" + prior+ "\t" + storedClust+ "\t"+ storedClust+ "\t"+propClust+"\t"+logHR+"\t"+logMHR+"\t"+draw );

    }

    private String printCluster(ArrayList<Integer>[] subtypeList){

        String setStr;
        ArrayList<String> setStrList = new ArrayList<String> ();
        for(int subtypeIndex = 0; subtypeIndex < subtypeList.length; subtypeIndex++){

            if(subtypeList[subtypeIndex].size() > 0){
                /*if(!setsStr.equals("[")){
                    setsStr += ",";
                }*/

                setStr = "[";
                Collections.sort(subtypeList[subtypeIndex]);
                for(int eltIndex = 0; eltIndex < subtypeList[subtypeIndex].size(); eltIndex++){
                    setStr += subtypeList[subtypeIndex].get(eltIndex);
                    if(eltIndex < (subtypeList[subtypeIndex].size() - 1)){
                        setStr+=",";
                    }

                }
                setStr += "]";
                setStrList.add(setStr);
                //setsStr += setStr;

            }

        }

        Collections.sort(setStrList);
        String setsStr = "[";
        for(int setIndex = 0; setIndex < setStrList.size(); setIndex++){
            if(setIndex >0){
                setsStr+=",";
            }
            setsStr+=setStrList.get(setIndex);

        }

        setsStr += "]";

        return setsStr;

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
        int[][][][] mkrGrpParts = new int[MARKER_GROUP_COUNT][][][];
        int[][][] allPartitionSets5 = getClusterArray(allPartSets5File, SET5_PARTITION_COUNT);
        int[][][] allPartitionSets7 = getClusterArray(allPartSets7File, SET7_PARTITION_COUNT);
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
        int[][][] data = new int[MARKER_GROUP_COUNT][][];
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
                                          String allPartSets7File){

        int[][][] partSet5 = getClusterArray(allPartSets5File, SET5_PARTITION_COUNT);
        double[] mdpProbSet5 = new double[SET5_PARTITION_COUNT];
        for (int partIndex = 0; partIndex < partSet5.length; partIndex++) {
            mdpProbSet5[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha,
                    SET5_SIZE,
                    partSet5[partIndex],
                    SET5_SIZE);
        }

        int[][][] partSet7 = getClusterArray(allPartSets7File, SET7_PARTITION_COUNT);
        double[] mdpProbSet7 = new double[SET7_PARTITION_COUNT];
        for (int partIndex = 0; partIndex < partSet7.length; partIndex++) {
            mdpProbSet7[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha,
                    SET7_SIZE,
                    partSet7[partIndex],
                    SET7_SIZE);
        }



        double[][] colPriors = new double[MARKER_GROUP_COUNT][];
        colPriors[0] = mdpProbSet5;
        colPriors[1] = mdpProbSet7;
        colPriors[2] = mdpProbSet5;
        colPriors[3] = mdpProbSet5;
        colPriors[4] = mdpProbSet5;

        return colPriors;
    }

}
