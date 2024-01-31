package data;

import utils.DataUtils;


public class CompoundMarkerData {

    protected SingleMarkerData[] dataSets;
    public CompoundMarkerData(){

    }
    public CompoundMarkerData(String[] files, int[][] rowInfo, int[][][] colInfo){
        dataSets = new SingleMarkerData[files.length];
        int[][][][] dataMat = DataUtils.extractDataAcrossTypes(files, rowInfo, colInfo);
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++){
            dataSets[typeIndex] = new SingleMarkerData(dataMat[typeIndex]);
        }
    }

    public CompoundMarkerData(String[] files, int[] rowInfo, int[][] colInfo){
        dataSets = new SingleMarkerData[files.length];
        int[][][][] dataMat = DataUtils.extractDataAcrossTypes(files, rowInfo, colInfo);
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++){
            dataSets[typeIndex] = new SingleMarkerData(dataMat[typeIndex]);
        }
    }



    public SingleMarkerData getData(int typeIndex){
        return dataSets[typeIndex];
    }

    public int getMkrGrpSize(int mkrGroupIndex){
        return dataSets[0].getMarkerCount(mkrGroupIndex);
    }

}
