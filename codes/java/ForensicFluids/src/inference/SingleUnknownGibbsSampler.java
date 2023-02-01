package inference;


import model.ClusterPrior;
import model.CompoundClusterLikelihood;
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
    private double[] logTypeLikelihoods;
    private double[][] logFullLikelihoods;


    public SingleUnknownGibbsSampler(TypeListWithUnknown typeList,
                                     CompoundClusterLikelihood likelihood,
                                     int unknownObsIndex,
                                     double[] logMDPPriorValues,
                                     double[] alphaValues){
        this.typeList = typeList;
        this.likelihood = likelihood;
        this.logMDPPriorValues = logMDPPriorValues;
        this.alphaValues = alphaValues;
        typeListCopy = this.typeList.copy();
        likelihoodCopy = setLikelihoodCopy(this.likelihood, typeListCopy);


        currSetSizeLists = new int[typeList.getTypeCount()][];
        propSetSizeLists = new int[typeList.getTypeCount()][];
        propLogMDPPriorValues = new double[typeList.getTypeCount()][];

        initialiseLogSubtypeLikLists(currLogSubtypeLikelihoodLists, typeList);
        initialiseLogSubtypeLikLists(propLogSubtypeLikelihoodLists, typeList);
        initialiseLogSubtypeLikLists(logFullLikelihoods, typeList);


        totalSubtype = 0;
        for(int typeIndex = 0; typeIndex < typeList.getTypeCount(); typeIndex++){
            totalSubtype += typeList.getMaxSubTypeCount(typeIndex);
        }

        logTypeLikelihoods = new double[typeList.getTypeCount()];


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

    protected void initialiseLogSubtypeLikLists(double[][] logSubtypeLikLists,
                                              TypeList typeList){
        logSubtypeLikLists = new double[typeList.getTypeCount()][];
        int maxSetCount;
        for(int typeIndex = 0; typeIndex < logSubtypeLikLists.length; typeIndex++){
            maxSetCount = typeList.getMaxSubTypeCount(typeIndex);
            logSubtypeLikLists[typeIndex] = new double[maxSetCount];
        }
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

    public static double[][] calcLogMDPPriorForAllConfig(double[] logTypeMDPPriors,
                                                          double[] alphaValues,
                                                          TypeList typeList,
                                                          int[][] currSetSizeLists,
                                                          int[][] propSetSizeLists,
                                                          double[][] logMDPPriors){
        int currSetSize;
        double constant = 0;
        double newLogTypeMDP;
        int[] typeCounts = new int[typeList.getTypeCount()];
        for(int typeIndex = 0; typeIndex < currSetSizeLists.length; typeIndex++){
            typeCounts[typeIndex] = typeList.getTotalCount(typeIndex) + 1;
        }

        for(int typeIndex = 0; typeIndex < propSetSizeLists.length; typeIndex++){

            logMDPPriors[typeIndex] = new double[propSetSizeLists[typeIndex].length];

            // Since independent MDP is applied to each fluid type,
            // except the type encompasses the subtype to which the unknown type is added,
            // the MDP prior for each fluid is not affected.
            constant = 0;
            for(int typeIndex2 = 0; typeIndex2 < propSetSizeLists.length; typeIndex2++){
                if(typeIndex != typeIndex2){
                    constant += logTypeMDPPriors[typeIndex2];
                }
            }



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

    protected static void calcFullLogLikelihoods(double[] logTypeLikelihoods,
                                     double[][] logFullLikelihoods,
                                     double[][] currLogSubtypeLikelihoodLists,
                                     double[][] propLogSubtypeLikelihoodLists){

        //Compute the full log likelihood without the unknown type
        double totalLik = 0.;
        for(int typeIndex = 0; typeIndex < logFullLikelihoods.length; typeIndex++){
            totalLik += logTypeLikelihoods[typeIndex];
        }

        for(int typeIndex = 0; typeIndex < propLogSubtypeLikelihoodLists.length; typeIndex++){
            for(int setIndex = 0; setIndex < propLogSubtypeLikelihoodLists[typeIndex].length; setIndex++){

                // Replace the relevant "subtype likelihood without the unknown sample"
                // with the corresponding  "subtype likelihood with the unknown sample".
                if(propLogSubtypeLikelihoodLists[typeIndex][setIndex] != 0){
                    logFullLikelihoods[typeIndex][setIndex] = totalLik -
                            currLogSubtypeLikelihoodLists[typeIndex][setIndex] +
                            propLogSubtypeLikelihoodLists[typeIndex][setIndex];
                }

            }

        }

    }

    protected static void getFullConditionalPosteriorProb(double[] fullConditonals,
                                                        double[][] propLogSubtypeLikelihoodLists,
                                                        double[][] propLogMDPPriorValues){
        int counter = 0;
        double min = 0;

        for(int typeIndex = 0; typeIndex < propLogSubtypeLikelihoodLists.length; typeIndex++){
            for(int setIndex = 0; setIndex < propLogSubtypeLikelihoodLists[typeIndex].length; setIndex++){

                // Log posterior up to a constant
                fullConditonals[counter] =
                        propLogMDPPriorValues[typeIndex][setIndex] +
                        propLogSubtypeLikelihoodLists[typeIndex][setIndex];

                // Update the minimum value
                if(min > fullConditonals[counter]){
                    min = fullConditonals[counter];
                }

                counter++;
            }

        }

        // Get the posterior up to a normalising constant
        double total = 0.0;
        for(int index = 0; index < fullConditonals.length; index++){
            if(fullConditonals[index] != 0){
                // Scale by the minimum to avoid under flow
                fullConditonals[index] =- min;
                // Exponentiate the log full conditional (after scaling by the minimum)
                fullConditonals[index] = Math.exp(fullConditonals[index]);
                // Update the normalising constant.
                total =+ fullConditonals[index];
            }

        }

        // Normalise the full conditionals.
        for(int index = 0; index < fullConditonals.length; index++){
            fullConditonals[index] = fullConditonals[index] / total;

        }

    }

    protected static int sampleIndex(double[] probs){

        // Calculate the cumulative probabilities
        double[] cumProbs = new double[probs.length];
        for(int index = 1; index < probs.length; index++){
            cumProbs[index] = probs[index - 1] + probs[index];
        }

        // Randomly sample from Unif(0, 1)
        double sample = Randomizer.nextDouble();

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

    protected static int[] mapToTypeListPos(TypeList typeList, int index){

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
        likelihood.getLogSubtypeLikelihoods(currLogSubtypeLikelihoodLists);

        typeList.copyLists(typeListCopy);
        typeList.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, currUnknownEltIndex);



        // Initialises currSetSizeLists
        getCurrSetSizesAcrossType(currSetSizeLists, typeList);
        // Calculate the size of each subtype when a the unknown sample is added.
        getSetSizesForAllConfig(currSetSizeLists, propSetSizeLists);

        // For each scenario of adding the unknown sample,
        // calculate the log MDP prior.
        calcLogMDPPriorForAllConfig(logMDPPriorValues, alphaValues, typeList,
                currSetSizeLists, propSetSizeLists, propLogMDPPriorValues);


        // Modify the subtype list such that each non-empty subtype
        // represents a scenario of having the unknown added.

        assignUnknownToAllPossibleSubtype(
                typeListCopy, propSetSizeLists, unknownObsIndex);

        int propUnknownEltIndex = typeListCopy.getUnknownObsEltIndex(
                unknownObsIndex + typeListCopy.getUnknownStartIndex(),
                currUnknownTypeIndex, currUnknownSubtypeIndex);
        typeListCopy.removeObs(currUnknownTypeIndex, currUnknownSubtypeIndex, propUnknownEltIndex);

        likelihoodCopy.getLogLikelihood();
        likelihoodCopy.getLogSubtypeLikelihoods(propLogSubtypeLikelihoodLists);


        swapLogSubtypeLikelihood(
                currLogSubtypeLikelihoodLists, propLogSubtypeLikelihoodLists,
                currUnknownTypeIndex, currUnknownSubtypeIndex);

        // Calculate the full log likelihoods under each assignment scenario
        likelihood.getLogTypeLikelihoods(logTypeLikelihoods);
        logTypeLikelihoods[currUnknownTypeIndex] = 0;
        for(int setIndex = 0; setIndex < currLogSubtypeLikelihoodLists[currUnknownTypeIndex].length; setIndex++){
            logTypeLikelihoods[currUnknownTypeIndex] += currLogSubtypeLikelihoodLists[currUnknownTypeIndex][setIndex];
        }

        getLogTypeLikelihoodsLessCurrUnknown(likelihood, logTypeLikelihoods,
                currLogSubtypeLikelihoodLists, currUnknownTypeIndex);

        calcFullLogLikelihoods(logTypeLikelihoods,
                logFullLikelihoods,
                currLogSubtypeLikelihoodLists,
                propLogSubtypeLikelihoodLists);

        // Calculate full conditionals
        double[] fullConditonals = new double[totalSubtype];
        getFullConditionalPosteriorProb(fullConditonals,
                propLogSubtypeLikelihoodLists, propLogMDPPriorValues);

        // Obtain the new type and subtype indexes.
        int subtypeIndex = sampleIndex(fullConditonals);
        int[] assignedIndexes = mapToTypeListPos(typeList, subtypeIndex);



        //
        // typeList.addObs(assignedIndexes[0], assignedIndexes[1], unknownObsIndex);
        // Return to the likelihood before assigning the unknown.

        return 0.0;
    }

    public static void swapLogSubtypeLikelihood(double[][] logSubtypeLikelihoodLists1,
                                                double[][] logSubtypeLikelihoodLists2,
                                                int typeIndex,
                                                int subtypeIndex){
        double temp = logSubtypeLikelihoodLists1[typeIndex][subtypeIndex];
        logSubtypeLikelihoodLists1[typeIndex][subtypeIndex]
                = logSubtypeLikelihoodLists2[typeIndex][subtypeIndex];
        logSubtypeLikelihoodLists2[typeIndex][subtypeIndex] = temp;
    }

    public static void getLogTypeLikelihoodsLessCurrUnknown(CompoundClusterLikelihood likelihood,
                                               double[] logTypeLikelihoods,
                                               double[][] logSubtypeLikelihoodLists,
                                               int typeIndex){
        likelihood.getLogTypeLikelihoods(logTypeLikelihoods);
        logTypeLikelihoods[typeIndex] = 0;
        for(int setIndex = 0; setIndex < logSubtypeLikelihoodLists[typeIndex].length; setIndex++){
            logTypeLikelihoods[typeIndex] += logSubtypeLikelihoodLists[typeIndex][setIndex];
        }
    }




}