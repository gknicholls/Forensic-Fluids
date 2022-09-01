package classify;

import data.CompoundMarkerDataWithUnknown;
import distribution.Multinomial;
import inference.*;
import model.AbstractProbability;
import model.CompoundClusterLikelihood;
import model.CompoundClusterPrior;
import state.*;
import utils.DataUtils;
import utils.Randomizer;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ClassifiyForensicFluid {

    private String inputFile;

    public static String ALL_PARTS_SETS_5 = "allPartitionSets5File";
    public static String ALL_PARTS_SETS_7 = "allPartitionSets7File";
    public static String ALPHA_5_COLS = "alpha5Cols";
    public static String ALPHA_7_COLS = "alpha7Cols";
    public static String ALPHA_ROW = "alphaRow";
    public static String TOTAL_OBS_COUNTS = "totalObsCounts";
    public static String MAX_ROW_CLUSTER_COUNT = "maxRowClustCount";
    public static String TRAINING_RNA_PROFILE = "trainingRNAProfilePath";
    public static String UNKNOWN_SAMPLE = "unknownSamplePath";
    public static String COL_SHAPE_A = "colShapeA";
    public static String COL_SHAPE_B = "colShapeB";
    public static String WEIGHTS = "weights";
    public static String CHAIN_LENGTH = "chainLength";
    public static String LOG_EVERY = "logEvery";
    public static String OUTPUT_PATH = "outputPath";
    public static String UNKNOWN_COUNT = "unknownCount";
    public static String UNKNOWN_TYPE_PRIOR = "unknownTypePrior";
    public static String SEED = "seed";
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};


    private AbstractProbability[] probs;
    private ProposalMove[] proposals;
    private double[] weights;
    private int[][] colRange;
    private State[] states;
    private int chainLength;
    private int logEvery;
    private String outputFilePath;

    public static void main(String[] args){

        try {

            ClassifiyForensicFluid bfc = new ClassifiyForensicFluid(args[0]);

            bfc.runMCMC();


        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    public ClassifiyForensicFluid(String inputFile) throws Exception{
        this.inputFile = inputFile;
        colRange = COL_RANGE;
        chainLength = -1;
        logEvery = -1;
        outputFilePath = null;
        weights = null;
        processInputFile();
    }

    private void processInputFile() throws Exception{
        String[] labels = new String[]{ALL_PARTS_SETS_5, ALL_PARTS_SETS_7};
        List<String> labelList = Arrays.asList(labels);

        BufferedReader inputReader = new BufferedReader(new FileReader(inputFile));
        String line  = "";
        String[] lineElts;
        String currLabel;


        String allPartitionSets5File = null;
        String allPartitionSets7File = null;
        double alpha5 = -1;
        double alpha7 = -1;
        double[] alphaRow = null;
        int[] totalObsCounts = null;
        int maxRowClustCount = -1;

        ArrayList<String> trainingRNAProfilePathList = new ArrayList<>();
        String unknownPath = null;
        ArrayList<String> colShapeAList = new ArrayList<>();
        ArrayList<String> colShapeBList = new ArrayList<>();

        double[] unknownTypePriorParamVals = null;

        int unknownCount = 1;

        while((line = inputReader.readLine()) != null){
            lineElts = line.split("\t");
            currLabel = lineElts[0].trim();
            lineElts[1] = lineElts[1].trim();
            if(currLabel.equals(ALL_PARTS_SETS_5)){

                allPartitionSets5File = lineElts[1];

            }else if(currLabel.equals(ALL_PARTS_SETS_7)){

                allPartitionSets7File = lineElts[1];

            }else if(currLabel.equals(ALPHA_5_COLS)){
                alpha5 = Double.parseDouble(lineElts[1]);

            }else if(currLabel.equals(ALPHA_7_COLS)){

                alpha7 = Double.parseDouble(lineElts[1]);

            }else if(currLabel.equals(ALPHA_ROW)){

                alphaRow =  DataUtils.processSeqsDouble(lineElts[1], ",");

            }else if(currLabel.equals(TOTAL_OBS_COUNTS)){

                totalObsCounts = DataUtils.processSeqsInteger(lineElts[1], ",");

            }else if(currLabel.equals(MAX_ROW_CLUSTER_COUNT)){

                maxRowClustCount = Integer.parseInt(lineElts[1]);
            }else if(currLabel.equals(TRAINING_RNA_PROFILE)) {

                trainingRNAProfilePathList.add(lineElts[1]);

            }else if(currLabel.equals(UNKNOWN_SAMPLE)){

                unknownPath = lineElts[1];

            }else if(currLabel.equals(COL_SHAPE_A)){

                colShapeAList.add(lineElts[1]);

            }else if(currLabel.equals(COL_SHAPE_B)){
                colShapeBList.add(lineElts[1]);

            }else if(currLabel.equals(UNKNOWN_COUNT)) {

                unknownCount = Integer.parseInt(lineElts[1]);

            }else if(currLabel.equals(WEIGHTS)){
                weights = DataUtils.processSeqsDouble(lineElts[1], ",");

            }else if(currLabel.equals(CHAIN_LENGTH)){

                chainLength = Integer.parseInt(lineElts[1]);

            }else if(currLabel.equals(LOG_EVERY)){

                logEvery = Integer.parseInt(lineElts[1]);

            }else if(currLabel.equals(OUTPUT_PATH)) {
                outputFilePath = lineElts[1];
            }else if(currLabel.equals(UNKNOWN_TYPE_PRIOR)){
                unknownTypePriorParamVals = DataUtils.processSeqsDouble(lineElts[1], ",");
            }else if(currLabel.equals(SEED)){
                int seed = Integer.parseInt(lineElts[1]);
                System.out.println("Seed: " + seed);
                Randomizer.setSeed(seed);
            }
        }
        inputReader.close();

        int[][][][] mkrGrpPartitions = DataUtils.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double[][] colPriors = DataUtils.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);
        TypeListWithUnknown typeList = createTypeList(totalObsCounts, maxRowClustCount);

        CompoundMarkerDataWithUnknown dataSets = createData(
                trainingRNAProfilePathList, unknownPath, totalObsCounts, colRange, unknownCount, typeList);

        Parameter[] shapeAParams = setupShapeParameters(colShapeAList, "shapeA");
        Parameter[] shapeBParams = setupShapeParameters(colShapeBList, "shapeB");
        proposals = setUpProposalMoves(typeList);



        unknownTypePriorParamVals = setUpUnknownTypePrior(unknownTypePriorParamVals, typeList);

        System.out.println("unknownTypePriorParamVals: "+unknownTypePriorParamVals.length);
        UnlabelledTypeWrapperParameter unknownTypeParam = new UnlabelledTypeWrapperParameter("unknownType", typeList);

        probs = setUpPosterior(alphaRow, maxRowClustCount, totalObsCounts,
                typeList, mkrGrpPartitions, colPriors, dataSets, shapeAParams, shapeBParams,
                unknownTypePriorParamVals, unknownTypeParam);
        states = new State[]{typeList, unknownTypeParam};




    }

    public void runMCMC(){
        MCMC estSubtype = new MCMC(probs, proposals, weights, states, chainLength, logEvery, outputFilePath);
        estSubtype.run();
    }

    private TypeListWithUnknown createTypeList(int[] totalObsCounts, int maxRowClustCount){

        int totalCount = 0;
        SubTypeList[] subTypeLists = new SubTypeList[totalObsCounts.length];

        for(int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++){
            totalCount += totalObsCounts[typeIndex];

            ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxRowClustCount];
            for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
                subtypeParts[setIndex] = new ArrayList<>();

            }

            for(int obsIndex = 0; obsIndex < totalObsCounts[typeIndex]; obsIndex++){
                subtypeParts[0].add(obsIndex);
            }

            if(typeIndex == (subTypeLists.length - 1) ){
                subtypeParts[0].add(totalCount);
            }

            subTypeLists[typeIndex] = new SubTypeList(subtypeParts);

        }




        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, totalCount);
        return typeList;
    }

    private CompoundMarkerDataWithUnknown createData(ArrayList<String> dataPathList,
                            String unknownPath, int[] totalObsCounts, int[][] colRange,
                            int unknownCount,
                            TypeListWithUnknown typeList) throws RuntimeException{
        if(dataPathList.size() != totalObsCounts.length){
            throw new RuntimeException("The number of data files does not match the number of type specific sample sizes.");
        }
        String[] dataPath = new String[dataPathList.size()];
        dataPathList.toArray(dataPath);

        int[][] rowInfo = new int[totalObsCounts.length][];
        int[][][] colInfo = new int[totalObsCounts.length][][];
        for(int typeIndex = 0; typeIndex < rowInfo.length; typeIndex++){
            rowInfo[typeIndex] = new int[]{0, totalObsCounts[typeIndex] - 1};
            colInfo[typeIndex] = colRange;
        }
        int[] rowInfoUnknown = new int[]{0, unknownCount};
        CompoundMarkerDataWithUnknown dataSets =  new CompoundMarkerDataWithUnknown(
                dataPath, unknownPath, rowInfo,  colInfo, rowInfoUnknown, colRange, typeList);

        return dataSets;
    }

    private Parameter[] setupShapeParameters(List<String> shapeList, String label){
        String[] shapeStr = new String[shapeList.size()];
        shapeList.toArray(shapeStr);
        Parameter[] shapeParams = new Parameter[shapeStr.length];
        double[] shapeVals;
        for(int typeIndex = 0; typeIndex < shapeParams.length; typeIndex++){
            shapeVals = DataUtils.processSeqsDouble(shapeStr[typeIndex], ",");
            shapeParams[typeIndex] = new Parameter(label+"."+typeIndex, shapeVals, 0);
        }

        return shapeParams;

    }

    private double[] setUpUnknownTypePrior(double[] unknownTypePriorParamVals,
                                            TypeList typeList){
        if(unknownTypePriorParamVals == null){
            unknownTypePriorParamVals = new double[typeList.getTypeCount()];
            for(int typeIndex = 0; typeIndex < unknownTypePriorParamVals.length; typeIndex++){
                unknownTypePriorParamVals[typeIndex] = 1.0/unknownTypePriorParamVals.length;
            }
        }
        return unknownTypePriorParamVals;

    }

    private ProposalMove[] setUpProposalMoves(TypeListWithUnknown typeList){
        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        AssignBetweenTypes btwnTypeMove = new AssignBetweenTypes(typeList);
        ProposalMove[] proposals = new ProposalMove[]{singleRowMove, btwnTypeMove};
        return proposals;

    }

    private AbstractProbability[] setUpPosterior(double[] alphaRow,
                                               int maxRowClustCount,
                                               int[] totalObsCounts,
                                               TypeListWithUnknown typeList,
                                               int[][][][] mkrGrpPartitions,
                                               double[][] colPriors,
                                               CompoundMarkerDataWithUnknown dataSets,
                                               Parameter[] shapeA,
                                               Parameter[] shapeB,
                                                 double[] unknownTypePriorParam,
                                                 Parameter unknownTypeParam){

        Multinomial typePrior = new Multinomial("unknownTypePrior",
                unknownTypeParam, unknownTypePriorParam);

        CompoundClusterPrior mdpPrior = null;
        if(alphaRow.length == 1){
            mdpPrior = new CompoundClusterPrior(
                    "multiTypeMDP", alphaRow[0], maxRowClustCount, totalObsCounts, typeList);
        }

        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, dataSets,
                shapeA,
                shapeB,
                typeList);

        return new AbstractProbability[]{typePrior, mdpPrior, lik};

    }







}
