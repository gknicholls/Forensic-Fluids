package inference;

import data.TypeList;
import data.TypeListWithUnknown;
import utils.Randomizer;

import java.util.ArrayList;

public class AssignBetweenTypes {

    public static double betweenTypesMove(TypeListWithUnknown typeList){
        int unknownObsIndex = Randomizer.nextInt(typeList.getUnknownObsCount());
        int typeIndex = typeList.getUnknownObsTypeIndex(unknownObsIndex);
        int subTypeIndex = typeList.getUnknownObsSubTypeIndex(unknownObsIndex);
        int eltIndex = typeList.getUnknownObsEltIndex(unknownObsIndex);
        //int obs = typeList.getObs(typeIndex, subTypeIndex, eltIndex);

        int propTypeOption = Randomizer.nextInt(typeList.getTypeCount() - 1);
        int propTypeIndex = propTypeOption < typeIndex ? propTypeOption : propTypeOption + 1;
        int[] subtypeSetSizes = typeList.getSubTypeSetSizes(propTypeIndex);
        ArrayList<Integer> currNonEmptySets = new ArrayList<Integer>();
        ArrayList<Integer> currEmptySets = new ArrayList<Integer>();
        for(int subtypeIndex = 0; subTypeIndex < subtypeSetSizes.length; subTypeIndex++){
            if(subtypeSetSizes[subTypeIndex] > 0){
                currNonEmptySets.add(subtypeIndex);
            }else{
                currEmptySets.add(subTypeIndex);
            }
        }

        int propSubtypeOption, propSubtypeIndex;
        if(currNonEmptySets.size()==typeList.getMaxSubTypeCount(typeIndex)){
            propSubtypeOption = Randomizer.nextInt(currNonEmptySets.size());
            propSubtypeIndex = currNonEmptySets.get(propSubtypeOption);
        }else{
            propSubtypeOption = Randomizer.nextInt(currNonEmptySets.size() + 1);
            if(propSubtypeOption == 0){
                propSubtypeIndex = currEmptySets.get(0);
            }else{
                propSubtypeIndex = currNonEmptySets.get(propSubtypeOption - 1);
            }

        }

        int obs = typeList.removeObs(propTypeIndex, propSubtypeIndex, eltIndex);
        typeList.addObs(propTypeIndex, propSubtypeIndex, obs);

        //TO-DO hastings ratios


        return 0.0;



    }
}
