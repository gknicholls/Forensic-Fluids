package inference;

import utils.MathUtils;

import java.util.ArrayList;
import java.util.Random;



public class AssignSingleRow {


    public static double SingleRowMove(ArrayList<Integer>[] subtypesList){
        Random random = new Random();
        int setMaxCount = subtypesList.length;
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
        for(int setIndex = 0; setIndex < setMaxCount; setIndex++){
            int currSetSize = subtypesList[setIndex].size();
            if(currSetSize > 0){
                currNonEmptySet.add(setIndex);
                propNonEmptySet.add(setIndex);
            }else{
                currEmptySet.add(setIndex);
            }
        }

        // Randomly select a non-empty cluster
        int currNonEmptySetIndex = random.nextInt(currNonEmptySet.size());
        int currSetIndex = currNonEmptySet.get(currNonEmptySetIndex);

        // Randomly select a row in the selected non-empty cluster
        int currSetSize = subtypesList[currSetIndex].size();
        int currSetEltIndex = random.nextInt(currSetSize);
        //System.out.println(currSetSize+" "+currSetEltIndex);
        // Move the row

        int propClustOption;
        int propSetIndex;
        boolean singleBefore, singleAfter;
        boolean reachedMax = false;
        if(currNonEmptySet.size() == subtypesList.length){
            reachedMax = true;
        }
        if(currSetSize > 1 && !reachedMax ){
            singleBefore = false;

            // Randomly select a cluster for the selected row to go into.


            propClustOption = random.nextInt(currNonEmptySet.size());
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

            propClustOption = random.nextInt(currNonEmptySet.size() - 1); // possible values are 0 ... K - 2.
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
        int obs = subtypesList[currSetIndex].remove(currSetEltIndex);
        subtypesList[propSetIndex].add(obs);



        // The non-empty clusters after the proposal
        if(subtypesList[currSetIndex].size() == 0){
            propNonEmptySet.remove(currNonEmptySetIndex);
        }
        if(subtypesList[propSetIndex].size() == 1){
            propNonEmptySet.add(propSetIndex);
        }

        double logFwd = -Math.log(currNonEmptySet.size()) - Math.log(currSetSize);
        //q(theta*|theta) theta* is the proposed state
        // 1/(#existing non-empty clusters) * 1/(# elements in the cluster)
        double logBwd = -Math.log(propNonEmptySet.size()) - Math.log(subtypesList[propSetIndex].size());
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


    /*public static double SingleRowMove(ArrayList<Integer>[] subtypesList){
        Random random = new Random();
        int setMaxCount = subtypesList.length;

        /*for(int setIndex = 0; setIndex < subtypesList.length; setIndex++){
            if(subtypesList[setIndex].size()==0){
                System.out.print("(none)");
            }
            for(int eltIndex = 0; eltIndex < subtypesList[setIndex].size(); eltIndex++){
                System.out.print(subtypesList[setIndex].get(eltIndex)+" ");
            }
            System.out.println();
        }*/

        /*ArrayList<Integer> currNonEmptySet = new ArrayList<>();
        ArrayList<Integer> propNonEmptySet = new ArrayList<>();
        for(int setIndex = 0; setIndex < setMaxCount; setIndex++){
            int currSetSize = subtypesList[setIndex].size();
            if(currSetSize > 0){
                currNonEmptySet.add(setIndex);
                propNonEmptySet.add(setIndex);
            }
        }

        // Randomly select a non-empty cluster
        int currNonEmptySetIndex = random.nextInt(currNonEmptySet.size());
        int currSetIndex = currNonEmptySet.get(currNonEmptySetIndex);

        // Randomly select a row in the selected non-empty cluster
        int currSetSize = subtypesList[currSetIndex].size();
        int currSetEltIndex = random.nextInt(currSetSize);
        //System.out.println(currSetSize+" "+currSetEltIndex);

        // Randomly select a cluster for the selected row to go into.
        int propSetIndex = random.nextInt(subtypesList.length - 1);
        // Avoids assigning into the same cluster where the row is from
        propSetIndex = propSetIndex < currSetIndex? propSetIndex : propSetIndex + 1;

        // Move the row
        int obs = subtypesList[currSetIndex].remove(currSetEltIndex);
        subtypesList[propSetIndex].add(obs);

        // The non-empty clusters after the proposal
        if(subtypesList[currSetIndex].size() == 0){
            propNonEmptySet.remove(currNonEmptySetIndex);
        }
        if(subtypesList[propSetIndex].size() == 1){
            propNonEmptySet.add(propSetIndex);
        }

        // Hastings ratio: Pr1/Pr2
        // Pr1 = Pr(move row i from proposed subtype k' to current subtype k)
        // Pr2 = Pr(move row i from current subtype k to proposed subtype k')
        // Let J be the max #subtypes allowed.
        // Pr1 = Pr(select row i|subtype k')Pr(subtype k')Pr(choose one of non-k' subtype)
        //     = (1/|k'|)(1/N'_ne)(1/(J-1)) where 1/N'_ne is the number of non-empty clusters after proposal
        // Pr2 = Pr(select row i|subtype k)Pr(subtype k)Pr(choose one of non-k subtype)
        //     = (1/|k|)(1/N_ne)(1/(J-1)) where 1/N_ne is the number of non-empty clusters before proposal
        double HR = ((double)currNonEmptySet.size() * (double)currSetSize) /
                ((double)propNonEmptySet.size() * (double)subtypesList[propSetIndex].size());
        double logHR = Math.log(HR);
        System.out.println(HR +" "+logHR);



        return logHR;
    }*/




    /*public static double SingleRowMove(ArrayList<Integer>[] subtypeList){
        double hr = 0.0;


        int[] currCumSum = getCumSum(subtypeList);
        int obsCount = currCumSum[currCumSum.length-1];
        int setMaxCount = obsCount;

        int currRowIndex = MathUtils.sample(0, obsCount - 1);
        int[] setInfo = getSetInfo(currRowIndex, currCumSum);
        int currSet = setInfo[0];
        int propSet = MathUtils.sample(0, setMaxCount - 1);
        int inClustIndex = setInfo[1];

        int obsID = subtypeList[currSet].get(inClustIndex);
        subtypeList[currSet].remove(inClustIndex);
        subtypeList[propSet].add(obsID);

        return hr;

    }

    private static int getSetIndex(int obsIndex, int[] cumSums){
        int set = 0;
        for(int setIndex = 0; setIndex < cumSums.length; setIndex++){
            if((obsIndex) < cumSums[setIndex]){
                set = setIndex;
                break;
            }
        }


        return set;

    }

    private static int[] getSetInfo(int obsIndex, int[] cumSums){
        int setIndex = getSetIndex(obsIndex, cumSums);
        int inSetIndex = obsIndex;

        if(setIndex > 0){
            inSetIndex = obsIndex + 1 - cumSums[setIndex - 1] - 1;
        }

        return new int[]{setIndex, inSetIndex};

    }



    private static int[] getSetSizes(ArrayList<Integer>[] subtypeList){
        int[] setSizes = new int[subtypeList.length];
        for(int setIndex = 0; setIndex < setSizes.length; setIndex++){
            setSizes[setIndex] = subtypeList[setIndex].size();
        }
        return setSizes;
    }

    private static int[] getCumSum(ArrayList<Integer>[] subtypeList){
        int[] setSizes = getSetSizes(subtypeList);
        int[] cumSum = new int[subtypeList.length];
        int prevCount = 0;
        for(int setIndex = 0; setIndex < setSizes.length; setIndex++){
            cumSum[setIndex] = prevCount + setSizes[setIndex];
            prevCount = cumSum[setIndex];
        }
        return cumSum;
    }*/
}
