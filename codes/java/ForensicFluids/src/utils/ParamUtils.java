package utils;

import state.SubTypeList;
import state.TypeList;
import state.TypeListWithUnknown;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;

public class ParamUtils {
    public static TypeListWithUnknown createTypeList(int[] totalObsCounts,
                                               int maxRowClustCount,
                                               String clustering,
                                               String unknownPath,
                                               int initType){

        int totalCount = 0;
        SubTypeList[] subTypeLists = new SubTypeList[totalObsCounts.length];
        for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {
            totalCount += totalObsCounts[typeIndex];
        }


        int unknownCount = 0;
        try {

            BufferedReader unknownReader = new BufferedReader(new FileReader(unknownPath));
            String unknownLine = unknownReader.readLine();
            while ((unknownLine = unknownReader.readLine()) != null) {
                unknownCount++;
            }
        }catch(Exception e){
            new RuntimeException(e);
        }
        int[] initialBF = new int[unknownCount];
        if(unknownPath != null ){
            for(int unknownIndex = 0; unknownIndex < initialBF.length; unknownIndex++){
                initialBF[unknownIndex] = (initType > -1)? initType:Randomizer.nextInt(subTypeLists.length);
            }
        }
        //System.out.println("unknownCount1: " + unknownCount);

        if(clustering == null) {
            ArrayList<Integer>[][] subtypeParts = (ArrayList<Integer>[][]) new ArrayList[subTypeLists.length][maxRowClustCount];
            for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {



                for (int setIndex = 0; setIndex < subtypeParts.length; setIndex++) {
                    subtypeParts[typeIndex][setIndex] = new ArrayList<>();

                }

                for (int obsIndex = 0; obsIndex < totalObsCounts[typeIndex]; obsIndex++) {
                    subtypeParts[typeIndex][0].add(obsIndex);
                }



            }

            for(int unknownIndex = 0; unknownIndex < unknownCount; unknownIndex++){

                subtypeParts[initialBF[unknownIndex]][0].add(totalCount + unknownIndex);

            }

            for(int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++){
                subTypeLists[typeIndex] = new SubTypeList(subtypeParts[typeIndex]);
            }

        }else{
            String[] typeClustStr = clustering.split(" ");
            String currTypeClustStr;
            for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {

                // Create J sets within each type, where J maxRowClustCount.
                ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxRowClustCount];
                for (int setIndex = 0; setIndex < subtypeParts.length; setIndex++) {
                    subtypeParts[setIndex] = new ArrayList<>();

                }

                currTypeClustStr = typeClustStr[typeIndex].substring(1, typeClustStr[typeIndex].length() - 1).replace("],[", "], [");
                //System.out.println("setsStr: "+ currTypeClustStr);
                String [] setsStr = currTypeClustStr.split(", ");


                String[] obsSetStr;
                //System.out.println("setsStr size: "+setsStr.length);
                for (int setIndex = 0; setIndex < setsStr.length; setIndex++) {
                    //System.out.println("obsSetStr: "+ setsStr[setIndex].substring(1, setsStr[setIndex].length() - 1));

                    obsSetStr = setsStr[setIndex].substring(1, setsStr[setIndex].length() - 1).split(",");

                    for(int obsIndex  = 0; obsIndex < obsSetStr.length; obsIndex++){
                        subtypeParts[setIndex].add(Integer.parseInt(obsSetStr[obsIndex]));
                    }

                }

                subTypeLists[typeIndex] = new SubTypeList(subtypeParts);

            }

        }




        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, totalCount);
        return typeList;
    }

    public static TypeList createTypeList(int[] totalObsCounts,
                                          int maxRowClustCount,
                                          String clustering){

        int totalCount = 0;
        SubTypeList[] subTypeLists = new SubTypeList[totalObsCounts.length];
        for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {
            totalCount += totalObsCounts[typeIndex];
        }

        String[] typeClustStr = clustering.split(" ");
        String currTypeClustStr;
        for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {

            // Create J sets within each type, where J maxRowClustCount.
            ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxRowClustCount];
            for (int setIndex = 0; setIndex < subtypeParts.length; setIndex++) {
                subtypeParts[setIndex] = new ArrayList<>();

            }

            currTypeClustStr = typeClustStr[typeIndex].substring(1, typeClustStr[typeIndex].length() - 1).replace("],[", "], [");
            //System.out.println("setsStr: "+ currTypeClustStr);
            String [] setsStr = currTypeClustStr.split(", ");


            String[] obsSetStr;
            //System.out.println("setsStr size: "+setsStr.length);
            for (int setIndex = 0; setIndex < setsStr.length; setIndex++) {
                //System.out.println("obsSetStr: "+ setsStr[setIndex].substring(1, setsStr[setIndex].length() - 1));

                obsSetStr = setsStr[setIndex].substring(1, setsStr[setIndex].length() - 1).split(",");

                for(int obsIndex  = 0; obsIndex < obsSetStr.length; obsIndex++){
                    subtypeParts[setIndex].add(Integer.parseInt(obsSetStr[obsIndex]));
                }

            }

            subTypeLists[typeIndex] = new SubTypeList(subtypeParts);

        }

        TypeList typeList = new TypeList(subTypeLists);
        return typeList;

    }

}
