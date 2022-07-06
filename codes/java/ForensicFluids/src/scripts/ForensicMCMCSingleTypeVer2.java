package scripts;

import cluster.State;
import cluster.SubTypeList;
import cluster.TypeList;
import inference.*;
import model.ClusterLikelihood;
import model.ClusterPrior;
import model.Likelihood;
import utils.DataUtils;
import utils.Randomizer;

import java.io.PrintStream;
import java.util.ArrayList;

public class ForensicMCMCSingleTypeVer2 {
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){
        Randomizer.setSeed(123);
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        double[] alphaC = new double[]{0.5, 0.5, 0.5, 0.5, 0.5};
        double[] betaC = new double[]{2.0, 2.0, 0.25, 2.0, 2.0};
        ForensicMCMCSingleTypeVer2 subtypeClf = new ForensicMCMCSingleTypeVer2();
        try {
            //subtypeClf.runCvfSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            //subtypeClf.runMtbSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            //subtypeClf.runSlvSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            //subtypeClf.runBldSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            //subtypeClf.runSmnSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            subtypeClf.runSmnSingleTypeClusteringV2(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);

        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }


    private void runSmnSingleTypeClusteringV2(String allPartitionSets5File,
                                            String allPartitionSets7File,
                                            double[] alphaC, double[] betaC) throws Exception{

        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.178;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 86;
        int maxClustCount = 5;

        int[][][] data = new int[OldSingleTypeMCMC.MARKER_GROUP_COUNT][][];

        for(int i = 0; i < COL_RANGE.length; i++){
            data[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/smn.single.csv",
                    COL_RANGE[i][0], COL_RANGE[i][1], 0, totalObsCount - 1);
        }

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>();
        }

        for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
            subtypeParts[0].add(setIndex);
        }

        SubTypeList subTypeList = new SubTypeList(subtypeParts);
        AssignSingleRow singleRowMove = new AssignSingleRow(subTypeList);
        ClusterPrior mdpPrior = new ClusterPrior(alphaRow, maxClustCount, subTypeList, totalObsCount);
        ClusterLikelihood lik = new ClusterLikelihood(mkrGrpPartitions, colPriors, data, alphaC, betaC, subTypeList);

        MCMC estSubtype = new MCMC(mdpPrior, lik, singleRowMove, subTypeList, 1000);
        PrintStream logWriter = new PrintStream("/Users/chwu/Documents/research/bfc/output/smn_single_clust1_0.5_test_seed2v3.log");
        estSubtype.run(logWriter, 100);
        logWriter.close();
    }




}
