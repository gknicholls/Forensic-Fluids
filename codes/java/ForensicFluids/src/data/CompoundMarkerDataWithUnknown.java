package data;

import cluster.TypeListWithUnknown;

import java.io.BufferedReader;
import java.io.FileReader;

public class CompoundMarkerDataWithUnknown {

    private int[][][][] data;
    private int[][][] unknownFluid;
    private int getUnknownStartIndex;
    public CompoundMarkerDataWithUnknown(String[] files,
                                         String unknownFluidFile,
                                         int[][] rowInfo, int[][][] colInfo,
                                         TypeListWithUnknown typeList){

        data = new int[files.length][][][];
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++){
            data[typeIndex] = new int[colInfo[typeIndex].length][][];
            for(int markerIndex = 0; markerIndex < colInfo[typeIndex].length; markerIndex++){
                data[typeIndex][markerIndex] = extractData(files[typeIndex],
                        colInfo[typeIndex][markerIndex][0],
                        colInfo[typeIndex][markerIndex][1],
                        rowInfo[typeIndex][0],
                        rowInfo[typeIndex][1]);
            }
        }

        getUnknownStartIndex = typeList.getUnknownStartIndex();

    }

    public CompoundMarkerDataWithUnknown(String[] files, int[] rowInfo, int[][] colInfo){
        data = new int[files.length][][][];
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++){
            for(int markerIndex = 0; markerIndex < colInfo[typeIndex].length; markerIndex++){
                data[typeIndex][markerIndex] = extractData(files[typeIndex],
                        colInfo[markerIndex][0],
                        colInfo[markerIndex][1],
                        rowInfo[0],
                        rowInfo[1]);
            }
        }

    }

    public static int[][] extractData(String file, int startCol, int endCol, int rowStart, int rowEnd){
        try{
            BufferedReader dataReader = new BufferedReader(new FileReader(file));
            String line = dataReader.readLine();
            String[] elts;
            int[][] data = new int[rowEnd - rowStart + 1][endCol - startCol + 1];
            int counter = 0;
            while((line = dataReader.readLine()) != null){
                elts = line.split(",");
                for(int colIndex = 0; colIndex < data[counter].length; colIndex++){
                    data[counter][colIndex] = Integer.parseInt(elts[startCol + colIndex]);
                }
                counter++;
            }
            dataReader.close();
            return data;

        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }

    public int[][][] getData(int typeIndex){
        return data[typeIndex];
    }

    public class MarkerData extends SingleMarkerData{

        MarkerData(int[][][] singleTypeData){
            super(singleTypeData);

        }

        public int getData(int mkrGrpIndex, int obsIndex, int mkrIndex){

            if(obsIndex < getUnknownStartIndex){
                return super.getData(mkrGrpIndex, obsIndex, mkrIndex);
            }else{
                return data[data.length - 1][mkrGrpIndex][obsIndex - getUnknownStartIndex][mkrIndex];
            }

        }



    }
}
