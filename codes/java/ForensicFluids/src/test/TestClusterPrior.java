package test;

import junit.framework.TestCase;
import model.ClusterPrior;

public class TestClusterPrior extends TestCase {

    public interface Instance {

        int[][][] getPartitions();

        double[] getExpectedResult();

        double getAlpha();

        int getMaxSetCount();

        int getTotalObsCount();
    }

    protected Instance test0 = new Instance() {

        @Override
        public int[][][] getPartitions() {

            int[][][] partition = {
                    {{1, 2, 3}},
                    {{1, 3}, {2}},
                    {{1, 2}, {3}},
                    {{1}, {2, 3}},
                    {{1}, {2}, {3}}

            };

            return partition;
        }



        @Override
        public double[] getExpectedResult() {
            return new double[]{
                    0.1648351648351658,
                    0.2197802197802201,
                    0.2197802197802201,
                    0.2197802197802201,
                    0.1758241758241763
            };
        }

        @Override
        public double getAlpha(){
            return 12;
        }

        @Override
        public int getMaxSetCount(){
            return 3;
        }

        @Override
        public int getTotalObsCount(){
            return 3;
        }
    };




    public void testCalcMDP(){
        Instance[] tests = new Instance[]{test0};
        for(Instance test: tests) {
            int[][][] partitions = test.getPartitions();
            double alpha = test.getAlpha();
            int maxSetCount = test.getMaxSetCount();
            int totalObsCount = test.getTotalObsCount();
            double mdpProb;
            double[] expectedResult = test.getExpectedResult();

            for (int partIndex = 0; partIndex < partitions.length; partIndex++) {
                mdpProb = ClusterPrior.CalcMDPDensity(
                        alpha,
                        maxSetCount,
                        partitions[partIndex],
                        totalObsCount);

                assertEquals(mdpProb, expectedResult[partIndex], 1e-10);
                assertEquals(Math.log(mdpProb), Math.log(expectedResult[partIndex]), 1e-10);
            }
        }
    }



}
