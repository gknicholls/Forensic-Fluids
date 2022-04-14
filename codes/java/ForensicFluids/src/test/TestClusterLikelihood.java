package test;

public class TestClusterLikelihood {
    public int[][] getData() {

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

    public static double[] getTest1ExpectedMkrGrpLik(){
        double[] test1MkrGrpLik = new double[]{
                7.62612815220286e-10,
                1.958641145541198e-10,
                4.244733132751831e-11,
                7.782010743378348e-11,
                9.52002247410134e-12
        };

        return test1MkrGrpLik;
    }
}
