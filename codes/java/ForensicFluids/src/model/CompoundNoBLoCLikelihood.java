package model;

import data.CompoundMarkerData;
import state.Parameter;
import state.TypeList;

public class CompoundNoBLoCLikelihood extends CompoundClusterLikelihood{

    public CompoundNoBLoCLikelihood(String label,
                                    int[][][][] eltsAllPartSetList,
                                    double[][] eltsAllPartSetPriorList,
                                    CompoundMarkerData multiTypeSamples,
                                    double[][] alphaCValues,
                                    double[][] betaCValues,
                                    TypeList typeClusters){

        super(label, eltsAllPartSetList,
                eltsAllPartSetPriorList, multiTypeSamples,
                alphaCValues, betaCValues, typeClusters);
        System.err.println("Using NoB-LoC model set up.");
    }

    public CompoundNoBLoCLikelihood(String label,
                                     int[][][][] eltsAllPartSetList,
                                     double[][] eltsAllPartSetPriorList,
                                     CompoundMarkerData multiTypeSamples,
                                     Parameter[] alphaC,
                                     Parameter[] betaC,
                                     TypeList typeClusters){
        super(label, eltsAllPartSetList,
                eltsAllPartSetPriorList, multiTypeSamples,
                alphaC, betaC, typeClusters);
        System.err.println("Using NoB-LoC model set up.");
    }

    public void setUp(){
        logMultiTypeLikelihoods = new double[typeClusters.getTypeCount()];
        storedLogMultiTypeLikelihoods = new double[logMultiTypeLikelihoods.length];

        liks = new NoBLoCLikelihood[typeClusters.getTypeCount()];
        for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){
            liks[typeIndex] = new NoBLoCLikelihood(
                    eltsAllPartSetList, eltsAllPartSetPriorList,
                    multiTypeSamples.getData(typeIndex),
                    alphaC[typeIndex], betaC[typeIndex],
                    typeClusters.getSubTypeList(typeIndex));
        }
    }
}
