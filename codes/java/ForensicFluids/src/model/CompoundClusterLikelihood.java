package model;

import data.CompoundMarkerData;
import state.Parameter;
import state.TypeList;

public class CompoundClusterLikelihood extends AbstractProbability {
    //private int[][][][] eltsAllPartSetList;
    //private double[][] eltsAllPartSetPriorList;
    //private CompoundMarkerData multiTypeSamples;
    //private double[] alphaC;
    //private  double[] betaC;
    private TypeList typeClusters;
    private ClusterLikelihood[] liks;
    private double[] logMultiTypeLikelihoods;
    private double[] storedLogMultiTypeLikelihoods;
    private double logMultiTypeLikelihood;
    private double storedLogMultiTypeLikelihood;

    public CompoundClusterLikelihood(String label,
                                     int[][][][] eltsAllPartSetList,
                                     double[][] eltsAllPartSetPriorList,
                                     CompoundMarkerData multiTypeSamples,
                                     double[][] alphaC,
                                     double[][] betaC,
                                     TypeList typeClusters){
        super(label);

        //this.multiTypeSamples = multiTypeSamples;
        this.typeClusters = typeClusters;
        logMultiTypeLikelihoods = new double[typeClusters.getTypeCount()];
        storedLogMultiTypeLikelihoods = new double[logMultiTypeLikelihoods.length];

        liks = new ClusterLikelihood[typeClusters.getTypeCount()];
        for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){
            liks[typeIndex] = new ClusterLikelihood(
                    eltsAllPartSetList, eltsAllPartSetPriorList,
                    multiTypeSamples.getData(typeIndex),
                    new Parameter("shape.a", alphaC[typeIndex], 0),
                    new Parameter("shape.b", betaC[typeIndex], 0),
                    typeClusters.getSubTypeList(typeIndex));
        }
    }

    public CompoundClusterLikelihood(String label,
                                     int[][][][] eltsAllPartSetList,
                                     double[][] eltsAllPartSetPriorList,
                                     CompoundMarkerData multiTypeSamples,
                                     Parameter[] alphaC,
                                     Parameter[] betaC,
                                     TypeList typeClusters){
        super(label);


        //this.multiTypeSamples = multiTypeSamples;
        this.typeClusters = typeClusters;
        logMultiTypeLikelihoods = new double[typeClusters.getTypeCount()];
        storedLogMultiTypeLikelihoods = new double[logMultiTypeLikelihoods.length];

        liks = new ClusterLikelihood[typeClusters.getTypeCount()];
        for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){

            liks[typeIndex] = new ClusterLikelihood(
                    eltsAllPartSetList, eltsAllPartSetPriorList,
                    multiTypeSamples.getData(typeIndex),
                    alphaC[typeIndex], betaC[typeIndex],
                    typeClusters.getSubTypeList(typeIndex));
        }
    }

    public double getLogLikelihood(){

        logMultiTypeLikelihood = 0;
        for(int typeIndex = 0; typeIndex < typeClusters.getTypeCount(); typeIndex++){
            if(typeClusters.hasUpdated(typeIndex)){
                logMultiTypeLikelihoods[typeIndex] =  liks[typeIndex].getLogLikelihood();
            }

            //System.out.println("type log-lik"+ logMultiTypeLikelihoods[typeIndex]);
            logMultiTypeLikelihood += logMultiTypeLikelihoods[typeIndex];


        }


        //System.out.println("all log-lik"+ logMultiTypeLikelihood);
        return(logMultiTypeLikelihood);
    }

    public String log(){


        String logCompLik = "" + logMultiTypeLikelihood;
        for(int typeIndex = 0; typeIndex < logMultiTypeLikelihoods.length; typeIndex++){
            logCompLik+=("\t" + logMultiTypeLikelihoods[typeIndex]);
        }
        //return "" + logMultiTypeLikelihood;
        return logCompLik;
    }

    public String logStored(){
        return "" + storedLogMultiTypeLikelihood;
    }

    public void store(){
        storedLogMultiTypeLikelihood = logMultiTypeLikelihood;
        System.arraycopy(logMultiTypeLikelihoods, 0,
                storedLogMultiTypeLikelihoods, 0, logMultiTypeLikelihoods.length);
        /*System.out.print(this.getClass()+"store ");
        for(int i = 0; i < logMultiTypeLikelihoods.length; i++){
            System.out.print(logMultiTypeLikelihoods[i]+" ");
        }
        System.out.println();*/
        for(ClusterLikelihood likelihood:liks){
            likelihood.store();
        }
    }

    public void restore(){
        logMultiTypeLikelihood = storedLogMultiTypeLikelihood;
        double[] tmp = logMultiTypeLikelihoods;
        logMultiTypeLikelihoods = storedLogMultiTypeLikelihoods;
        storedLogMultiTypeLikelihoods = tmp;

        for(ClusterLikelihood likelihood:liks){
            likelihood.restore();
        }

        /*System.out.print(this.getClass()+"restore ");
        for(int i = 0; i < logMultiTypeLikelihoods.length; i++){
            System.out.print(logMultiTypeLikelihoods[i]+" ");
        }
        System.out.println();*/
    }
}
