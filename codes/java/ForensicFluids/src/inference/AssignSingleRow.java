package inference;

import cluster.SubTypeList;
import utils.Randomizer;

import java.util.ArrayList;


public class AssignSingleRow {


    public static double SingleRowMove(SubTypeList subtypesList){

        int setMaxCount = subtypesList.getSubTypeMaxCount();
        if(setMaxCount < 2){
            return Double.NEGATIVE_INFINITY;
        }

        /*for(int setIndex = 0; setIndex < subtypesList.length; setIndex++){
            if(subtypesList[setIndex].size()==0){
                System.out.print("(none)");
            }
            for(int eltIndex = 0; eltIndex < subtypesList[setIndex].size(); eltIndex++){
                System.out.print(subtypesList[setIndex].get(eltIndex)+" ");
            }
            System.out.println();
        }*/

        ArrayList<Integer> currNonEmptySet = new ArrayList<>();
        ArrayList<Integer> propNonEmptySet = new ArrayList<>();
        ArrayList<Integer> currEmptySet = new ArrayList<>();
        int[] currSetSizes = subtypesList.getSubTypeSetSizes();
        for(int setIndex = 0; setIndex < setMaxCount; setIndex++){
            if(currSetSizes[setIndex] > 0){
                currNonEmptySet.add(setIndex);
                propNonEmptySet.add(setIndex);
            }else{
                currEmptySet.add(setIndex);
            }
        }

        // Randomly select a non-empty cluster
        int currNonEmptySetIndex = Randomizer.nextInt(currNonEmptySet.size());
        int currSetIndex = currNonEmptySet.get(currNonEmptySetIndex);

        // Randomly select a row in the selected non-empty cluster
        int currSetSize = currSetSizes[currSetIndex];
        int currSetEltIndex = Randomizer.nextInt(currSetSize);
        //System.out.println(currSetSize+" "+currSetEltIndex);
        // Move the row

        int propClustOption;
        int propSetIndex;
        boolean singleBefore, singleAfter;
        boolean reachedMax = false;
        if(currNonEmptySet.size() == subtypesList.getSubTypeMaxCount()){
            reachedMax = true;
        }
        if(currSetSize > 1 && !reachedMax ){
            singleBefore = false;

            // Randomly select a cluster for the selected row to go into.


            propClustOption = Randomizer.nextInt(currNonEmptySet.size());
            if(propClustOption > 0 ){
                singleAfter = false;
                propClustOption = propClustOption - 1; // possible values of propClustOption are 0 ... K - 2
                propClustOption = propClustOption < currNonEmptySetIndex? propClustOption : propClustOption + 1;
                // If currNonEmptySetIndex = k, and propClustOption < k, then propClustOption can be one of 0 ... k - 1.
                // But propClustOption >= k, then propClustOption increments by 1,  can be one of k + 1 ... K - 1.
                propSetIndex = currNonEmptySet.get(propClustOption);
            }else{
                singleAfter = true;
                propSetIndex = currEmptySet.get(0);
            }

            //subtypesList[propSetIndex].add(obs);

        }else{

            propClustOption = Randomizer.nextInt(currNonEmptySet.size() - 1); // possible values are 0 ... K - 2.
            propClustOption = propClustOption < currNonEmptySetIndex? propClustOption : propClustOption + 1;
            // If currNonEmptySetIndex = k, and propClustOption < k, then propClustOption can be one of 0 ... k - 1.
            // But propClustOption >= k, then propClustOption increments by 1,  can be one of k + 1 ... K - 1.
            propSetIndex = currNonEmptySet.get(propClustOption);
            //subtypesList[propSetIndex].add(obs);

            if(currSetSize==1){
                singleBefore = true;
                singleAfter = false;
            }else{
                singleBefore = false;
                singleAfter = false;
            }
        }
        //int obs = subtypesList[currSetIndex].remove(currSetEltIndex);
        int obs = subtypesList.removeObs(currSetIndex, currSetEltIndex);
        subtypesList.addObs(propSetIndex, obs);



        // The non-empty clusters after the proposal
        //if(subtypesList[currSetIndex].size() == 0){
        if(subtypesList.getSubTypeSetSize(currSetIndex) == 0){
            propNonEmptySet.remove(currNonEmptySetIndex);
        }
        //if(subtypesList[propSetIndex].size() == 1){
        if(subtypesList.getSubTypeSetSize(propSetIndex) == 1){
            propNonEmptySet.add(propSetIndex);
        }

        double logFwd = -Math.log(currNonEmptySet.size()) - Math.log(currSetSize);
        //q(theta*|theta) theta* is the proposed state
        // 1/(#existing non-empty clusters) * 1/(# elements in the cluster)
        //double logBwd = -Math.log(propNonEmptySet.size()) - Math.log(subtypesList[propSetIndex].size());
        double logBwd = -Math.log(propNonEmptySet.size()) - Math.log(subtypesList.getSubTypeSetSize(propSetIndex));
        //q(theta|theta*)
        // 1/(# non-empty clusters after proposal) * 1/(# elements in the proposed cluster)
        if(singleBefore) { // picked row is singleton
            logFwd -= Math.log(currNonEmptySet.size() - 1.0);
            // 1/(#existing other (non-empty) clusters, i.e., K - 1)
            // rows cannot arrive in its original set,
            // and a singleton cannot go into an empty cluster.
            logBwd -= Math.log(propNonEmptySet.size());
            // 1/(#existing other clusters + an empty set)
            // #existing other clusters + an empty set --> K' - 1 + 1
        }else if(reachedMax){
            logFwd -= Math.log(currNonEmptySet.size() - 1.0);
            logBwd -= Math.log(propNonEmptySet.size() - 1.0);

        }else if(singleAfter){ // picked row is not a singleton
            logFwd  -= Math.log(currNonEmptySet.size());
            // the row can go into one of the K - 1 non-empty set or a empty set
            // 1/K
            logBwd  -= Math.log(propNonEmptySet.size() - 1.0);
            //
        }else{
            logFwd  -= Math.log(currNonEmptySet.size());
            // the row can go into one of the K - 1 non-empty set or a empty set, i.e., K - 1 + 1
            logBwd  -= Math.log(propNonEmptySet.size());
            // the row can go into one of the K' - 1 non-empty set or a empty set, i.e., K' - 1 + 1

        }

        return logBwd - logFwd;
    }

}
