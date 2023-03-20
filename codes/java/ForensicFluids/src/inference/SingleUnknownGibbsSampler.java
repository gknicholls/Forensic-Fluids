package inference;


import distribution.Multinomial;
import model.ClusterPrior;
import model.CompoundClusterLikelihood;
import state.SubTypeList;
import state.TypeList;
import state.TypeListWithUnknown;
import utils.Randomizer;

import java.util.ArrayList;

/**
 * Obtains the next subtype assignment of a floating by Gibbs sampling
 */
public class SingleUnknownGibbsSampler extends ProposalMove{
    private TypeListWithUnknown typeList;
    private TypeListWithUnknown typeListCopy;
    private CompoundClusterLikelihood likelihood;
    private CompoundClusterLikelihood likelihoodCopy;
    private double[] logMDPPriorValues;
    private double[] alphaValues;
    private int[][] currSetSizeLists;
    private int[][] propSetSizeLists;
    private double[][] propLogMDPPriorValues;
    private double[][] currLogSubtypeLikelihoodLists;
    private double[][] propLogSubtypeLikelihoodLists;
    private int totalSubtype;
    private double[][] logFullLikelihoods;
    private double[] logTypePrior;
    private int currType, propType;
    private int currSubtype, propSubtype;
    double[] fullConditonals;


    public SingleUnknownGibbsSampler(TypeListWithUnknown typeList,
                                     CompoundClusterLikelihood likelihood,
                                     Multinomial typePrior,
                                     double[] alphaValues){
        this.typeList = typeList;
        this.likelihood = likelihood;
        this.logMDPPriorValues = new double[typeList.getTypeCount()];
        this.alphaValues = alphaValues;
        logTypePrior = new double[typeList.getTypeCount()];
        typePrior.getLogProbs(logTypePrior);
        typeListCopy = this.typeList.copy();
        likelihoodCopy = setLikelihoodCopy(this.likelihood, typeListCopy);


        currSetSizeLists = new int[typeList.getTypeCount()][];
        propSetSizeLists = new int[typeList.getTypeCount()][];
        propLogMDPPriorValues = new double[typeList.getTypeCount()][];

        currLogSubtypeLikelihoodLists = initialiseListsBasedOnClusters(typeList);
        propLogSubtypeLikelihoodLists = initialiseListsBasedOnClusters(typeList);
        logFullLikelihoods = initialiseListsBasedOnClusters(typeList);


        totalSubtype = 0;
        for(int typeIndex = 0; typeIndex < typeList.getTypeCount(); typeIndex++){
            totalSubtype += typeList.getMaxSubTypeCount(typeIndex);
        }



    }



    public SingleUnknownGibbsSampler() {

    }

    public static CompoundClusterLikelihood setLikelihoodCopy(CompoundClusterLikelihood srcLik,
                                         TypeList typeList){
        CompoundClusterLikelihood desLik = new CompoundClusterLikelihood(srcLik.getLabel()+".copy");
        srcLik.shareMkrGrpParts(desLik);
        srcLik.shareColPriors(desLik);
        srcLik.shareData(desLik);
        srcLik.shareAlphaC(desLik);
        srcLik.shareBetaC(desLik);
        desLik.setTypeClusters(typeList);
        desLik.setUp();
        return desLik;
    }

    protected double[][] initialiseListsBasedOnClusters(TypeList typeList){
        double[][] logSubtypeLikLists = new double[typeList.getTypeCount()][];
        int maxSetCount;
        for(int typeIndex = 0; typeIndex < logSubtypeLikLists.length; typeIndex++){
            maxSetCount = typeList.getMaxSubTypeCount(typeIndex);
            logSubtypeLikLists[typeIndex] = new double[maxSetCount];
        }
        return logSubtypeLikLists;
    }

    public static void getCurrSetSizesAcrossType(int[][] setSizeLists, TypeList typeList){
        for(int typeIndex = 0; typeIndex < setSizeLists.length; typeIndex++){
            setSizeLists[typeIndex] = typeList.getSubTypeSetSizes(typeIndex);
        }
    }



    public static void getSetSizesForAllConfig(int[][] currSetSizeLists,
                                                  int[][] setSizeLists){

        ArrayList<Integer> currEmptySet;

        for(int typeIndex  = 0; typeIndex < currSetSizeLists.length; typeIndex++){

            // Create an array with length equal to the maximum subtypes allowed for that type.
            setSizeLists[typeIndex] = new int[currSetSizeLists[typeIndex].length];

            // Record which positions in the typeIndex-th array of currSetSizeLists is empty.
            currEmptySet = new ArrayList<>();

            // Go through each subtype (empty and non-empty) of fluid typeIndex in currSetSizeLists
            for(int setIndex = 0; setIndex < currSetSizeLists[typeIndex].length; setIndex++ ){

                if(currSetSizeLists[typeIndex][setIndex] > 0){
                    // If it is an existing subtype, then increment the size by 1.
                    setSizeLists[typeIndex][setIndex] =  currSetSizeLists[typeIndex][setIndex] + 1;
                }else{
                    // If it is empty, then store its position in the array list.
                    currEmptySet.add(setIndex);
                }

            }

            if(currEmptySet.size() > 0){
                // If the max number of subtype has not being reached for fluid typeIndex,
                // choose the first empty subtype position to create a singleton.
                setSizeLists[typeIndex][currEmptySet.get(0)] = 1;
            }
        }
    }

    public static double[][] calcLogMDPPriorForAllConfig(double[] alphaValues,
                                                          TypeList typeList,
                                                          int[][] currSetSizeLists,
                                                          int[][] propSetSizeLists,
                                                          double[][] logMDPPriors){
        int currSetSize;
        double newLogTypeMDP;
        int[] typeCounts = new int[typeList.getTypeCount()];
        for(int typeIndex = 0; typeIndex < currSetSizeLists.length; typeIndex++){
            typeCounts[typeIndex] = typeList.getTotalCount(typeIndex) + 1;
        }

        double[] logTypeMDPPriors = new double[typeList.getTypeCount()];

        int typeObsCount;
        double totalLogTypeMDPPrior = 0;
        for(int typeIndex = 0; typeIndex < logTypeMDPPriors.length; typeIndex++){
            typeObsCount = 0;
            for(int setIndex = 0; setIndex < currSetSizeLists[typeIndex].length; setIndex++){
                typeObsCount += currSetSizeLists[typeIndex][setIndex];
            }
            logTypeMDPPriors[typeIndex] = ClusterPrior.calcLogMDPDensity(alphaValues[typeIndex],
                    typeList.getMaxSubTypeCount(typeIndex),
                    currSetSizeLists[typeIndex],
                    typeObsCount);
            totalLogTypeMDPPrior += logTypeMDPPriors[typeIndex];
        }

        double constant;
        for(int typeIndex = 0; typeIndex < propSetSizeLists.length; typeIndex++){

            logMDPPriors[typeIndex] = new double[propSetSizeLists[typeIndex].length];

            // Since independent MDP is applied to each fluid type,
            // except the type encompasses the subtype to which the unknown type is added,
            // the MDP prior for each fluid is not affected.
            constant = totalLogTypeMDPPrior - logTypeMDPPriors[typeIndex];

            for(int setIndex = 0; setIndex < propSetSizeLists[typeIndex].length; setIndex++){

                // Each non-empty subtype in propSetSizeLists is
                // one of the possible scenarios of adding the unknown.
                if(propSetSizeLists[typeIndex][setIndex] > 0){

                    // Substitute the relevant subtype with the one including the unknown,
                    // but keep the original value somewhere safe.
                    currSetSize = currSetSizeLists[typeIndex][setIndex];
                    currSetSizeLists[typeIndex][setIndex] = propSetSizeLists[typeIndex][setIndex];

                    // Calculate the new MDP with the unknown added.
                    newLogTypeMDP = ClusterPrior.calcLogMDPDensity(alphaValues[typeIndex],
                            typeList.getMaxSubTypeCount(typeIndex),
                            currSetSizeLists[typeIndex],
                            typeCounts[typeIndex]);

                    // Calculate the full log MDP across all fluid types
                    logMDPPriors[typeIndex][setIndex] = constant + newLogTypeMDP;
                    // Return to the original set sizes.
                    currSetSizeLists[typeIndex][setIndex] = currSetSize;

                }
            }
        }

        return logMDPPriors;

    }

    public static void assignUnknownToAllPossibleSubtype(TypeList typeList,
                                                          int[][] propSetSizeLists,
                                                          int unknownObsIndex){

        int setSize;

        for(int typeIndex = 0; typeIndex < propSetSizeLists.length; typeIndex++){

            for(int setIndex = 0; setIndex < propSetSizeLists[typeIndex].length; setIndex++){

                setSize = propSetSizeLists[typeIndex][setIndex];

                if(setSize > 0){
                    // If this is a non-empty set after including the unknown
                    typeList.addObs(typeIndex, setIndex, unknownObsIndex);
                }
            }

        }

    }

    private static void calcFullLogLikelihoods(double totalLogLik,
                                     double[][] logFullLikelihoods,
                                     double[][] currLogSubtypeLikelihoodLists,
                                     double[][] propLogSubtypeLikelihoodLists){



        for(int typeIndex = 0; typeIndex < propLogSubtypeLikelihoodLists.length; typeIndex++){
            for(int setIndex = 0; setIndex < propLogSubtypeLikelihoodLists[typeIndex].length; setIndex++){

                // Replace the relevant "subtype likelihood without the unknown sample"
                // with the corresponding  "subtype likelihood with the unknown sample".
                if(propLogSubtypeLikelihoodLists[typeIndex][setIndex] != 0){
                    logFullLikelihoods[typeIndex][setIndex] = totalLogLik -
                            currLogSubtypeLikelihoodLists[typeIndex][setIndex] +
                            propLogSubtypeLikelihoodLists[typeIndex][setIndex];
                    //System.out.println("flag: " + totalLogLik+" "+currLogSubtypeLikelihoodLists[typeIndex][setIndex]+" "+
                    //        propLogSubtypeLikelihoodLists[typeIndex][setIndex]);
                }

            }

        }

    }

    public static void getFullConditionalPosteriorProb(double[] fullConditonals,
                                                       double[][] propLogSubtypeLikelihoodLists,
                                                       double[][] propLogMDPPriorValues,
                                                       double[] logTypePrior,
                                                       int[][] allConfigSetSizesAcrossType){
        int counter = 0;
        double min = 0;

        for(int typeIndex = 0; typeIndex < propLogSubtypeLikelihoodLists.length; typeIndex++){
            for(int setIndex = 0; setIndex < propLogSubtypeLikelihoodLists[typeIndex].length; setIndex++){

                // Log posterior up to a constant
                if(allConfigSetSizesAcrossType[typeIndex][setIndex] > 0) {
                    fullConditonals[counter] =
                            propLogMDPPriorValues[typeIndex][setIndex] +
                                    propLogSubtypeLikelihoodLists[typeIndex][setIndex] +
                                    logTypePrior[typeIndex];
                    //System.out.println(fullConditonals[counter]);

                    // Update the minimum value
                    if (min > fullConditonals[counter]) {
                        min = fullConditonals[counter];
                    }
                }



                counter++;
            }

        }


        // Get the posterior up to a normalising constant
        double total = 0.0;
        for(int index = 0; index < fullConditonals.length; index++){
            if(fullConditonals[index] != 0){
                // Scale by the minimum to avoid under flow
                fullConditonals[index] -= min;
                // Exponentiate the log full conditional (after scaling by the minimum)
                fullConditonals[index] = Math.exp(fullConditonals[index]);
                // Update the normalising constant.
                total += fullConditonals[index];
            }

        }



        // Normalise the full conditionals.
        for(int index = 0; index < fullConditonals.length; index++){
            fullConditonals[index] = fullConditonals[index] / total;

        }

    }

    public static int[] sampleRandomSubtype(double[] probs, TypeList typeList){
        // Randomly sample from Unif(0, 1)
        double sample = Randomizer.nextDouble();
        //System.out.println("sample: "+sample);
        int sampledIndex = sampleIndex(probs, sample);
        //System.out.println("sampleIndex: "+sampledIndex);
        return mapToTypeListPos(typeList, sampledIndex);

    }

    public static int sampleIndex(double[] probs, double sample){

        // Calculate the cumulative probabilities
        double[] cumProbs = new double[probs.length];
        cumProbs[0] = probs[0];
        for(int index = 1; index < probs.length; index++){
            cumProbs[index] = cumProbs[index - 1] + probs[index];

        }



        int sampledIndex = -1;
        for(int index = 0; index < probs.length; index++){
            if(sample < cumProbs[index]){
                // Once we find the smallest value in cumProbs
                // that upper bounds the value of sample.
                sampledIndex = index;
                break;
            }
        }

        return sampledIndex;
    }

    public static int[] mapToTypeListPos(TypeList typeList, int index){

        int assignedTypeIndex = -1;
        int assignedSubtypeIndex = -1;
        int temp = -1;

        for(int typeIndex = 0; typeIndex < typeList.getTypeCount(); typeIndex++){
            // Check whether the modified index exceeds the subtype indexes in the current type.
            temp = index - typeList.getMaxSubTypeCount(typeIndex);
            if(temp < 0){
                // If not, then the index is mapped to the current type;
                assignedTypeIndex = typeIndex;
                // the current index value indicates the subtype position
                assignedSubtypeIndex = index;
                break;
            }else{
                // update the index value
                index = temp;
            }
        }

        return new int[]{assignedTypeIndex, assignedSubtypeIndex};
    }



    public double proposal(){

        int unknownObsIndex = Randomizer.nextInt(typeList.getUnknownObsCount());
        // Retrieve the classification information on this sample.
        int currUnknownTypeIndex = typeList.getUnknownObsTypeIndex(unknownObsIndex);
        int currUnknownSubtypeIndex = typeList.getUnknownObsSubTypeIndex(unknownObsIndex);
        int currUnknownEltIndex = typeList.getUnknownObsEltIndex(
                unknownObsIndex + typeList.getUnknownStartIndex(),
                currUnknownTypeIndex, currUnknownSubtypeIndex);

        // Calculate the log subtype likelihoods in each fluid type
        // for the current configuration of the training set.
        double totalLogLik = likelihood.getLogLikelihood();
        //System.out.println("totalLogLik: "+totalLogLik);
        //System.out.println("currLogSubtypeLikelihoodLists: "+currLogSubtypeLikelihoodLists);
        likelihood.getLogSubtypeLikelihoods(currLogSubtypeLikelihoodLists);

        /*for(int typeIndex = 0; typeIndex < currLogSubtypeLikelihoodLists.length; typeIndex++){
            for(int setIndex = 0; setIndex < currLogSubtypeLikelihoodLists[typeIndex].length; setIndex++){
                System.out.print(currLogSubtypeLikelihoodLists[typeIndex][setIndex]+" ");
            }
            System.out.println();

        }*/

        typeList.copyLists(typeListCopy);
        int obs = typeList.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, currUnknownEltIndex);

        // Initialises currSetSizeLists
        getCurrSetSizesAcrossType(currSetSizeLists, typeList);
        // Calculate the size of each subtype when a the unknown sample is added.
        getSetSizesForAllConfig(currSetSizeLists, propSetSizeLists);





        // For each scenario of adding the unknown sample,
        // calculate the log MDP prior.
        calcLogMDPPriorForAllConfig(alphaValues, typeList,
                currSetSizeLists, propSetSizeLists, propLogMDPPriorValues);


        // Modify the subtype list such that each non-empty subtype
        // represents a scenario of having the unknown added.
        typeListCopy.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, currUnknownEltIndex);
        assignUnknownToAllPossibleSubtype(
                typeListCopy, propSetSizeLists, unknownObsIndex + typeList.getUnknownStartIndex());

        int propUnknownEltIndex = typeListCopy.getUnknownObsEltIndex(unknownObsIndex + typeListCopy.getUnknownStartIndex(),
                currUnknownTypeIndex, currUnknownSubtypeIndex);
        //System.out.println("flag 1: "+(unknownObsIndex + typeListCopy.getUnknownStartIndex()) +" "
        //        //        + currUnknownTypeIndex + " "+ currUnknownSubtypeIndex);
        //        //System.out.println("flag 2: "+currUnknownTypeIndex +" "+ currUnknownSubtypeIndex + " "+ propUnknownEltIndex);
        //        //System.out.println("flag 3: "+typeListCopy.log());
        //int propUnknownSubtypeIndex = currUnknownSubtypeIndex;
        if(propUnknownEltIndex== -1){
            for(int subtypeIndex = 0; subtypeIndex < propSetSizeLists[currUnknownTypeIndex].length; subtypeIndex++){
                if(propSetSizeLists[currUnknownTypeIndex][subtypeIndex] == 1){

                    propUnknownEltIndex = typeListCopy.getUnknownObsEltIndex(
                            unknownObsIndex + typeListCopy.getUnknownStartIndex(),
                            currUnknownTypeIndex, subtypeIndex);

                    currLogSubtypeLikelihoodLists[currUnknownTypeIndex][subtypeIndex] =
                            currLogSubtypeLikelihoodLists[currUnknownTypeIndex][currUnknownSubtypeIndex];
                    currLogSubtypeLikelihoodLists[currUnknownTypeIndex][currUnknownSubtypeIndex] = 0;
                    currUnknownSubtypeIndex = subtypeIndex;
                    break;
                }
            }
        }
        //System.out.println("flag 2: "+currUnknownTypeIndex +" "+ currUnknownSubtypeIndex + " "+ propUnknownEltIndex);
        typeListCopy.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, propUnknownEltIndex);



        likelihoodCopy.setUpdateAll(true);
        likelihoodCopy.getLogLikelihood();
        likelihoodCopy.getLogSubtypeLikelihoods(propLogSubtypeLikelihoodLists);



        /*System.out.println("flag 3 "+propLogSubtypeLikelihoodLists[currUnknownTypeIndex][currUnknownSubtypeIndex]);

        for(int typeIndex = 0; typeIndex < propLogSubtypeLikelihoodLists.length; typeIndex++){
            for(int setIndex = 0; setIndex < propLogSubtypeLikelihoodLists[typeIndex].length; setIndex++){
                System.out.print(propLogSubtypeLikelihoodLists[typeIndex][setIndex]+" ");
            }
            System.out.println();

        }*/

        //Calculate full logLikelikehoods for each scenario
        //System.out.println("totalLogLik: "+totalLogLik);
        prepareAndCalcFullLogLikelihoods(totalLogLik,
                logFullLikelihoods,
                currLogSubtypeLikelihoodLists,
                propLogSubtypeLikelihoodLists,
                currUnknownTypeIndex,
                currUnknownSubtypeIndex);

        // Calculate full conditionals
        fullConditonals = new double[totalSubtype];
        getFullConditionalPosteriorProb(fullConditonals,
                logFullLikelihoods, propLogMDPPriorValues, logTypePrior, propSetSizeLists);

        // Obtain the new type and subtype indexes.
        int[] assignedIndexes = sampleRandomSubtype(fullConditonals, typeList);
        typeList.addObs(assignedIndexes[0], assignedIndexes[1], obs);

        double logFwd = logFullLikelihoods[assignedIndexes[0]][assignedIndexes[1]] +
                propLogMDPPriorValues[assignedIndexes[0]][assignedIndexes[1]] +
                logTypePrior[assignedIndexes[0]];
        double logBwd = logFullLikelihoods[currUnknownTypeIndex][currUnknownSubtypeIndex] +
                propLogMDPPriorValues[currUnknownTypeIndex][currUnknownSubtypeIndex]+
                logTypePrior[currUnknownTypeIndex];
        currType = currUnknownTypeIndex;
        propType = assignedIndexes[0];
        currSubtype = currUnknownSubtypeIndex;
        propSubtype = assignedIndexes[1];

        /*
        for(int index = 0; index < fullConditonals.length; index++){
            System.out.print(fullConditonals[index]+" ");
        }
        System.out.println();

        System.out.println(assignedIndexes[0] +" "+ assignedIndexes[1]);

        System.out.println("logFwd: "+logFwd);
        System.out.println("logFwd: "+logFullLikelihoods[assignedIndexes[0]][assignedIndexes[1]]);
        System.out.println("logFwd: "+propLogMDPPriorValues[assignedIndexes[0]][assignedIndexes[1]]);
        System.out.println(currUnknownTypeIndex+" "+currUnknownSubtypeIndex);
        System.out.println("logBwd: "+logBwd);
        System.out.println("logFwd: "+logFullLikelihoods[currUnknownTypeIndex][currUnknownSubtypeIndex]);
        System.out.println("logFwd: "+propLogMDPPriorValues[currUnknownTypeIndex][currUnknownSubtypeIndex]);
        System.out.println(logBwd - logFwd);*/
        return logBwd - logFwd;
        //return Double.POSITIVE_INFINITY;
    }

    public void printCalculations(){
        System.out.println(currType+" "+currSubtype+" "+propType+ " "+propSubtype);
        int counter = 0;
        for(int typeIndex = 0; typeIndex < typeList.getTypeCount(); typeIndex++){
            for(int setIndex = 0; setIndex < typeList.getMaxSubTypeCount(typeIndex); setIndex++){
                System.out.print(fullConditonals[counter++] +" ");

            }
            System.out.println();
        }

        for(int typeIndex = 0; typeIndex < typeList.getTypeCount(); typeIndex++){
            for(int setIndex = 0; setIndex < typeList.getMaxSubTypeCount(typeIndex); setIndex++){
                System.out.println(typeIndex + " " + setIndex +" " + logFullLikelihoods[typeIndex][setIndex] +" "+
                        propLogMDPPriorValues[typeIndex][setIndex] +" "+
                        logTypePrior[typeIndex]+" "+
                        currLogSubtypeLikelihoodLists[typeIndex][setIndex] +" " +
                        propLogSubtypeLikelihoodLists[typeIndex][setIndex] +" ");

            }
            System.out.println();
        }


        System.out.println(typeListCopy.log());




    }

    private static void swapLogSubtypeLikelihood(double[][] logSubtypeLikelihoodLists1,
                                                double[][] logSubtypeLikelihoodLists2,
                                                int typeIndex,
                                                int subtypeIndex){

        double temp = logSubtypeLikelihoodLists1[typeIndex][subtypeIndex];
        logSubtypeLikelihoodLists1[typeIndex][subtypeIndex]
                = logSubtypeLikelihoodLists2[typeIndex][subtypeIndex];
        logSubtypeLikelihoodLists2[typeIndex][subtypeIndex] = temp;
    }

    private static double getTotalLogTypeLikelihoodLessCurrUnknown(double totalLogLik,
                                                                double[][] beReplaced,
                                                                double[][] replace,
                                                                int typeIndex,
                                                                int subtypeIndex){

        return totalLogLik - beReplaced[typeIndex][subtypeIndex] + replace[typeIndex][subtypeIndex];

    }

    public static void prepareAndCalcFullLogLikelihoods(double totalLogLik,
                                                          double[][] logFullLikelihoods,
                                                          double[][] currLogSubtypeLikelihoodLists,
                                                          double[][] propLogSubtypeLikelihoodLists,
                                                          int currUnknownTypeIndex,
                                                          int currUnknownSubtypeIndex){
        swapLogSubtypeLikelihood(
                currLogSubtypeLikelihoodLists, propLogSubtypeLikelihoodLists,
                currUnknownTypeIndex, currUnknownSubtypeIndex);

        // Calculate the full log likelihoods under each assignment scenario
        //likelihood.getLogTypeLikelihoods(logTypeLikelihoods);

        //System.out.println("totalLogLik:"+ totalLogLik);
        totalLogLik = getTotalLogTypeLikelihoodLessCurrUnknown(totalLogLik,
                propLogSubtypeLikelihoodLists, currLogSubtypeLikelihoodLists,
                currUnknownTypeIndex, currUnknownSubtypeIndex);
        //System.out.println("totalLogLik:"+ totalLogLik);

        calcFullLogLikelihoods(totalLogLik,
                logFullLikelihoods,
                currLogSubtypeLikelihoodLists,
                propLogSubtypeLikelihoodLists);

    }




}