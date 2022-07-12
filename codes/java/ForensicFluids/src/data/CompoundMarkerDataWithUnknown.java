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

        super(files, rowInfo, colInfo);
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
        super(files, rowInfo, colInfo);
        unknownFluid = DataUtils.extractDataAcrossMarkers(unknownFluidFile, rowInfoUnknown, colInfoUnknown);

        getUnknownStartIndex = typeList.getUnknownStartIndex();

    }

    public class MarkerData extends SingleMarkerData{

        public MarkerData(int[][][] singleTypeData){
            super(singleTypeData);

        }

        public int getData(int mkrGrpIndex, int obsIndex, int mkrIndex){

            if(obsIndex < getUnknownStartIndex){
                return super.getData(mkrGrpIndex, obsIndex, mkrIndex);
            }else{
                return unknownFluid[mkrGrpIndex][obsIndex - getUnknownStartIndex][mkrIndex];
            }

        }



    }
}
