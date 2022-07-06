package data;

import java.io.BufferedReader;
import java.io.FileReader;

public class CompoundMarkerData {

    private SingleMarkerData[] dataSets;
    public CompoundMarkerData(String[] files, int[][] rowInfo, int[][][] colInfo){
        dataSets = new SingleMarkerData[files.length];
        int[][][] data;
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++){
            data = new int[colInfo[typeIndex].length][][];
            for(int markerIndex = 0; markerIndex < colInfo[typeIndex].length; markerIndex++){
                data[markerIndex] = extractData(files[typeIndex],
                        colInfo[typeIndex][markerIndex][0],
                        colInfo[typeIndex][markerIndex][1],
                        rowInfo[typeIndex][0],
                        rowInfo[typeIndex][1]);
            }
            dataSets[typeIndex] = new SingleMarkerData(data);
        }


    }

    public CompoundMarkerData(String[] files, int[] rowInfo, int[][] colInfo){
        dataSets = new SingleMarkerData[files.length];
        int[][][] data;
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++){
            data = new int[colInfo[typeIndex].length][][];
            for(int markerIndex = 0; markerIndex < colInfo[typeIndex].length; markerIndex++){
                data[markerIndex] = extractData(files[typeIndex],
                        colInfo[markerIndex][0],
                        colInfo[markerIndex][1],
                        rowInfo[0],
                        rowInfo[1]);
            }
            dataSets[typeIndex] = new SingleMarkerData(data);
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

    public SingleMarkerData getData(int typeIndex){
        return dataSets[typeIndex];
    }

}
