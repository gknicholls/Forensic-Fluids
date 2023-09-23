package inference;

import data.CompoundMarkerData;
import data.CompoundMarkerDataWithUnknown;
import model.CompoundClusterLikelihood;
import model.CompoundNoBLoCLikelihood;
import state.*;
import utils.DataUtils;
import utils.ParamUtils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by jessiewu on 20/12/2022.
 */
public class BayesFactorBridgeEstimator {
    private String inputFile;

    public static String ALL_PARTS_SETS_5 = "allPartitionSets5File";
    public static String ALL_PARTS_SETS_7 = "allPartitionSets7File";
    public static String ALPHA_5_COLS = "alpha5Cols";
    public static String ALPHA_7_COLS = "alpha7Cols";
    public static String TOTAL_OBS_COUNTS = "totalObsCounts";
    public static String MAX_ROW_CLUSTER_COUNT = "maxRowClustCount";
    public static String RNA_PROFILE = "rnaProfilePath";
    public static String COL_SHAPE_A = "colShapeA";
    public static String COL_SHAPE_B = "colShapeB";
    public static String MAIN_CHAIN_PATH = "mainChain";
    public static String CLUSTER_NAME = "clusterName";
    public static String USE_NOBLOC = "useNoBLoC";
    public static String LIK_NAME = "likName";
    public static String OTHER_MODEL_NAME = "otherModel";
    public static String BURNIN = "burnin";
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};


    private int[][] colRange;
    private String mainChainPath;
    private int[][][][] mkrGrpPartitions;
    private double[][] colPriors;
    private Parameter[] shapeAParams;
    private Parameter[] shapeBParams;
    private String clusterName;
    private int unknownCount;
    private int[] totalObsCounts;
    private int maxRowClustCount;
    private ArrayList<String> rnaProfilePathList;
    private boolean useNoBLoC;
    private String[] likNames;
    private String otherModelName;
    private int burnin;

    static public int threadCount = 1;
    public static ExecutorService executor = Executors.newFixedThreadPool(threadCount);

    public static void main(String[] args){

        try {
            for(int fileIndex = 0; fileIndex < args.length; fileIndex++){
                BayesFactorBridgeEstimator bfc = new BayesFactorBridgeEstimator(args[fileIndex]);
                bfc.computeWeightML();

            }



        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }




    public BayesFactorBridgeEstimator(String inputFile) throws Exception{
        this.inputFile = inputFile;
        colRange = COL_RANGE;
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


        rnaProfilePathList = new ArrayList<>();

        ArrayList<String> colShapeAList = new ArrayList<>();
        ArrayList<String> colShapeBList = new ArrayList<>();
        ArrayList<String> likNameList = new ArrayList<>();




        unknownCount = 1;
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

            }else if(currLabel.equals(TOTAL_OBS_COUNTS)){

                totalObsCounts = DataUtils.processSeqsInteger(lineElts[1], ",");

            }else if(currLabel.equals(MAX_ROW_CLUSTER_COUNT)){

                maxRowClustCount = Integer.parseInt(lineElts[1]);
            }else if(currLabel.equals(RNA_PROFILE)) {

                rnaProfilePathList.add(lineElts[1]);

            }else if(currLabel.equals(COL_SHAPE_A)){

                colShapeAList.add(lineElts[1]);

            }else if(currLabel.equals(COL_SHAPE_B)){
                colShapeBList.add(lineElts[1]);

            }else if(currLabel.equals(LIK_NAME)) {

                likNameList.add(lineElts[1].trim());

            }else if(currLabel.equals(OTHER_MODEL_NAME)){
                otherModelName = lineElts[1].trim();
            }else if(currLabel.equals(USE_NOBLOC)){
                useNoBLoC = Boolean.parseBoolean(lineElts[1]);
            }else if(currLabel.equals(MAIN_CHAIN_PATH)){
                mainChainPath = lineElts[1].trim();
            }else if(currLabel.equals(CLUSTER_NAME)){
                clusterName = lineElts[1].trim();
            }else if(currLabel.equals(BURNIN)){
                burnin = Integer.parseInt(lineElts[1].trim());

            }
        }
        inputReader.close();

        if(useNoBLoC){
            System.err.println("Using NoB-LoC model set up.");
        }

        mkrGrpPartitions =
                DataUtils.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        colPriors =
                DataUtils.getColPriors(alpha5, alpha7,
                        allPartitionSets5File, allPartitionSets7File);
        shapeAParams = setupShapeParameters(colShapeAList, "shapeA");
        shapeBParams = setupShapeParameters(colShapeBList, "shapeB");
        likNames = new String[likNameList.size()];
        likNameList.toArray(likNames);

    }

    public void computeWeightML(){
        executor = Executors.newFixedThreadPool(threadCount);


        try {
            BufferedReader mainChainReader = new BufferedReader(new FileReader(mainChainPath));
            String mainChainLogLine = mainChainReader.readLine();
            int clusterIndex = findLogColumnIndex(mainChainLogLine, clusterName, "\t");
            int stateNameIndex = findLogColumnIndex(mainChainLogLine, "STATE", "\t");
            int[] likNameIndexes = new int[likNames.length];
            for(int typeIndex = 0; typeIndex < likNameIndexes.length; typeIndex++){
                likNameIndexes[typeIndex] = findLogColumnIndex(mainChainLogLine, likNames[typeIndex], "\t");
            }
            double[] liks = new double[likNames.length];
            double[] weightedLiks = new double[likNames.length];
            String[] logElts;

            int stepNum;
            double[] typeLogLiks;
            PrintStream likWriter = new PrintStream(inputFile+"_liks.txt");
            likWriter.print("STATE\t");
            for(int typeIndex = 0; typeIndex < likNameIndexes.length; typeIndex++){
                likWriter.print(likNames[typeIndex] + "\t");

            }
            for(int typeIndex = 0; typeIndex < likNameIndexes.length; typeIndex++){
                likWriter.print(otherModelName + "." + typeIndex+ "\t");
            }
            likWriter.println();

            while ((mainChainLogLine = mainChainReader.readLine()) != null) {

                logElts = mainChainLogLine.split("\t");
                stepNum = Integer.parseInt(logElts[stateNameIndex]);

                if((stepNum%1000000) == 0){
                    System.out.println(stepNum);
                }

                if((stepNum - burnin) >= 0) {
                    likWriter.print(stepNum  + "\t");


                    //Create the TypeList for the clustering of the training data of the current posterior sample.

                    TypeList typeList = ParamUtils.createTypeList(
                            totalObsCounts, maxRowClustCount, logElts[clusterIndex], null, -1);
                    typeLogLiks = new double[typeList.getTypeCount()];

                    CompoundMarkerData  dataSets = createData(
                                    rnaProfilePathList, null, totalObsCounts,
                                    colRange, unknownCount, typeList);





                    CompoundClusterLikelihood lik;
                    if(useNoBLoC){
                        lik = new CompoundNoBLoCLikelihood("NoBLoCLikelihood",
                                        mkrGrpPartitions, colPriors, dataSets,
                                        shapeAParams, shapeBParams, typeList);
                    }else{
                        lik = new CompoundClusterLikelihood("bdpLikelihood",
                                mkrGrpPartitions, colPriors, dataSets,
                                shapeAParams, shapeBParams, typeList);
                    }

                    for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){
                        liks[typeIndex] = Double.parseDouble(logElts[likNameIndexes[typeIndex]]);
                        likWriter.print(liks[typeIndex]+"\t");

                    }

                    lik.getLogLikelihood();
                    lik.getLogTypeLikelihoods(typeLogLiks);



                    for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){
                        likWriter.print(typeLogLiks[typeIndex]+"\t");
                    }
                    likWriter.println();

                    for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){
                        weightedLiks[typeIndex] += Math.exp(1/2*(liks[typeIndex]-typeLogLiks[typeIndex]));
                    }

                }


            }
            for(int typeIndex = 0; typeIndex < weightedLiks.length; typeIndex++){
                System.out.print(weightedLiks[typeIndex]+"\t");
            }
            System.out.println();
            likWriter.close();

        }catch (Exception e){
            throw new RuntimeException(e);
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



}