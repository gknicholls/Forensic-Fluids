package utils;

import data.SingleMarkerData;
import model.ClusterPrior;

import java.io.BufferedReader;
import java.io.FileReader;

public class DataUtils {

    public static final int SET5_SIZE = 5;
    public static final int SET7_SIZE = 7;
    public static final int SET5_PARTITION_COUNT = 52;
    public static final int SET7_PARTITION_COUNT = 877;
    public static final int MARKER_GROUP_COUNT = 5;


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

    public static int[][][][] getMkerGroupPartitions(String allPartSets5File,
                                                     String allPartSets7File){
        int[][][][] mkrGrpParts = new int[MARKER_GROUP_COUNT][][][];
        int[][][] allPartitionSets5 = getClusterArray(allPartSets5File, SET5_PARTITION_COUNT);
        int[][][] allPartitionSets7 = getClusterArray(allPartSets7File, SET7_PARTITION_COUNT);
        mkrGrpParts[0] = allPartitionSets5;
        mkrGrpParts[1] = allPartitionSets7;
        mkrGrpParts[2] = allPartitionSets5;
        mkrGrpParts[3] = allPartitionSets5;
        mkrGrpParts[4] = allPartitionSets5;

        return mkrGrpParts;

    }

    public static int[][][][] getMkerGroupPartitions(String allPartSets5File,
                                                     String allPartSets7File,
                                                     int set5Count,
                                                     int set7Count){
        int[][][][] mkrGrpParts = new int[MARKER_GROUP_COUNT][][][];
        int[][][] allPartitionSets5 = getClusterArray(allPartSets5File, set5Count);
        int[][][] allPartitionSets7 = getClusterArray(allPartSets7File, set7Count);
        mkrGrpParts[0] = allPartitionSets5;
        mkrGrpParts[1] = allPartitionSets7;
        mkrGrpParts[2] = allPartitionSets5;
        mkrGrpParts[3] = allPartitionSets5;
        mkrGrpParts[4] = allPartitionSets5;

        return mkrGrpParts;

    }

    private static int[][][] getClusterArray(String file, int lineCount){
        try{

            BufferedReader clustReader = new BufferedReader(new FileReader(file));
            String line = "";
            String[] clustStr;
            String[] obsInClust;
            int[][][] clusts = new int[lineCount][][];

            for(int lineIndex = 0; lineIndex < lineCount; lineIndex++){

                line = clustReader.readLine().trim();
                line = line.substring(1, line.length() - 1);

                if(line.contains("], [")){
                    clustStr = line.split("\\], \\[");
                }else{
                    clustStr = new String[]{line};
                }


                clusts[lineIndex] = new int[clustStr.length][];
                for(int clustIndex = 0; clustIndex < clustStr.length; clustIndex++){
                    obsInClust = clustStr[clustIndex].replaceAll("\\[|\\]", "").split(", ");

                    clusts[lineIndex][clustIndex] = new int[obsInClust.length];
                    for(int obsIndex = 0; obsIndex < obsInClust.length; obsIndex++){

                        clusts[lineIndex][clustIndex][obsIndex] = Integer.parseInt(obsInClust[obsIndex]);

                    }
                }
            }

            clustReader.close();

            return clusts;

        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }

    public static double[][] getColPriors(double alpha5,
                                          double alpha7,
                                          String allPartSets5File,
                                          String allPartSets7File){

        int[][][] partSet5 = getClusterArray(allPartSets5File, SET5_PARTITION_COUNT);
        double[] mdpProbSet5 = new double[SET5_PARTITION_COUNT];
        for (int partIndex = 0; partIndex < partSet5.length; partIndex++) {
            mdpProbSet5[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha5,
                    SET5_SIZE,
                    partSet5[partIndex],
                    SET5_SIZE);
        }

        int[][][] partSet7 = getClusterArray(allPartSets7File, SET7_PARTITION_COUNT);
        double[] mdpProbSet7 = new double[SET7_PARTITION_COUNT];
        for (int partIndex = 0; partIndex < partSet7.length; partIndex++) {
            mdpProbSet7[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha7,
                    SET7_SIZE,
                    partSet7[partIndex],
                    SET7_SIZE);
        }



        double[][] colPriors = new double[MARKER_GROUP_COUNT][];
        colPriors[0] = mdpProbSet5;
        colPriors[1] = mdpProbSet7;
        colPriors[2] = mdpProbSet5;
        colPriors[3] = mdpProbSet5;
        colPriors[4] = mdpProbSet5;

        return colPriors;
    }


    public static double[][] getColPriors(double alpha5,
                                          double alpha7,
                                          String allPartSets5File,
                                          String allPartSets7File,
                                          int partCount5,
                                          int partCount7){

        int[][][] partSet5 = getClusterArray(allPartSets5File, partCount5);
        double[] mdpProbSet5 = new double[partCount5];
        for (int partIndex = 0; partIndex < partSet5.length; partIndex++) {
            mdpProbSet5[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha5,
                    SET5_SIZE,
                    partSet5[partIndex],
                    SET5_SIZE);
        }

        int[][][] partSet7 = getClusterArray(allPartSets7File, partCount7);
        double[] mdpProbSet7 = new double[partCount7];
        for (int partIndex = 0; partIndex < partSet7.length; partIndex++) {
            mdpProbSet7[partIndex] = ClusterPrior.CalcMDPDensity(
                    alpha7,
                    SET7_SIZE,
                    partSet7[partIndex],
                    SET7_SIZE);
        }



        double[][] colPriors = new double[MARKER_GROUP_COUNT][];
        colPriors[0] = mdpProbSet5;
        colPriors[1] = mdpProbSet7;
        colPriors[2] = mdpProbSet5;
        colPriors[3] = mdpProbSet5;
        colPriors[4] = mdpProbSet5;

        return colPriors;
    }


}
