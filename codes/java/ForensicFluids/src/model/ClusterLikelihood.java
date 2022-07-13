package model;

import state.Parameter;
import state.SubTypeList;
import data.SingleMarkerData;
import org.apache.commons.math3.special.Beta;

public class ClusterLikelihood implements Probability {

    private double logLikelihood;
    private double storedLogLikelihood;
    private int[][][][] eltsAllPartSetList;
    private double[][] eltsAllPartSetPriorList;
    private SingleMarkerData sample;
    private Parameter alphaC;
    private Parameter betaC;
    private double[][] subtypeMkrLik;
    private double[][] storedSubtypeMkrLik;
    private SubTypeList subtypeSets;
    public ClusterLikelihood(int[][][][] eltsAllPartSetList,
                             double[][] eltsAllPartSetPriorList,
                             SingleMarkerData sample,
                             Parameter alphaC,
                             Parameter betaC,
                             SubTypeList subtypeSets){
        this.eltsAllPartSetList = eltsAllPartSetList;
        this.eltsAllPartSetPriorList = eltsAllPartSetPriorList;
        this.sample = sample;
        this.alphaC = alphaC;
        this.betaC = betaC;
        this.subtypeSets = subtypeSets;
        subtypeMkrLik = new double[subtypeSets.getSubTypeMaxCount()][sample.getMarkerGroupCount()];
        storedSubtypeMkrLik = new double[subtypeSets.getSubTypeMaxCount()][sample.getMarkerGroupCount()];
        getLogLikelihood();

    }

    public ClusterLikelihood(int[][][][] eltsAllPartSetList,
                             double[][] eltsAllPartSetPriorList,
                             SingleMarkerData sample,
                             double[] alphaCValues,
                             double[] betaCValues,
                             SubTypeList subtypeSets){
        this(eltsAllPartSetList, eltsAllPartSetPriorList, sample,
                new Parameter("shape.a", alphaCValues, 0),
                new Parameter("shape.b", betaCValues, 0),
                subtypeSets);

    }






    public static double[] CalcIntAllPartsMkrGrpLik(int[][][] eltsAllPartSet,
                                                    SingleMarkerData sample,
                                                    int mkrGrpIndex,
                                                    double alphaC,
                                                    double betaC,
                                                    SubTypeList subtypeSets,
                                                    int subtypeIndex){

        int partCount = eltsAllPartSet.length;

        int s, c;
        double logMarkerLik = 0.0;

        double[] partLikVec = new double[eltsAllPartSet.length];
        for(int partIndex = 0; partIndex < partCount; partIndex++){

            logMarkerLik = 0.0;

            for(int setIndex = 0; setIndex < eltsAllPartSet[partIndex].length; setIndex++){
                //System.out.println(partIndex + " "+ setIndex+" "+eltsAllPartSet[partIndex][setIndex]);


                s = CalculateAmplifiedCount(sample, mkrGrpIndex, eltsAllPartSet[partIndex][setIndex], subtypeSets, subtypeIndex);
                c = subtypeSets.getSubTypeSetSize(subtypeIndex) * eltsAllPartSet[partIndex][setIndex].length;
                logMarkerLik += Beta.logBeta(alphaC + s, betaC + c - s);
                //System.out.println(alphaC + " "+ s +" "+betaC+" "+c);
                //System.out.println(Beta.logBeta(alphaC + s, betaC + c - s));


            }


            partLikVec[partIndex] = Math.exp(logMarkerLik);
            //System.out.println(partLikVec[partIndex]);
        }

        return partLikVec;


    }


    private static int CalculateAmplifiedCount(SingleMarkerData sample,
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

    }




    public double calcLogSubtypeLikelihood(int subtypeIndex){
        double logSubtypeLikelihood = 0.0;
        //System.out.println(subtypeIndex+" "+subtypeSets.isUpdated(subtypeIndex));

        double[] colPartLik;
        for(int mkrGrpIndex = 0; mkrGrpIndex < sample.getMarkerGroupCount(); mkrGrpIndex++){
            if(alphaC.isUpdated(mkrGrpIndex) || betaC.isUpdated(mkrGrpIndex) || subtypeSets.isUpdated(subtypeIndex)){
                colPartLik =
                        CalcIntAllPartsMkrGrpLik(
                                eltsAllPartSetList[mkrGrpIndex],
                                sample,
                                mkrGrpIndex,
                                alphaC.getValue(mkrGrpIndex),
                                betaC.getValue(mkrGrpIndex),
                                subtypeSets,
                                subtypeIndex);
                subtypeMkrLik[subtypeIndex][mkrGrpIndex] = 0.0;
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



    public double getLogLikelihood(){
        logLikelihood = 0.0;

        for(int subtypeIndex = 0; subtypeIndex < subtypeSets.getSubTypeMaxCount(); subtypeIndex++){
            //System.out.println(subtypeIndex);
            //if(subtypeSets[subtypeIndex].size() > 0){
            if(subtypeSets.getSubTypeSetSize(subtypeIndex) > 0){

                //logLikelihood += calcLogSubtypeLikelihood(eltsAllPartSetList,
                //        eltsAllPartSetPriorList, sample, alphaC, betaC, subtypeSets, subtypeIndex);

                logLikelihood += calcLogSubtypeLikelihood(subtypeIndex);
            }

        }

        return(logLikelihood);
    }

    public void store(){
        storedLogLikelihood = logLikelihood;
        for(int typeIndex = 0; typeIndex < storedSubtypeMkrLik.length; typeIndex++){
            System.arraycopy(subtypeMkrLik[typeIndex], 0,
                    storedSubtypeMkrLik[typeIndex], 0,
                    subtypeMkrLik[typeIndex].length);
        }

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
