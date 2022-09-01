package inference;

import state.TypeListWithUnknown;
import utils.Randomizer;

import java.util.ArrayList;

public class AssignBetweenTypes implements ProposalMove{

    private ArrayList<Integer> propTypeNonEmptySets;
    private ArrayList<Integer> propTypeEmptySets;

    private TypeListWithUnknown typeList;

    public AssignBetweenTypes(TypeListWithUnknown typeList){
        this.typeList = typeList;
    }


    public double proposal(){
        // Randomly select an unknown fluid sample
        int unknownObsIndex = Randomizer.nextInt(typeList.getUnknownObsCount());
        // Retrieve the classification information on this sample.
        int currTypeIndex = typeList.getUnknownObsTypeIndex(unknownObsIndex);
        int currSubTypeIndex = typeList.getUnknownObsSubTypeIndex(unknownObsIndex);
        int currEltIndex = typeList.getUnknownObsEltIndex(
                unknownObsIndex + typeList.getUnknownStartIndex(),
                currTypeIndex, currSubTypeIndex);
        //System.out.println(unknownObsIndex+": "+currTypeIndex+" "+currSubTypeIndex+" "+currEltIndex);


        //System.out.println("unknown obs: "+ typeList.getObs(currTypeIndex, currSubTypeIndex, currEltIndex)+" "+
        //        currTypeIndex +" "+ currSubTypeIndex+" "+ currEltIndex);

        int currTypeSubtypeCount = typeList.getNonSubTypesCount(currTypeIndex);

        boolean isSingleton = checkSingleton(currTypeIndex, currSubTypeIndex);




        // Select a different fluid type to the current, to which the chosen unknown is assigned.
        int propTypeOption = Randomizer.nextInt(typeList.getTypeCount() - 1);
        // Ensure that it is not the current type.
        int propTypeIndex = propTypeOption < currTypeIndex ? propTypeOption : propTypeOption + 1;

        calcNonEmptySets(typeList, currTypeIndex);
        calcNonEmptySets(typeList, propTypeIndex);


        int propSubtypeOption, propSubtypeIndex;
        // If the maximum number of subtype is reached
        boolean isMaxSubtypeCount = propTypeNonEmptySets.size() == typeList.getMaxSubTypeCount(currTypeIndex);
        if(isMaxSubtypeCount){
            //Randomly and uniformly select any of the existing subtypes in the proposed type.
            propSubtypeOption = Randomizer.nextInt(propTypeNonEmptySets.size());
            //Get the subtype index
            propSubtypeIndex = propTypeNonEmptySets.get(propSubtypeOption);
        }else{ // If the maximum number of subtype is "not" reached
            // //Randomly and uniformly select from "the existing subtypes in the proposed type & empty cluster.".
            propSubtypeOption = Randomizer.nextInt(propTypeNonEmptySets.size() + 1);
            if(propSubtypeOption == 0){ // Selects the empty cluster
                // Takes the index of an empty cluster.
                propSubtypeIndex = propTypeEmptySets.get(0);
            }else{// Selects of the non-empty clusters
                // Takes the index of an non-empty cluster
                // (indexes of elements in currNonEmptySets is from 0 to  propSubtypeOption - 1).
                propSubtypeIndex = propTypeNonEmptySets.get(propSubtypeOption - 1);
            }

        }


        //System.out.println("unknown obs: "+ typeList.getObs(currTypeIndex, currSubTypeIndex, currEltIndex)+" "+
        //        currTypeIndex +" "+ currSubTypeIndex+" "+ currEltIndex);
        int obs = typeList.removeObs(currTypeIndex, currSubTypeIndex, currEltIndex);
        //System.out.println("unknown obs: "+obs);
        typeList.addObs(propTypeIndex, propSubtypeIndex, obs);

        /*
         * Keeping the code below for now to explain the simplied code below them.
         */
        /*
        // The two lines below cancel out!
        double fwd = 1.0/(typeList.getTypeCount() - 1.0);
        double bwd = 1.0/(typeList.getTypeCount() - 1.0);

        if(isMaxSubtypeCount){
            fwd *= 1.0/propTypeNonEmptySets.size();
            if(isSingleton){
                bwd *= 1.0/currTypeSubtypeCount;
            }else{
                bwd *= 1.0/currTypeSubtypeCount;
            }

        }else{
            fwd *= 1.0/(propTypeNonEmptySets.size() + 1.0);
            if(isSingleton){
                bwd *= 1.0/currTypeSubtypeCount;
            }else{
                bwd *= 1.0/(currTypeSubtypeCount + 1.0);
            }
        }

        double logq = Math.log(bwd) - Math.log(fwd);*/

        // log(q(theta*|theta)), log(q(theta|theta*))
        double fwd, bwd;

        if(isMaxSubtypeCount){
            //log(1.0/propTypeNonEmptySets.size());

            fwd = -Math.log(propTypeNonEmptySets.size());
            //log(1.0/currTypeSubtypeCount);
            bwd = -Math.log(currTypeSubtypeCount);
        }else{
            //log(1.0/(currTypeSubtypeCount + 1.0));
            fwd = -Math.log(propTypeNonEmptySets.size() + 1.0);
            //System.out.println(propTypeNonEmptySets.size() + 1.0);
            if(isSingleton){
                //log(1.0/currTypeSubtypeCount);
                bwd = -Math.log(currTypeSubtypeCount);
                //System.out.println(currTypeSubtypeCount);
            }else{
                //log(1.0/(currTypeSubtypeCount + 1.0));
                bwd = -Math.log(currTypeSubtypeCount + 1.0);
            }
        }

        // log(q(theta|theta*)) -  log(q(theta*|theta))
        return bwd - fwd;



    }

    private void calcNonEmptySets(TypeListWithUnknown typeList, int propTypeIndex){
        // Identify the empty and non empty sets in the chosen type.
        int[] subtypeSetSizes = typeList.getSubTypeSetSizes(propTypeIndex);
        propTypeNonEmptySets = new ArrayList<Integer>();
        propTypeEmptySets = new ArrayList<Integer>();
        for(int subtypeIndex = 0; subtypeIndex < subtypeSetSizes.length; subtypeIndex++){
            if(subtypeSetSizes[subtypeIndex] > 0){
                propTypeNonEmptySets.add(subtypeIndex);
            }else{
                propTypeEmptySets.add(subtypeIndex);
            }
        }

    }



    private boolean checkSingleton(int typeIndex, int subTypeIndex){
        if(typeList.getSubTypeSetSize(typeIndex, subTypeIndex) == 1){
            return true;
        }else if(typeList.getSubTypeSetSize(typeIndex, subTypeIndex) > 1){
            return false;
        }else{
            throw new RuntimeException("The current subtype of the unknown sample should have at least one sample.");
        }
    }

}
