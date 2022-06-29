package inference;

import utils.MathUtils;
import utils.Randomizer;

import java.util.ArrayList;

public class RandomPartitionMove {
    public static double randomPartition(ArrayList<Integer>[] subtypesList){
        ArrayList<Integer>[][] allParts = MathUtils.getCluster("/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt", 52);
        int propPartIndex = Randomizer.nextInt(allParts.length);

        for(int setIndex = 0; setIndex < allParts[propPartIndex].length; setIndex++){
            subtypesList[setIndex] = new ArrayList<>();
            for(int eltIndex = 0; eltIndex < allParts[propPartIndex][setIndex].size(); eltIndex++ ){
                subtypesList[setIndex].add(allParts[propPartIndex][setIndex].get(eltIndex));
            }
        }

        for(int setIndex = allParts[propPartIndex].length; setIndex < subtypesList.length; setIndex++){
            subtypesList[setIndex] = new ArrayList<>();
        }




        return 0.0;
    }
}
