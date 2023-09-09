package classify;

import data.CompoundMarkerData;
import data.CompoundMarkerDataWithUnknown;
import distribution.Multinomial;
import inference.*;
import model.AbstractProbability;
import model.CompoundClusterLikelihood;
import model.CompoundClusterPrior;
import model.CompoundNoBLoCLikelihood;
import state.*;
import utils.DataUtils;
import utils.ParamUtils;
import utils.Randomizer;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ClassifyForensicFluid {

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
    public static String INITIAL_CLUSTER = "initialClustering";
    public static String INITIAL_TYPE = "initialType";
    public static String USE_NOBLOC = "useNoBLoC";
    public static String SEED = "seed";
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};


    private AbstractProbability[] probs;
    private ProposalMove[] proposals;
    private double[] weights;
    private int[][] colRange;
    private State[] states;
    private State[] constants;
    private int chainLength;
    private int logEvery;
    private String outputFilePath;
    private boolean useNoBLoC;

    static public int threadCount = 1;
    public static ExecutorService executor = Executors.newFixedThreadPool(threadCount);

    public static void main(String[] args){

        try {

            if(args.length == 1){
                ClassifyForensicFluid bfc = new ClassifyForensicFluid(args[0]);

                bfc.run();
            }else if(args.length == 2){

                if(!args[0].equals("-fileSeq")){
                    throw new RuntimeException("When have multiple input files, the option label should be -fileSeq");
                }

                BufferedReader inputFilePathReader = new BufferedReader(new FileReader(args[1]));
                String inputFilePath = "";
                ClassifyForensicFluid bfc;
                while((inputFilePath = inputFilePathReader.readLine()) != null){
                    bfc = new ClassifyForensicFluid(inputFilePath);
                    bfc.run();
                }
            }

        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }




    public ClassifyForensicFluid(String inputFile) throws Exception{
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
        long seed = Randomizer.getSeed();
        String clusterStr = null;
        int initType = -1;
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
            }else if(currLabel.equals(UNKNOWN_TYPE_PRIOR)) {
                unknownTypePriorParamVals = DataUtils.processSeqsDouble(lineElts[1], ",");
            }else if(currLabel.equals(USE_NOBLOC)){
                useNoBLoC = Boolean.parseBoolean(lineElts[1]);
            }else if(currLabel.equals(SEED)){
                seed = Long.parseLong(lineElts[1]);

                Randomizer.setSeed(seed);
            }else if(currLabel.equals(INITIAL_CLUSTER)){
                clusterStr = lineElts[1].trim();
            }else if(currLabel.equals(INITIAL_TYPE)){
                initType = Integer.parseInt(lineElts[1].trim());
            }
        }
        inputReader.close();



        System.out.println("Seed: " + seed);

        int[][][][] mkrGrpPartitions = DataUtils.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double[][] colPriors = DataUtils.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);

        TypeList typeList = ParamUtils.createTypeList(totalObsCounts, maxRowClustCount, clusterStr, unknownPath, initType);


        CompoundMarkerData dataSets = createData(
                trainingRNAProfilePathList, unknownPath, totalObsCounts, colRange, unknownCount, typeList);

        Parameter[] shapeAParams = setupShapeParameters(colShapeAList, "shapeA");
        Parameter[] shapeBParams = setupShapeParameters(colShapeBList, "shapeB");
        proposals = setUpProposalMoves(typeList);



        unknownTypePriorParamVals = setUpUnknownTypePrior(unknownTypePriorParamVals, typeList);

        System.out.println("unknownTypePriorParamVals: "+unknownTypePriorParamVals.length);

        UnlabelledTypeWrapperParameter unknownTypeParam = null;
        if(unknownPath != null){
            unknownTypeParam = new UnlabelledTypeWrapperParameter("unknownType", (TypeListWithUnknown) typeList);
        }

        probs = setUpPosterior(alphaRow, maxRowClustCount, totalObsCounts,
                typeList, mkrGrpPartitions, colPriors, dataSets, shapeAParams, shapeBParams,
                unknownTypePriorParamVals, unknownTypeParam);
        if(unknownPath==null){
            states = new State[]{typeList};
        }else{
            states = new State[]{typeList, unknownTypeParam};
        }

        constants = new State[]{shapeAParams[0], shapeAParams[1], shapeAParams[2], shapeAParams[3], shapeAParams[4],
                shapeBParams[0], shapeBParams[1], shapeBParams[2], shapeBParams[3], shapeBParams[4]};




    }

    public void run(){
        MCMC estSubtype = new MCMC(probs, proposals, weights, states, constants, chainLength, logEvery, outputFilePath);
        executor = Executors.newFixedThreadPool(threadCount);
        estSubtype.run();
        executor.shutdown();
        executor.shutdownNow();
    }


    private CompoundMarkerData createData(ArrayList<String> dataPathList,
                            String unknownPath, int[] totalObsCounts, int[][] colRange,
                            int unknownCount,
                            TypeList typeList) throws RuntimeException{
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

        CompoundMarkerData dataSets;
        if(unknownPath == null){
            dataSets = new CompoundMarkerData(dataPath, rowInfo,  colInfo);
        }else{
            int[] rowInfoUnknown = new int[]{0, unknownCount - 1};
            dataSets = new CompoundMarkerDataWithUnknown(
                    dataPath, unknownPath, rowInfo,  colInfo, rowInfoUnknown, colRange, (TypeListWithUnknown) typeList);
        }


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

    private ProposalMove[] setUpProposalMoves(TypeList typeList){
        AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
        ProposalMove[] proposals;
        if(typeList instanceof TypeListWithUnknown) {
            AssignBetweenTypes btwnTypeMove = new AssignBetweenTypes((TypeListWithUnknown)typeList);
            proposals = new ProposalMove[]{singleRowMove, btwnTypeMove};
        }else{
            proposals = new ProposalMove[]{singleRowMove};
        }
        return proposals;

    }

    private AbstractProbability[] setUpPosterior(double[] alphaRow,
                                               int maxRowClustCount,
                                               int[] totalObsCounts,
                                               TypeList typeList,
                                               int[][][][] mkrGrpPartitions,
                                               double[][] colPriors,
                                               CompoundMarkerData dataSets,
                                               Parameter[] shapeA,
                                               Parameter[] shapeB,
                                                 double[] unknownTypePriorParam,
                                                 Parameter unknownTypeParam){



        CompoundClusterPrior mdpPrior;
        if(alphaRow.length == 1){
            mdpPrior = new CompoundClusterPrior(
                    "multiTypeMDP", alphaRow[0], maxRowClustCount, totalObsCounts, typeList);
        }else{
            mdpPrior = new CompoundClusterPrior(
                    "multiTypeMDP", alphaRow, maxRowClustCount, totalObsCounts, typeList);
        }
        CompoundClusterLikelihood lik;

        if(useNoBLoC){
            lik = new CompoundNoBLoCLikelihood("multitypeLikelihood",
                    mkrGrpPartitions, colPriors, dataSets,
                    shapeA,
                    shapeB,
                    typeList);
        }else{
            lik = new CompoundClusterLikelihood("multitypeLikelihood",
                    mkrGrpPartitions, colPriors, dataSets,
                    shapeA,
                    shapeB,
                    typeList);
        }


        if(unknownTypeParam == null){
            return new AbstractProbability[]{mdpPrior, lik};
        }else{
            Multinomial typePrior = new Multinomial("unknownTypePrior",
                    unknownTypeParam, unknownTypePriorParam);
            return new AbstractProbability[]{typePrior, mdpPrior, lik};
        }




    }







}
