package inference;

import data.CompoundMarkerDataWithUnknown;
import model.ClusterPrior;
import model.CompoundClusterLikelihood;
import model.CompoundClusterPrior;
import state.SubTypeList;
import state.TypeList;
import utils.Randomizer;

import java.util.ArrayList;

/**
 * Created by jessiewu on 20/12/2022.
 */
public class SingleUnknownGibbsSampler extends ProposalMove{
    private TypeList typeList;
    private CompoundClusterLikelihood likelihood;
    private int unknownObsIndex;
    private double[] logMDPPriorValues;
    private double[] alphaValues;

    private CompoundMarkerDataWithUnknown dataSets;
    public SingleUnknownGibbsSampler(TypeList typeList,
                                     CompoundClusterLikelihood likelihood,
                                     int unknownObsIndex,
                                     double[] logMDPPriorValues,
                                     double[] alphaValues){
        this.typeList = typeList;
        this.likelihood = likelihood;
        this.unknownObsIndex = unknownObsIndex;
        this.logMDPPriorValues = logMDPPriorValues;
        this.alphaValues = alphaValues;
    }

    private static int[][] getSetSizesForAllConfig(TypeList typeList,
                                                   int unknownIndex,
                                                   int[][] currSetSizeLists){



        ArrayList<Integer> currEmptySet;

        int[][] setSizeLists = new int[typeList.getTypeCount()][];



        int typeNonEmptySetCount;

        for(int typeIndex  = 0; typeIndex < typeList.getTypeCount(); typeIndex++){
            setSizeLists[typeIndex] = new int[typeList.getMaxSubTypeCount(typeIndex)];
            typeNonEmptySetCount = typeList.getNonSubTypesCount(typeIndex);

            currEmptySet = new ArrayList<>();


            for(int setIndex = 0; setIndex < typeList.getMaxSubTypeCount(typeNonEmptySetCount); setIndex++ ){

                if(currSetSizeLists[typeIndex][setIndex] > 0){
                    setSizeLists[typeIndex][setIndex] =  currSetSizeLists[typeIndex][setIndex] + 1;
                }else{
                    currEmptySet.add(setIndex);
                }

            }
            if(currEmptySet.size() > 0){
                typeList.addObs(typeIndex, currEmptySet.get(0), unknownIndex);
                setSizeLists[typeIndex][currEmptySet.get(0)] = 1;
            }
        }

        return setSizeLists;

    }

    private static double[][] calcLogMDPPriorForAllConfig(double[] logTypeMDPPriors,
                                                          double[] alphaValues,
                                                          TypeList typeList,
                                                          int[][] currSetSizeLists,
                                                          int[][] propSetSizeLists){
        int currSetSize;
        double[][] logMDPPriors = new double[typeList.getTypeCount()][];
        double constant = 0;
        double newLogTypeMDP;
        for(int typeIndex = 0; typeIndex < propSetSizeLists.length; typeIndex++){
            logMDPPriors[typeIndex] = new double[propSetSizeLists[typeIndex].length];

            constant = 0;
            for(int typeIndex2 = 0; typeIndex2 < propSetSizeLists.length; typeIndex2++){
                if(typeIndex != typeIndex2){
                    constant += logTypeMDPPriors[typeIndex2];
                }
            }

            for(int setIndex = 0; setIndex < propSetSizeLists[typeIndex].length; setIndex++){
                if(propSetSizeLists[typeIndex][setIndex] > 0){
                    currSetSize = currSetSizeLists[typeIndex][setIndex];
                    currSetSizeLists[typeIndex][setIndex] = propSetSizeLists[typeIndex][setIndex];
                    newLogTypeMDP = ClusterPrior.calcLogMDPDensity(alphaValues[typeIndex],
                            typeList.getMaxSubTypeCount(typeIndex),
                            currSetSizeLists[typeIndex],
                            typeList.getTotalCount());
                    logMDPPriors[typeIndex][setIndex] = constant + newLogTypeMDP;
                    currSetSizeLists[typeIndex][setIndex] = currSetSize;
                }
            }
        }

        return logMDPPriors;


    }

    private void assignUnknownToAllPossibleSubtype(){

        int setSize = -1;
        ArrayList<Integer> nonEmptySet;
        for(int typeIndex = 0; typeIndex < typeList.getTypeCount(); typeIndex++){
            nonEmptySet = new ArrayList<>();
            for(int setIndex = 0; setIndex < typeList.getMaxSubTypeCount(typeIndex); setIndex++){
                setSize = typeList.getSubTypeSetSize(typeIndex, setIndex);
                if(setSize > 0){
                    typeList.addObs(typeIndex, setIndex, unknownObsIndex);
                }
            }
            if(nonEmptySet.size()>0){
                typeList.addObs(typeIndex, nonEmptySet.get(0), unknownObsIndex);

            }
        }

    }

    private void calcFullLikelihoods(double[] logTypeLikelihoods,
                                     double[][] logFullLikelihoods,
                                     double[][] currLogSubtypeLikelihoodLists,
                                     double[][] propLogSubtypeLikelihoodLists){

        double totalLik = 0.;
        for(int typeIndex = 0; typeIndex < logFullLikelihoods.length; typeIndex++){
            totalLik += logTypeLikelihoods[typeIndex];

        }
        for(int typeIndex = 0; typeIndex < propLogSubtypeLikelihoodLists.length; typeIndex++){
            for(int setIndex = 0; setIndex < propLogSubtypeLikelihoodLists[typeIndex].length; setIndex++){
                currLogSubtypeLikelihoodLists[typeIndex][setIndex] = 0;
                if(propLogSubtypeLikelihoodLists[typeIndex][setIndex] > 0){
                    currLogSubtypeLikelihoodLists[typeIndex][setIndex] =
                            totalLik - currLogSubtypeLikelihoodLists[typeIndex][setIndex] +
                                    propLogSubtypeLikelihoodLists[typeIndex][setIndex];
                }

            }

        }
    }


    public double proposal(){
        int[][] currSetSizeLists = new int[typeList.getTypeCount()][];
        for(int typeIndex = 0; typeIndex < currSetSizeLists.length; typeIndex++){
            currSetSizeLists[typeIndex] = typeList.getSubTypeSetSizes(typeIndex);
        }
        int[][] propSetSizeLists = getSetSizesForAllConfig(typeList, unknownObsIndex, currSetSizeLists);

        double[][] propLogMDPPriorValues = calcLogMDPPriorForAllConfig(logMDPPriorValues, alphaValues,
                typeList, currSetSizeLists, propSetSizeLists);

        double[][] currLogSubtypeLikelihoodLists = new double[typeList.getTypeCount()][];
        double[][] propLogSubtypeLikelihoodLists = new double[typeList.getTypeCount()][];
        int totalSubtype = 0;
        int maxSetCount;
        for(int typeIndex = 0; typeIndex < currLogSubtypeLikelihoodLists.length; typeIndex++){
            maxSetCount = typeList.getMaxSubTypeCount(typeIndex);
            totalSubtype += maxSetCount;
            currLogSubtypeLikelihoodLists[typeIndex] = new double[maxSetCount];
            propLogSubtypeLikelihoodLists[typeIndex] = new double[maxSetCount];
        }

        likelihood.getSubtypeLikelihoods(currLogSubtypeLikelihoodLists);

        assignUnknownToAllPossibleSubtype();
        likelihood.getSubtypeLikelihoods(propLogSubtypeLikelihoodLists);

        double[] logTypeLikelihoods = new double[typeList.getTypeCount()];
        likelihood.getLogTypeLikelihoods(logTypeLikelihoods);

        double[][] logFullLikelihoods = new double[typeList.getTypeCount()][];
        for(int typeIndex = 0; typeIndex < logFullLikelihoods.length; typeIndex++){
            logFullLikelihoods[typeIndex] = new double[propLogSubtypeLikelihoodLists.length];
        }

        calcFullLikelihoods(logTypeLikelihoods,
                logFullLikelihoods,
                currLogSubtypeLikelihoodLists,
                propLogSubtypeLikelihoodLists);

        int counter = 0;
        double[] fullConditonals = new double[totalSubtype];
        double min = 0;
        for(int typeIndex = 0; typeIndex < propLogSubtypeLikelihoodLists.length; typeIndex++){
            for(int setIndex = 0; setIndex < propLogSubtypeLikelihoodLists[typeIndex].length; setIndex++){
                fullConditonals[counter] = propLogMDPPriorValues[typeIndex][setIndex] +
                        propLogSubtypeLikelihoodLists[typeIndex][setIndex];
                if(min > fullConditonals[counter]){
                    min = fullConditonals[counter];
                }
                counter++;
            }

        }


        for(int index = 0; index < fullConditonals.length; index++){
            if(fullConditonals[index] != 0){
                fullConditonals[index] =- min;
                fullConditonals[index] = Math.exp(fullConditonals[index]);
            }

        }
        fullConditonals = Randomizer.getNormalized(fullConditonals);
        double[] cumFullConditonals = new double[fullConditonals.length];
        for(int index = 1; index < fullConditonals.length; index++){
            cumFullConditonals[index] = fullConditonals[index - 1] + fullConditonals[index];
        }


        double sample = Randomizer.nextDouble();

        int subtypeIndex = -1;
        for(int index = 0; index < fullConditonals.length; index++){
            if(sample < cumFullConditonals[index]){
                break;
            }
            subtypeIndex = index;
        }

        int assignedTypeIndex = -1;
        int assignedSubtypeIndex = -1;
        int temp = -1;
        for(int typeIndex = 0; typeIndex < propLogMDPPriorValues.length; typeIndex++){
            temp = subtypeIndex - propLogMDPPriorValues[typeIndex].length;
            if(temp  < 0){
                assignedTypeIndex = typeIndex;
                assignedSubtypeIndex = subtypeIndex;
            }else{
                subtypeIndex  = temp;
            }
        }
        typeList.restore();
        typeList.addObs(assignedTypeIndex, assignedSubtypeIndex, unknownObsIndex);
        likelihood.restore();



        return 0.0;
    }




}