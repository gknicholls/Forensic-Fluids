package scripts;

import inference.MCMC;
import utils.DataUtils;

import java.io.PrintStream;
import java.util.ArrayList;

public class ForensicMCMCCvfSingle {
    public static void main(String[] args){
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        int[][][][] mkrGrpPartitions = MCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.1845;
        //double alpha5 = 2.11;
        //double alpha7 = 2.11;
        //double alphaRow = 2.11;
        double[][] colPriors = MCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);
        double[] alphaC = new double[]{0.5, 0.5, 0.5, 0.5, 0.5};
        double[] betaC = new double[]{2.0, 2.0, 0.25, 2.0, 2.0};
        int totalObsCount = 73;
        int maxClustCount = 5;

        int[][][] data = new int[MCMC.MARKER_GROUP_COUNT][][];
        int[][] colRange = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};
        for(int i = 0; i < colRange.length; i++){
            data[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/cvf.single.csv",
                    colRange[i][0], colRange[i][1], 0, totalObsCount - 1);
        }

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>();
        }

        for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
            subtypeParts[0].add(setIndex);
        }


        MCMC estSubtype = new MCMC(subtypeParts, mkrGrpPartitions, colPriors,
                alphaC, betaC, alphaRow, data,1000000);
        try{
            PrintStream logWriter = new PrintStream("/Users/chwu/Documents/research/bfc/output/cvf_single_clust1_0.5.log");
            estSubtype.run(logWriter, 100);
            logWriter.close();
        }catch (Exception e){
            throw new RuntimeException(e);
        }


    }


}
