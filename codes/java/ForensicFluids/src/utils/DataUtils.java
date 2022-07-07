package utils;

import data.SingleMarkerData;

import java.io.BufferedReader;
import java.io.FileReader;

public class DataUtils {

    public static int[][][][] extractDataAcrossTypes(String[] files, int[] rowInfo, int[][] colInfo){
        int[][][][] data = new int[files.length][][][];
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++) {
            data[typeIndex] = new int[colInfo[typeIndex].length][][];
            for (int markerIndex = 0; markerIndex < colInfo.length; markerIndex++) {
                data[typeIndex] = extractDataAcrossMarkers(files[typeIndex], rowInfo, colInfo);
            }
        }

        return data;
    }

    public static int[][][][] extractDataAcrossTypes(String[] files, int[][] rowInfo, int[][][] colInfo){
        int[][][][] data = new int[files.length][][][];
        for(int typeIndex = 0; typeIndex < files.length; typeIndex++) {
            data[typeIndex] = new int[colInfo[typeIndex].length][][];
            for (int markerIndex = 0; markerIndex < colInfo.length; markerIndex++) {
                data[typeIndex] = extractDataAcrossMarkers(files[typeIndex], rowInfo[typeIndex], colInfo[typeIndex]);
            }
        }

        return data;
    }

    public static int[][][] extractDataAcrossMarkers(String files, int[] rowInfo, int[][] colInfo){
        int[][][] data = new int[colInfo.length][][];
        for(int markerIndex = 0; markerIndex < colInfo.length; markerIndex++){
            data[markerIndex] = extractData(files,
                    colInfo[markerIndex][0],
                    colInfo[markerIndex][1],
                    rowInfo[0],
                    rowInfo[1]);
        }

        return data;
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


}
