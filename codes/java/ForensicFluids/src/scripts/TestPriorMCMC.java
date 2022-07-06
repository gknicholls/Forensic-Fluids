package scripts;

import cluster.SubTypeList;
import cluster.TypeList;
import data.CompoundMarkerData;
import inference.AssignSingleRowWrapper;
import inference.MCMC;
import inference.OldSingleTypeMCMC;
import model.CompoundClusterLikelihood;
import model.CompoundClusterPrior;
import model.DummyLikelihood;
import utils.DataUtils;
import utils.Randomizer;

import java.util.ArrayList;

public class TestPriorMCMC {

    public static final int[][] COL_RANGE = {{0, 4}, {5, 11}, {12, 16}, {17, 21}, {22, 26}};

    public static void main(String[] args){

        String allPartitionSets5File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets5.txt";
        String allPartitionSets7File = "/Users/chwu/Documents/research/bfc/github/Forensic-Fluids/output/allPartitionSets7.txt";
        double[] alphaC = new double[]{0.5, 0.5, 0.5, 0.5, 0.5};
        double[] betaC = new double[]{2.0, 2.0, 0.25, 2.0, 2.0};
        TestPriorMCMC subtypeClf = new TestPriorMCMC();
        try {

            Randomizer.setSeed(123);
            subtypeClf.runEx7Obs(allPartitionSets5File, allPartitionSets7File, alphaC, betaC);


        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }

    private void runEx7Obs(String allPartitionSets5File,
                                              String allPartitionSets7File,
                                              double[] alphaC, double[] betaC) throws Exception{
        int[][][][] mkrGrpPartitions = OldSingleTypeMCMC.getMkerGroupPartitions(allPartitionSets5File, allPartitionSets7File);
        //double alpha5 = 0.49;
        //double alpha7 = 0.375;
        double alphaRow = 20;


        int totalObsCount = 7;
        int maxClustCount;

        for(int maxCountIndex = 0; maxCountIndex < totalObsCount; maxCountIndex++){
            maxClustCount = maxCountIndex + 1;

            ArrayList<Integer>[] subtypeParts = (ArrayList<Integer>[]) new ArrayList[maxClustCount];
            for(int setIndex = 0; setIndex < subtypeParts.length; setIndex++){
                subtypeParts[setIndex] = new ArrayList<>();
            }

            for(int setIndex = 0; setIndex < totalObsCount; setIndex++){
                subtypeParts[0].add(setIndex);
            }

            SubTypeList subTypeList = new SubTypeList(subtypeParts);
            SubTypeList[] subTypeLists = new SubTypeList[]{subTypeList};
            TypeList typeList = new TypeList(subTypeLists);

            AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
            CompoundClusterPrior mdpPrior = new CompoundClusterPrior(alphaRow, maxClustCount, new int[]{totalObsCount}, typeList);
            DummyLikelihood lik = new DummyLikelihood();

            String outputFilePath = "/Users/chwu/Documents/research/bfc/output/ex.7obs_J" + maxClustCount + "_v2.log";
            MCMC estSubtype = new MCMC(mdpPrior, lik, singleRowMove, typeList, 1000000, 1, outputFilePath);
            estSubtype.run();
        }




    }
}
