package scripts;

import inference.AssignSingleRowWrapper;
import inference.MCMC;
import inference.OldSingleTypeMCMC;
import inference.ScaleMove;
import model.CompoundClusterPrior;
import model.DummyLikelihood;
import model.Gamma;
import state.Parameter;
import state.SubTypeList;
import state.TypeList;
import utils.Randomizer;

import java.util.ArrayList;

public class TestScaleMoveProposal {

    public static void main(String[] args){


        TestScaleMoveProposal testSMP = new TestScaleMoveProposal();
        try {

            Randomizer.setSeed(123);
            testSMP.singleValueParameter();

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

        String outputFilePath = "/Users/chwu/Documents/research/bfc/output/test_scale_gamma_v2.log";
        MCMC estSubtype = new MCMC(gammaPrior, lik, scaleMove, param, 10000, 1, outputFilePath);
        estSubtype.run();




    }
}
