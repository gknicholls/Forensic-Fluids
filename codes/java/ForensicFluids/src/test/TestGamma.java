package test;

import junit.framework.TestCase;
import distribution.Gamma;
import state.Parameter;

public class TestGamma extends TestCase {

    public interface Instance {

        double[] getX();

        double getShape();

        double getScale();

        double[] getExpectedLogP();
    }

    protected Instance test0 = new Instance() {
        public double[] getX(){
            return new double[]{0.1, 0.2, 0.3, 0.4, 0.5};
        }

        public double getShape(){
            return 0.5;
        }

        public double getScale(){
            return 2.0;
        }

        public double[] getExpectedLogP(){
            return new double[]{
                    0.182354013292,
                    -0.214219576988,
                    -0.466952131042,
                    -0.660793167268,
                    -0.822364942925};
        }

    };

    protected Instance test1 = new Instance() {
        public double[] getX(){
            return new double[]{
                    1.053005877908680,
                    1.349191895139637,
                    3.307649506232723,
                    4.384867160620074,
                    4.913772369946862};
        }

        public double getShape(){
            return 0.5;
        }

        public double getScale(){
            return 0.25;
        }

        public double[] getExpectedLogP(){
            return new double[]{
                    -4.11706568160,
                    -5.42573825144,
                    -13.70793469638,
                    -18.15776607051,
                    -20.33032821728};
        }

    };


    protected Instance test2 = new Instance() {
        public double[] getX(){
            return new double[]{
                    0.09646627480608801,
                    0.24338720699069089,
                    0.27949003291781843,
                    0.37434218929199509,
                    0.50574850867020915,
                    0.59646627480608794,
                    0.74338720699069083,
                    0.77949003291781849,
                    0.87434218929199514,
                    1.0057485086702091};
        }

        public double getShape(){
            return 1;
        }

        public double getScale(){
            return 3.0;
        }

        public double[] getExpectedLogP(){
            return new double[]{
                    -1.13076771360,
                    -1.17974135767,
                    -1.19177563297,
                    -1.22339301843,
                    -1.26719512489,
                    -1.29743438027,
                    -1.34640802433,
                    -1.35844229964,
                    -1.39005968510,
                    -1.43386179156};
        }

    };

    protected Instance test3 = new Instance() {
        public double[] getX(){
            return new double[]{
                    0.057852722653137789,
                    0.003583984465131432,
                    0.195577704627070109,
                    0.257017357128899837,
                    0.237225536288424049,
                    0.307852722653137789,
                    0.253583984465131418,
                    0.445577704627070137,
                    0.507017357128899837,
                    0.487225536288424077};
        }

        public double getShape(){
            return 1;
        }

        public double getScale(){
            return 0.4;
        }

        public double[] getExpectedLogP(){
            return new double[]{
                    0.771658925241,
                    0.907330770711,
                    0.427346470306,
                    0.273747339052,
                    0.323226891153,
                    0.146658925241,
                    0.28233077071,
                    -0.197653529694,
                    -0.351252660948,
                    -0.301773108847};
        }

    };


    protected Instance test4 = new Instance() {
        public double[] getX(){
            return new double[]{
                    0.10921841354933567,
                    0.08681598176341516,
                    0.35350426195351708,
                    0.46693341923827369,
                    0.48500389042554126,
                    0.60921841354933559,
                    0.58681598176341510,
                    0.85350426195351714,
                    0.96693341923827369,
                    0.98500389042554126};
        }

        public double getShape(){
            return 2;
        }

        public double getScale(){
            return 3.5;
        }

        public double[] getExpectedLogP(){
            return new double[]{
                    -4.75113680564,
                    -4.97429505577,
                    -3.64638689196,
                    -3.40050408805,
                    -3.36769684369,
                    -3.17516677349,
                    -3.20623164370,
                    -2.90778904081,
                    -2.81541826701,
                    -2.80206530812};
        }

    };

    protected Instance test5 = new Instance() {
        public double[] getX(){
            return new double[]{
                    0.2075722682726686,
                    0.3070274135913768,
                    0.6439499294618176,
                    0.8549810229457249,
                    0.9876817671352660,
                    1.2075722682726686,
                    1.3070274135913766,
                    1.6439499294618176,
                    1.8549810229457249,
                    1.9876817671352660};
        }

        public double getShape(){
            return 3;
        }

        public double getScale(){
            return 0.2;
        }

        public double[] getExpectedLogP(){
            return new double[]{
                    -0.0472462228509,
                    0.2383930081943,
                    0.0351482990667,
                    -0.4530905693399,
                    -0.8280317412544,
                    -1.5254708761113,
                    -1.8644596934929,
                    -3.0903794112899,
                    -3.9039896264080,
                    -4.4293042418800};
        }

    };

    public void testLogP(){
        Instance[] tests = new Instance[]{test0, test1, test2, test3, test4, test5};
        for(Instance test:tests){
            Gamma gammaDistr = new Gamma(
                    new Parameter("shape", new double[]{test.getShape()}, 0),
                    new Parameter("scale", new double[]{test.getScale()}, 0),
                    new Parameter("x", test.getX(), 0));
            double[] exptlogPs = test.getExpectedLogP();
            assertEquals(sum(exptlogPs), gammaDistr.getLogLikelihood(), 1e-10);


        }
    }

    public static double sum(double[] values){
        double sumValue = 0.0;
        for(int index = 0; index < values.length; index++){
            sumValue += values[index];
        }
        return sumValue;
    }


}
