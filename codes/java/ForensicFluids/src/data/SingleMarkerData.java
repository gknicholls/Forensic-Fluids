package data;

import utils.DataUtils;

public class SingleMarkerData {
    protected int[][][] singleTypeData;
    public SingleMarkerData(int[][][] singleTypeData){
        this.singleTypeData = singleTypeData;
    }

    public SingleMarkerData(String file, int[] rowInfo, int[][] colInfo){
        this.singleTypeData = DataUtils.extractDataAcrossMarkers(file, rowInfo, colInfo);
    }

    public int getData(int mkrGrpIndex, int obsIndex, int mkrIndex){
        //System.out.println(mkrGrpIndex+" "+obsIndex+" "+mkrIndex);
        return singleTypeData[mkrGrpIndex][obsIndex][mkrIndex];
    }

    public int getMarkerGroupCount(){
        return singleTypeData.length;
    }
}
