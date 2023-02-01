package state;

public class TypeListWithUnknown extends TypeList{
    public static final int TYPE_POS = 0;
    public static final int SUBTYPE_POS = 1;

    private int unknownObsCount;
    private int[][] unknownClusterMap;
    private int[][] storedUnknownClusterMap;
    private int unknownStartIndex;

    public TypeListWithUnknown(SubTypeList[] subTypeLists, int unknownStartIndex){
        super(subTypeLists);
        setup(unknownStartIndex);
    }

    public void setup(int unknownStartIndex){
        unknownObsCount = totalCount - unknownStartIndex;
        unknownClusterMap = new int[2][unknownObsCount];
        storedUnknownClusterMap = new int[unknownClusterMap.length][unknownObsCount];
        this.unknownStartIndex = unknownStartIndex;
        createMap();

    }

    private void createMap(){
        //System.out.println(unknownClusterMap.length);
        //System.out.println(unknownClusterMap[0].length);
        int obsNum;
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            for(int subTypeIndex = 0; subTypeIndex < typeList[typeIndex].getSubTypeMaxCount(); subTypeIndex++){
                for(int eltIndex = 0; eltIndex < typeList[typeIndex].getSubTypeSetSize(subTypeIndex); eltIndex++){
                    obsNum = getObs(typeIndex, subTypeIndex, eltIndex);
                    if(obsNum >= unknownStartIndex ){
                        unknownClusterMap[0][obsNum - unknownStartIndex] = typeIndex;
                        unknownClusterMap[1][obsNum - unknownStartIndex] = subTypeIndex;
                    }
                }
            }
        }
    }

    public int getUnknownObsCount(){
        return unknownObsCount;
    }

    public int getUnknownStartIndex(){
        return unknownStartIndex;
    }

    public int getUnknownObsTypeIndex(int obsIndex){
        return unknownClusterMap[TYPE_POS][obsIndex];
    }

    public int getUnknownObsSubTypeIndex(int obsIndex){
        return unknownClusterMap[SUBTYPE_POS][obsIndex];
    }

    public int getUnknownObsEltIndex(int obsIndex, int typeIndex, int subtypeIndex){
        return typeList[typeIndex].getPosInSubtype(obsIndex, subtypeIndex);
    }



    public void addObs(int typeIndex, int subtypeIndex, int obs){


        super.addObs(typeIndex, subtypeIndex, obs);


        //createMap();
        if(obs >= unknownStartIndex){
            unknownClusterMap[TYPE_POS][obs - unknownStartIndex] = typeIndex;
            unknownClusterMap[SUBTYPE_POS][obs - unknownStartIndex] = subtypeIndex;
        }else{
            //Very expensive
            createMap();
        }



    }

    public int removeObs(int typeIndex, int subtypeIndex, int eltIndex){

        int rmvObs = super.removeObs(typeIndex, subtypeIndex, eltIndex);

        //createMap();
        // This is not really necessary but it will help with debugging.
        if(rmvObs >= unknownStartIndex){
            unknownClusterMap[TYPE_POS][rmvObs - unknownStartIndex] = -1;
            unknownClusterMap[SUBTYPE_POS][rmvObs - unknownStartIndex] = -1;
        }else{
            createMap();
        }

        return rmvObs;

    }

    public TypeListWithUnknown copy(){
        SubTypeList[] typeListCopy = new SubTypeList[typeList.length];
        for(int typeIndex = 0; typeIndex < typeListCopy.length; typeIndex++){
            typeListCopy[typeIndex] = typeList[typeIndex].copy();
        }
        setup(unknownStartIndex);

        return new TypeListWithUnknown(typeListCopy, this.unknownStartIndex);

    }



    public void updateMap(){
        createMap();
    }

    public void store(){
        super.store();
        for(int infoIndex = 0; infoIndex < unknownClusterMap.length; infoIndex++){
            System.arraycopy(
                    unknownClusterMap[infoIndex],0,
                    storedUnknownClusterMap[infoIndex], 0,
                    unknownClusterMap[infoIndex].length);
        }



    }

    public void restore(){
        //System.out.println("restore");
        super.restore();
        int[][] temp = unknownClusterMap;
        unknownClusterMap = storedUnknownClusterMap;
        storedUnknownClusterMap = temp;
    }







}
