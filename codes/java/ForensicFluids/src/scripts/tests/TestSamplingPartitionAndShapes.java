package scripts.tests;

import data.CompoundMarkerData;
import inference.*;
import model.*;
import state.*;
import utils.Randomizer;

import java.util.ArrayList;



public class TestSamplingPartitionAndShapes {

    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){

        TestSamplingPartitionAndShapes mcmcPrior = new TestSamplingPartitionAndShapes();
        try {

            String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
            String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";


            Randomizer.setSeed(123);
            mcmcPrior.runEx7ObsShape1(allPartitionSets5File, allPartitionSets7File);


        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }


    private void runEx7ObsShape1(String allPartitionSets5File,
                                 String allPartitionSets7File){
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow = 0.18;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 81;
        int maxClustCount = 5;

        String dataFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv";
        int[][] rowInfo = new int[][]{new int[]{0, totalObsCount - 1}};
        int[][][] colInfo = new int[][][]{COL_RANGE};
        CompoundMarkerData dataSets =  new CompoundMarkerData(new String[]{dataFilePath}, rowInfo,  colInfo);


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

        Parameter shapeA = new Parameter("shape.a", new double[]{0.5, 0.5, 0.50, 0.5, 0.5}, 0);
        Parameter shapeB = new Parameter("shape.b", new double[]{1.0, 1.0, 1.0, 1.0, 1.0}, 0);


        Parameter gammaShape0 = new Parameter("gamma.shape", new double[]{100}, 0);
        Parameter gammaScale0 = new Parameter("gamma.scale", new double[]{0.001}, 0);


        ScaleMove scaleMove = new ScaleMove(shapeA, 0.75);
        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        ProposalMove[] proposalMoves = new ProposalMove[]{scaleMove, singleRowMove};
        double[] proposalWeights = new double[]{1.0, 1.0};


        Gamma gammaPrior0 = new Gamma("gammaPrior.0", gammaShape0, gammaScale0, shapeA, 0);
        Gamma gammaPrior1 = new Gamma("gammaPrior.1", gammaShape0, gammaScale0, shapeA, 1);
        Gamma gammaPrior2 = new Gamma("gammaPrior.2", gammaShape0, gammaScale0, shapeA, 2);
        Gamma gammaPrior3 = new Gamma("gammaPrior.3", gammaShape0, gammaScale0, shapeA, 3);
        Gamma gammaPrior4 = new Gamma("gammaPrior.4", gammaShape0, gammaScale0, shapeA, 4);
        CompoundClusterPrior mdpPrior =
                new CompoundClusterPrior("multiTypeMDP", alphaRow,
                        maxClustCount, new int[]{totalObsCount}, typeList);
        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, dataSets,
                new Parameter[]{shapeA},
                new Parameter[]{shapeB},
                typeList);
        AbstractProbability[] probs = new AbstractProbability[]{lik, mdpPrior,
                gammaPrior0, gammaPrior1, gammaPrior2, gammaPrior3, gammaPrior4};
        State[] states = new State[]{subTypeList, shapeA};

        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_15/test_slv_single_7obs_part_shapeA_2022_07_15_v4.log";
        MCMC estSubtype = new MCMC(probs, proposalMoves, null, states, 1000000, 100, outputFilePath);
        estSubtype.run();




    }
}
