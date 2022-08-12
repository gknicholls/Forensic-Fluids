package scripts.tests;

import inference.*;
import model.AbstractProbability;
import model.CompoundClusterPrior;
import model.DummyLikelihood;
import model.Gamma;
import state.Parameter;
import state.State;
import state.SubTypeList;
import state.TypeList;
import utils.Randomizer;

import java.util.ArrayList;

public class TestMultiParameterPrior {

    public static void main(String[] args){

        TestMultiParameterPrior mcmcPrior = new TestMultiParameterPrior();
        try {


            Randomizer.setSeed(123);
            mcmcPrior.runEx7Obs3DimParam();


        }catch(Exception e){
            throw new RuntimeException(e);
        }
    }


    private void runEx7Obs3DimParam() {
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

            Parameter param = new Parameter("parameter1", new double[]{1.0, 1.0, 1.0}, 0);
            Parameter gammaShape0 = new Parameter("gamma.shape", new double[]{0.5}, 0);
            Parameter gammaScale0 = new Parameter("gamma.scale", new double[]{1}, 0);

            Parameter gammaShape1 = new Parameter("gamma.shape", new double[]{1.0}, 0);
            Parameter gammaScale1 = new Parameter("gamma.scale", new double[]{1.5}, 0);

            Parameter gammaShape2 = new Parameter("gamma.shape", new double[]{2.0}, 0);
            Parameter gammaScale2 = new Parameter("gamma.scale", new double[]{1.25}, 0);

            ScaleMove scaleMove = new ScaleMove(param, 0.75);
            AssignSingleRowWrapper singleRowMove = new AssignSingleRowWrapper(typeList);
            ProposalMove[] proposalMoves = new ProposalMove[]{scaleMove, singleRowMove};
            //ProposalMove[] proposalMoves = new ProposalMove[]{ singleRowMove};
            double[] proposalWeights = new double[]{8, 2};
            //double[] proposalWeights = new double[]{1};


            Gamma gammaPrior0 = new Gamma("gammaPrior.0", gammaShape0, gammaScale0, param, 0);
            Gamma gammaPrior1 = new Gamma("gammaPrior.1", gammaShape1, gammaScale1, param, 1);
            Gamma gammaPrior2 = new Gamma("gammaPrior.2", gammaShape2, gammaScale2, param, 2);
            CompoundClusterPrior mdpPrior = new CompoundClusterPrior("multiTypeMDP", alphaRow, maxClustCount,
                    new int[]{totalObsCount}, typeList);
            DummyLikelihood lik = new DummyLikelihood();

            State[] states = new State[]{typeList, param};
            //State[] states = new State[]{typeList};

            AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik, gammaPrior0, gammaPrior1, gammaPrior2};
            //AbstractProbability[] probs = new AbstractProbability[]{mdpPrior, lik};
            String outputFilePath = "/Users/chwu/Documents/research/bfc/output/2022_07_15/test_sample_prior_parts_param_2022_07_15.log";
            MCMC estSubtype = new MCMC(probs, proposalMoves, proposalWeights, states, 5000000, 500, outputFilePath);
            estSubtype.run();
        }




    }
}
