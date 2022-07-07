package cluster;

import java.util.ArrayList;
import java.util.Collections;

public class SubTypeList implements State{
    private ArrayList<Integer>[] subtypeList;
    private ArrayList<Integer>[] storedSubtypeList;
    private boolean[] subtypeUpdated;
    private int totalObsCount;
    public SubTypeList(ArrayList<Integer>[] subtypeList){
        this.subtypeList = subtypeList;
        storedSubtypeList = (ArrayList<Integer>[]) new ArrayList[this.subtypeList.length];
        subtypeUpdated = new boolean[subtypeList.length];
        calcTotalObs();
        store();
    }

    private void calcTotalObs(){
        for(int setIndex = 0; setIndex < this.subtypeList.length; setIndex++){
            //System.out.println("setIndex: "+subtypeList[setIndex]);
            totalObsCount+= this.subtypeList[setIndex].size();
        }
    }

    public int getTotalObsCount(){
        return totalObsCount;
    }


    public int getSubTypeMaxCount(){
        return subtypeList.length;
    }

    public int getSubTypeCount(int subtypeIndex){
        return subtypeList[subtypeIndex].size();
    }

    public int getNonEmptySetCount(){
        int[] setSizes = getSubTypeSetSizes();
        int notEmptySetCount = 0;
        for(int setIndex = 0; setIndex < setSizes.length; setIndex++){
            notEmptySetCount++;
        }
        return notEmptySetCount;
    }

    public int[] getSubTypeSetSizes(){
        int[] setSizes = new int[subtypeList.length];
        for(int subtypeIndex = 0; subtypeIndex < setSizes.length; subtypeIndex++){
            setSizes[subtypeIndex] = subtypeList[subtypeIndex].size();
        }
        return setSizes;
    }

    public int getSubTypeSetSize(int subTypeIndex){

        return subtypeList[subTypeIndex].size();
    }

    public int getObs(int subtypeIndex, int eltIndex){
        return subtypeList[subtypeIndex].get(eltIndex);
    }

    public void addObs(int subtypeIndex, int obs){
        subtypeList[subtypeIndex].add(obs);
        /*System.out.print("update SubtypeList: ");
        for(int i = 0; i < subtypeList[subtypeIndex].size(); i++){
            System.out.print(subtypeList[subtypeIndex].get(i)+" ");
        }
        System.out.println();*/
        subtypeUpdated[subtypeIndex] = true;

    }

    public int removeObs(int subtypeIndex, int eltIndex){
        subtypeUpdated[subtypeIndex] = true;
        return subtypeList[subtypeIndex].remove(eltIndex);

    }

    public void store(){

        //System.out.println("SubtypeList store: ");
        for(int subtypeIndex = 0; subtypeIndex < storedSubtypeList.length; subtypeIndex++){
            storedSubtypeList[subtypeIndex] = new ArrayList<Integer>();

            for(int eltIndex = 0; eltIndex < subtypeList[subtypeIndex].size(); eltIndex++){
                storedSubtypeList[subtypeIndex].add(subtypeList[subtypeIndex].get(eltIndex));
                //System.out.print(subtypeList[subtypeIndex].get(eltIndex)+" ");

            }


        }
        //System.out.println();



    }

    public void restore(){

        ArrayList<Integer>[] temp = subtypeList;
        subtypeList = storedSubtypeList;
        storedSubtypeList = temp;

    }

    public String printCurrCluster(){
        return printCluster(subtypeList);
    }

    public String printStoredCluster(){
        return printCluster(storedSubtypeList);
    }

    public String log(){
        return printCluster(subtypeList);
    }

    public String logStored(){
        return printCluster(storedSubtypeList);
    }

    private String printCluster(ArrayList<Integer>[] subtypeList){

        String setStr;
        ArrayList<String> setStrList = new ArrayList<String> ();
        ArrayList<Integer> copy = new ArrayList<>();
        for(int subtypeIndex = 0; subtypeIndex < subtypeList.length; subtypeIndex++){

            if(subtypeList[subtypeIndex].size() > 0){
                /*if(!setsStr.equals("[")){
                    setsStr += ",";
                }*/

                setStr = "[";
                copy = new ArrayList<>();
                for(int i = 0; i < subtypeList[subtypeIndex].size(); i++){
                    copy.add(subtypeList[subtypeIndex].get(i));
                }
                //Collections.copy(copy, subtypeList[subtypeIndex]);
                Collections.sort(copy);
                for(int eltIndex = 0; eltIndex < copy.size(); eltIndex++){
                    setStr += copy.get(eltIndex);
                    if(eltIndex < (copy.size() - 1)){
                        setStr+=",";
                    }

                }
                setStr += "]";
                setStrList.add(setStr);
                //setsStr += setStr;

            }

        }

        Collections.sort(setStrList);
        String setsStr = "[";
        for(int setIndex = 0; setIndex < setStrList.size(); setIndex++){
            if(setIndex >0){
                setsStr+=",";
            }
            setsStr+=setStrList.get(setIndex);

        }

        setsStr += "]";

        return setsStr;

    }
}
