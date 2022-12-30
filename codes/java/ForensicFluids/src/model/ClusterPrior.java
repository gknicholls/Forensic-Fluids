package model;

import state.SubTypeList;
import org.apache.commons.math3.special.Gamma;

import java.util.ArrayList;
import java.util.List;

public class ClusterPrior extends AbstractProbability {

    private double alpha;
    private int setCountMax;
    private SubTypeList setList;
    private int totalObsCount;
    private double logPrior;
    private double storedLogPrior;
    public ClusterPrior(String label,
                        double alpha,
                        int setCountMax,
                        SubTypeList setList,
                        int totalObsCount){
        super(label);
        this.alpha = alpha;
        this.setCountMax = setCountMax;
        this.setList = setList;
        this.totalObsCount = totalObsCount;

    }

    public ClusterPrior(double alpha,
                        int setCountMax,
                        SubTypeList setList,
                        int totalObsCount){
        this("MDP.prior", alpha, setCountMax, setList, totalObsCount);

    }

    public double getLogLikelihood(){
        logPrior = calcLogMDPDensity(alpha, setCountMax, setList, totalObsCount);
        return logPrior;
    }

    public void store(){
        storedLogPrior = logPrior;
    }

    public void restore(){
        logPrior = storedLogPrior;
    }

    public String log(){
        return ""+ logPrior;
    }

    public String logStored(){
        return ""+ storedLogPrior;
    }

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

    public static double calcLogMDPDensity(double alpha,
                                           int setCountMax,
                                           int[] setSizes,
                                           int totalObsCount){


        int setCount = 0;
        for(int setIndex = 0; setIndex < setSizes.length; setIndex++){
            if(setSizes[setIndex] > 0){
                setCount++;
            }
        }
        double frac1 = Gamma.logGamma(alpha) - setCount*Gamma.logGamma(alpha/setCountMax);
        double frac2 = Gamma.logGamma(setCountMax + 1) - Gamma.logGamma(setCountMax - setCount + 1);
        double frac3 = 0.0;
        for(int setIndex = 0; setIndex < setCountMax; setIndex++){
            if(setSizes[setIndex] > 0) {
                frac3 += Gamma.logGamma(alpha / setCountMax + setSizes[setIndex]);
            }
        }
        frac3 -= Gamma.logGamma(alpha + totalObsCount);
        double logMDP = frac1 + frac2 + frac3;

        return logMDP;

    }

    public static double calcLogMDPDensity(double alpha,
                                           int setCountMax,
                                           ArrayList<Integer>[] setList,
                                           int totalObsCount){


        int setCount = 0;
        for(int setIndex = 0; setIndex < setList.length; setIndex++){
            if(setList[setIndex].size() > 0){
                setCount++;
            }
        }
        double frac1 = Gamma.logGamma(alpha) - setCount*Gamma.logGamma(alpha/setCountMax);
        double frac2 = Gamma.logGamma(setCountMax + 1) - Gamma.logGamma(setCountMax - setCount + 1);
        double frac3 = 0.0;
        for(int setIndex = 0; setIndex < setCountMax; setIndex++){
            if(setList[setIndex].size() > 0) {
                frac3 += Gamma.logGamma(alpha / setCountMax + setList[setIndex].size());
            }
        }
        frac3 -= Gamma.logGamma(alpha + totalObsCount);
        double logMDP = frac1 + frac2 + frac3;

        return logMDP;

    }


    public static double calcLogMDPDensity(double alpha,
                                           int setCountMax,
                                           SubTypeList setList,
                                           int totalObsCount){


        int setCount = 0;

        for(int setIndex = 0; setIndex < setList.getSubTypeMaxCount(); setIndex++){
            //if(setList[setIndex].size() > 0){
            if(setList.getSubTypeSetSize(setIndex) > 0){
                setCount++;
            }
        }
        //System.out.println("setCount = "+setCount );
        double frac1 = Gamma.logGamma(alpha) - setCount*Gamma.logGamma(alpha/setCountMax);
        double frac2 = Gamma.logGamma(setCountMax + 1) - Gamma.logGamma(setCountMax - setCount + 1);
        double frac3 = 0.0;
        for(int setIndex = 0; setIndex < setCountMax; setIndex++){
            //if(setList[setIndex].size() > 0) {
            if(setList.getSubTypeSetSize(setIndex) > 0){
                //System.out.println("frac3 calc1 = "+ alpha+" "+setCountMax+" "+setList.getSubTypeSetSize(setIndex));
                frac3 += Gamma.logGamma(alpha / setCountMax + setList.getSubTypeSetSize(setIndex));
            }
        }
        frac3 -= Gamma.logGamma(alpha + totalObsCount);
        //System.out.println("frac3 calc2 = "+ alpha+" "+totalObsCount);
        double logMDP = frac1 + frac2 + frac3;

        //System.out.println("frac1="+frac1+", frac2="+frac2+", frac3="+frac3);

        return logMDP;

    }


    public static double CalcLogMDPDensity(double alpha,
                                           int setCountMax,
                                           int[][] setList,
                                           int totalObsCount){



        int setCount = setList.length;
        //System.out.println("setCount = "+setCount );
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

    public double getAlpha(){
        return alpha;
    }




}
