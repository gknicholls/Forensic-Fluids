package data;

import state.TypeListWithUnknown;
import utils.DataUtils;

public class CompoundMarkerDataWithUnknown extends CompoundMarkerData{

    private int[][][] unknownFluid;
    private int getUnknownStartIndex;
    public CompoundMarkerDataWithUnknown (String[] files,
                                         String unknownFluidFile,
                                         int[][] rowInfo,
                                         int[][][] colInfo,
                                         int[] rowInfoUnknown,
                                         int[][] colInfoUnknown,
                                         TypeListWithUnknown typeList){

        super();
        //super(files, rowInfo, colInfo);
        dataSets = new MarkerData[files.length];
        int[][][][] dataMat = DataUtils.extractDataAcrossTypes(files, rowInfo, colInfo);
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++){
            dataSets[typeIndex] = new MarkerData(dataMat[typeIndex]);
        }
        unknownFluid = DataUtils.extractDataAcrossMarkers(unknownFluidFile, rowInfoUnknown, colInfoUnknown);
        getUnknownStartIndex = typeList.getUnknownStartIndex();

    }

    public CompoundMarkerDataWithUnknown(String[] files,
                                         String unknownFluidFile,
                                         int[] rowInfo,
                                         int[][] colInfo,
                                         int[] rowInfoUnknown,
                                         int[][] colInfoUnknown,
                                         TypeListWithUnknown typeList){
        super();
        dataSets = new MarkerData[files.length];
        int[][][][] dataMat = DataUtils.extractDataAcrossTypes(files, rowInfo, colInfo);
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++){
            dataSets[typeIndex] = new MarkerData(dataMat[typeIndex]);
        }
        unknownFluid = DataUtils.extractDataAcrossMarkers(unknownFluidFile, rowInfoUnknown, colInfoUnknown);

        getUnknownStartIndex = typeList.getUnknownStartIndex();

    }

    public class MarkerData extends SingleMarkerData{

        public MarkerData(int[][][] singleTypeData){
            super(singleTypeData);

        }

        public int getData(int mkrGrpIndex, int obsIndex, int mkrIndex){

            //System.out.println(obsIndex);

            if(obsIndex < getUnknownStartIndex){
                return super.getData(mkrGrpIndex, obsIndex, mkrIndex);
            }else{
                System.out.println(mkrGrpIndex+" "+(obsIndex )+" " +getUnknownStartIndex + " "+mkrIndex);
                return unknownFluid[mkrGrpIndex][obsIndex - getUnknownStartIndex][mkrIndex];
            }

        }



    }
}
