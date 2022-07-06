package inference;

import cluster.State;
import model.Likelihood;
import utils.Randomizer;

import java.io.PrintStream;

public class MCMC {
    private Likelihood prior;
    private Likelihood likelihood;
    private ProposalMove proposalMove;
    private State state;
    private int chainLength;
    private int logEvery;
    private String outputFilePath;


    public MCMC(Likelihood prior,
                Likelihood likelihood,
                ProposalMove proposalMove,
                State state,
                int chainLength,
                int logEvery,
                String outputFilePath){
        this.prior = prior;
        this.likelihood = likelihood;
        this.proposalMove = proposalMove;
        this.state = state;
        this.chainLength = chainLength;
        this.logEvery = logEvery;

        this.outputFilePath = outputFilePath;

    }

    public void run(){
        try {

            PrintStream output = new PrintStream(outputFilePath);

            double currLogLik = likelihood.getLogLikelihood();
            double currLogPrior = prior.getLogLikelihood();
            double currLogPost = currLogLik + currLogPrior;
            double logHR, propLogLik, propLogPrior, propLogPost, logMHR;

            output.println("STATE\tPosterior\tLog-likelihood\tLog-prior\tPartition\tstoredPartition\tPropPartiton\tlogHR\tlogMHR\tdraw");
            log(output, currLogPost, currLogLik, currLogPrior, 0, state.log(), state.logStored(), 0, 0, 0);
            for (int stepIndex = 0; stepIndex < chainLength; stepIndex++) {
                //System.out.println(stepIndex);
                //store();
                state.store();
                likelihood.store();
                prior.store();


                String storedClust = state.logStored();

                logHR = proposalMove.proposal();

                propLogLik = likelihood.getLogLikelihood();
                propLogPrior = prior.getLogLikelihood();
                propLogPost = propLogLik + propLogPrior;
                logMHR = propLogPost - currLogPost + logHR;
                String propClust = state.log();


                double draw = Math.log(Randomizer.nextDouble());
                //boolean accept = false;
                if (logMHR >= 0.0 || draw < logMHR) {
                    //System.out.println("accepted: "+ accept+"," + currLogLik+" "+ currLogPrior+ " "+propLogLik+" "+ propLogPrior);
                    //accept = true;

                    currLogPost = propLogPost;
                    currLogPrior = propLogPrior;
                    currLogLik = propLogLik;
                } else {
                    state.restore();
                    likelihood.restore();
                    prior.restore();
                }

            /*if(accepted){
                System.out.println("accepted "+ currLogLik+" "+ currLogPrior);
            }*/


                if (((stepIndex + 1) % logEvery) == 0) {
                    //System.out.println("log " + currLogLik + " " + currLogPrior);
                    log(output, currLogPost, currLogLik, currLogPrior, stepIndex + 1, state.log(), storedClust, logHR, logMHR, draw);
                }


            }
            output.close();
        }catch(Exception e){
            throw new RuntimeException(e);
        }


    }

    private void log(PrintStream output, double posterior, double likelihood,
                     double prior, int state, String propClust, String storedClust,
                     double logHR, double logMHR, double draw){

        output.println(state + "\t" + posterior + "\t" + likelihood + "\t" + prior+ "\t"
                + storedClust+ "\t"+ storedClust+ "\t"+propClust+"\t"+logHR+"\t"+logMHR+"\t"+ draw );

    }


}
