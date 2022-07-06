package inference;

import cluster.SubTypeList;
import model.ClusterLikelihood;
import model.ClusterPrior;
import model.OldClusterLikelihood;
import utils.DataUtils;
import utils.Randomizer;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintStream;

public class SingleTypeMCMC {
    public static final int SET5_SIZE = 5;
    public static final int SET7_SIZE = 7;
    public static final int SET5_PARTITION_COUNT = 52;
    public static final int SET7_PARTITION_COUNT = 877;
    public static final int MARKER_GROUP_COUNT = 5;




    private SubTypeList subtypeList;
    private int[][][][] mkrGrpPartitions;
    private double[][] colPriors;
    private double[] alphaC;
    private double[] betaC;
    private int[][][] data;
    private double alpha;

    private int maxSetCount;
    private int chainLength;
    public SingleTypeMCMC(SubTypeList subtypeList, int[][][][] mkrGrpPartitions,
                          double[][] colPriors, double[] alphaC, double[] betaC,
                          double alpha, int[][][] data, int chainLength){
        this.subtypeList = subtypeList;
        this.mkrGrpPartitions = mkrGrpPartitions;
        this.colPriors = colPriors;
        this.alphaC = alphaC;
        this.betaC = betaC;
        this.alpha = alpha;
        this.data = data;
        this.chainLength = chainLength;
        maxSetCount = this.subtypeList.getSubTypeMaxCount();
        this.subtypeList.store();

    }

    public void run(PrintStream output, int logEvery){
        double currLogLik = OldClusterLikelihood.CalcLogTypeLikelihood(mkrGrpPartitions,
                colPriors, data, alphaC, betaC, subtypeList);
        double currLogPrior = ClusterPrior.calcLogMDPDensity(
                alpha, subtypeList.getSubTypeMaxCount(), subtypeList, subtypeList.getTotalObsCount());
        double currLogPost = currLogLik + currLogPrior;
        double logHR, propLogLik, propLogPrior, propLogPost, logMHR;

        output.println("STATE\tPosterior\tLog-likelihood\tLog-prior\tPartition\tstoredPartition\tPropPartiton\tlogHR\tlogMHR\tdraw");
        log(output, currLogPost, currLogLik, currLogPrior, 0, subtypeList.printCurrCluster(), subtypeList.printStoredCluster(),0, 0, 0);
        for(int stepIndex = 0; stepIndex < chainLength; stepIndex++){
            //System.out.println(stepIndex);
            //store();
            subtypeList.store();
            String storedClust = subtypeList.printStoredCluster();
            //System.out.println(stepIndex+": "+storedClust);
            //if(  (stepIndex%5) == 0){
            //    logHR = RandomPartitionMove.randomPartition(subtypeList);
            //}else{
                logHR = AssignSingleRow.SingleRowMove(subtypeList);
            //}



            propLogLik = OldClusterLikelihood.CalcLogTypeLikelihood(mkrGrpPartitions,
                    colPriors, data, alphaC, betaC, subtypeList);
            //propLogLik = 0.0;
            propLogPrior = ClusterPrior.calcLogMDPDensity(
                    alpha, subtypeList.getSubTypeMaxCount(), subtypeList, subtypeList.getTotalObsCount());
            propLogPost = propLogLik + propLogPrior;
            logMHR = propLogPost  - currLogPost + logHR;
            String propClust = subtypeList.printCurrCluster();


            double draw = Math.log(Randomizer.nextDouble());
            if( logMHR >= 0.0 || draw < logMHR ){

                currLogPost = propLogPost;
                currLogPrior = propLogPrior;
                currLogLik = propLogLik;
            }else{
                subtypeList.restore();
            }
            /*if(accepted){
                System.out.println("accepted "+ currLogLik+" "+ currLogPrior);
            }*/

            if(((stepIndex + 1)%logEvery) == 0){
                System.out.println("log "+ currLogLik+" "+ currLogPrior+" "+subtypeList.getTotalObsCount());
                log(output, currLogPost, currLogLik, currLogPrior, stepIndex + 1, propClust, storedClust, logHR, logMHR, draw );
            }


        }


    }

    private void log(PrintStream output, double posterior, double likelihood,
                     double prior, int state, String propClust, String storedClust,
                     double logHR, double logMHR, double draw){

        output.println(state + "\t" + posterior + "\t" + likelihood + "\t" + prior+ "\t"
                + storedClust+ "\t"+ storedClust+ "\t"+propClust+"\t"+logHR+"\t"+logMHR+"\t"+ draw );

    }





    public static int[][][][] getMkerGroupPartitions(String allPartSets5File,
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

                        clusts[lineIndex][clustIndex][obsIndex] = Integer.parseInt(obsInClust[obsIndex]);

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
            data[i] = DataUtils.extractData(file,colRange[i][0], colRange[i][1], 0, 9);
        }
        return data;
    }




    public static double[][] getColPriors(double alpha5,
                                          double alpha7,
                                          String allPartSets5File,
                                          String allPartSets7File){

        int[][][] partSet5 = getClusterArray(allPartSets5File, SET5_PARTITION_COUNT);
        double[] mdpProbSet5 = new double[SET5_PARTITION_COUNT];
        for (int partIndex = 0; partIndex < partSet5.length; partIndex++) {
            mdpProbSet5[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha5,
                    SET5_SIZE,
                    partSet5[partIndex],
                    SET5_SIZE);
        }

        int[][][] partSet7 = getClusterArray(allPartSets7File, SET7_PARTITION_COUNT);
        double[] mdpProbSet7 = new double[SET7_PARTITION_COUNT];
        for (int partIndex = 0; partIndex < partSet7.length; partIndex++) {
            mdpProbSet7[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha7,
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
