package state;

import model.AbstractState;

public class TypeList extends AbstractState {

    protected SubTypeList[] typeList;
    protected boolean[] typeUpdated;
    protected int totalCount;
    public TypeList(String label, SubTypeList[] typeList){
        super(label);
        this.typeList = typeList;
        calcTotalCount();

        typeUpdated = new boolean[typeList.length];
        for(int typeIndex = 0; typeIndex < typeUpdated.length; typeIndex++){
            typeUpdated[typeIndex] = true;
        }
    }

    public TypeList(SubTypeList[] typeList){
        this("typeList", typeList);
    }

    public TypeList copy(){
        SubTypeList[] typeListCopy = new SubTypeList[typeList.length];
        for(int typeIndex = 0; typeIndex < typeListCopy.length; typeIndex++){
            typeListCopy[typeIndex] = typeList[typeIndex].copy();
        }

        return new TypeList(label+".copy", typeListCopy);

    }


    public void copyLists(TypeList desTypeList){
        int setCount;
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            setCount = typeList[typeIndex].getSubTypeMaxCount();
            for(int setIndex = 0; setIndex < setCount; setIndex++){
                typeList[typeIndex].copySet(setIndex, desTypeList.getSubTypeList(typeIndex));
            }

        }
    }


    public int getTypeCount(){
        return typeList.length;
    }

    public int getMaxSubTypeCount(int typeIndex){
        return typeList[typeIndex].getSubTypeMaxCount();
    }

    public int getNonSubTypesCount(int typeIndex){
        return typeList[typeIndex].getNonEmptySetCount();
    }

    public void calcTotalCount(){
        totalCount = 0;
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            totalCount += typeList[typeIndex].getTotalObsCount();
        }
    }

    public int getTotalCount(int typeIndex){
        return typeList[typeIndex].getTotalObsCount();
    }

    public int getTotalCount(){
        return totalCount;
    }

    public int[] getSubTypeSetSizes(int typeIndex){
        int[] setSizes = typeList[typeIndex].getSubTypeSetSizes();
        return setSizes;
    }

    public int getSubTypeSetSize(int typeIndex, int subTypeIndex){
        int setSize = typeList[typeIndex].getSubTypeCount(subTypeIndex);
        return setSize;
    }

    public SubTypeList getSubTypeList(int typeIndex){
        return typeList[typeIndex];
    }

    public int getObs(int typeIndex, int subtypeIndex, int eltIndex){
        return typeList[typeIndex].getObs(subtypeIndex, eltIndex);
    }

    public void setTypeUpdate(int typeIndex){
        typeUpdated[typeIndex] = true;
    }

    public void addObs(int typeIndex, int subtypeIndex, int obs){
        //System.out.println("add: "+typeIndex);
        typeList[typeIndex].addObs(subtypeIndex, obs);
        typeUpdated[typeIndex] = true;

    }

    public int removeObs(int typeIndex, int subtypeIndex, int eltIndex){

        //System.out.println("remove: "+typeIndex);
        typeUpdated[typeIndex] = true;
        return typeList[typeIndex].removeObs(subtypeIndex, eltIndex);

    }

    public boolean hasUpdated(int typeIndex){
        //System.out.println(typeIndex+" "+typeUpdated[typeIndex]);
        return typeUpdated[typeIndex];
    }



    public String log(){
        String logStr = "";
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            if(typeIndex > 0){
                logStr += " ";
            }

            logStr += typeList[typeIndex].log();

        }
        return logStr;
    }

    public String logStored(){
        String logStr = "";
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            if(typeIndex > 0){
                logStr += " ";
            }

            logStr += typeList[typeIndex].logStored();

        }
        return logStr;
    }

    public void store(){
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            typeList[typeIndex].store();
            typeUpdated[typeIndex] = false;
        }
    }


    public void restore(){

        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            typeList[typeIndex].restore();

        }

    }


}
