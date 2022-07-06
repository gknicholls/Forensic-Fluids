package data;

public class SingleMarkerData {
    protected int[][][] singleTypeData;
    public SingleMarkerData(int[][][] singleTypeData){
        this.singleTypeData = singleTypeData;
    }

    public int getData(int mkrGrpIndex, int obsIndex, int mkrIndex){
        return singleTypeData[mkrGrpIndex][obsIndex][mkrIndex];
    }

    public int getMarkerGroupCount(){
        return singleTypeData.length;
    }
}
