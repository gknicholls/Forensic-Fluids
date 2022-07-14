package scripts;

import model.AbstractProbability;
import state.State;
import state.SubTypeList;
import state.TypeList;
import inference.AssignSingleRowWrapper;
import inference.MCMC;
import inference.OldSingleTypeMCMC;
import model.CompoundClusterPrior;
import model.DummyLikelihood;
import utils.Randomizer;

import java.util.ArrayList;

public class TestPriorMCMC {

    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){

        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        double[] alphaC = new double[]{0.5, 0.5, 0.5, 0.5, 0.5};
        double[] betaC = new double[]{2.0, 2.0, 0.25, 2.0, 2.0};
        TestPriorMCMC subtypeClf = new TestPriorMCMC();
        try {

            //Randomizer.setSeed(123);
            //subtypeClf.runEx7Obs(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);
            Randomizer.setSeed(123);
            subtypeClf.runMultiTypeObs(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);


        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    private void runEx7Obs(String allPartitionSets5File,
                                              String allPartitionSets7File,
                                              double[] alphaC, double[] betaC) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        //double alpha5 = 0.49;
        //double alpha7 = 0.375;
        double alphaRow = 20;


        int totalObsCount = 7;
        int maxClustCount;

        for(int maxCountIndex = 0; maxCountIndex < totalObsCount; maxCountIndex++){
            maxClustCount = maxCountIndex + 1;

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
            State[] states = new State[]{typeList};

            AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
            CompoundClusterPrior mdpPrior = new CompoundClusterPrior("multiTypeMDP", alphaRow, maxClustCount, new int[]{totalObsCount}, typeList);
            DummyLikelihood lik = new DummyLikelihood();

            AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};
            String outputFilePath = "/Users/chwu/Documents/research/bfc/output/ex.7obs_J" + maxClustCount + "_v2.log";
            MCMC estSubtype = new MCMC(probs, singleRowMove, states, 1000000, 1, outputFilePath);
            estSubtype.run();
        }




    }


    private void runMultiTypeObs(String allPartitionSets5File,
                           String allPartitionSets7File,
                           double[] alphaC, double[] betaC) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        //double alpha5 = 0.49;
        //double alpha7 = 0.375;
        double alphaRow = 20;


        int totalObsCount1 = 7;
        int totalObsCount2 = 5;
        int totalObsCount3 = 10;
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

            ArrayList<Integer>[] subtypeParts3 = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
            for(int setIndex = 0; setIndex < subtypeParts3.length; setIndex++){
                subtypeParts3[setIndex] = new ArrayList<>();

            }
            for(int obsIndex = 0; obsIndex < totalObsCount3; obsIndex++){
                subtypeParts3[0].add(obsIndex);
            }



            SubTypeList subTypeList1 = new SubTypeList(subtypeParts1);
            SubTypeList subTypeList2 = new SubTypeList(subtypeParts2);
            SubTypeList subTypeList3 = new SubTypeList(subtypeParts3);

            SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList1, subTypeList2, subTypeList3};
            TypeList typeList = new TypeList("partition", subTypeLists);
        State[] states = new State[]{typeList};

            AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
            CompoundClusterPrior mdpPrior = new CompoundClusterPrior("multTypeMDP", alphaRow, maxClustCount,
                    new int[]{totalObsCount1, totalObsCount2, totalObsCount3}, typeList);
            DummyLikelihood lik = new DummyLikelihood();

            AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};
            //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_14/ex.multiTypeObs_2022_07_14.log";
        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_14/ex.multiTypeObs_2022_07_14_v2.log";
            MCMC estSubtype = new MCMC(probs, singleRowMove, states, 1000000, 1, outputFilePath);
            estSubtype.run();
        //}




    }
}
