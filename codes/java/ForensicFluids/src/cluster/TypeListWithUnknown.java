package cluster;

public class TypeListWithUnknown extends TypeList{
    public static final int TYPE_POS = 0;
    public static final int SUBTYPE_POS = 1;
    public static final int ELT_POS = 2;

    private int unknownObsCount;
    private int[][] unknownClusterMap;
    private int[][] storedUnknownClusterMap;
    private int unknownStartIndex;
    public TypeListWithUnknown(SubTypeList[] subTypeLists, int unknownStartIndex){
        super(subTypeLists);
        unknownObsCount = totalCount - unknownStartIndex - 1;
        unknownClusterMap = new int[unknownObsCount][2];
        this.unknownStartIndex = unknownStartIndex;
        createMap();

    }

    private void createMap(){
        int obsNum;
        for(int typeIndex = 0; typeIndex < typeList.length; typeIndex++){
            for(int subTypeIndex = 0; subTypeIndex < typeList[typeIndex].getSubTypeMaxCount(); subTypeIndex++){
                for(int eltIndex = 0; eltIndex < typeList[typeIndex].getSubTypeSetSize(subTypeIndex); eltIndex++){
                    obsNum = getObs(typeIndex, subTypeIndex, eltIndex);
                    if(obsNum >= unknownStartIndex ){
                        unknownClusterMap[0][obsNum - unknownStartIndex] = typeIndex;
                        unknownClusterMap[1][obsNum - unknownStartIndex] = subTypeIndex;
                        unknownClusterMap[2][obsNum - unknownStartIndex] = eltIndex;
                    }
                }
            }
        }
    }

    public int getUnknownObsCount(){
        return unknownObsCount;
    }

    public int getUnknownObsTypeIndex(int obsIndex){
        return unknownClusterMap[TYPE_POS][obsIndex];
    }

    public int getUnknownObsSubTypeIndex(int obsIndex){
        return unknownClusterMap[SUBTYPE_POS][obsIndex];
    }

    public int getUnknownObsEltIndex(int obsIndex){
        return unknownClusterMap[ELT_POS][obsIndex];
    }

    public void addObs(int typeIndex, int subtypeIndex, int obs){
        super.addObs(typeIndex, subtypeIndex, obs);
        if(obs >= unknownStartIndex){
            unknownClusterMap[TYPE_POS][obs - unknownStartIndex] = typeIndex;
            unknownClusterMap[SUBTYPE_POS][obs - unknownStartIndex] = subtypeIndex;
            unknownClusterMap[ELT_POS][obs - unknownStartIndex] = typeList[typeIndex].getSubTypeSetSize(subtypeIndex) - 1;
        }


    }

    public int removeObs(int typeIndex, int subtypeIndex, int eltIndex){
        int rmvObs = super.removeObs(typeIndex, subtypeIndex, eltIndex);

        // This is not really necessary but it will help with debugging.
        if(rmvObs >= unknownStartIndex){
            unknownClusterMap[TYPE_POS][rmvObs - unknownStartIndex] = -1;
            unknownClusterMap[SUBTYPE_POS][rmvObs - unknownStartIndex] = -1;
            unknownClusterMap[ELT_POS][rmvObs - unknownStartIndex] = -1;
        }

        return rmvObs;

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
        super.restore();
        int[][] temp = unknownClusterMap;
        unknownClusterMap = storedUnknownClusterMap;
        storedUnknownClusterMap = temp;
    }







}
