package model;
import cluster.TypeList;


public class CompoundClusterPrior {

    private double[] logSingleTypePriors;
    private double[] storedLogSingleTypePriors;
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
    public  double calcLogMDPDensity(){

        double logMDP = 0.0;

        for(int typeIndex = 0; typeIndex < setLists.getTypeCount(); typeIndex++){
            logSingleTypePriors[typeIndex] = ClusterPrior.calcLogMDPDensity(alpha, setCountMax,
                    setLists.getSubTypeList(typeIndex), singleTypeTotalObsCounts[typeIndex]);
            logMDP += logSingleTypePriors[typeIndex];

        }

        return logMDP;

    }

    public void store(){
        System.arraycopy(logSingleTypePriors, 0,
                storedLogSingleTypePriors, 0,
                logSingleTypePriors.length);
    }

    public void restore(){
        double[] tmp = logSingleTypePriors;
        logSingleTypePriors = storedLogSingleTypePriors;
        storedLogSingleTypePriors = tmp;
    }
}
