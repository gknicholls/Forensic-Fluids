package model;
import state.TypeList;


public class CompoundClusterPrior extends AbstractProbability {

    private double[] logSingleTypePriors;
    private double[] storedLogSingleTypePriors;
    private double logMultiTypePrior;
    private double storedLogMultiTypePrior;
    private double alpha;
    private int setCountMax;
    private int[] singleTypeTotalObsCounts;
    private TypeList setLists;

    public CompoundClusterPrior(String label,
                                double alpha,
                                int setCountMax,
                                int[] singleTypeTotalObsCounts,
                                TypeList setLists){
        super(label);
        this.alpha = alpha;
        this.setCountMax = setCountMax;
        this.singleTypeTotalObsCounts = singleTypeTotalObsCounts;
        this.setLists = setLists;
        logSingleTypePriors = new double[setLists.getTypeCount()];
        storedLogSingleTypePriors = new double[logSingleTypePriors.length];
    }

    public double calcLogMDPDensity(){

        logMultiTypePrior = 0.0;

        int typeObsCount;

        int[] setSizes;
        for(int typeIndex = 0; typeIndex < setLists.getTypeCount(); typeIndex++){

            typeObsCount = 0;
            setSizes = setLists.getSubTypeSetSizes(typeIndex);
            for(int setIndex = 0; setIndex < setSizes.length; setIndex++){
                typeObsCount += setSizes[setIndex];
            }

            //System.out.println("alpha="+alpha+" max J = "+setCountMax);
            logSingleTypePriors[typeIndex] = ClusterPrior.calcLogMDPDensity(alpha, setCountMax,
                    setLists.getSubTypeList(typeIndex), typeObsCount);
            logMultiTypePrior += logSingleTypePriors[typeIndex];

        }

        return logMultiTypePrior;

    }

    public String getLabel(){

        String newLabel = label;
        for(int typeIndex = 0; typeIndex < setLists.getTypeCount(); typeIndex++){
            newLabel+= "\t"+label+"."+typeIndex;
        }

        return newLabel;
    }

    public String log(){
        String logCompClustPrior = ""+logMultiTypePrior;
        for(int typeIndex = 0; typeIndex < logSingleTypePriors.length; typeIndex++){
            logCompClustPrior+=("\t" + logSingleTypePriors[typeIndex]);
        }

        return logCompClustPrior;
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
