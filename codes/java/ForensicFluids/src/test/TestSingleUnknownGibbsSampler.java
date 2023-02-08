package test;

import data.CompoundMarkerData;
import inference.SingleUnknownGibbsSampler;
import junit.framework.TestCase;
import model.CompoundClusterLikelihood;
import state.Parameter;
import state.TypeList;
import state.TypeListWithUnknown;
import utils.DataUtils;
import utils.ParamUtils;

import java.util.ArrayList;

import inference.SingleUnknownGibbsSampler;
import utils.Randomizer;

public class TestSingleUnknownGibbsSampler extends TestCase {
    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    class GibbsSamplerDummy extends SingleUnknownGibbsSampler {

        public GibbsSamplerDummy(){
            super();
        }
    }

    public interface Instance {

        TypeList getTypeList();
        TypeListWithUnknown getTypeListWithUnknown();
        int[][] getExpectedCurrSetSizesAcrossType();
        int[][] getExpectedAllConfigSetSizesAcrossType();
        double[][] getExpectedLogMDPPriorForAllConfig();
        int[][][] getExpectedAssignUnknownToAllPossibleSubtype();
        double getAlpha5();
        double getAlpha7();
        Parameter[] getShapeA();
        Parameter[] getShapeB();
        CompoundMarkerData getDatasets();
        double[][] getExpectedAllConfigFullLikelihood();
        double[] getExpectedFullConditionals();
        double[] getRandomDouble();
        int[] getFullConditionalIndexes();
        int[][] getExpectedSubtype();
        double[] getLogTypePrior();


    }
    /*protected Instance test0 = new Instance() {
        @Override
        public TypeList getTypeList() {
            return null;
        }
    };*/

    protected Instance test1 = new Instance() {
        public TypeList getTypeList() {
            String clusteringStr = "[[0,1,2,3,4,5,6,7,8,9,10,11,12,14,20,32,36,37,38,42,45,48,49,50,51,52,53,54,55,56],[13,15,16,17,18,19,21,22,23,24,25,26,27,28,29,31,33,34,35,39,40,41,43,44,46,47,57],[30]] [[0,1,2,3,4,5,9,11,12,14,15,16,17,18,19,20,21,22,25,26,27,28,29,30],[6,10,13,23,24],[7,8]] [[0,2,3,4,5,6,7,8,11,12,14,15,16,18,20,21,22,23,24,25,27,29,30,31,33,34,35,36,38,39,40,41,42,43,44,46,47,48,49,51,52,58,63,64,65,66,70,72],[1,9,10,13,17,19,26,28,32,45,53,54,55,56,57,59,60,61,62,67,68,77,78],[37,50,69,71,73,74,75,76,79]] [[0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,35,36,37,38,43,45,46,47,50,51,52,54,55,56,57,58,59,60,61,62,63,64],[29,30,31,32,33,34,39,40,41,42,44,48,49,53],[9]] [[0,1,3,4,5,6,7,8,11,15,16,17,19,21,22,23,24,25,27,28,29,30,32,45,46,47,58,61,62,66,67,68,69,70,72,73,74,75,83,85],[2,9,10,12,13,14,18,20,26,34,35,36,37,38,39,40,48,49,53,54,55,57,59,63,65,71,76,77,78,79,80,81,82,84],[31,33,41,42,43,44,50,51,52,56,60,64]]";
            TypeList typeList = ParamUtils.createTypeList(
                    new int[]{58, 31, 80, 65, 86}, 5, clusteringStr);
            return typeList;
        }

        public TypeListWithUnknown getTypeListWithUnknown() {
            String clusteringStr = "[[0,1,2,3,4,5,6,7,8,9,10,11,12,14,20,32,36,37,38,42,45,48,49,50,51,52,53,54,55,56],[13,15,16,17,18,19,21,22,23,24,25,26,27,28,29,31,33,34,35,39,40,41,43,44,46,47,57],[30,320]] [[0,1,2,3,4,5,9,11,12,14,15,16,17,18,19,20,21,22,25,26,27,28,29,30],[6,10,13,23,24],[7,8]] [[0,2,3,4,5,6,7,8,11,12,14,15,16,18,20,21,22,23,24,25,27,29,30,31,33,34,35,36,38,39,40,41,42,43,44,46,47,48,49,51,52,58,63,64,65,66,70,72],[1,9,10,13,17,19,26,28,32,45,53,54,55,56,57,59,60,61,62,67,68,77,78],[37,50,69,71,73,74,75,76,79]] [[0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,35,36,37,38,43,45,46,47,50,51,52,54,55,56,57,58,59,60,61,62,63,64],[29,30,31,32,33,34,39,40,41,42,44,48,49,53],[9]] [[0,1,3,4,5,6,7,8,11,15,16,17,19,21,22,23,24,25,27,28,29,30,32,45,46,47,58,61,62,66,67,68,69,70,72,73,74,75,83,85],[2,9,10,12,13,14,18,20,26,34,35,36,37,38,39,40,48,49,53,54,55,57,59,63,65,71,76,77,78,79,80,81,82,84],[31,33,41,42,43,44,50,51,52,56,60,64]]";
            String unknownPath = "/Users/chwu/Documents/research/bfc/data/loocvCut/cvf/loocvTrain_cvf_unknown_1.csv";
            TypeListWithUnknown typeList = ParamUtils.createTypeList(new int[]{58, 31, 80, 65, 86},
                    5, clusteringStr, unknownPath, 0);
            return typeList;
        }

        public int[][] getExpectedCurrSetSizesAcrossType(){
            return new int[][]{
                    {30, 27,  1, 0, 0},
                    {24,  5,  2, 0, 0},
                    {48, 23,  9, 0, 0},
                    {50, 14,  1, 0, 0},
                    {40, 34, 12, 0, 0}
            };
        }

        public int[][] getExpectedAllConfigSetSizesAcrossType(){
            return new int[][]{
                    {31, 28,  2, 1, 0},
                    {25,  6,  3, 1, 0},
                    {49, 24, 10, 1, 0},
                    {51, 15,  2, 1, 0},
                    {41, 35, 13, 1, 0}
            };
        }


        public double[][] getExpectedLogMDPPriorForAllConfig(){
            return new double[][]{
                    {-278.9327790446595, -279.0376951482387, -282.2242100334603, -283.7609433932106, 0},
                    {-278.5402353842051, -280.0862873342446, -280.9611731511506, -282.9621870595322, 0},
                    {-278.2672076899302, -279.5158203752669, -280.4467130882813, -284.5322361798105, 0},
                    {-278.5361944293055, -279.8031749562952, -282.3399081811102, -283.9029888648216, 0},
                    {-279.0361400646326, -279.1981970783448, -280.2340224890614, -284.2882888277161, 0}
            };
        }

        public int[][][] getExpectedAssignUnknownToAllPossibleSubtype(){
            return new int[][][]{
                {{0,1,2,3,4,5,6,7,8,9,10,11,12,14,20,32,36,37,38,42,45,48,49,50,51,52,53,54,55,56, 320}, {13,15,16,17,18,19,21,22,23,24,25,26,27,28,29,31,33,34,35,39,40,41,43,44,46,47,57, 320}, {30, 320}, {320}, {}},
                    {{0,1,2,3,4,5,9,11,12,14,15,16,17,18,19,20,21,22,25,26,27,28,29,30, 320}, {6,10,13,23,24, 320}, {7,8, 320}, {320}, {}},
                    {{0,2,3,4,5,6,7,8,11,12,14,15,16,18,20,21,22,23,24,25,27,29,30,31,33,34,35,36,38,39,40,41,42,43,44,46,47,48,49,51,52,58,63,64,65,66,70,72, 320}, {1,9,10,13,17,19,26,28,32,45,53,54,55,56,57,59,60,61,62,67,68,77,78, 320}, {37,50,69,71,73,74,75,76,79, 320},{320}, {}},
                    {{0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,35,36,37,38,43,45,46,47,50,51,52,54,55,56,57,58,59,60,61,62,63,64, 320}, {29,30,31,32,33,34,39,40,41,42,44,48,49,53, 320}, {9, 320}, {320}, {}},
                    {{0,1,3,4,5,6,7,8,11,15,16,17,19,21,22,23,24,25,27,28,29,30,32,45,46,47,58,61,62,66,67,68,69,70,72,73,74,75,83,85,320}, {2,9,10,12,13,14,18,20,26,34,35,36,37,38,39,40,48,49,53,54,55,57,59,63,65,71,76,77,78,79,80,81,82,84, 320}, {31,33,41,42,43,44,50,51,52,56,60,64, 320}, {320}, {}}

            };
        }

        public double getAlpha5(){
            return 0.49;
        }

        public double getAlpha7(){
            return 0.375;
        }

        public Parameter[] getShapeA(){
            Parameter[] shapeAParams = new Parameter[5];
            shapeAParams[0] = new Parameter("shapeA0", new double[]{1.000, 0.200, 0.200, 0.200, 0.200}, 0.0);
            shapeAParams[1] = new Parameter("shapeA1", new double[]{1.000, 1.000, 0.200, 1.000, 0.200}, 0.0);
            shapeAParams[2] = new Parameter("shapeA2", new double[]{0.200, 0.200, 0.450, 0.200, 0.200}, 0.0);
            shapeAParams[3] = new Parameter("shapeA3", new double[]{0.200, 0.200, 0.200, 0.450, 0.200}, 0.0);
            shapeAParams[4] = new Parameter("shapeA4", new double[]{0.200, 0.200, 0.200, 0.200, 0.450}, 0.0);

            return shapeAParams;
        }


        public Parameter[] getShapeB(){
            Parameter[] shapeBParams = new Parameter[5];
            shapeBParams[0] = new Parameter("shapeB0", new double[]{1.000, 0.800, 0.800, 0.800, 0.800}, 0.0);
            shapeBParams[1] = new Parameter("shapeB1", new double[]{1.000, 1.000, 0.800, 1.000, 0.800}, 0.0);
            shapeBParams[2] = new Parameter("shapeB2", new double[]{0.800, 0.800, 0.150, 0.800, 0.800}, 0.0);
            shapeBParams[3] = new Parameter("shapeB3", new double[]{0.800, 0.800, 0.800, 0.150, 0.800}, 0.0);
            shapeBParams[4] = new Parameter("shapeB4", new double[]{0.800, 0.800, 0.800, 0.800, 0.150}, 0.0);

            return shapeBParams;
        }

        public CompoundMarkerData getDatasets(){
            ArrayList<String> trainingDataPathList = new ArrayList<>();
            trainingDataPathList.add("/Users/chwu/Documents/research/bfc/data/loocvCut/cvf/loocvTrain_cvf_train_1.csv");
            trainingDataPathList.add("/Users/chwu/Documents/research/bfc/data/loocvCut/cvf/singleBin_mtb.csv");
            trainingDataPathList.add("/Users/chwu/Documents/research/bfc/data/loocvCut/cvf/singleBin_slv.csv");
            trainingDataPathList.add("/Users/chwu/Documents/research/bfc/data/loocvCut/cvf/singleBin_bld.csv");
            trainingDataPathList.add("/Users/chwu/Documents/research/bfc/data/loocvCut/cvf/singleBin_smn.csv");
            String unknownPath = "/Users/chwu/Documents/research/bfc/data/loocvCut/cvf/loocvTrain_cvf_unknown_1.csv";
            CompoundMarkerData dataSets = DataUtils.createData(
                    trainingDataPathList,
                    unknownPath, new int[]{58, 31, 80, 65, 86}, COL_RANGE, 1, getTypeListWithUnknown());

            return dataSets;
        }

        public double[][] getExpectedAllConfigFullLikelihood(){
            /*
            * CompoundClusterLikelihood likTest;
        int[][] allConfigSetSizeListsExptd = test1.getExpectedAllConfigSetSizesAcrossType();
        for(int typeIndex = 0; typeIndex < logFullLikelihoods.length; typeIndex++){
            for(int setIndex = 0; setIndex < logFullLikelihoods[typeIndex].length; setIndex++){
                typeList.addObs(typeIndex, setIndex, unknownObsIndex+typeList.getUnknownStartIndex());
                //System.out.println(typeList.log());
                if(allConfigSetSizeListsExptd[typeIndex][setIndex] > 0){
                    likTest = new CompoundClusterLikelihood("multitypeLikelihood",
                            mkrGrpPartitions, colPriors, test1.getDatasets(),
                            test1.getShapeA(),
                            test1.getShapeB(),
                            typeList);
                    System.out.print(likTest.getLogLikelihood()+" ");
                    assertEquals(logFullLikelihoods[typeIndex][setIndex],
                            likTest.getLogLikelihood(), 1e-10);
                }
                typeList.removeObs(typeIndex, setIndex,
                        typeList.getSubTypeSetSize(typeIndex, setIndex) - 1);

            }
            System.out.println();

        }
             */
            return new double[][]{
                    {-1380.0214837219269, -1389.8860020326733, -1379.2952920027442, -1382.6062370473599, 0.0},
                    {-1389.2018551475273, -1396.6556616305563, -1398.7057242040514, -1385.7942867409563, 0.0},
                    {-1407.4974772083563, -1390.739371081685, -1410.1043769203006, -1385.2450836609532, 0.0},
                    {-1416.7784384562235, -1395.4547240270258, -1394.4906765699395, -1385.2450836609532, 0.0},
                    {-1397.6757112863663, -1397.7615503598834, -1394.226583366867, -1384.1647759885443, 0.0}
            };
        }

        public double[] getExpectedFullConditionals(){
            return new double[]{
                    9.2676894738513493e-01, 4.3381155921462939e-05, 7.1269254211108343e-02, 5.5921940506901090e-04, 0,
                    4.2421656413524914e-04, 5.2359894975265993e-08, 2.8100226528301974e-09, 1.5383195734265914e-04, 0,
                    8.4219580874179668e-12, 4.5824791167365746e-05, 7.0259288622307337e-14, 7.3898819440112814e-05, 0,
                    7.4960655474080288e-16, 3.8491269427910541e-07, 7.9864446017965353e-08, 1.7331100876567538e-04, 0,
                    1.2590610231422507e-07, 9.8262289036528931e-08, 1.1960525892389820e-06, 4.8617452538375893e-04, 0
            };
        }

        public double[] getRandomDouble(){
            return new double[]{0.99950, 0.92775, 0.99925, 0.99900, 0.50000, 0.99990};
        }

        public int[] getFullConditionalIndexes(){
            return new int[]{18, 2, 11, 5, 0, 23};
        }

        public int[][] getExpectedSubtype(){
            return new int[][]{{3,3}, {0, 2}, {2, 1}, {1, 0}, {0, 0}, {4, 3}};
        }

        public double[] getLogTypePrior(){
            return new double[]{-2.9957322735539909, -1.8971199848858813, -1.6094379124341003, -1.3862943611198906, -1.0498221244986778};
        }


    };






    public void testSetSizesAcrossType(){
        TypeList typeList = test1.getTypeList();
        int[][] currSetSizeLists = new int[typeList.getTypeCount()][];
        SingleUnknownGibbsSampler.getCurrSetSizesAcrossType(currSetSizeLists, typeList);
        int[][] currSetSizeListsExptd = test1.getExpectedCurrSetSizesAcrossType();
        for(int i = 0; i < currSetSizeLists.length; i++){
            for(int j = 0; j < currSetSizeLists[i].length; j++){
                //
                assertEquals(currSetSizeLists[i][j], currSetSizeListsExptd[i][j], 0);
            }

        }

        int[][] allConfigSetSizeLists = new int[typeList.getTypeCount()][];
        int[][] allConfigSetSizeListsExptd = test1.getExpectedAllConfigSetSizesAcrossType();
        SingleUnknownGibbsSampler.getSetSizesForAllConfig(currSetSizeLists, allConfigSetSizeLists);
        for(int i = 0; i < currSetSizeLists.length; i++){
            for(int j = 0; j < currSetSizeLists[i].length; j++){
                assertEquals(allConfigSetSizeLists[i][j], allConfigSetSizeListsExptd[i][j], 0);
            }
        }



    }

    public void testCalcLogMDPPriorForAllConfig(){
        TypeList typeList = test1.getTypeList();

        double[][] logTypeMDPPriors = new double[typeList.getTypeCount()][];
        int[][] currSetSizeListsExptd = test1.getExpectedCurrSetSizesAcrossType();
        int[][] allConfigSetSizeListsExptd = test1.getExpectedAllConfigSetSizesAcrossType();
        double[] alphaValues = new double[]{0.6025, 0.725, 0.55, 0.585, 0.525};
        SingleUnknownGibbsSampler.calcLogMDPPriorForAllConfig(
                alphaValues, typeList, currSetSizeListsExptd, allConfigSetSizeListsExptd, logTypeMDPPriors);
        double[][] logTypeMDPPriorsExptd = test1.getExpectedLogMDPPriorForAllConfig();

        for(int i = 0; i < logTypeMDPPriors.length; i++){
            for(int j = 0; j < logTypeMDPPriors[1].length; j++){
                assertEquals(logTypeMDPPriors[4][j], logTypeMDPPriorsExptd[4][j], 1e-10);
            }
        }

    }

    public void testAssignUnknownToAllPossibleSubtype(){
        TypeList typeList = test1.getTypeList();
        TypeList typeListCopy = typeList.copy();
        SingleUnknownGibbsSampler.assignUnknownToAllPossibleSubtype(
                typeListCopy, test1.getExpectedAllConfigSetSizesAcrossType(), typeList.getTotalCount()
        );


        int[][][] allSubtypeExptd = test1.getExpectedAssignUnknownToAllPossibleSubtype();
        for(int typeIndex = 0; typeIndex < typeListCopy.getTypeCount(); typeIndex++){
            for(int setIndex = 0; setIndex < typeListCopy.getMaxSubTypeCount(typeIndex); setIndex++){
                for(int eltIndex = 0; eltIndex < typeListCopy.getSubTypeSetSize(typeIndex, setIndex); eltIndex++){
                    assertEquals(typeListCopy.getObs(typeIndex, setIndex, eltIndex),
                            allSubtypeExptd[typeIndex][setIndex][eltIndex]);
                }
            }

        }
    }


    public void testAssignUnknownToAllPossibleSubtypeV2(){
        int[][][] allSubtypeExptd = test1.getExpectedAssignUnknownToAllPossibleSubtype();


        TypeListWithUnknown typeList = test1.getTypeListWithUnknown();
        TypeListWithUnknown typeListCopy = typeList.copy();
        int unknownObsIndex = Randomizer.nextInt(typeList.getUnknownObsCount());
        // Retrieve the classification information on this sample.
        int currUnknownTypeIndex = typeList.getUnknownObsTypeIndex(unknownObsIndex);
        int currUnknownSubtypeIndex = typeList.getUnknownObsSubTypeIndex(unknownObsIndex);
        int currUnknownEltIndex = typeList.getUnknownObsEltIndex(
                unknownObsIndex + typeList.getUnknownStartIndex(),
                currUnknownTypeIndex, currUnknownSubtypeIndex);

        typeList.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, currUnknownEltIndex);
        int unknownObs = typeListCopy.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, currUnknownEltIndex);
        SingleUnknownGibbsSampler.assignUnknownToAllPossibleSubtype(
                typeListCopy, test1.getExpectedAllConfigSetSizesAcrossType(), unknownObs);

        for(int typeIndex = 0; typeIndex < typeListCopy.getTypeCount(); typeIndex++){
            for(int setIndex = 0; setIndex < typeListCopy.getMaxSubTypeCount(typeIndex); setIndex++){
                for(int eltIndex = 0; eltIndex < typeListCopy.getSubTypeSetSize(typeIndex, setIndex); eltIndex++){
                    assertEquals(typeListCopy.getObs(typeIndex, setIndex, eltIndex),
                            allSubtypeExptd[typeIndex][setIndex][eltIndex]);

                }
            }
        }

        int propUnknownEltIndex = typeListCopy.getUnknownObsEltIndex(
                unknownObs, currUnknownTypeIndex, currUnknownSubtypeIndex);
        typeListCopy.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex,propUnknownEltIndex);
        for(int eltIndex = 0; eltIndex < typeListCopy.getSubTypeSetSize(currUnknownTypeIndex, currUnknownSubtypeIndex); eltIndex++){
            System.out.print(typeListCopy.getObs(currUnknownTypeIndex, currUnknownSubtypeIndex, eltIndex)+" ");

        }
        System.out.println();

        for(int eltIndex = 0; eltIndex < typeListCopy.getSubTypeSetSize(currUnknownTypeIndex, currUnknownSubtypeIndex); eltIndex++){
            System.out.print(typeList.getObs(currUnknownTypeIndex, currUnknownSubtypeIndex, eltIndex)+" ");

        }
        System.out.println();
    }




    private void testCopyLikelihood(CompoundClusterLikelihood lik,
                                    CompoundClusterLikelihood likCopy,
                                    double[] logLiks, double[] logLiksCopy,
                                    double[][] logSubtypeLiks, double[][] logSubtypeLiksCopy){
        lik.getLogTypeLikelihoods(logLiks);
        likCopy.getLogTypeLikelihoods(logLiksCopy);
        lik.getLogSubtypeLikelihoods(logSubtypeLiks);
        likCopy.getLogSubtypeLikelihoods(logSubtypeLiksCopy);


        for(int typeIndex = 0; typeIndex < logLiks.length; typeIndex++){
            assertEquals(logLiks[typeIndex], logLiksCopy[typeIndex]);
        }

        for(int typeIndex = 0; typeIndex < logSubtypeLiks.length; typeIndex++){
            for(int setIndex = 0; setIndex < logSubtypeLiks[typeIndex].length; setIndex++){
                assertEquals(logSubtypeLiks[typeIndex][setIndex], logSubtypeLiksCopy[typeIndex][setIndex]);
            }
        }


    }


    public void testSubLikelihoodCopy(){
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/data/loocvTrain/smn_2/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/data/loocvTrain/smn_2/allPartitionSets7.txt";
        int[][][][] mkrGrpPartitions = DataUtils.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double[][] colPriors = DataUtils.getColPriors(
                test1.getAlpha5(), test1.getAlpha7(),
                allPartitionSets5File, allPartitionSets7File);

        TypeList typeList = test1.getTypeList();
        TypeList typeListCopy = typeList.copy();

        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, test1.getDatasets(),
                test1.getShapeA(),
                test1.getShapeB(),
                test1.getTypeList());
        //lik.getLogLikelihood();
        System.out.println(lik.getLogLikelihood());
        double[] logLiks = new double[typeList.getTypeCount()];
        double[][] logSubtypeLiks = new double[typeList.getTypeCount()][typeList.getMaxSubTypeCount(0)];
        lik.getLogTypeLikelihoods(logLiks);

        CompoundClusterLikelihood likCopy = null;
        likCopy = SingleUnknownGibbsSampler.setLikelihoodCopy(lik, typeListCopy);
        likCopy.getLogLikelihood();
        double[] logLiksCopy = new double[typeList.getTypeCount()];
        double[][] logSubtypeLiksCopy = new double[typeList.getTypeCount()][typeList.getMaxSubTypeCount(0)];
        testCopyLikelihood(lik, likCopy, logLiks, logLiksCopy, logSubtypeLiks, logSubtypeLiksCopy);

    }


    public void testFullLikelihood(){
        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/data/loocvTrain/smn_2/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/data/loocvTrain/smn_2/allPartitionSets7.txt";
        int[][][][] mkrGrpPartitions = DataUtils.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        double[][] colPriors = DataUtils.getColPriors(
                test1.getAlpha5(), test1.getAlpha7(),
                allPartitionSets5File, allPartitionSets7File);

        TypeListWithUnknown typeList = test1.getTypeListWithUnknown();
        TypeListWithUnknown typeListCopy = typeList.copy();

        int unknownObsIndex = Randomizer.nextInt(typeList.getUnknownObsCount());
        // Retrieve the classification information on this sample.
        int currUnknownTypeIndex = typeList.getUnknownObsTypeIndex(unknownObsIndex);
        int currUnknownSubtypeIndex = typeList.getUnknownObsSubTypeIndex(unknownObsIndex);
        int currUnknownEltIndex = typeList.getUnknownObsEltIndex(
                unknownObsIndex + typeList.getUnknownStartIndex(),
                currUnknownTypeIndex, currUnknownSubtypeIndex);

        CompoundClusterLikelihood lik = new CompoundClusterLikelihood("multitypeLikelihood",
                mkrGrpPartitions, colPriors, test1.getDatasets(),
                test1.getShapeA(),
                test1.getShapeB(),
                test1.getTypeListWithUnknown());
        CompoundClusterLikelihood likCopy = SingleUnknownGibbsSampler.setLikelihoodCopy(lik, typeListCopy);

        double totalLogLik = lik.getLogLikelihood();
        double[][] logSubtypeLiks = new double[typeList.getTypeCount()][typeList.getMaxSubTypeCount(0)];
        lik.getLogSubtypeLikelihoods(logSubtypeLiks);


        int unknownObs = typeList.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, currUnknownEltIndex);
        typeListCopy.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, currUnknownEltIndex);
        SingleUnknownGibbsSampler.assignUnknownToAllPossibleSubtype(
                typeListCopy, test1.getExpectedAllConfigSetSizesAcrossType(), unknownObs);
        typeListCopy.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, currUnknownEltIndex);

        likCopy.getLogLikelihood();
        double[][] logSubtypeLiksCopy = new double[typeList.getTypeCount()][typeList.getMaxSubTypeCount(0)];
        likCopy.getLogSubtypeLikelihoods(logSubtypeLiksCopy);


        double[][] logFullLikelihoods = new double[logSubtypeLiks.length][];
        for(int typeIndex = 0; typeIndex < logFullLikelihoods.length; typeIndex++){
            logFullLikelihoods[typeIndex] = new double[logSubtypeLiks[typeIndex].length];
        }
        SingleUnknownGibbsSampler.prepareAndCalcFullLogLikelihoods(totalLogLik,
                logFullLikelihoods,
                logSubtypeLiks,
                logSubtypeLiksCopy,
                currUnknownTypeIndex,
                currUnknownSubtypeIndex);


        double[][] logFullLikExptd = test1.getExpectedAllConfigFullLikelihood();
        for(int typeIndex = 0; typeIndex < logFullLikelihoods.length; typeIndex++){
            for(int setIndex = 0; setIndex < logFullLikelihoods[typeIndex].length; setIndex++){
                assertEquals(logFullLikelihoods[typeIndex][setIndex],
                        logFullLikExptd[typeIndex][setIndex], 1e-10);


            }
            System.out.println();

        }

    }

    public void testGetFullConditionalPosteriorProb(){
        double[][] logAllConfigLogMDPPriors = test1.getExpectedLogMDPPriorForAllConfig();
        double[][] logAllConfigLogLik = test1.getExpectedAllConfigFullLikelihood();
        int count = 0;
        for(int typeIndex = 0; typeIndex < logAllConfigLogLik.length; typeIndex++){
            count += logAllConfigLogLik[typeIndex].length;
        }

        int[][] allConfigSetSizesAcrossType = test1.getExpectedAllConfigSetSizesAcrossType();
        double[] fullConditonals = new double[count];
        SingleUnknownGibbsSampler.getFullConditionalPosteriorProb(fullConditonals,
                logAllConfigLogLik, logAllConfigLogMDPPriors,
                test1.getLogTypePrior(), allConfigSetSizesAcrossType);


        double[] fullConditonalsExptd = test1.getExpectedFullConditionals();
        for(int index = 0; index < fullConditonals.length; index++){
            //System.out.println(fullConditonals[index]+ " "+fullConditonalsExptd[index]);
            assertEquals(fullConditonals[index], fullConditonalsExptd[index], 1e-10);
        }
    }

    public void testSampleSubtype(){
        double[] fullConditonals = test1.getExpectedFullConditionals();
        double[] quantile = test1.getRandomDouble();
        int[] sampleIndexExptd = test1.getFullConditionalIndexes();
        TypeList typeList = test1.getTypeList();
        int sampledFullCondIndex;
        int[] sampledSubtype;
        int[][] sampledSubtypesExptd = test1.getExpectedSubtype();
        for(int sampleIndex = 0; sampleIndex < quantile.length; sampleIndex++){
            sampledFullCondIndex = SingleUnknownGibbsSampler.sampleIndex(fullConditonals, quantile[sampleIndex]);
            assertEquals(sampledFullCondIndex, sampleIndexExptd[sampleIndex]);
            sampledSubtype = SingleUnknownGibbsSampler.mapToTypeListPos(typeList, sampledFullCondIndex);
            assertEquals(sampledSubtype[0], sampledSubtypesExptd[sampleIndex][0]);
            assertEquals(sampledSubtype[1], sampledSubtypesExptd[sampleIndex][1]);

        }



    }
}
