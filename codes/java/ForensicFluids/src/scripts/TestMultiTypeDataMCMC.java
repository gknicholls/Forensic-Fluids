package scripts;

import data.CompoundMarkerData;
import data.CompoundMarkerDataWithUnknown;
import inference.*;
import model.AbstractProbability;
import model.CompoundClusterLikelihood;
import model.CompoundClusterPrior;
import model.DummyLikelihood;
import state.Parameter;
import state.State;
import state.SubTypeList;
import state.TypeListWithUnknown;
import utils.Randomizer;

import java.util.ArrayList;

public class TestMultiTypeDataMCMC {
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){

        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        double[] alphaC = new double[]{0.5, 0.5, 0.5, 0.5, 0.5};
        double[] betaC = new double[]{2.0, 2.0, 0.25, 2.0, 2.0};
        TestMultiTypeDataMCMC subtypeClf = new TestMultiTypeDataMCMC();
        try {

            //Randomizer.setSeed(123);
            Randomizer.setSeed(123);
            subtypeClf.runMultiTypeObs(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);


        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    private void runMultiTypeObs(String allPartitionSets5File,
                                 String allPartitionSets7File,
                                 double[] alphaC, double[] betaC) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow1 = 0.18;
        double alphaRow2 = 0.1894025;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);



        int totalObsCount1 = 81;
        int totalObsCount2 = 65;
        int maxClustCount = 5;

        //for(int maxCountIndex = 0; maxCountIndex < totalObsCount1; maxCountIndex++){
        //maxClustCount = maxCountIndex + 1;

        ArrayList<Integer>[] subtypeParts1 = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts1.length; setIndex++){
            subtypeParts1[setIndex] = new ArrayList<>();

        }

        for(int obsIndex = 0; obsIndex < totalObsCount1; obsIndex++){
            subtypeParts1[0].add(obsIndex);
        }



        ArrayList<Integer>[] subtypeParts2 = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts2.length; setIndex++){
            subtypeParts2[setIndex] = new ArrayList<>();
        }

        for(int obsIndex = 0; obsIndex < totalObsCount2; obsIndex++){
            subtypeParts2[0].add(obsIndex);
        }

        subtypeParts2[0].add(146);

        SubTypeList subTypeList1 = new SubTypeList(subtypeParts1);
        SubTypeList subTypeList2 = new SubTypeList(subtypeParts2);

        SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList1, subTypeList2};
        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, 146);

        String slvFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv";
        String bldFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv";
        String unknownPath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/unknown.csv";
        int[][] rowInfo = new int[][]{new int[]{0, totalObsCount1 - 1}, new int[]{0, totalObsCount2 - 1}};
        int[][][] colInfo = new int[][][]{COL_RANGE, COL_RANGE};
        int[] rowInfoUnknown = new int[]{0, 1};
        CompoundMarkerDataWithUnknown dataSets =  new CompoundMarkerDataWithUnknown(
                new String[]{slvFilePath, bldFilePath}, unknownPath, rowInfo,  colInfo, rowInfoUnknown, COL_RANGE, typeList);






        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        AssignBetweenTypes btwnTypeMove = new AssignBetweenTypes(typeList);
        ProposalMove[] proposals = new ProposalMove[]{singleRowMove, btwnTypeMove};
        CompoundClusterPrior mdpPrior = new CompoundClusterPrior("multiTypeMDP",
                alphaRow1, maxClustCount,
                new int[]{totalObsCount1, totalObsCount2}, typeList);


        Parameter shapeA = new Parameter("shape.a", alphaC, 0);
        Parameter shapeB = new Parameter("shape.a", betaC, 0);
        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, dataSets,
                new Parameter[]{shapeA, shapeA},
                new Parameter[]{shapeB, shapeB},
                typeList);
        State[] states = new State[]{typeList, lik};

        AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};
        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_18/ex.multiTypeObsWithUnknown_2022_07_18.log";
        MCMC estSubtype = new MCMC(probs, proposals, null, states, 1000000, 100, outputFilePath);
        estSubtype.run();
        //}




    }
}
