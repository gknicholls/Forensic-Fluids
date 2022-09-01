package scripts.tests;

import inference.MCMC;
import inference.ScaleMove;
import model.AbstractProbability;
import model.DummyLikelihood;
import distribution.Gamma;
import state.Parameter;
import state.State;
import utils.Randomizer;

public class TestScaleMoveProposal {

    public static void main(String[] args){


        TestScaleMoveProposal testSMP = new TestScaleMoveProposal();
        try {

            //Randomizer.setSeed(123);
            //testSMP.singleValueParameter();

            Randomizer.setSeed(123);
            testSMP.multiValueParameter();

        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }



    private void singleValueParameter() throws Exception{

        Parameter param = new Parameter("parameter1", new double[]{1.0}, 0);
        Parameter gammaShape = new Parameter("gamma.shape", new double[]{2.0}, 0);
        Parameter gammaScale = new Parameter("gamma.scale", new double[]{0.5}, 0);

        ScaleMove scaleMove = new ScaleMove(param, 0.75);

        Gamma gammaPrior = new Gamma(gammaShape,gammaScale, param);
        DummyLikelihood lik = new DummyLikelihood();

        AbstractProbability[] probs = new AbstractProbability[]{gammaPrior, lik};
        State[] states = new State[]{param};

        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_14/test_scale_gamma_2022_07_14.log";
        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_14/test_scale_gamma_2022_07_14_v2.log";
        MCMC estSubtype = new MCMC(probs, scaleMove, states , 100000, 1, outputFilePath);
        estSubtype.run();




    }


    private void multiValueParameter() throws Exception{

        Parameter param = new Parameter("parameter1", new double[]{1.0, 1.0, 1.0}, 0);
        Parameter gammaShape0 = new Parameter("gamma.shape", new double[]{0.5}, 0);
        Parameter gammaScale0 = new Parameter("gamma.scale", new double[]{1}, 0);

        Parameter gammaShape1 = new Parameter("gamma.shape", new double[]{1.0}, 0);
        Parameter gammaScale1 = new Parameter("gamma.scale", new double[]{1.5}, 0);

        Parameter gammaShape2 = new Parameter("gamma.shape", new double[]{2.0}, 0);
        Parameter gammaScale2 = new Parameter("gamma.scale", new double[]{1.25}, 0);

        ScaleMove scaleMove = new ScaleMove(param, 0.75);


        State[] states = new State[]{param};

        Gamma gammaPrior0 = new Gamma("gammaPrior.0", gammaShape0, gammaScale0, param, 0);
        Gamma gammaPrior1 = new Gamma("gammaPrior.1", gammaShape1, gammaScale1, param, 1);
        Gamma gammaPrior2 = new Gamma("gammaPrior.2", gammaShape2, gammaScale2, param, 2);

        DummyLikelihood lik = new DummyLikelihood();

        AbstractProbability[] probs = new AbstractProbability[]{gammaPrior0, gammaPrior1, gammaPrior2, lik};

        //String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_14/test_scale_gamma_2022_07_14.log";
        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_14/test_scale_multi_gamma_2022_07_14.log";
        MCMC estSubtype = new MCMC(probs, scaleMove, states , 100000, 100, outputFilePath);
        estSubtype.run();




    }
}
