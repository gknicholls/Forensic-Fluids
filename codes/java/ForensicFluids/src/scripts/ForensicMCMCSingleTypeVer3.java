package scripts;

import cluster.SubTypeList;
import cluster.TypeList;
import data.CompoundMarkerData;
import inference.AssignSingleRow;
import inference.AssignSingleRowWrapper;
import inference.MCMC;
import inference.OldSingleTypeMCMC;
import model.ClusterLikelihood;
import model.ClusterPrior;
import model.CompoundClusterLikelihood;
import model.CompoundClusterPrior;
import utils.DataUtils;
import utils.Randomizer;

import java.util.ArrayList;

public class ForensicMCMCSingleTypeVer3 {
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){

        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        double[] alphaC = new double[]{0.5, 0.5, 0.5, 0.5, 0.5};
        double[] betaC = new double[]{2.0, 2.0, 0.25, 2.0, 2.0};
        ForensicMCMCSingleTypeVer3 subtypeClf = new ForensicMCMCSingleTypeVer3();
        try {

            Randomizer.setSeed(123);
            subtypeClf.runSlvSingleTypeClusteringV3(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            Randomizer.setSeed(123);
            subtypeClf.runSmnSingleTypeClusteringV4(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);

        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    private void runSlvSingleTypeClusteringV3(String allPartitionSets5File,
                                              String allPartitionSets7File,
                                              double[] alphaC, double[] betaC) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.18;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 81;
        int maxClustCount = 5;

        int[][][] data = new int[OldSingleTypeMCMC.MARKER_GROUP_COUNT][][];
        for(int i = 0; i < COL_RANGE.length; i++){
            data[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv",
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
        SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList};
        TypeList typeList = new TypeList(subTypeLists);

        String dataFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv";
        int[][] rowInfo = new int[][]{new int[]{0, totalObsCount - 1}};
        int[][][] colInfo = new int[][][]{COL_RANGE};
        CompoundMarkerData dataSets =  new CompoundMarkerData(new String[]{dataFilePath}, rowInfo,  colInfo);
        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        CompoundClusterPrior mdpPrior = new CompoundClusterPrior(alphaRow, maxClustCount, new int[]{totalObsCount}, typeList);
        CompoundClusterLikelihood lik = new CompoundClusterLikelihood(mkrGrpPartitions, colPriors, dataSets, alphaC, betaC, typeList);

        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/slv_single_clust1_0.5_test_seed_v3.log";
        MCMC estSubtype = new MCMC(mdpPrior, lik, singleRowMove, typeList, 1000, 100, outputFilePath);
        estSubtype.run();



    }


    private void runSmnSingleTypeClusteringV4(String allPartitionSets5File,
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

        String dataFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/smn.single.csv";
        int[][] rowInfo = new int[][]{new int[]{0, totalObsCount - 1}};
        int[][][] colInfo = new int[][][]{COL_RANGE};
        CompoundMarkerData dataSets =  new CompoundMarkerData(new String[]{dataFilePath}, rowInfo,  colInfo);

        SubTypeList subTypeList = new SubTypeList(subtypeParts);
        SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList};
        TypeList typeList = new TypeList(subTypeLists);
        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        CompoundClusterPrior mdpPrior = new CompoundClusterPrior(alphaRow, maxClustCount, new int[]{totalObsCount}, typeList);
        CompoundClusterLikelihood lik = new CompoundClusterLikelihood(mkrGrpPartitions, colPriors, dataSets, alphaC, betaC, typeList);

        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/smn_single_clust1_0.5_test_seed2v4.log";
        MCMC estSubtype = new MCMC(mdpPrior, lik, singleRowMove, subTypeList, 1000, 100, outputFilePath);
        estSubtype.run();
    }

}
