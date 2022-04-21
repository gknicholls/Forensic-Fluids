package inference;

import utils.MathUtils;

import java.util.ArrayList;
import java.util.Random;



public class AssignSingleRow {
    public static double proposal(ArrayList<Integer>[] subtypeList, int obsCount, int setMaxCount){
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
    }
}
