package test;

import junit.framework.TestCase;
import model.ClusterLikelihood;

import java.util.ArrayList;
import java.util.Arrays;

public class TestClusterLikelihood extends TestCase {

    public interface Instance {

        int[][][] getPartitions();

        int[][] getData();

        double[] getExpectedResult();

        double getAlpha();

        double getBeta();

        double[] getColPrior();

        ArrayList<Integer> getSubtypeIndexes();
    }

    protected Instance test0 = new Instance() {

        @Override
        public int[][][] getPartitions() {

            int[][][] partition = {
                    {{0, 1, 2}},
                    {{0, 1}, {2}},
                    {{0, 2}, {1}},
                    {{0}, {1, 2}},
                    {{0}, {1}, {2}}

            };

            return partition;
        }

        @Override
        public int[][] getData(){

            int[][] slvEx1Mat = {
                    {0, 1, 1},
                    {0, 1, 1},
                    {1, 0, 0},
                    {0, 0, 0},
                    {0, 0, 1},
                    {0, 0, 1},
                    {0, 0, 1},
                    {0, 0, 0},
                    {0, 0, 0},
                    {0, 0, 0}
            };

            return slvEx1Mat;
        }



        @Override
        public double[] getExpectedResult() {
            return new double[]{
                    7.62612815220286e-10,
                    1.958641145541198e-10,
                    4.244733132751831e-11,
                    7.782010743378348e-11,
                    9.52002247410134e-12
            };
        }

        @Override
        public double[] getColPrior() {
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
            return 2;
        }

        @Override
        public double getBeta(){
            return 3;
        }

        @Override
        public ArrayList<Integer> getSubtypeIndexes(){
            ArrayList<Integer> subtypeIndexes = new ArrayList<Integer>(
                    Arrays.asList(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
            );
            return subtypeIndexes;
        }
    };

    protected Instance test1 = new Instance() {

        @Override
        public int[][][] getPartitions() {

            int[][][] partition = {
                    {{0, 1, 2, 3}},
                    {{0, 1, 2}, {3}},
                    {{0, 1, 3}, {2}},
                    {{0, 1}, {2, 3}},
                    {{0, 1}, {2}, {3}},
                    {{0, 2, 3}, {1}},
                    {{0, 2}, {1, 3}},
                    {{0, 2}, {1}, {3}},
                    {{0, 3}, {1, 2}},
                    {{0}, {1, 2, 3}},
                    {{0}, {1, 2}, {3}},
                    {{0, 3}, {1}, {2}},
                    {{0}, {1, 3}, {2}},
                    {{0}, {1}, {2, 3}},
                    {{0}, {1}, {2}, {3}}
            };

            return partition;
        }

        @Override
        public int[][] getData(){

            int[][] slvEx2Mat = {
                    {1, 1, 1, 1},
                    {1, 1, 1, 1},
                    {1, 1, 0, 1},
                    {1, 1, 0, 1},
                    {1, 1, 0, 1},
                    {1, 1, 0, 1},
                    {1, 1, 0, 1},
                    {0, 1, 0, 1},
                    {0, 1, 0, 0},
                    {0, 1, 0, 1}
            };

            return slvEx2Mat;
        }



        @Override
        public double[] getExpectedResult() {
            return new double[]{
                    6.213567834736545e-13,
                    7.590906346753908e-14,
                    1.238007816916047e-11,
                    1.713712134340804e-13,
                    4.304705814376286e-13,
                    2.819479500222888e-13,
                    5.075224397855477e-12,
                    1.550575742854044e-13,
                    6.31367628441347e-14,
                    3.17437901773346e-14,
                    4.664541904122907e-15,
                    6.796903917436222e-13,
                    1.643614947307302e-12,
                    1.999089387481247e-14,
                    5.021550316009523e-14
            };
        }

        @Override
        public double[] getColPrior() {
            return new double[]{
                    35.0/(3.0 * 17.0 * 19.0),
                    20.0/(17.0 * 19.0),
                    20.0/(17.0 * 19.0),
                    50.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    20.0/(17.0 * 19.0),
                    50.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    50.0/(3.0 * 17.0 * 19.0),
                    20.0/(17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    80.0/(3.0 * 17.0 * 19.0),
                    64.0/(3.0 * 17.0 * 19.0)

            };
        }

        @Override
        public double getAlpha(){
            return 3;
        }

        @Override
        public double getBeta(){
            return 2;
        }

        @Override
        public ArrayList<Integer> getSubtypeIndexes(){
            ArrayList<Integer> subtypeIndexes = new ArrayList<Integer>(
                    Arrays.asList(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
            );
            return subtypeIndexes;
        }
    };

    public void testCalcIntAllPartsMkrGrpLik (){
        Instance[] tests = new Instance[]{test0, test1};
        for(Instance test: tests) {

            int[][][] partitions = test.getPartitions();
            int[][] data = test.getData();
            double alpha = test.getAlpha();
            double beta = test.getBeta();
            double[] mkrGrpLik;
            double[] expectedResult = test.getExpectedResult();
            ArrayList<Integer> subtypeIndexes = test.getSubtypeIndexes();

            mkrGrpLik = ClusterLikelihood.CalcIntAllPartsMkrGrpLik(
                        partitions,
                        data,
                        alpha,
                        beta,
                        subtypeIndexes);

            for (int partIndex = 0; partIndex < partitions.length; partIndex++) {

                assertEquals(mkrGrpLik[partIndex], expectedResult[partIndex], 1e-10);
                assertEquals(Math.log(mkrGrpLik[partIndex]), Math.log(expectedResult[partIndex]), 1e-10);
            }
        }
    }

    public void testCalcLogSubtypeLikelihood(){
        int[][][][] mkrGrpPartitions = new int[2][][][];
        mkrGrpPartitions[0] = test0.getPartitions();
        mkrGrpPartitions[1] = test1.getPartitions();

        int[][][] data = new int[2][][];
        data[0] = test0.getData();
        data[1] = test1.getData();

        double[][] colPriors = new double[2][];
        colPriors[0] = test0.getColPrior();
        colPriors[1] = test1.getColPrior();
        double[] alphaC = new double[]{test0.getAlpha(), test1.getAlpha()};
        double[] betaC = new double[]{test0.getBeta(), test1.getBeta()};

        double logSubLik = ClusterLikelihood.CalcLogSubtypeLikelihood(mkrGrpPartitions,
                colPriors, data, alphaC, betaC, test1.getSubtypeIndexes());

        assertEquals(logSubLik, -49.6924097777349, 1e-10);

    }





}
