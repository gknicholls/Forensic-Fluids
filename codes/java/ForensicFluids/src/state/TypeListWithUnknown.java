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
        unknownObsCount = totalCount - unknownStartIndex;
        unknownClusterMap = new int[2][unknownObsCount];
        storedUnknownClusterMap = new int[unknownClusterMap.length][unknownObsCount];
        this.unknownStartIndex = unknownStartIndex;
        createMap();

        /*for(int typeIndex1 = 0; typeIndex1 < typeList.length; typeIndex1++){

            for(int subtypeIndex1 = 0; subtypeIndex1 < typeList[typeIndex1].getSubTypeMaxCount(); subtypeIndex1++) {
                if(typeList[typeIndex1].getSubTypeCount(subtypeIndex1) > 0){
                    for (int eltIndex1 = 0; eltIndex1 < typeList[typeIndex1].getSubTypeSetSize(subtypeIndex1); eltIndex1++) {

                        System.out.print(typeList[typeIndex1].getObs(subtypeIndex1, eltIndex1) + " ");


                    }

                }
            }
            System.out.println(" a");
        }
        System.out.println("end");*/



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
        /*for(int typeIndex1 = 0; typeIndex1 < typeList.length; typeIndex1++){

                for(int subTypeIndex = 0; subTypeIndex < typeList[typeIndex1].getSubTypeMaxCount(); subTypeIndex++) {
                    if(typeList[typeIndex1].getSubTypeCount(subTypeIndex) > 0){
                        System.out.println("length: "+typeList[typeIndex1].getSubTypeSetSize(subTypeIndex));
                    for (int eltIndex1 = 0; eltIndex1 < typeList[typeIndex1].getSubTypeSetSize(subTypeIndex); eltIndex1++) {

                        System.out.print(typeList[typeIndex1].getObs(subTypeIndex, eltIndex1) + " ");


                    }

                }
            }
            System.out.println(" a");
        }
        System.out.println("end");*/

        super.addObs(typeIndex, subtypeIndex, obs);


        //createMap();
        if(obs >= unknownStartIndex){
            unknownClusterMap[TYPE_POS][obs - unknownStartIndex] = typeIndex;
            unknownClusterMap[SUBTYPE_POS][obs - unknownStartIndex] = subtypeIndex;
        }else{
            //Very expensive
            createMap();
        }

        /*System.out.println("map: "+unknownClusterMap[TYPE_POS][obs - unknownStartIndex]+" "+
                unknownClusterMap[SUBTYPE_POS][obs - unknownStartIndex]+" "+
                unknownClusterMap[ELT_POS][obs - unknownStartIndex] );*/


    }

    public int removeObs(int typeIndex, int subtypeIndex, int eltIndex){
        /*for(int typeIndex1 = 0; typeIndex1 < typeList.length; typeIndex1++){

            for(int subtypeIndex1 = 0; subtypeIndex1 < typeList[typeIndex1].getSubTypeMaxCount(); subtypeIndex1++) {
                if(typeList[typeIndex1].getSubTypeCount(subtypeIndex1) > 0){
                    System.out.println("length: "+typeList[typeIndex1].getSubTypeSetSize(subtypeIndex1));
                    for (int eltIndex1 = 0; eltIndex1 < typeList[typeIndex1].getSubTypeSetSize(subtypeIndex1); eltIndex1++) {

                        System.out.print(typeList[typeIndex1].getObs(subtypeIndex1, eltIndex1) + " ");


                    }
                    System.out.println();

                }
            }
            System.out.println(" a");
        }
        System.out.println("end");*/
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

        /*rint("stored: ");
        for(int infoIndex = 0; infoIndex < unknownClusterMap.length; infoIndex++){
            for(int obsIndex = 0; obsIndex < storedUnknownClusterMap[infoIndex].length; obsIndex++){
                System.out.print(storedUnknownClusterMap[infoIndex][obsIndex]+" ");
            }

        }

        System.out.println();

        if(typeList[0].getSubTypeCount(0)>0){
            System.out.println("000: "+getObs(0, 0,0));
        }*/


    }

    public void restore(){
        //System.out.println("restore");
        super.restore();
        int[][] temp = unknownClusterMap;
        unknownClusterMap = storedUnknownClusterMap;
        storedUnknownClusterMap = temp;
    }







}
