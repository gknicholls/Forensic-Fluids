package model;

import data.SubTypeList;
import data.TypeList;
import org.apache.commons.math3.special.Gamma;

public class CompoundClusterPrior {

    public static double calcLogMDPDensity(double alpha,
                                           int setCountMax,
                                           TypeList setLists,
                                           int totalObsCount){

        double logMDP = 0.0;
        double[] singleTypePriors = new double[setLists.getTypeCount()];
        for(int typeIndex = 0; typeIndex < setLists.getTypeCount(); typeIndex++){
            singleTypePriors[typeIndex] = ClusterPrior.calcLogMDPDensity(alpha, setCountMax,
                    setLists.getSubTypeList(typeIndex),totalObsCount);
            logMDP += singleTypePriors[typeIndex];

        }
        return logMDP;

    }
}
