package utils;

import state.SubTypeList;
import state.TypeListWithUnknown;

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

        int initialBF = initType;
        if(unknownPath != null &&initialBF == -1){
            Randomizer.nextInt(subTypeLists.length);
        }
        if(clustering == null) {
            for (int typeIndex = 0; typeIndex < subTypeLists.length; typeIndex++) {


                ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxRowClustCount];
                for (int setIndex = 0; setIndex < subtypeParts.length; setIndex++) {
                    subtypeParts[setIndex] = new ArrayList<>();

                }

                for (int obsIndex = 0; obsIndex < totalObsCounts[typeIndex]; obsIndex++) {
                    subtypeParts[0].add(obsIndex);
                }

                if (unknownPath != null && typeIndex == initialBF) {
                    subtypeParts[0].add(totalCount);
                }


                subTypeLists[typeIndex] = new SubTypeList(subtypeParts);

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

    public static TypeListWithUnknown createTypeList(int[] totalObsCounts,
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

        TypeListWithUnknown typeList = new TypeListWithUnknown(subTypeLists, totalCount);
        return typeList;

    }

}
