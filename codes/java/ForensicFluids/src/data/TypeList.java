package data;

import java.util.ArrayList;

public class TypeList {

    private ArrayList<Integer>[][] typeList;
    public TypeList(ArrayList<Integer>[][] typeList){
        this.typeList = typeList;
    }

    public int getTypeCount(){
        return typeList.length;
    }

    public int getSubTypeCount(int typeIndex){
        return typeList[typeIndex].length;
    }

    public int[] getSubTypeSetSizes(int typeIndex){
        int[] setSizes = new int[typeList[typeIndex].length];
        for(int subtypeIndex = 0; subtypeIndex < setSizes.length; subtypeIndex++){
            setSizes[subtypeIndex++] = typeList[typeIndex][subtypeIndex].size();
        }
        return setSizes;
    }

    public int getObs(int typeIndex, int subtypeIndex, int eltIndex){
        return typeList[typeIndex][subtypeIndex].get(eltIndex);
    }


}
