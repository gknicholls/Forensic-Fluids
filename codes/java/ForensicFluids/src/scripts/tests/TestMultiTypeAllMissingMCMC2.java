package scripts.tests;

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

public class TestMultiTypeAllMissingMCMC2 {
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){

        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";

        TestMultiTypeAllMissingMCMC2 allMissingProfile = new TestMultiTypeAllMissingMCMC2();
        try {

            Randomizer.setSeed(333);
            //Randomizer.setSeed(702974802);
            allMissingProfile.runMultiTypeAllMissingProfileEx1(allPartitionSets5File, allPartitionSets7File);
            //
            //allMissingProfile.runMultiTypeAllMissingProfileEx3(allPartitionSets5File, allPartitionSets7File);




        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }


    private void runMultiTypeAllMissingProfileEx1(String allPartitionSets5File,
                                               String allPartitionSets7File) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow1 = 1;
        double alphaRow2 = 0.1894025;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);



        int totalObsCount1 = 50;
        int totalObsCount2 = 5;

        int maxClustCount = 5;
        //int maxClustCount = 15;

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

        subtypeParts2[0].add(55);

        SubTypeList subTypeList1 = new SubTypeList(subtypeParts1);
        SubTypeList subTypeList2 = new SubTypeList(subtypeParts2);

        SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList1, subTypeList2};
        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, 55);

        String slvFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv";
        String bldFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv";
        String unknownPath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/missing.csv";
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

        double[] alphaC1 = new double[]{0.1, 0.1, 0.1, 0.1, 0.1};
        double[] betaC1 = new double[]{1.0, 1.0, 0.1, 1.0, 1.0};

        double[] alphaC2 = new double[]{0.1, 0.1, 0.1, 0.1, 0.1};
        double[] betaC2 = new double[]{1.0, 1.0, 1.0, 0.1, 1.0};
        Parameter shapeA1 = new Parameter("shape.a1", alphaC1, 0);
        Parameter shapeB1 = new Parameter("shape.b1", betaC1, 0);
        Parameter shapeA2 = new Parameter("shape.a2", alphaC2, 0);
        Parameter shapeB2 = new Parameter("shape.b2", betaC2, 0);
        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, dataSets,
                new Parameter[]{shapeA1, shapeA2},
                new Parameter[]{shapeB1, shapeB2},
                typeList);
        State[] states = new State[]{typeList};

        AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};

        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_v2_2022_07_21.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_v3_seed123.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_J2_slv5_bld50_seed123.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_J2_slv2_bld20_seed123.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_19_J2_slv2_bld20_seed123.log";
        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_19_J2_slv2_bld20_seed123_v2.log";

        MCMC estSubtype = new MCMC(probs, proposals, new double[]{1.0, 1.0}, states, 100000, 100, outputFilePath);
        //MCMC estSubtype = new MCMC(probs, proposals, new double[]{8.0, 2.0}, states, 1000, 100, outputFilePath);
        estSubtype.run();
        //}




    }

    private void runMultiTypeAllMissingProfileEx2(String allPartitionSets5File,
                                                  String allPartitionSets7File) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow1 = 0.18;
        double alphaRow2 = 0.1894025;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);



        int totalObsCount1 = 81;
        int totalObsCount2 = 65;

        int maxClustCount = 5;
        //int maxClustCount = 15;

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
        String unknownPath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/missing.csv";
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

        double[] alphaC1 = new double[]{0.1, 0.1, 0.1, 0.1, 0.1};
        double[] betaC1 = new double[]{1.0, 1.0, 0.1, 1.0, 1.0};

        double[] alphaC2 = new double[]{0.1, 0.1, 0.1, 0.1, 0.1};
        double[] betaC2 = new double[]{1.0, 1.0, 1.0, 0.1, 1.0};
        Parameter shapeA1 = new Parameter("shape.a1", alphaC1, 0);
        Parameter shapeB1 = new Parameter("shape.b1", betaC1, 0);
        Parameter shapeA2 = new Parameter("shape.a2", alphaC2, 0);
        Parameter shapeB2 = new Parameter("shape.b2", betaC2, 0);
        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, dataSets,
                new Parameter[]{shapeA1, shapeA2},
                new Parameter[]{shapeB1, shapeB2},
                typeList);
        State[] states = new State[]{typeList};

        AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};

        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_v2_2022_08_18_v3_seed123.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_v2_2022_07_21.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_v3_2022_07_21.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_1_2022_07_21.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_21/ex.missing_2_2022_07_21.log";
        MCMC estSubtype = new MCMC(probs, proposals, new double[]{8.0, 2.0}, states, 1000000, 100, outputFilePath);
        //MCMC estSubtype = new MCMC(probs, proposals, new double[]{8.0, 2.0}, states, 1000, 100, outputFilePath);
        estSubtype.run();
        //}




    }

    private void runMultiTypeAllMissingProfileEx3(String allPartitionSets5File,
                                                  String allPartitionSets7File) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double alpha5 = 0.49;
        double alpha7 = 0.375;
        double alphaRow1 = 0.18;
        double alphaRow2 = 0.1894025;

        double[][] colPriors = OldSingleTypeMCMC.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);



        int totalObsCount1 = 81;
        int totalObsCount2 = 5;

        int maxClustCount = 5;
        //int maxClustCount = 15;

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

        subtypeParts1[0].add(86);

        SubTypeList subTypeList1 = new SubTypeList(subtypeParts1);
        SubTypeList subTypeList2 = new SubTypeList(subtypeParts2);

        SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList1, subTypeList2};
        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, 86);

        String slvFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/slv.single.csv";
        String bldFilePath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/bld.single.csv";
        String unknownPath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/data/missing.csv";
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

        double[] alphaC1 = new double[]{0.1, 0.1, 0.1, 0.1, 0.1};
        double[] betaC1 = new double[]{1.0, 1.0, 0.1, 1.0, 1.0};

        double[] alphaC2 = new double[]{0.1, 0.1, 0.1, 0.1, 0.1};
        double[] betaC2 = new double[]{1.0, 1.0, 1.0, 0.1, 1.0};
        Parameter shapeA1 = new Parameter("shape.a1", alphaC1, 0);
        Parameter shapeB1 = new Parameter("shape.b1", betaC1, 0);
        Parameter shapeA2 = new Parameter("shape.a2", alphaC2, 0);
        Parameter shapeB2 = new Parameter("shape.b2", betaC2, 0);
        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, dataSets,
                new Parameter[]{shapeA1, shapeA2},
                new Parameter[]{shapeB1, shapeB2},
                typeList);
        State[] states = new State[]{typeList};

        AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};

        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_18/ex.missing_J5_2022_08_18.log";
        MCMC estSubtype = new MCMC(probs, proposals, new double[]{8.0, 2.0}, states, 100000, 10, outputFilePath);
        //MCMC estSubtype = new MCMC(probs, proposals, new double[]{8.0, 2.0}, states, 1000, 100, outputFilePath);
        estSubtype.run();
        //}




    }



    private void runMultiTypeAllMissingProfileEx4(String allPartitionSets5File,
                                                  String allPartitionSets7File) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        //double alphaRow1 = 20;
        double alphaRow1 = 2;

        //int totalObsCount1 = 3;
        //int totalObsCount2 = 5;


        int totalObsCount1 = 5;
        int totalObsCount2 = 50;

        int maxClustCount = 5;
        //int maxClustCount = 15;

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

        subtypeParts2[0].add(55);

        SubTypeList subTypeList1 = new SubTypeList(subtypeParts1);
        SubTypeList subTypeList2 = new SubTypeList(subtypeParts2);

        SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList1, subTypeList2};
        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, 55);


        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        AssignBetweenTypes btwnTypeMove = new AssignBetweenTypes(typeList);
        ProposalMove[] proposals = new ProposalMove[]{singleRowMove, btwnTypeMove};
        CompoundClusterPrior mdpPrior = new CompoundClusterPrior("multiTypeMDP",
                alphaRow1, maxClustCount,
                new int[]{totalObsCount1, totalObsCount2}, typeList);


        DummyLikelihood lik = new DummyLikelihood();
        State[] states = new State[]{typeList};

        AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};

        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_17/ex.missing_prior_2022_08_17.log";
        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_17/ex.missing_prior_alpha2_2022_08_17.log";
        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_08_17/ex.missing_prior_alpha2_2022_08_18_v2.log";
        MCMC estSubtype = new MCMC(probs, proposals, new double[]{8.0, 2.0}, states, 100000, 10, outputFilePath);
        //MCMC estSubtype = new MCMC(probs, proposals, new double[]{8.0, 2.0}, states, 1000, 100, outputFilePath);
        estSubtype.run();
        //}




    }

}
