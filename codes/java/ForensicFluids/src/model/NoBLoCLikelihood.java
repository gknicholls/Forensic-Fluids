package model;

import data.SingleMarkerData;
import org.apache.commons.math3.special.Beta;
import state.Parameter;
import state.SubTypeList;

public class NoBLoCLikelihood extends ClusterLikelihood {


    private double[][][] betaTable;

    public NoBLoCLikelihood(String label,
                            int[][][][] eltsAllPartSetList,
                            double[][] eltsAllPartSetPriorList,
                            SingleMarkerData sample,
                            Parameter alphaC,
                            Parameter betaC,
                            SubTypeList subtypeSets){
        super(label, eltsAllPartSetList, eltsAllPartSetPriorList,
                sample, alphaC, betaC, subtypeSets);
        setup();


    }


    public NoBLoCLikelihood(int[][][][] eltsAllPartSetList,
                            double[][] eltsAllPartSetPriorList,
                            SingleMarkerData sample,
                            Parameter alphaC,
                            Parameter betaC,
                            SubTypeList subtypeSets){
        this.label = label;
        this.eltsAllPartSetList = eltsAllPartSetList;
        this.eltsAllPartSetPriorList = eltsAllPartSetPriorList;
        this.sample = sample;
        this.alphaC = alphaC;
        this.betaC = betaC;
        this.subtypeSets = subtypeSets;
        subtypeMkrLik = new double[subtypeSets.getSubTypeMaxCount()][sample.getMarkerGroupCount()];
        storedSubtypeMkrLik = new double[subtypeSets.getSubTypeMaxCount()][sample.getMarkerGroupCount()];

        setup();
        getLogLikelihood();
        updateAll = false;


    }

    private void setup(){
        betaTable = setupBetaTable(sample, alphaC, betaC);

    }

    public static double[][][] setupBetaTable(SingleMarkerData sample,
                                            Parameter alphaC,
                                            Parameter betaC){
        int markerGrpCount  = sample.getMarkerGroupCount();

        int maxGroupSize = sample.getMarkerCount(0);
        int temp;
        for(int groupIndex = 1; groupIndex < markerGrpCount; groupIndex++){
            temp = sample.getMarkerCount(groupIndex);
            if(maxGroupSize < temp){
                maxGroupSize = temp;
            }

        }

        double[][][] betaTable = new double[markerGrpCount][maxGroupSize][];
        for(int groupIndex = 0; groupIndex < betaTable.length; groupIndex++){
            for(int i = 0; i < betaTable[groupIndex].length; i++){
                betaTable[groupIndex][i] = new double[i + 2];
                for(int j = 0; j < betaTable[groupIndex][i].length; j++){
                    //System.out.println(groupIndex+" " + (i+1) +" "+j);
                    betaTable[groupIndex][i][j] = Beta.logBeta(
                            alphaC.getValue(groupIndex) + j,
                            betaC.getValue(groupIndex) + i + 1 - j);
                }

            }
        }




        return betaTable;
    }

    public NoBLoCLikelihood(int[][][][] eltsAllPartSetList,
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








    public static double[] calcNoBLoCIntAllPartsMkrGrpLik(int[][][] eltsAllPartSet,
                                                          SingleMarkerData sample,
                                                          int mkrGrpIndex,
                                                          double alphaC,
                                                          double betaC,
                                                          SubTypeList subtypeSets,
                                                          int subtypeIndex,
                                                          double[][][] betaTable){

        int partCount = eltsAllPartSet.length;
        double priorBetaNC = Beta.logBeta(alphaC, betaC);
        double logMarkerLik;

        int subtypeSize = subtypeSets.getSubTypeSetSize(subtypeIndex);

        int[] nonZeros;
        double[] partLikVec = new double[eltsAllPartSet.length];
        for(int partIndex = 0; partIndex < partCount; partIndex++){
            //System.out.print("colPart: "+partIndex+" ");

            logMarkerLik = 0.0;

            for(int setIndex = 0; setIndex < eltsAllPartSet[partIndex].length; setIndex++){
                //System.out.println("set: "+setIndex+" ");


                for(int rowIndex = 0; rowIndex < subtypeSize; rowIndex++){
                    nonZeros = CalculateAmplifiedCountPerProfile(
                            sample,
                            mkrGrpIndex,
                            eltsAllPartSet[partIndex][setIndex],
                            subtypeSets.getObs(subtypeIndex, rowIndex));
                    //double temp1 = Beta.logBeta(alphaC + nonZeros[1], betaC + nonZeros[0]);
                    //double temp2 = betaTable[mkrGrpIndex][nonZeros[0] + nonZeros[1]-1][nonZeros[1]];
                    /*if(temp1 - temp2 > 1e-10){
                        System.out.println("mkrGrpIndex: "+ mkrGrpIndex+
                                ", nonZeros[0]: " + nonZeros[0]+" "+
                                ", nonZeros[1]: " + nonZeros[1]+" "+
                                " alphaC: "+ alphaC+", betaC: "+ betaC+" "+
                                betaTable[mkrGrpIndex][nonZeros[0] + nonZeros[1]][nonZeros[1]]+ " " +
                                Beta.logBeta(alphaC + nonZeros[1], betaC + nonZeros[0]) +" "+
                                (Beta.logBeta(alphaC + nonZeros[1], betaC + nonZeros[0]) -
                                        betaTable[mkrGrpIndex][nonZeros[0] + nonZeros[1] - 1][nonZeros[1]]));
                        throw new RuntimeException(temp1 + " " + temp2);
                    }
                    System.out.println(betaTable[mkrGrpIndex].length);
                    System.out.println(betaTable[mkrGrpIndex][nonZeros[0] + nonZeros[1] - 1].length+" "+ (nonZeros[0] + nonZeros[1]));

                    System.out.println(betaTable[mkrGrpIndex][nonZeros[0] + nonZeros[1] - 1][nonZeros[1]]);*/
                    logMarkerLik += betaTable[mkrGrpIndex][nonZeros[0] + nonZeros[1]-1][nonZeros[1]];
                    //System.out.println(Beta.logBeta(alphaC + nonZeros[1], betaC + nonZeros[0]));
                    /*System.out.println("mkrGrpIndex: "+ mkrGrpIndex+
                            ", nonZeros[0]: " + nonZeros[0]+" "+
                            ", nonZeros[1]: " + nonZeros[1]+" "+
                            " alphaC: "+ alphaC+", betaC: "+ betaC+" "+
                            betaTable[mkrGrpIndex][nonZeros[0] + nonZeros[1]][nonZeros[1]]+ " " +
                            Beta.logBeta(alphaC + nonZeros[1], betaC + nonZeros[0]) +" "+
                    (Beta.logBeta(alphaC + nonZeros[1], betaC + nonZeros[0]) -
                            betaTable[mkrGrpIndex][nonZeros[0] + nonZeros[1] - 1][nonZeros[1]]));*/


                }


            }
            logMarkerLik -= subtypeSize*eltsAllPartSet[partIndex].length*priorBetaNC;
            //System.out.println(logMarkerLik);



            partLikVec[partIndex] = Math.exp(logMarkerLik);

        }

        return partLikVec;


    }

    private static int[] CalculateAmplifiedCountPerProfile(SingleMarkerData sample,
                                                 int mkrGrpIndex,
                                                 int[] set,
                                                 int obsIndex){
        int col;
        int mkrStatus;
        int zeroCount = 0;
        int oneCount = 0;

        for(int colIndex = 0; colIndex < set.length; colIndex++){

            col = set[colIndex];
            mkrStatus = sample.getData(mkrGrpIndex, obsIndex, col);
            //System.out.print(mkrStatus+" ");
            // As we account for missing values
            // both 0's and 1' need to be counted explicitly.
            if(mkrStatus == 0){
                    zeroCount++;
            }else if(mkrStatus == 1){
                    oneCount++;
            }

        }
        //System.out.println();



        return new int[]{zeroCount, oneCount};

    }

    public double[] calcIntAllPartsMkrGrpLik(int[][][] eltsAllPartSet,
                                             SingleMarkerData sample,
                                             int mkrGrpIndex,
                                             double alphaC,
                                             double betaC,
                                             SubTypeList subtypeSets,
                                             int subtypeIndex){

        return calcNoBLoCIntAllPartsMkrGrpLik(eltsAllPartSet, sample, mkrGrpIndex,
                alphaC, betaC, subtypeSets, subtypeIndex, betaTable);

    }








    /*public double getLogLikelihood(){
        if(!isUpdated()){
            return logLikelihood;
        }
        logLikelihood = 0.0;

        for(int subtypeIndex = 0; subtypeIndex < subtypeSets.getSubTypeMaxCount(); subtypeIndex++){
            //System.out.println("subtype: "+ subtypeIndex);
            //if(subtypeSets[subtypeIndex].size() > 0){
            //System.out.print(subtypeSets.getSubTypeSetSize(subtypeIndex)+" ");
            if(subtypeSets.getSubTypeSetSize(subtypeIndex) > 0){

                //logLikelihood += calcLogSubtypeLikelihood(eltsAllPartSetList,
                //        eltsAllPartSetPriorList, sample, alphaC, betaC, subtypeSets, subtypeIndex);

                logLikelihood += calcLogSubtypeLikelihood(subtypeIndex);

            }

        }

        return(logLikelihood);
    }*/






}
