package scripts;

import model.AbstractProbability;
import state.State;
import state.SubTypeList;
import state.TypeListWithUnknown;
import inference.*;
import model.CompoundClusterPrior;
import model.DummyLikelihood;
import utils.Randomizer;

import java.util.ArrayList;

public class TestMultiTypeDataMDPPriorMCMC {
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){

        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        double[] alphaC = new double[]{0.5, 0.5, 0.5, 0.5, 0.5};
        double[] betaC = new double[]{2.0, 2.0, 0.25, 2.0, 2.0};
        TestMultiTypeDataMDPPriorMCMC subtypeClf = new TestMultiTypeDataMDPPriorMCMC();
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
        //double alpha5 = 0.49;
        //double alpha7 = 0.375;
        double alphaRow = 20;


        int totalObsCount1 = 4;
        int totalObsCount2 = 6;
        int maxClustCount = 4;

        //for(int maxCountIndex = 0; maxCountIndex < totalObsCount1; maxCountIndex++){
        //maxClustCount = maxCountIndex + 1;

        ArrayList<Integer>[] subtypeParts1 = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts1.length; setIndex++){
            subtypeParts1[setIndex] = new ArrayList<>();

        }

        for(int obsIndex = 0; obsIndex < totalObsCount1; obsIndex++){
            subtypeParts1[0].add(obsIndex);
        }

        subtypeParts1[0].add(10);

        ArrayList<Integer>[] subtypeParts2 = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
        for(int setIndex = 0; setIndex < subtypeParts2.length; setIndex++){
            subtypeParts2[setIndex] = new ArrayList<>();
        }

        for(int obsIndex = 0; obsIndex < totalObsCount2; obsIndex++){
            subtypeParts2[0].add(obsIndex);
        }





        SubTypeList subTypeList1 = new SubTypeList(subtypeParts1);
        SubTypeList subTypeList2 = new SubTypeList(subtypeParts2);

        SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList1, subTypeList2};
        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, 10);

        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        AssignBetweenTypes btwnTypeMove = new AssignBetweenTypes(typeList);
        ProposalMove[] proposals = new ProposalMove[]{singleRowMove, btwnTypeMove};
        CompoundClusterPrior mdpPrior = new CompoundClusterPrior("multiTypeMDP", alphaRow, maxClustCount,
                new int[]{totalObsCount1, totalObsCount2}, typeList);
        DummyLikelihood lik = new DummyLikelihood();
        State[] states = new State[]{typeList};

        AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};
        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/ex.multiTypeObsWithUnknown_1.01.log";
        MCMC estSubtype = new MCMC(probs, proposals, null, states, 1000000, 100, outputFilePath);
        estSubtype.run();
        //}




    }
}
