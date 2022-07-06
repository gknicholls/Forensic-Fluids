package model;

import cluster.SubTypeList;
import data.CompoundMarkerData;
import data.SingleMarkerData;
import org.apache.commons.math3.special.Beta;

import java.util.ArrayList;

public class NewClusterLikelihood implements Likelihood {

    private double logLikelihood;
    private double storedLogLikelihood;
    private int[][][][] eltsAllPartSetList;
    private double[][] eltsAllPartSetPriorList;
    private SingleMarkerData sample;
    private double[] alphaC;
    private double[] betaC;
    private SubTypeList subtypeSets;
    public NewClusterLikelihood(int[][][][] eltsAllPartSetList,
                                double[][] eltsAllPartSetPriorList,
                                SingleMarkerData sample,
                                double[] alphaC,
                                double[] betaC,
                                SubTypeList subtypeSets){
        this.eltsAllPartSetList = eltsAllPartSetList;
        this.eltsAllPartSetPriorList = eltsAllPartSetPriorList;
        this.sample = sample;
        this.alphaC = alphaC;
        this.betaC = betaC;
        this.subtypeSets = subtypeSets;


    }

    public double getLogLikelihood(){
       logLikelihood = CalcLogTypeLikelihood(eltsAllPartSetList, eltsAllPartSetPriorList, sample,
               alphaC, betaC, subtypeSets);
        return logLikelihood;
    }

    public void store(){
        storedLogLikelihood = logLikelihood;
    }

    public void restore(){
        logLikelihood = storedLogLikelihood;
    }

    public String log(){
        return ""+ logLikelihood;
    }

    public String logStored(){
        return ""+ storedLogLikelihood;
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
                amplified += sample.getData(mkrGrpIndex, subtypeSets.getObs(subtypeIndex, rowIndex), col);
            }

        }
        //System.out.println(amplified+" "+set.length+" "+subtypeIndexes.size());

        return amplified;

    }




    public static double CalcLogSubtypeLikelihood(int[][][][] eltsAllPartSetList,
                                                  double[][] eltsAllPartSetPriorList,
                                                  SingleMarkerData sample,
                                                  double[] alphaC,
                                                  double[] betaC,
                                                  SubTypeList subtypeSets,
                                                  int subtypeIndex){
        double logSubtypeLikelihood = 0.0;

        for(int mkrGrpIndex = 0; mkrGrpIndex < sample.getMarkerGroupCount(); mkrGrpIndex++){
            double[] colPartLik =
                    CalcIntAllPartsMkrGrpLik(
                            eltsAllPartSetList[mkrGrpIndex],
                            sample,
                            mkrGrpIndex,
                            alphaC[mkrGrpIndex],
                            betaC[mkrGrpIndex],
                            subtypeSets,
                            subtypeIndex);

            double subtypeMkrGrpLik = 0.0;
            for(int partIndex = 0; partIndex < eltsAllPartSetList[mkrGrpIndex].length; partIndex++){

                //System.out.println(eltsAllPartSetPriorList[mkrGrpIndex][partIndex]);
                //System.out.println(colPartLik[partIndex]);

                subtypeMkrGrpLik += eltsAllPartSetPriorList[mkrGrpIndex][partIndex]*colPartLik[partIndex];


            }

            logSubtypeLikelihood += Math.log(subtypeMkrGrpLik);


        }

        return logSubtypeLikelihood;


    }



    public static double CalcLogTypeLikelihood(int[][][][] eltsAllPartSetList,
                                               double[][] eltsAllPartSetPriorList,
                                               SingleMarkerData sample,
                                               double[] alphaC,
                                               double[] betaC,
                                               SubTypeList subtypeSets){
        double logTypeLikelihood = 0.0;

        for(int subtypeIndex = 0; subtypeIndex < subtypeSets.getSubTypeMaxCount(); subtypeIndex++){
            //System.out.println(subtypeIndex);
            //if(subtypeSets[subtypeIndex].size() > 0){
            if(subtypeSets.getSubTypeSetSize(subtypeIndex) > 0){
                logTypeLikelihood += CalcLogSubtypeLikelihood(eltsAllPartSetList,
                        eltsAllPartSetPriorList, sample, alphaC, betaC, subtypeSets, subtypeIndex);
            }

        }

        return(logTypeLikelihood);
    }
}
