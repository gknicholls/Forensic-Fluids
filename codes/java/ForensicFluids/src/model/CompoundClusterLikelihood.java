package model;

import data.CompoundMarkerData;
import data.SubTypeList;
import data.TypeList;

public class CompoundClusterLikelihood {
    private int[][][][] eltsAllPartSetList;
    private double[][] eltsAllPartSetPriorList;
    private CompoundMarkerData multiTypeSamples;
    private double[] alphaC;
    private  double[] betaC;
    private TypeList typeClusters;
    private double[] logMultiTypeLikelihoods;
    private double[] storedLogMultiTypeLikelihoods;

    public CompoundClusterLikelihood(int[][][][] eltsAllPartSetList,
                                     double[][] eltsAllPartSetPriorList,
                                     CompoundMarkerData multiTypeSamples,
                                     double[] alphaC,
                                     double[] betaC,
                                     TypeList typeClusters){
        this.eltsAllPartSetList = eltsAllPartSetList;
        this.eltsAllPartSetPriorList = eltsAllPartSetPriorList;
        this.multiTypeSamples = multiTypeSamples;
        this.alphaC = alphaC;
        this.betaC = betaC;
        this.typeClusters = typeClusters;
        logMultiTypeLikelihoods = new double[typeClusters.getTypeCount()];
        storedLogMultiTypeLikelihoods = new double[logMultiTypeLikelihoods.length];
    }

    public double CalcLogTypeLikelihood(){

        double logMultiTypeLikelihood = 0;
        for(int typeIndex = 0; typeIndex < typeClusters.getTypeCount(); typeIndex++){
            if(typeClusters.hasUpdated(typeIndex)){
                logMultiTypeLikelihoods[typeIndex] = ClusterLikelihood.CalcLogTypeLikelihood(eltsAllPartSetList,
                        eltsAllPartSetPriorList,
                        multiTypeSamples.getData(typeIndex),
                        alphaC,
                        betaC,
                        typeClusters.getSubTypeList(typeIndex));
            }
            logMultiTypeLikelihood += logMultiTypeLikelihoods[typeIndex];


        }


        return(logMultiTypeLikelihood);
    }

    public void store(){
        System.arraycopy(logMultiTypeLikelihoods, 0,
                storedLogMultiTypeLikelihoods, 0, logMultiTypeLikelihoods.length);
    }

    public void restore(){
        double[] tmp = logMultiTypeLikelihoods;
        logMultiTypeLikelihoods = storedLogMultiTypeLikelihoods;
        storedLogMultiTypeLikelihoods = tmp;
    }
}
