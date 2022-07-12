package model;
import state.TypeList;


public class CompoundClusterPrior implements Likelihood{

    private double[] logSingleTypePriors;
    private double[] storedLogSingleTypePriors;
    private double logMultiTypePrior;
    private double storedLogMultiTypePrior;
    private double alpha;
    private int setCountMax;
    private int[] singleTypeTotalObsCounts;
    private TypeList setLists;

    public CompoundClusterPrior(double alpha, int setCountMax, int[] singleTypeTotalObsCounts, TypeList setLists){
        this.alpha = alpha;
        this.setCountMax = setCountMax;
        this.singleTypeTotalObsCounts = singleTypeTotalObsCounts;
        this.setLists = setLists;
        logSingleTypePriors = new double[setLists.getTypeCount()];
        storedLogSingleTypePriors = new double[logSingleTypePriors.length];
    }
    public double calcLogMDPDensity(){

        logMultiTypePrior = 0.0;

        for(int typeIndex = 0; typeIndex < setLists.getTypeCount(); typeIndex++){
            logSingleTypePriors[typeIndex] = ClusterPrior.calcLogMDPDensity(alpha, setCountMax,
                    setLists.getSubTypeList(typeIndex), singleTypeTotalObsCounts[typeIndex]);
            logMultiTypePrior += logSingleTypePriors[typeIndex];

        }

        return logMultiTypePrior;

    }

    public String log(){
        return ""+ logMultiTypePrior;
    }

    public String logStored(){
        return "" + storedLogMultiTypePrior;
    }

    public double getLogLikelihood(){
        return calcLogMDPDensity();
    }

    public void store(){
        storedLogMultiTypePrior = logMultiTypePrior;
        System.arraycopy(logSingleTypePriors, 0,
                storedLogSingleTypePriors, 0,
                logSingleTypePriors.length);
    }

    public void restore(){
        logMultiTypePrior = storedLogMultiTypePrior;
        double[] tmp = logSingleTypePriors;
        logSingleTypePriors = storedLogSingleTypePriors;
        storedLogSingleTypePriors = tmp;
    }
}
