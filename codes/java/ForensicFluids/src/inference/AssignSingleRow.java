package inference;

import utils.MathUtils;

import java.util.ArrayList;
import java.util.Random;



public class AssignSingleRow {

    public static double SingleRowMove(ArrayList<Integer>[] subtypesList){
        Random random = new Random();
        int setMaxCount = subtypesList.length;

        ArrayList<Integer> currNonEmptySet = new ArrayList<>();
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
        double logHR = Math.log( currNonEmptySet.size() * currSetSize) /
                (propNonEmptySet.size() * subtypesList[propSetIndex].size());

        return logHR;
    }




    /*public static double proposal(ArrayList<Integer>[] subtypeList, int obsCount, int setMaxCount){
        double hr = 0.0;

        int[] currCumSum = getCumSum(subtypeList);

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
