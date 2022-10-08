package scripts.tests;

import data.CompoundMarkerData;
import distribution.Gamma;
import inference.*;
import model.AbstractProbability;
import model.CompoundClusterLikelihood;
import model.CompoundClusterPrior;
import state.Parameter;
import state.State;
import state.SubTypeList;
import state.TypeList;
import utils.Randomizer;

import java.util.ArrayList;


public class TestSamplingPartitionAndShapesCVF {

    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){

        TestSamplingPartitionAndShapesCVF mcmcPrior = new TestSamplingPartitionAndShapesCVF();
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
        double alphaRow = 0.1865;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        int totalObsCount = 70;
        int maxClustCount = 5;

        String dataFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/cvf.single_noAll0s.csv";
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


        Parameter gammaShape0a = new Parameter("gamma.shape", new double[]{0.01}, 0);
        Parameter gammaScale0a = new Parameter("gamma.scale", new double[]{100}, 0);

        Parameter gammaShape0b = new Parameter("gamma.shape", new double[]{0.01}, 0);
        Parameter gammaScale0b = new Parameter("gamma.scale", new double[]{100}, 0);


        ScaleMove scaleMoveA = new ScaleMove(shapeA, 0.1);
        ScaleMove scaleMoveB = new ScaleMove(shapeB, 0.1);
        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        ProposalMove[] proposalMoves = new ProposalMove[]{scaleMoveA, scaleMoveB, singleRowMove};
        double[] proposalWeights = new double[]{1.0, 1.0, 10.0};


        Gamma gammaPrior0a = new Gamma("gammaPrior.a0", gammaShape0a, gammaScale0a, shapeA, 0);
        Gamma gammaPrior1a = new Gamma("gammaPrior.a1", gammaShape0a, gammaScale0a, shapeA, 1);
        Gamma gammaPrior2a = new Gamma("gammaPrior.a2", gammaShape0a, gammaScale0a, shapeA, 2);
        Gamma gammaPrior3a = new Gamma("gammaPrior.a3", gammaShape0a, gammaScale0a, shapeA, 3);
        Gamma gammaPrior4a = new Gamma("gammaPrior.a4", gammaShape0a, gammaScale0a, shapeA, 4);

        Gamma gammaPrior0b = new Gamma("gammaPrior.b0", gammaShape0b, gammaScale0b, shapeB, 0);
        Gamma gammaPrior1b = new Gamma("gammaPrior.b1", gammaShape0b, gammaScale0b, shapeB, 1);
        Gamma gammaPrior2b = new Gamma("gammaPrior.b2", gammaShape0b, gammaScale0b, shapeB, 2);
        Gamma gammaPrior3b = new Gamma("gammaPrior.b3", gammaShape0b, gammaScale0b, shapeB, 3);
        Gamma gammaPrior4b = new Gamma("gammaPrior.b4", gammaShape0b, gammaScale0b, shapeB, 4);

        CompoundClusterPrior mdpPrior =
                new CompoundClusterPrior("multiTypeMDP", alphaRow,
                        maxClustCount, new int[]{totalObsCount}, typeList);
        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, dataSets,
                new Parameter[]{shapeA},
                new Parameter[]{shapeB},
                typeList);
        AbstractProbability[] probs = new AbstractProbability[]{lik, mdpPrior,
                gammaPrior0a, gammaPrior1a, gammaPrior2a, gammaPrior3a, gammaPrior4a,
                gammaPrior0b, gammaPrior1b, gammaPrior2b, gammaPrior3b, gammaPrior4b};
        State[] states = new State[]{shapeA, shapeB, typeList};

        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_09_16/test_cvf_single_estBetaShapes_2022_09_16_v2.log";
        MCMC estSubtype = new MCMC(probs, proposalMoves, proposalWeights, states, 2000000, 1000, outputFilePath);
        estSubtype.run();




    }
}
