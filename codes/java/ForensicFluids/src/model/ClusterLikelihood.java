package model;

import org.apache.commons.math3.special.Beta;
import org.apache.commons.math3.special.Gamma;

import java.util.ArrayList;

public class ClusterLikelihood {
    public static double[] CalcIntAllPartsMkrGrpLik(int[][][] eltsAllPartSet,
                                              int[][] sample,
                                              double alphaC,
                                              double betaC,
                                              ArrayList<Integer> subtypeIndexes){

        int partCount = eltsAllPartSet.length;

        int s, c;
        double logMarkerLik = 0.0;

        double[] partLikVec = new double[eltsAllPartSet.length];
        for(int partIndex = 0; partIndex < partCount; partIndex++){

            logMarkerLik = 0.0;

            for(int setIndex = 0; setIndex < eltsAllPartSet[partIndex].length; setIndex++){

                s = CalculateAmplifiedCount(sample, eltsAllPartSet[partIndex][setIndex], subtypeIndexes);
                c = subtypeIndexes.size() * eltsAllPartSet[partIndex][setIndex].length;
                logMarkerLik += Beta.logBeta(alphaC + s, betaC + c - s);
                //System.out.println(alphaC + " "+ s +" "+betaC+" "+c);
                //System.out.println(Beta.logBeta(alphaC + s, betaC + c - s));


            }


            partLikVec[partIndex] = Math.exp(logMarkerLik);
            //System.out.println(partLikVec[partIndex]);
        }

        return partLikVec;


    }

    private static int CalculateAmplifiedCount(int[][] sample, int[] set, ArrayList<Integer> subtypeIndexes){
        int amplified = 0;
        int col;

        for(int colIndex = 0; colIndex < set.length; colIndex++){

            col = set[colIndex];

            for(int rowIndex = 0; rowIndex < subtypeIndexes.size(); rowIndex++){

                //System.out.println(rowIndex+" "+col+sample.length+" "+subtypeIndexes.get(rowIndex));

                amplified += sample[subtypeIndexes.get(rowIndex)][col];
            }

        }
        //System.out.println(amplified+" "+set.length+" "+subtypeIndexes.size());

        return amplified;

    }

    public static double CalcLogSubtypeLikelihood(int[][][][] eltsAllPartSetList,
                                                  double[][] eltsAllPartSetPriorList,
                                                  int[][][] sample,
                                                  double[] alphaC,
                                                  double[] betaC,
                                                  ArrayList<Integer> subtypeIndexes){
        double logSubtypeLikelihood = 0.0;

        for(int mkrGrpIndex = 0; mkrGrpIndex < sample.length; mkrGrpIndex++){
            double[] colPartLik =
                    CalcIntAllPartsMkrGrpLik(
                            eltsAllPartSetList[mkrGrpIndex],
                            sample[mkrGrpIndex],
                            alphaC[mkrGrpIndex],
                            betaC[mkrGrpIndex],
                            subtypeIndexes);

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
                                               int[][][] sample,
                                               double[] alphaC,
                                               double[] betaC,
                                               ArrayList<Integer>[] subtypeSets){
        double logTypeLikelihood = 0.0;

        for(int subtypeIndex = 0; subtypeIndex < subtypeSets.length; subtypeIndex++){
            //System.out.println(subtypeIndex);
            if(subtypeSets[subtypeIndex].size() > 0){
                logTypeLikelihood += CalcLogSubtypeLikelihood(eltsAllPartSetList,
                        eltsAllPartSetPriorList, sample, alphaC, betaC, subtypeSets[subtypeIndex]);
            }

        }

        return(logTypeLikelihood);
    }
}
