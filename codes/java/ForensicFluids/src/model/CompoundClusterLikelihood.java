package model;

import data.CompoundMarkerData;
import state.Parameter;
import state.TypeList;

public class CompoundClusterLikelihood extends AbstractProbability {
    private int[][][][] eltsAllPartSetList;
    private double[][] eltsAllPartSetPriorList;
    private CompoundMarkerData multiTypeSamples;
    private Parameter[] alphaC;
    private Parameter[] betaC;
    private TypeList typeClusters;
    private ClusterLikelihood[] liks;
    private double[] logMultiTypeLikelihoods;
    private double[] storedLogMultiTypeLikelihoods;
    private double logMultiTypeLikelihood;
    private double storedLogMultiTypeLikelihood;

    public CompoundClusterLikelihood(String label){
        super(label);
    }




    public CompoundClusterLikelihood(String label,
                                     int[][][][] eltsAllPartSetList,
                                     double[][] eltsAllPartSetPriorList,
                                     CompoundMarkerData multiTypeSamples,
                                     double[][] alphaCValues,
                                     double[][] betaCValues,
                                     TypeList typeClusters){
        super(label);
        this.eltsAllPartSetList = eltsAllPartSetList;
        this.eltsAllPartSetPriorList = eltsAllPartSetPriorList;
        this.multiTypeSamples = multiTypeSamples;
        this.typeClusters = typeClusters;

        alphaC = new Parameter[alphaCValues.length];
        betaC = new Parameter[betaCValues.length];
        for(int typeIndex = 0; typeIndex < alphaC.length; typeIndex++){
            alphaC[typeIndex] = new Parameter("shape.a", alphaCValues[typeIndex], 0);
            betaC[typeIndex] = new Parameter("shape.b", betaCValues[typeIndex], 0);
        }



        setUp();
    }

    public void setUp(){
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

    public CompoundClusterLikelihood(String label,
                                     int[][][][] eltsAllPartSetList,
                                     double[][] eltsAllPartSetPriorList,
                                     CompoundMarkerData multiTypeSamples,
                                     Parameter[] alphaC,
                                     Parameter[] betaC,
                                     TypeList typeClusters){
        super(label);

        this.eltsAllPartSetList = eltsAllPartSetList;
        this.eltsAllPartSetPriorList = eltsAllPartSetPriorList;
        this.multiTypeSamples = multiTypeSamples;
        this.alphaC = alphaC;
        this.betaC = betaC;
        this.typeClusters = typeClusters;
        setUp();



        /*logMultiTypeLikelihoods = new double[typeClusters.getTypeCount()];
        storedLogMultiTypeLikelihoods = new double[logMultiTypeLikelihoods.length];


        liks = new ClusterLikelihood[typeClusters.getTypeCount()];
        for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){

            liks[typeIndex] = new ClusterLikelihood(
                    eltsAllPartSetList, eltsAllPartSetPriorList,
                    multiTypeSamples.getData(typeIndex),
                    alphaC[typeIndex], betaC[typeIndex],
                    typeClusters.getSubTypeList(typeIndex));
        }*/
    }


    public double getLogLikelihood(){

        logMultiTypeLikelihood = 0;
        //for(int typeIndex = 0; typeIndex < typeClusters.getTypeCount(); typeIndex++){
            //if(typeClusters.hasUpdated(typeIndex)){
        for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){
            //print("type: "+typeIndex+" ");
            if(liks[typeIndex].isUpdated()){
                logMultiTypeLikelihoods[typeIndex] =  liks[typeIndex].getLogLikelihood();
            }
            //System.out.println();

            //System.out.println("type log-lik"+ logMultiTypeLikelihoods[typeIndex]);
            logMultiTypeLikelihood += logMultiTypeLikelihoods[typeIndex];


        }


        //System.out.println("all log-lik"+ logMultiTypeLikelihood);
        return(logMultiTypeLikelihood);
    }

    public void getLogTypeLikelihoods(double[] copy){
        System.arraycopy(logMultiTypeLikelihoods, 0,
                copy, 0, logMultiTypeLikelihoods.length);
    }

    public void getLogSubtypeLikelihoods(double[][] subtypeLikelihoodLists) {
        for(int typeIndex = 0; typeIndex < subtypeLikelihoodLists.length; typeIndex++){
            liks[typeIndex].getLogSubtypeLikelihoods(subtypeLikelihoodLists[typeIndex]);
        }
    }

    public double getLogSubtypeLikelihood(int typeIndex, int setIndex) {
        return liks[typeIndex].getLogSubtypeLikelihoods(setIndex);
    }

    public String getLabel(){

        String newLabel = label;
        for(int typeIndex = 0; typeIndex < typeClusters.getTypeCount(); typeIndex++){
            newLabel+= "\t"+label+"."+typeIndex;
        }

        return newLabel;
    }

    public void setUpdateAll(boolean updateAll){
        for(int typeIndex = 0; typeIndex < liks.length; typeIndex++){
            liks[typeIndex].setUpdateAll(updateAll);
        }

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

    public void shareMkrGrpParts(CompoundClusterLikelihood desLik){
        desLik.eltsAllPartSetList = this.eltsAllPartSetList;




    }

    public void shareColPriors(CompoundClusterLikelihood desLik) {
        desLik.eltsAllPartSetPriorList = this.eltsAllPartSetPriorList;
    }

    public void shareData(CompoundClusterLikelihood desLik) {
        desLik.multiTypeSamples = this.multiTypeSamples;
    }

    public void shareAlphaC(CompoundClusterLikelihood desLik) {
        desLik.alphaC = this.alphaC;
    }

    public void shareBetaC(CompoundClusterLikelihood desLik) {
        desLik.betaC = this.betaC;
    }

    public void setTypeClusters(TypeList typeList){
        this.typeClusters = typeList;
    }




}
