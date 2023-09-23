package model;

import state.Parameter;
import state.SubTypeList;
import data.SingleMarkerData;
import org.apache.commons.math3.special.Beta;

public class ClusterLikelihood extends AbstractProbability {

    protected double logLikelihood;
    protected double storedLogLikelihood;
    protected int[][][][] eltsAllPartSetList;
    protected double[][] eltsAllPartSetPriorList;
    protected SingleMarkerData sample;
    protected Parameter alphaC;
    protected Parameter betaC;
    protected double[][] subtypeMkrLik;
    protected double[][] storedSubtypeMkrLik;
    protected SubTypeList subtypeSets;
    protected boolean updateAll;

    public ClusterLikelihood(){

    }

    public ClusterLikelihood(String label,
                             int[][][][] eltsAllPartSetList,
                             double[][] eltsAllPartSetPriorList,
                             SingleMarkerData sample,
                             Parameter alphaC,
                             Parameter betaC,
                             SubTypeList subtypeSets){
        super(label);
        this.eltsAllPartSetList = eltsAllPartSetList;
        this.eltsAllPartSetPriorList = eltsAllPartSetPriorList;
        this.sample = sample;
        this.alphaC = alphaC;
        this.betaC = betaC;
        this.subtypeSets = subtypeSets;
        subtypeMkrLik = new double[subtypeSets.getSubTypeMaxCount()][sample.getMarkerGroupCount()];
        storedSubtypeMkrLik = new double[subtypeSets.getSubTypeMaxCount()][sample.getMarkerGroupCount()];
        getLogLikelihood();
        updateAll = false;

    }

    public ClusterLikelihood(int[][][][] eltsAllPartSetList,
                             double[][] eltsAllPartSetPriorList,
                             SingleMarkerData sample,
                             Parameter alphaC,
                             Parameter betaC,
                             SubTypeList subtypeSets){
        this("typeLikelihood", eltsAllPartSetList, eltsAllPartSetPriorList, sample, alphaC, betaC, subtypeSets);


    }

    public ClusterLikelihood(int[][][][] eltsAllPartSetList,
                             double[][] eltsAllPartSetPriorList,
                             SingleMarkerData sample,
                             double[] alphaCValues,
                             double[] betaCValues,
                             SubTypeList subtypeSets){
        this("typeLikelihood", eltsAllPartSetList, eltsAllPartSetPriorList, sample,
                new Parameter("shape.a", alphaCValues, 0),
                new Parameter("shape.b", betaCValues, 0),
                subtypeSets);

    }






    public double[] calcIntAllPartsMkrGrpLik(int[][][] eltsAllPartSet,
                                                    SingleMarkerData sample,
                                                    int mkrGrpIndex,
                                                    double alphaC,
                                                    double betaC,
                                                    SubTypeList subtypeSets,
                                                    int subtypeIndex){
        return CalcIntAllPartsMkrGrpLik(eltsAllPartSet, sample, mkrGrpIndex,
                alphaC, betaC, subtypeSets, subtypeIndex);

    }


    public static double[] CalcIntAllPartsMkrGrpLik(int[][][] eltsAllPartSet,
                                                    SingleMarkerData sample,
                                                    int mkrGrpIndex,
                                                    double alphaC,
                                                    double betaC,
                                                    SubTypeList subtypeSets,
                                                    int subtypeIndex){

        int partCount = eltsAllPartSet.length;
        double priorBetaNC = Beta.logBeta(alphaC, betaC);

        int s, c;
        double logMarkerLik = 0.0;

        int[] nonZeros = new int[2];
        double[] partLikVec = new double[eltsAllPartSet.length];
        for(int partIndex = 0; partIndex < partCount; partIndex++){

            logMarkerLik = 0.0;

            for(int setIndex = 0; setIndex < eltsAllPartSet[partIndex].length; setIndex++){
                //System.out.println(partIndex + " "+ setIndex+" "+eltsAllPartSet[partIndex][setIndex]);


                //s = CalculateAmplifiedCount(sample, mkrGrpIndex, eltsAllPartSet[partIndex][setIndex], subtypeSets, subtypeIndex);
                nonZeros = CalculateAmplifiedCount(sample, mkrGrpIndex, eltsAllPartSet[partIndex][setIndex], subtypeSets, subtypeIndex);
                //c = subtypeSets.getSubTypeSetSize(subtypeIndex) * eltsAllPartSet[partIndex][setIndex].length;
                //logMarkerLik += Beta.logBeta(alphaC + s, betaC + c - s);
                logMarkerLik += Beta.logBeta(alphaC + nonZeros[1], betaC + nonZeros[0]);
                //System.out.println(alphaC + " "+ s +" "+betaC+" "+c);
                //System.out.println(Beta.logBeta(alphaC + s, betaC + c - s));


            }
            logMarkerLik -= eltsAllPartSet[partIndex].length*priorBetaNC;
            /*if(nonZeros[0] == 0 && nonZeros[1] ==0){
                System.out.println("missing:"+logMarkerLik);
            }else{
                System.out.println(logMarkerLik);
            }*/


            partLikVec[partIndex] = Math.exp(logMarkerLik);

        }

        return partLikVec;


    }

    protected static int[] CalculateAmplifiedCount(SingleMarkerData sample,
                                                 int mkrGrpIndex,
                                                 int[] set,
                                                 SubTypeList subtypeSets,
                                                 int subtypeIndex){
        int amplified = 0;
        int col;
        int mkrStatus;
        int missingCount = 0;
        int zeroCount = 0;
        int oneCount = 0;

        for(int colIndex = 0; colIndex < set.length; colIndex++){

            col = set[colIndex];


            for(int rowIndex = 0; rowIndex < subtypeSets.getSubTypeSetSize(subtypeIndex); rowIndex++){

                //System.out.println(rowIndex+" "+col+" "+sample.length+" "+subtypeIndexes.get(rowIndex));

                //amplified += sample[subtypeSets.getObs(subtypeIndex, rowIndex)][col];
                //System.out.println(subtypeIndex+" "+rowIndex);
                mkrStatus = sample.getData(mkrGrpIndex, subtypeSets.getObs(subtypeIndex, rowIndex), col);
                /*if(mkrStatus == -1){
                    missingCount++;
                }else{
                    amplified += mkrStatus;
                }*/
                if(mkrStatus == 0){
                    zeroCount++;
                }else if(mkrStatus == 1){
                    oneCount++;
                }

                //amplified += sample.getData(mkrGrpIndex, subtypeSets.getObs(subtypeIndex, rowIndex), col);
            }

        }
        //System.out.println(amplified+" "+set.length+" "+subtypeIndexes.size());
        //System.out.println(amplified+ " " + missingCount);

        return new int[]{zeroCount, oneCount};

    }


    /*private static int CalculateAmplifiedCount(SingleMarkerData sample,
                                               int mkrGrpIndex,
                                               int[] set,
                                               SubTypeList subtypeSets,
                                               int subtypeIndex){
        int amplified = 0;
        int col;

        for(int colIndex = 0; colIndex < set.length; colIndex++){

            col = set[colIndex];

            for(int rowIndex = 0; rowIndex < subtypeSets.getSubTypeSetSize(subtypeIndex); rowIndex++){

                //System.out.println(rowIndex+" "+col+" "+sample.length+" "+subtypeIndexes.get(rowIndex));

                //amplified += sample[subtypeSets.getObs(subtypeIndex, rowIndex)][col];
                //System.out.println(subtypeIndex+" "+rowIndex);

                amplified += sample.getData(mkrGrpIndex, subtypeSets.getObs(subtypeIndex, rowIndex), col);
            }

        }
        //System.out.println(amplified+" "+set.length+" "+subtypeIndexes.size());

        return amplified;

    }*/




    public double calcLogSubtypeLikelihood(int subtypeIndex){
        double logSubtypeLikelihood = 0.0;
        //System.out.println(subtypeIndex+" "+subtypeSets.isUpdated(subtypeIndex));

        double[] colPartLik;
        for(int mkrGrpIndex = 0; mkrGrpIndex < sample.getMarkerGroupCount(); mkrGrpIndex++){
            if(updateAll ||
                    alphaC.isUpdated(mkrGrpIndex) ||
                    betaC.isUpdated(mkrGrpIndex) ||
                    subtypeSets.isUpdated(subtypeIndex)){
                colPartLik = calcIntAllPartsMkrGrpLik(
                                eltsAllPartSetList[mkrGrpIndex],
                                sample,
                                mkrGrpIndex,
                                alphaC.getValue(mkrGrpIndex),
                                betaC.getValue(mkrGrpIndex),
                                subtypeSets,
                                subtypeIndex);
                subtypeMkrLik[subtypeIndex][mkrGrpIndex] = 0.0;

                //Iterate through all possible column partition configurations
                for(int partIndex = 0; partIndex < eltsAllPartSetList[mkrGrpIndex].length; partIndex++){

                    subtypeMkrLik[subtypeIndex][mkrGrpIndex] += eltsAllPartSetPriorList[mkrGrpIndex][partIndex]*colPartLik[partIndex];

                }

            }

            logSubtypeLikelihood += Math.log(subtypeMkrLik[subtypeIndex][mkrGrpIndex]);
            //System.out.println(Math.log(subtypeMkrLik[subtypeIndex][mkrGrpIndex]));

        }

        return logSubtypeLikelihood;


    }


    public static double CalcLogTypeLikelihood(int[][][][] eltsAllPartSetList,
                                               double[][] eltsAllPartSetPriorList,
                                               SingleMarkerData sample,
                                               double[] alphaC,
                                               double[] betaC,
                                               SubTypeList subtypeSets){
        ClusterLikelihood likelihood = new ClusterLikelihood(eltsAllPartSetList,
                eltsAllPartSetPriorList, sample, alphaC, betaC, subtypeSets);

        return(likelihood.getLogLikelihood());
    }

    public double getLogSubtypeLikelihoods(int setIndex){
        double temp = 0;
        for(int mkrIndex = 0; mkrIndex < subtypeMkrLik[setIndex].length; mkrIndex++){
            if(subtypeMkrLik[setIndex][mkrIndex] > 0){
                temp += Math.log(subtypeMkrLik[setIndex][mkrIndex]);

            }

        }
        return temp;
    }

    public void getLogSubtypeLikelihoods(double[] subtypeLikelihoods){

        for(int setIndex = 0; setIndex < subtypeLikelihoods.length; setIndex++){

            subtypeLikelihoods[setIndex] = 0;
            if(subtypeSets.getSubTypeSetSize(setIndex) > 0 ){
                for(int mkrIndex = 0; mkrIndex < subtypeMkrLik[setIndex].length; mkrIndex++){
                    if(subtypeMkrLik[setIndex][mkrIndex] > 0){
                        subtypeLikelihoods[setIndex] += Math.log(subtypeMkrLik[setIndex][mkrIndex]);

                    }
                }
            }
        }

    }



    public double getLogLikelihood(){
        logLikelihood = 0.0;

        for(int subtypeIndex = 0; subtypeIndex < subtypeSets.getSubTypeMaxCount(); subtypeIndex++){
            //System.out.println(subtypeIndex);
            //if(subtypeSets[subtypeIndex].size() > 0){
            //System.out.print(subtypeSets.getSubTypeSetSize(subtypeIndex)+" ");
            if(subtypeSets.getSubTypeSetSize(subtypeIndex) > 0){

                //logLikelihood += calcLogSubtypeLikelihood(eltsAllPartSetList,
                //        eltsAllPartSetPriorList, sample, alphaC, betaC, subtypeSets, subtypeIndex);

                logLikelihood += calcLogSubtypeLikelihood(subtypeIndex);
            }

        }

        return(logLikelihood);
    }

    public boolean isUpdated(){
        //System.out.println("alpha: "+alphaC.isUpdated());
        //System.out.println("beta: "+betaC.isUpdated());
        //System.out.println("subtype: "+subtypeSets.isUpdated());
        return (alphaC.isUpdated() || betaC.isUpdated() || subtypeSets.isUpdated());
    }

    public boolean isAllUpdated(){
        return updateAll;
    }

    public void setUpdateAll(boolean update){
        updateAll = update;
    }

    public void store(){
        storedLogLikelihood = logLikelihood;
        for(int typeIndex = 0; typeIndex < storedSubtypeMkrLik.length; typeIndex++){
            System.arraycopy(subtypeMkrLik[typeIndex], 0,
                    storedSubtypeMkrLik[typeIndex], 0,
                    subtypeMkrLik[typeIndex].length);
        }
        //System.out.println("stored-lik"+storedLogLikelihood);
        updateAll = false;

    }

    public void restore(){
        logLikelihood = storedLogLikelihood;
        double[][] tmp = subtypeMkrLik;
        subtypeMkrLik = storedSubtypeMkrLik;
        storedSubtypeMkrLik = tmp;
    }

    public String log(){
        return ""+ logLikelihood;
    }

    public String logStored(){
        return ""+ storedLogLikelihood;
    }
}
