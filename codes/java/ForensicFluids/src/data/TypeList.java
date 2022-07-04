package data;

import java.util.ArrayList;

public class TypeList {

    protected SubTypeList[] typeList;
    protected boolean[] typeUpdated;
    protected int totalCount;
    public TypeList(SubTypeList[] typeList){
        this.typeList = typeList;
        calcTotalCount();

        typeUpdated = new boolean[typeList.length];
    }

    public int getTypeCount(){
        return typeList.length;
    }

    public int getMaxSubTypeCount(int typeIndex){
        return typeList[typeIndex].getSubTypeMaxCount();
    }

    public void calcTotalCount(){
        totalCount = 0;
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            totalCount += typeList[typeIndex].getTotalObsCount();
        }
    }

    public int[] getSubTypeSetSizes(int typeIndex){
        int[] setSizes = typeList[typeIndex].getSubTypeSetSizes();
        return setSizes;
    }

    public int getSubtypeCount(int typeIndex){
        int setSize = typeList[typeIndex].getSubTypeCount();
        return setSize;
    }

    public SubTypeList getSubTypeList(int subtypeIndex){
        return typeList[subtypeIndex];
    }

    public int getObs(int typeIndex, int subtypeIndex, int eltIndex){
        return typeList[typeIndex].getObs(subtypeIndex, eltIndex);
    }

    public void addObs(int typeIndex, int subtypeIndex, int obs){
        typeList[typeIndex].addObs(subtypeIndex, obs);
        typeUpdated[typeIndex] = true;

    }

    public int removeObs(int typeIndex, int subtypeIndex, int eltIndex){
        typeUpdated[typeIndex] = true;
        return typeList[typeIndex].removeObs(subtypeIndex, eltIndex);

    }

    public void store(){
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            typeList[typeIndex].store();
        }




    }

    public void restore(){

        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            typeList[typeIndex].restore();
        }

    }


}
