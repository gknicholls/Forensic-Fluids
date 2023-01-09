package test;

import inference.SingleUnknownGibbsSampler;
import junit.framework.TestCase;
import model.CompoundClusterLikelihood;
import state.TypeList;
import utils.ParamUtils;

import java.util.ArrayList;

import inference.SingleUnknownGibbsSampler;

public class TestSingleUnknownGibbsSampler extends TestCase {
    class GibbsSamplerDummy extends SingleUnknownGibbsSampler {

        public GibbsSamplerDummy(){
            super();
        }
    }

    public interface Instance {

        TypeList getTypeList();
        int[][] getExpectedCurrSetSizesAcrossType();
        int[][] getExpectedAllConfigSetSizesAcrossType();

    }
    /*protected Instance test0 = new Instance() {
        @Override
        public TypeList getTypeList() {
            return null;
        }
    };*/

    protected Instance test1 = new Instance() {
        public TypeList getTypeList() {
            String clusteringStr = "[[0,3,5,7,8,12,31,39],[1,2,4,6,9,10,11,13,15,21,33,36,37,38,43,45,46,49,50,51,52,53,54,55,56,57],[14,16,17,18,19,20,22,23,24,25,26,27,28,29,30,32,34,35,40,41,42,44,47,48,58]] [[0,1,2,3,4,5,9,12,14,15,16,17,18,20,21,25,26,27,28,29,30],[6,10,11,13,19,22,23,24],[7,8]] [[0,37,48,50,69,71,72,73,74,75,76,79],[1],[2,3,4,5,6,7,8,11,12,14,15,16,18,20,21,22,23,24,25,27,29,30,31,33,34,35,36,38,39,40,41,42,43,44,46,47,49,51,52,58,63,64,65,66,70],[9,10,13,17,19,26,28,32,45,53,54,55,56,57,59,60,61,62,67,68,77,78]] [[0,1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,35,36,37,38,43,45,46,47,50,51,52,54,55,56,57,58,59,60,61,62,63,64],[29,30,31,32,33,34,39,40,41,42,44,48,49,53],[9]] [[0,1,3,4,5,6,7,8,9,10,11,13,15,16,17,19,22,23,24,25,26,27,28,29,30,44,45,46,57,58,60,61,62,66,67,68,69,70,71,72,73,75,319],[2,12,14,18,20,21,31,32,33,34,35,36,37,38,39,40,41,42,43,47,48,49,50,51,52,53,54,55,56,59,63,64,65,76,77,78,79,80,81,82,83],[74]]";
            TypeList typeList = ParamUtils.createTypeList(
                    new int[]{59, 31, 80, 65, 85}, 5, clusteringStr);
            return typeList;
        }
        public int[][] getExpectedCurrSetSizesAcrossType(){
            return new int[][]{
                    {8, 26, 25, 0, 0},
                    {21, 8, 2, 0, 0},
                    {12, 1, 45, 22, 0},
                    {50, 14, 1, 0, 0},
                    {43, 41, 1, 0, 0}
            };
        }

        public int[][] getExpectedAllConfigSetSizesAcrossType(){
            return new int[][]{
                    {9, 27, 26, 1, 0},
                    {22, 9, 3, 1, 0},
                    {13, 2, 46, 23, 1},
                    {51, 15, 2, 1, 0},
                    {44, 42, 2, 1, 0}
            };
        }

    };






    public void testSetSizesAcrossType(){
        TypeList typeList = test1.getTypeList();
        int[][] currSetSizeLists = new int[typeList.getTypeCount()][];
        SingleUnknownGibbsSampler.getCurrSetSizesAcrossType(currSetSizeLists, typeList);
        int[][] currSetSizeListsExptd = test1.getExpectedCurrSetSizesAcrossType();
        for(int i = 0; i < currSetSizeLists.length; i++){
            for(int j = 0; j < currSetSizeLists[i].length; j++){
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




}
