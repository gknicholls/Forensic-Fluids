package state;

import model.AbstractState;

import java.util.ArrayList;
import java.util.Collections;

public class SubTypeList extends AbstractState {
    private ArrayList<Integer>[] subtypeList;
    private ArrayList<Integer>[] storedSubtypeList;
    private boolean[] subtypeUpdated;
    private int totalObsCount;
    private boolean isUpdated;

    public SubTypeList(String label, ArrayList<Integer>[] subtypeList){
        super(label);
        this.subtypeList = subtypeList;
        storedSubtypeList = (ArrayList<Integer>[]) new ArrayList[this.subtypeList.length];
        subtypeUpdated = new boolean[subtypeList.length];

        for(int i = 0; i < subtypeUpdated.length; i++){
            subtypeUpdated[i] = true;
        }

        calcTotalObs();

        for(int subtypeIndex = 0; subtypeIndex < storedSubtypeList.length; subtypeIndex++){
            storedSubtypeList[subtypeIndex] = new ArrayList<Integer>();

            for(int eltIndex = 0; eltIndex < subtypeList[subtypeIndex].size(); eltIndex++){
                storedSubtypeList[subtypeIndex].add(subtypeList[subtypeIndex].get(eltIndex));
                //System.out.print(subtypeList[subtypeIndex].get(eltIndex)+" ");

            }

        }
        isUpdated = true;
    }

    public SubTypeList copy(){
        ArrayList<Integer>[] subtypeListCopy = (ArrayList<Integer>[]) new ArrayList[this.subtypeList.length];
        for(int subtypeIndex = 0; subtypeIndex < subtypeListCopy.length; subtypeIndex++){
            subtypeListCopy[subtypeIndex] = new ArrayList<Integer>();

            for(int eltIndex = 0; eltIndex < subtypeList[subtypeIndex].size(); eltIndex++){
                subtypeListCopy[subtypeIndex].add(subtypeList[subtypeIndex].get(eltIndex));
            }

        }
        SubTypeList SubTypeListCopy = new SubTypeList(label+".copy", subtypeListCopy);
        return SubTypeListCopy;
    }

    public void copySet(int setIndex, SubTypeList desList){
        ArrayList<Integer> set = desList.getSet(setIndex);
        set.clear();
        int setSize = subtypeList[setIndex].size();
        if(setSize == 0){
            return;
        }
        for(int eltIndex = 0; eltIndex < setSize; eltIndex++){
            set.add(subtypeList[setIndex].get(eltIndex));
        }

    }

    private ArrayList<Integer> getSet(int setIndex){
        return subtypeList[setIndex];
    }


    public SubTypeList(ArrayList<Integer>[] subtypeList){
        this("subTypeList", subtypeList);
    }


    private void calcTotalObs(){
        totalObsCount = 0;
        for(int setIndex = 0; setIndex < this.subtypeList.length; setIndex++){
            //System.out.println("setIndex: "+subtypeList[setIndex]);
            totalObsCount+= this.subtypeList[setIndex].size();
        }
    }

    public int getTotalObsCount(){
        calcTotalObs();
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
            if(setSizes[setIndex] > 0.0){
                notEmptySetCount++;
            }

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

    public int getPosInSubtype(int obsIndex, int subtypeIndex){
        return subtypeList[subtypeIndex].indexOf(obsIndex);
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
        isUpdated = true;

    }

    public int removeObs(int subtypeIndex, int eltIndex){
        subtypeUpdated[subtypeIndex] = true;
        isUpdated = true;
        return subtypeList[subtypeIndex].remove(eltIndex);

    }

    public boolean isUpdated(int index){
        return subtypeUpdated[index];
    }

    public boolean isUpdated(){
        return isUpdated;
    }

    public void store(){
        isUpdated = false;
        for(int subtypeIndex = 0; subtypeIndex < subtypeUpdated.length; subtypeIndex++){
            subtypeUpdated[subtypeIndex] = false;
        }

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
