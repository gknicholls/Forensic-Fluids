package model;

import org.apache.commons.math3.special.Gamma;

import java.util.ArrayList;
import java.util.List;

public class ClusterPrior {
    public static double CalcLogMDPDensity(double alpha,
                                         int setCountMax,
                                         List<ArrayList<Integer>> setList,
                                           int totalObsCount){


        int setCount = setList.size();
        double frac1 = Gamma.logGamma(alpha) - setCount*Gamma.logGamma(alpha/setCountMax);
        double frac2 = Gamma.logGamma(setCountMax + 1) - Gamma.logGamma(setCountMax - setCount + 1);
        double frac3 = 0.0;
        for(int setIndex = 0; setIndex < setCount; setIndex++){
            frac3 += Gamma.logGamma(alpha/setCountMax + setList.get(setIndex).size());
        }
        frac3 -= Gamma.logGamma(alpha + totalObsCount);
        double logMDP = frac1 + frac2 + frac3;

        return logMDP;

    }

    public static double CalcMDPDensity(double alpha,
                                        int setCountMax,
                                        List<ArrayList<Integer>> setList,
                                        int totalObsCount){

        double mdpProb = Math.exp(CalcLogMDPDensity(alpha, setCountMax, setList, totalObsCount));

        return mdpProb;

    }


    public static double CalcLogMDPDensity(double alpha,
                                           int setCountMax,
                                           int[][] setList,
                                           int totalObsCount){


        int setCount = setList.length;
        double frac1 = Gamma.logGamma(alpha) - setCount*Gamma.logGamma(alpha/setCountMax);
        double frac2 = Gamma.logGamma(setCountMax + 1) - Gamma.logGamma(setCountMax - setCount + 1);
        double frac3 = 0.0;

        for(int setIndex = 0; setIndex < setCount; setIndex++){
            frac3 += Gamma.logGamma(alpha/setCountMax + setList[setIndex].length);
        }


        frac3 -= Gamma.logGamma(alpha + totalObsCount);

        double logMDP = frac1 + frac2 + frac3;

        return logMDP;

    }

    public static double CalcMDPDensity(double alpha,
                                        int setCountMax,
                                        int[][] setList,
                                        int totalObsCount){

        double mdpProb = Math.exp(CalcLogMDPDensity(alpha, setCountMax, setList, totalObsCount));

        return mdpProb;

    }


}
