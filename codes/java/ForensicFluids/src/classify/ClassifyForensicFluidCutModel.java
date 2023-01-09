package classify;

import data.CompoundMarkerData;
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
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by jessiewu on 20/12/2022.
 */
public class ClassifyForensicFluidCutModel {
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
    public static String SEED = "seed";
    public static String MAIN_CHAIN_PATH = "mainChain";
    public static String CLUSTER_NAME = "clusterName";
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
    private String mainChainPath;
    private int[][][][] mkrGrpPartitions;
    private double[][] colPriors;
    private Parameter[] shapeAParams;
    private Parameter[] shapeBParams;
    private String clusterName;
    private int unknownCount;
    private int[] totalObsCounts;
    private int maxRowClustCount;
    private String unknownPath;
    private int initType;
    private ArrayList<String> trainingRNAProfilePathList;
    private double[] unknownTypePriorParamVals;
    private double[] alphaRow;

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




    public ClassifyForensicFluidCutModel(String inputFile) throws Exception{
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
        String line = "";
        String[] lineElts;
        String currLabel;


        String allPartitionSets5File = null;
        String allPartitionSets7File = null;
        double alpha5 = -1;
        double alpha7 = -1;

        maxRowClustCount = -1;


        trainingRNAProfilePathList = new ArrayList<>();

        ArrayList<String> colShapeAList = new ArrayList<>();
        ArrayList<String> colShapeBList = new ArrayList<>();



        unknownCount = 1;
        long seed = Randomizer.getSeed();
        String clusterStr = null;
        initType = -1;
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

                alphaRow = DataUtils.processSeqsDouble(lineElts[1], ",");

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
                seed = Long.parseLong(lineElts[1]);

                Randomizer.setSeed(seed);
            }else if(currLabel.equals(INITIAL_CLUSTER)){
                clusterStr = lineElts[1].trim();
            }else if(currLabel.equals(INITIAL_TYPE)){
                initType = Integer.parseInt(lineElts[1].trim());
            }else if(currLabel.equals(MAIN_CHAIN_PATH)){
                mainChainPath = lineElts[1].trim();
            }else if(currLabel.equals(CLUSTER_NAME)){
                clusterName = lineElts[1].trim();
            }
        }
        inputReader.close();



        System.out.println("Seed: " + seed);

        mkrGrpPartitions = DataUtils.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        colPriors = DataUtils.getColPriors(alpha5, alpha7, allPartitionSets5File, allPartitionSets7File);
        shapeAParams = setupShapeParameters(colShapeAList, "shapeA");
        shapeBParams = setupShapeParameters(colShapeBList, "shapeB");

    }

    public void run(){
        executor = Executors.newFixedThreadPool(threadCount);
        try {
            BufferedReader mainChainReader = new BufferedReader(new FileReader(mainChainPath));
            String mainChainLogLine = mainChainReader.readLine();
            int clusterIndex = findLogColumnIndex(mainChainLogLine, clusterName, "\t");
            String[] logElts;
            while ((mainChainLogLine = mainChainLogLine) != null) {
                logElts = mainChainLogLine.split("\t");
                TypeList typeList = createTypeList(
                        totalObsCounts, maxRowClustCount, logElts[clusterIndex], null, initType);
                CompoundMarkerData dataSets = createData(
                        trainingRNAProfilePathList, unknownPath, totalObsCounts, colRange, unknownCount, typeList);

                proposals = setUpProposalMoves(typeList, null);

                unknownTypePriorParamVals = setUpUnknownTypePrior(unknownTypePriorParamVals, typeList);


                UnlabelledTypeWrapperParameter unknownTypeParam =
                        new UnlabelledTypeWrapperParameter("unknownType", (TypeListWithUnknown) typeList);


                probs = setUpPosterior(alphaRow, maxRowClustCount, totalObsCounts,
                        typeList, mkrGrpPartitions, colPriors, dataSets, shapeAParams, shapeBParams,
                        unknownTypePriorParamVals, unknownTypeParam);
                states = new State[]{typeList, unknownTypeParam};

                constants = new State[]{shapeAParams[0], shapeAParams[1], shapeAParams[2], shapeAParams[3], shapeAParams[4],
                        shapeBParams[0], shapeBParams[1], shapeBParams[2], shapeBParams[3], shapeBParams[4]};


            }

            MCMC estSubtype = new MCMC(probs, proposals, weights, states, constants, chainLength, logEvery, outputFilePath);

            estSubtype.run();

        }catch (Exception e){
            throw new RuntimeException();
        }
        executor.shutdown();
        executor.shutdownNow();
    }

    public static int findLogColumnIndex(String eltStrs, String target, String sep){
        String[] elts = eltStrs.split(sep);
        for(int eltIndex = 0; eltIndex < elts.length; eltIndex++){
            if(elts[eltIndex].equals(target)){
                return eltIndex;
            }
        }
        return -1;

    }

    private TypeListWithUnknown createTypeList(int[] totalObsCounts,
                                               int maxRowClustCount,
                                               String clustering,
                                               String unknownPath,
                                               int initType){

        int totalCount = 0;
        SubTypeList[] subTypeLists = new SubTypeList[totalObsCounts.length];
        for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {
            totalCount += totalObsCounts[typeIndex];
        }

        int initialBF = initType;
        if(unknownPath != null &&initialBF == -1){
            Randomizer.nextInt(subTypeLists.length);
        }
        if(clustering == null) {
            for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {


                ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxRowClustCount];
                for (int setIndex = 0; setIndex < subtypeParts.length; setIndex++) {
                    subtypeParts[setIndex] = new ArrayList<>();

                }

                for (int obsIndex = 0; obsIndex < totalObsCounts[typeIndex]; obsIndex++) {
                    subtypeParts[0].add(obsIndex);
                }

                if (unknownPath != null && typeIndex == initialBF) {
                    subtypeParts[0].add(totalCount);
                }


                subTypeLists[typeIndex] = new SubTypeList(subtypeParts);

            }
        }else{
            String[] typeClustStr = clustering.split(" ");
            String currTypeClustStr;
            for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {

                // Create J sets within each type, where J maxRowClustCount.
                ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxRowClustCount];
                for (int setIndex = 0; setIndex < subtypeParts.length; setIndex++) {
                    subtypeParts[setIndex] = new ArrayList<>();

                }

                currTypeClustStr = typeClustStr[typeIndex].substring(1, typeClustStr[typeIndex].length() - 1).replace("],[", "], [");
                //System.out.println("setsStr: "+ currTypeClustStr);
                String [] setsStr = currTypeClustStr.split(", ");


                String[] obsSetStr;
                //System.out.println("setsStr size: "+setsStr.length);
                for (int setIndex = 0; setIndex < setsStr.length; setIndex++) {
                    //System.out.println("obsSetStr: "+ setsStr[setIndex].substring(1, setsStr[setIndex].length() - 1));

                    obsSetStr = setsStr[setIndex].substring(1, setsStr[setIndex].length() - 1).split(",");

                    for(int obsIndex = 0; obsIndex < obsSetStr.length; obsIndex++){
                        subtypeParts[setIndex].add(Integer.parseInt(obsSetStr[obsIndex]));
                    }

                }

                subTypeLists[typeIndex] = new SubTypeList(subtypeParts);

            }

        }




        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, totalCount);
        return typeList;
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
            dataSets = new CompoundMarkerData(dataPath, rowInfo, colInfo);
        }else{
            int[] rowInfoUnknown = new int[]{0, unknownCount - 1};
            dataSets = new CompoundMarkerDataWithUnknown(
                    dataPath, unknownPath, rowInfo, colInfo, rowInfoUnknown, colRange, (TypeListWithUnknown) typeList);
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

    private ProposalMove[] setUpProposalMoves(TypeList typeList, CompoundMarkerDataWithUnknown dataSets){
        //SingleUnknownGibbsSampler singleGibbs = new SingleUnknownGibbsSampler(typeList, dataSets);
        SingleUnknownGibbsSampler singleGibbs = null;
        ProposalMove[] proposals = new ProposalMove[]{singleGibbs};
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

        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, dataSets,
                shapeA,
                shapeB,
                typeList);

        if(unknownTypeParam == null){
            return new AbstractProbability[]{mdpPrior, lik};
        }else{
            Multinomial typePrior = new Multinomial("unknownTypePrior",
                    unknownTypeParam, unknownTypePriorParam);
            return new AbstractProbability[]{typePrior, mdpPrior, lik};
        }




    }
}