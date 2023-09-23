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
                                              Parameter alphaC, // a specific to fluid type of interest
                                              Parameter betaC){ // b specific to fluid type of interest
        int markerGrpCount  = sample.getMarkerGroupCount();
        int partitionSize = -1;


        double[][][] betaTable = new double[markerGrpCount][][];
        for(int groupIndex = 0; groupIndex < betaTable.length; groupIndex++){

            betaTable[groupIndex] = new double[sample.getMarkerCount(groupIndex)][];

            // partSizeIndex + 1 is the column partition size (# markers in a partition) of interest
            for(int partSizeIndex = 0; partSizeIndex < betaTable[groupIndex].length; partSizeIndex++){
                partitionSize = partSizeIndex + 1;

                // partSizeIndex + 2 is the column partition size + 1,
                // because the number of 1's in a partition be 0, ..., partition size (= partSizeIndex + 1).
                betaTable[groupIndex][partSizeIndex] = new double[partitionSize + 1];

                // Iterate through all possible counts of 1's
                // betaTable[groupIndex][partSizeIndex].length = partition size + 1 (= partSizeIndex + 2)
                // so oneCount iterates through 0, ..., partition size
                for(int oneCount = 0; oneCount < betaTable[groupIndex][partSizeIndex].length; oneCount++){

                    // Calculate the log beta function, i.e., log(Beta(a + #1's, b + #0's))
                    betaTable[groupIndex][partSizeIndex][oneCount] = Beta.logBeta(
                            alphaC.getValue(groupIndex) + oneCount, //a + #1's
                            betaC.getValue(groupIndex) + partitionSize - oneCount); //b + #0's
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

        // The number of the possible column partitions given a marker group
        int partCount = eltsAllPartSet.length;
        // Constant a and b for a given fluid type and marker group
        double priorBetaNC = Beta.logBeta(alphaC, betaC);
        double logMarkerLik;

        // # Rows in the subtype k of fluid type f, i.e., |R_{f(k)}|
        int subtypeSize = subtypeSets.getSubTypeSetSize(subtypeIndex);

        int[] zeroAndOnes;
        double[] partLikVec = new double[partCount];

        // Iterate through all possible column partition configurations given a marker group
        for(int partIndex = 0; partIndex < partCount; partIndex++){

            logMarkerLik = 0.0;

            // Calculate the numerator product:
            // Given a partition configuration, we iterate through each set,
            // i.e., column subgroup, in that partition configuration.
            for(int setIndex = 0; setIndex < eltsAllPartSet[partIndex].length; setIndex++){

                // Given the column subgroup of current column partition configuration,
                // iterate through each row, i.e., rna profile.
                for(int rowIndex = 0; rowIndex < subtypeSize; rowIndex++){

                    // Count the number of 0's & 1's for current profile,
                    // given the current column subgroup of current column partition configuration
                    zeroAndOnes = CalculateAmplifiedCountPerProfile(
                            sample,
                            mkrGrpIndex,
                            eltsAllPartSet[partIndex][setIndex], // column indices of the current column subgroup
                            subtypeSets.getObs(subtypeIndex, rowIndex)); //The row index in the data for fluid type f


                    // Numerator of the fraction of the beta function,
                    // which is the likelihood for the current profile,
                    // of the current column subgroup, given the current
                    // column- and the row partitions (subtype clustering).
                    logMarkerLik += betaTable[mkrGrpIndex][zeroAndOnes[0] + zeroAndOnes[1] - 1][zeroAndOnes[1]];


                }


            }

            // Calculate the denominator product:
            logMarkerLik -= subtypeSize*eltsAllPartSet[partIndex].length*priorBetaNC;

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

        // Iterating through the column indices (i.e., in the array set)
        // (of the column subgroup of interest).
        for(int colIndex = 0; colIndex < set.length; colIndex++){

            col = set[colIndex];
            // Get the binary entry value in the matrix
            mkrStatus = sample.getData(
                    mkrGrpIndex, // which marker group
                    obsIndex, // which profile
                    col); // which marker conditioned on the marker group

            // As we account for missing values
            // both 0's and 1' need to be counted explicitly.
            if(mkrStatus == 0){
                    zeroCount++;
            }else if(mkrStatus == 1){
                    oneCount++;
            }

        }

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
