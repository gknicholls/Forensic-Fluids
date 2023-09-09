package test;

import data.SingleMarkerData;
import junit.framework.TestCase;
import model.ClusterLikelihood;
import model.NoBLoCLikelihood;
import state.Parameter;
import state.SubTypeList;
import utils.MathUtils;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;

//import model.OldClusterLikelihood;

public class TestNoBLoCLikelihood extends TestCase {

    public interface Instance {

        int[][][] getPartitions();

        int[][] getData();

        double[] getExpectedMarginalizedMarkerGroupLik();

        double getAlpha();

        double getBeta();

        double[] getColPrior();

        double[][][] getBetaTable();

        ArrayList<Integer> getSubtypeIndexes();
    }

    protected Instance test0 = new Instance() {

        @Override
        public int[][][] getPartitions() {

            int[][][] partition = {
                    {{0, 1, 2}},
                    {{0, 1}, {2}},
                    {{0, 2}, {1}},
                    {{0}, {1, 2}},
                    {{0}, {1}, {2}}

            };

            return partition;
        }

        @Override
        public int[][] getData(){

            int[][] slvEx1Mat = {
                    {0, 1, 1},
                    {0, 1, 1},
                    {1, 0, 0},
                    {0, 0, 0},
                    {0, 0, 1},
                    {0, 0, 1},
                    {0, 0, 1},
                    {0, 0, 0},
                    {0, 0, 0},
                    {0, 0, 0}
            };

            return slvEx1Mat;
        }



        @Override
        public double[] getExpectedMarginalizedMarkerGroupLik() {
            return new double[]{
                    8.352222038398864e-09,
                    1.043677052928005e-08,
                    4.403012567040002e-09,
                    1.320903770112002e-08,
                    8.625959983006912e-09
            };
        }

        @Override
        public double[] getColPrior() {
            return new double[]{
                    0.1648351648351658,
                    0.2197802197802201,
                    0.2197802197802201,
                    0.2197802197802201,
                    0.1758241758241763
            };
        }

        public double[][][] getBetaTable(){
            return new double[][][]{{{-2.995732273553991, -3.401197381662155},
                    {-3.401197381662155, -4.094344562222100, -4.094344562222100},
                    {-3.737669618283368, -4.653960350157523, -4.941642422609304, -4.653960350157523}
                   }};
        }

        @Override
        public double getAlpha(){
            return 2;
        }

        @Override
        public double getBeta(){
            return 3;
        }

        @Override
        public ArrayList<Integer> getSubtypeIndexes(){
            ArrayList<Integer> subtypeIndexes = new ArrayList<Integer>(
                    Arrays.asList(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
            );
            return subtypeIndexes;
        }
    };

    protected Instance test1 = new Instance() {

        @Override
        public int[][][] getPartitions() {

            int[][][] partition = {
                    {{0, 1, 2, 3}},
                    {{0, 1, 2}, {3}},
                    {{0, 1, 3}, {2}},
                    {{0, 1}, {2, 3}},
                    {{0, 1}, {2}, {3}},
                    {{0, 2, 3}, {1}},
                    {{0, 2}, {1, 3}},
                    {{0, 2}, {1}, {3}},
                    {{0, 3}, {1, 2}},
                    {{0}, {1, 2, 3}},
                    {{0}, {1, 2}, {3}},
                    {{0, 3}, {1}, {2}},
                    {{0}, {1, 3}, {2}},
                    {{0}, {1}, {2, 3}},
                    {{0}, {1}, {2}, {3}}
            };

            return partition;
        }

        @Override
        public int[][] getData(){

            int[][] slvEx2Mat = {
                    {1, 1, 1, 1},
                    {1, 1, 1, 1},
                    {1, 1, 0, 1},
                    {1, 1, 0, 1},
                    {1, 1, 0, 1},
                    {1, 1, 0, 1},
                    {1, 1, 0, 1},
                    {0, 1, 0, 1},
                    {0, 1, 0, 0},
                    {0, 1, 0, 1}
            };

            return slvEx2Mat;
        }



        @Override
        public double[] getExpectedMarginalizedMarkerGroupLik() {
            return new double[]{
                    6.720721573733366e-12,
                    4.040215422119243e-12,
                    4.105284176313832e-11,
                    5.368709120000038e-12,
                    1.246561192484089e-11,
                    8.080430844238501e-12,
                    2.147483648000016e-11,
                    9.983749980332087e-12,
                    5.368709120000038e-12,
                    3.192268975501622e-12,
                    2.958148142320624e-12,
                    1.869841788726112e-11,
                    2.216108786638352e-11,
                    4.437222213480934e-12,
                    1.030279139755946e-11
            };
        }

        @Override
        public double[] getColPrior() {
            return new double[]{
                    35.0/(3.0 * 17.0 * 19.0),
                    20.0/(17.0 * 19.0),
                    20.0/(17.0 * 19.0),
                    50.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    20.0/(17.0 * 19.0),
                    50.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    50.0/(3.0 * 17.0 * 19.0),
                    20.0/(17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    64.0/(3.0 * 17.0 * 19.0)

            };
        }

        public double[][][] getBetaTable(){
            return new double[][][]{{{-3.401197381662155, -2.995732273553991},
                    {-4.094344562222100, -4.094344562222100, -3.401197381662155},
                    {-4.653960350157523, -4.941642422609304, -4.653960350157523, -3.737669618283368},
                    {-5.123963979403259, -5.634789603169249, -5.634789603169249, -5.123963979403259, -4.025351690735150}
            }};
        }

        @Override
        public double getAlpha(){
            return 3;
        }

        @Override
        public double getBeta(){
            return 2;
        }

        @Override
        public ArrayList<Integer> getSubtypeIndexes(){
            ArrayList<Integer> subtypeIndexes = new ArrayList<Integer>(
                    Arrays.asList(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
            );
            return subtypeIndexes;
        }
    };

    public void testCalcIntAllPartsMkrGrpLik (){
        Instance[] tests = new Instance[]{test0, test1};
        for(Instance test: tests) {

            int[][][] partitions = test.getPartitions();
            //int[][] data = test.getData();
            double alpha = test.getAlpha();
            double beta = test.getBeta();
            double[] mkrGrpLik;
            double[] expectedResult = test.getExpectedMarginalizedMarkerGroupLik();

            ArrayList<Integer>[] subtypeList = (ArrayList<Integer>[]) new ArrayList[]{test.getSubtypeIndexes()};
            SingleMarkerData data = new SingleMarkerData(new int[][][]{test.getData()});
            SubTypeList subTypeList = new SubTypeList(subtypeList );
            double[][][] betaTable = test.getBetaTable();


            mkrGrpLik = NoBLoCLikelihood.calcNoBLoCIntAllPartsMkrGrpLik(
                    partitions, data, 0,
                    alpha, beta, subTypeList,0,
                    betaTable);

            for (int partIndex = 0; partIndex < partitions.length; partIndex++) {

                assertEquals(mkrGrpLik[partIndex], expectedResult[partIndex], 1e-10);
                assertEquals(Math.log(mkrGrpLik[partIndex]), Math.log(expectedResult[partIndex]), 1e-10);
            }
        }
    }

    public void testCalcLogSubtypeLikelihood(){
        int[][][][] mkrGrpPartitions = new int[2][][][];
        mkrGrpPartitions[0] = test0.getPartitions();
        mkrGrpPartitions[1] = test1.getPartitions();

        int[][][] dataMat = new int[2][][];
        dataMat[0] = test0.getData();
        dataMat[1] = test1.getData();
        SingleMarkerData data = new SingleMarkerData(dataMat);

        double[][] colPriors = new double[2][];
        colPriors[0] = test0.getColPrior();
        colPriors[1] = test1.getColPrior();
        double[] alphaCValues = new double[]{test0.getAlpha(), test1.getAlpha()};
        double[] betaCValues = new double[]{test0.getBeta(), test1.getBeta()};

        ArrayList<Integer>[] subtypeSets = (ArrayList<Integer>[]) new ArrayList[]{test1.getSubtypeIndexes()};

        SubTypeList subTypeList = new SubTypeList(subtypeSets);

        Parameter alphaC = new Parameter("shape.a", alphaCValues, 0);
        Parameter betaC = new Parameter("shape.b", betaCValues, 0);
        NoBLoCLikelihood likelihood = new NoBLoCLikelihood(mkrGrpPartitions,
                colPriors, data, alphaC, betaC, subTypeList);

        double logSubLik = likelihood.calcLogSubtypeLikelihood(0);

        assertEquals(logSubLik, -43.67302884784564, 1e-10);

    }

    public void testCalcLogTypeLikelihood(){
        String filepath = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/ex.nob-loc.type.log.res.csv";
        double[][] logTypeLik = getTable(filepath, 115975);

        int[][][][] mkrGrpPartitions = new int[2][][][];
        mkrGrpPartitions[0] = test0.getPartitions();
        mkrGrpPartitions[1] = test1.getPartitions();

        int[][][] dataMat = new int[2][][];
        dataMat[0] = test0.getData();
        dataMat[1] = test1.getData();
        SingleMarkerData data = new SingleMarkerData(dataMat);

        double[][] colPriors = new double[2][];
        colPriors[0] = test0.getColPrior();
        colPriors[1] = test1.getColPrior();
        double[] alphaCValues = new double[]{test0.getAlpha(), test1.getAlpha()};
        double[] betaCValues = new double[]{test0.getBeta(), test1.getBeta()};


        ArrayList<Integer>[] subtypeParts;
        double logSubLik;

        String clustFile = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets10.txt";

        int setMaxCount = 10;
        ArrayList<Integer>[][] allParts10 = getCluster(clustFile, 115975);

        for(int partIndex = 0; partIndex < allParts10.length; partIndex++){
            subtypeParts = (ArrayList<Integer>[]) new ArrayList[setMaxCount];
            for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
                subtypeParts[setIndex] = new ArrayList<Integer>();
            }
            int[] samples = MathUtils.sample(allParts10[partIndex].length, 0,setMaxCount -1);
            for(int setIndex = 0; setIndex < allParts10[partIndex].length; setIndex++){
                subtypeParts[samples[setIndex]] = allParts10[partIndex][setIndex];
            }

            SubTypeList subTypeList = new SubTypeList(subtypeParts);

            Parameter alphaC = new Parameter("shape.a", alphaCValues, 0);
            Parameter betaC = new Parameter("shape.b", betaCValues, 0);
            NoBLoCLikelihood likelihood = new NoBLoCLikelihood(mkrGrpPartitions,
                    colPriors, data, alphaC, betaC, subTypeList);

            logSubLik = likelihood.getLogLikelihood();

            assertEquals(logSubLik, logTypeLik[partIndex][0], 1e-10);
        }


    }

    private static double[][] getTable(String file, int lineCount){
        try{

            BufferedReader tableReader = new BufferedReader(new FileReader(file));
            String line = tableReader.readLine();
            String[] elts = line.split(",");
            double[][] table = new double[lineCount][elts.length];

            for(int lineIndex = 0; lineIndex < lineCount; lineIndex++){
                elts = tableReader.readLine().split(",");
                for(int eltsIndex = 0; eltsIndex < elts.length; eltsIndex++){
                    table[lineIndex][eltsIndex] = Double.parseDouble(elts[eltsIndex]);
                }
            }

            tableReader.close();

            return table;

        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }

    private static ArrayList<Integer>[][] getCluster(String file, int lineCount){
        try{

            BufferedReader clustReader = new BufferedReader(new FileReader(file));
            String line = "";
            String[] clustStr;
            String[] obsInClust;
            ArrayList<Integer>[][] clusts = (ArrayList<Integer>[][]) new ArrayList[lineCount][];

            for(int lineIndex = 0; lineIndex < lineCount; lineIndex++){
                line = clustReader.readLine().trim();
                line = line.substring(1, line.length() - 1);

                if(line.contains("], [")){
                    clustStr = line.split("\\], \\[");
                }else{
                    clustStr = new String[]{line};
                }


                clusts[lineIndex] = (ArrayList<Integer>[]) new ArrayList[clustStr.length];
                for(int clustIndex = 0; clustIndex < clustStr.length; clustIndex++){
                    obsInClust = clustStr[clustIndex].replaceAll("\\[|\\]", "").split(", ");

                    clusts[lineIndex][clustIndex] = new ArrayList<Integer>();
                    for(int obsIndex = 0; obsIndex < obsInClust.length; obsIndex++){
                        clusts[lineIndex][clustIndex].add(Integer.parseInt(obsInClust[obsIndex]));

                    }



                }
            }

            clustReader.close();

            return clusts;

        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }





}
