package scripts;

import state.SubTypeList;
import data.SingleMarkerData;
import inference.SingleTypeMCMC;
import inference.OldSingleTypeMCMC;
import utils.DataUtils;
import utils.Randomizer;

import java.io.PrintStream;
import java.util.ArrayList;

public class ForensicMCMCSingleType {
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){
        Randomizer.setSeed(123);
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        double[] alphaC = new double[]{0.5, 0.5, 0.5, 0.5, 0.5};
        double[] betaC = new double[]{2.0, 2.0, 0.25, 2.0, 2.0};
        ForensicMCMCSingleType subtypeClf = new ForensicMCMCSingleType();
        try {
            //subtypeClf.runCvfSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            //subtypeClf.runMtbSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            subtypeClf.runSlvSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            //subtypeClf.runBldSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            //subtypeClf.runSmnSingleTypeClustering(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            //subtypeClf.runSmnSingleTypeClusteringV2(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);

        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    private void runCvfSingleTypeClustering(String allPartitionSets5File,
                                            String allPartitionSets7File,
                                            double[] alphaC, double[] betaC) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.1845;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 73;
        int maxClustCount = 5;

        int[][][] dataMat = new int[OldSingleTypeMCMC.MARKER_GROUP_COUNT][][];

        for(int i = 0; i < COL_RANGE.length; i++){
            dataMat[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/cvf.single.csv",
                    COL_RANGE[i][0], COL_RANGE[i][1], 0, totalObsCount - 1);
        }

        SingleMarkerData data = new SingleMarkerData(dataMat);

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>();
        }

        for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
            subtypeParts[0].add(setIndex);
        }


        OldSingleTypeMCMC estSubtype = new OldSingleTypeMCMC(subtypeParts, mkrGrpPartitions, colPriors,
                alphaC, betaC, alphaRow, data,1000000);
        PrintStream logWriter = new PrintStream("/Users/chwu/Documents/research/bfc/output/cvf_single_clust1_0.5.log");
        estSubtype.run(logWriter, 100);
        logWriter.close();


    }
    private void runMtbSingleTypeClustering(String allPartitionSets5File,
                                            String allPartitionSets7File,
                                            double[] alphaC, double[] betaC) throws Exception{

        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.225;
        //double alpha5 = 2.11;
        //double alpha7 = 2.11;
        //double alphaRow = 2.11;
        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 32;
        int maxClustCount = 5;

        int[][][] dataMat = new int[OldSingleTypeMCMC.MARKER_GROUP_COUNT][][];

        for(int i = 0; i < COL_RANGE.length; i++){
            dataMat[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/mtb.single.csv",
                    COL_RANGE[i][0], COL_RANGE[i][1], 0, totalObsCount - 1);
        }

        SingleMarkerData data = new SingleMarkerData(dataMat);

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>();
        }

        for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
            subtypeParts[0].add(setIndex);
        }


        OldSingleTypeMCMC estSubtype = new OldSingleTypeMCMC(subtypeParts, mkrGrpPartitions, colPriors,
                alphaC, betaC, alphaRow, data,1000000);
        PrintStream logWriter = new PrintStream("/Users/chwu/Documents/research/bfc/output/mtb_single_clust1_0.5.log");
        estSubtype.run(logWriter, 100);
        logWriter.close();

    }

    private void runSlvSingleTypeClustering(String allPartitionSets5File,
                                            String allPartitionSets7File,
                                            double[] alphaC, double[] betaC) throws Exception{

        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.18;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 81;
        int maxClustCount = 5;

        int[][][] dataMat = new int[OldSingleTypeMCMC.MARKER_GROUP_COUNT][][];
        for(int i = 0; i < COL_RANGE.length; i++){
            dataMat[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv",
                    COL_RANGE[i][0], COL_RANGE[i][1], 0, totalObsCount - 1);
        }

        SingleMarkerData data = new SingleMarkerData(dataMat);

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>();
        }

        for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
            subtypeParts[0].add(setIndex);
        }




        OldSingleTypeMCMC estSubtype = new OldSingleTypeMCMC(subtypeParts, mkrGrpPartitions, colPriors,
                alphaC, betaC, alphaRow, data,1000);
        try{
            //String file = "/Users/chwu/Documents/research/bfc/output/slv_single_clust1_0.5.log";
            String file = "/Users/chwu/Documents/research/bfc/output/slv_single_clust1_0.5_test_seed_v1.log";
            PrintStream logWriter = new PrintStream(file);
            estSubtype.run(logWriter, 100);
            logWriter.close();
        }catch (Exception e){
            throw new RuntimeException(e);
        }

    }

    private void runBldSingleTypeClustering(String allPartitionSets5File,
                                            String allPartitionSets7File,
                                            double[] alphaC, double[] betaC) throws Exception{

        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.1894025;


        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 65;
        int maxClustCount = 5;

        int[][][] dataMat = new int[OldSingleTypeMCMC.MARKER_GROUP_COUNT][][];
        for(int i = 0; i < COL_RANGE.length; i++){
            dataMat[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv",
                    COL_RANGE[i][0], COL_RANGE[i][1], 0, totalObsCount - 1);
        }

        SingleMarkerData data = new SingleMarkerData(dataMat);

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>();
        }

        for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
            subtypeParts[0].add(setIndex);
        }


        OldSingleTypeMCMC estSubtype = new OldSingleTypeMCMC(subtypeParts, mkrGrpPartitions, colPriors,
                alphaC, betaC, alphaRow, data,1000000);

        PrintStream logWriter = new PrintStream("/Users/chwu/Documents/research/bfc/output/bld_single_clust1_0.5.log");
        estSubtype.run(logWriter, 100);
        logWriter.close();


    }

    private void runSmnSingleTypeClustering(String allPartitionSets5File,
                                            String allPartitionSets7File,
                                            double[] alphaC, double[] betaC) throws Exception{

        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.178;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 86;
        int maxClustCount = 5;

        int[][][] dataMat = new int[OldSingleTypeMCMC.MARKER_GROUP_COUNT][][];

        for(int i = 0; i < COL_RANGE.length; i++){
            dataMat[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/smn.single.csv",
                    COL_RANGE[i][0], COL_RANGE[i][1], 0, totalObsCount - 1);
        }

        SingleMarkerData data = new SingleMarkerData(dataMat);

        ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>();
        }

        for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
            subtypeParts[0].add(setIndex);
        }


        OldSingleTypeMCMC estSubtype = new OldSingleTypeMCMC(subtypeParts, mkrGrpPartitions, colPriors,
                alphaC, betaC, alphaRow, data,1000);
        PrintStream logWriter = new PrintStream("/Users/chwu/Documents/research/bfc/output/smn_single_clust1_0.5_test_seed2.log");
        estSubtype.run(logWriter, 100);
        logWriter.close();
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

        int[][][] dataMat = new int[OldSingleTypeMCMC.MARKER_GROUP_COUNT][][];

        for(int i = 0; i < COL_RANGE.length; i++){
            dataMat[i] = DataUtils.extractData("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/smn.single.csv",
                    COL_RANGE[i][0], COL_RANGE[i][1], 0, totalObsCount - 1);
        }
        SingleMarkerData data = new SingleMarkerData(dataMat);

                ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
            subtypeParts[setIndex] = new ArrayList<>();
        }

        for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
            subtypeParts[0].add(setIndex);
        }

        SubTypeList subTypeList =new SubTypeList(subtypeParts);



        SingleTypeMCMC estSubtype = new SingleTypeMCMC(subTypeList, mkrGrpPartitions, colPriors,
                alphaC, betaC, alphaRow, data,1000);
        PrintStream logWriter = new PrintStream("/Users/chwu/Documents/research/bfc/output/smn_single_clust1_0.5_test_seed2v2.log");
        estSubtype.run(logWriter, 100);
        logWriter.close();
    }




}
