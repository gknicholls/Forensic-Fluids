package inference;

import state.State;
import model.Probability;
import utils.Randomizer;

import java.io.PrintStream;

public class MCMC {
    private Probability prior;
    private Probability likelihood;
    private ProposalMove[] proposalMoves;
    private State state;
    private int chainLength;
    private int logEvery;
    private String outputFilePath;
    private double[] weights;
    private double[] cumSumWeights;


    public MCMC(Probability prior,
                Probability likelihood,
                ProposalMove proposalMove,
                State state,
                int chainLength,
                int logEvery,
                String outputFilePath){
        this.prior = prior;
        this.likelihood = likelihood;
        this.proposalMoves = new ProposalMove[]{proposalMove};
        this.state = state;
        this.chainLength = chainLength;
        this.logEvery = logEvery;



        this.outputFilePath = outputFilePath;

    }

    public MCMC(Probability prior,
                Probability likelihood,
                ProposalMove[] proposalMoves,
                double[] weights,
                State state,
                int chainLength,
                int logEvery,
                String outputFilePath){
        this.prior = prior;
        this.likelihood = likelihood;
        this.proposalMoves = proposalMoves;
        this.weights = weights;
        this.state = state;
        this.chainLength = chainLength;
        this.logEvery = logEvery;

        this.outputFilePath = outputFilePath;

        if(weights != null){
            cumSumWeights = new double[weights.length];
            double prevWeight = 0;
            for(int i = 0; i < cumSumWeights.length; i++){
                cumSumWeights[i] = prevWeight + weights[i];
                prevWeight = cumSumWeights[i];
            }
        }


    }

    public void run(){
        try {

            PrintStream output = new PrintStream(outputFilePath);

            double currLogLik = likelihood.getLogLikelihood();
            double currLogPrior = prior.getLogLikelihood();
            double currLogPost = currLogLik + currLogPrior;
            double logHR, propLogLik, propLogPrior, propLogPost, logMHR;

            output.println("STATE\tPosterior\tLog-likelihood\tLog-prior\tPartition\tstoredPartition\tPropPartiton\tlogHR\tlogMHR\tdraw");
            log(output, currLogPost, currLogLik, currLogPrior, 0, state.log(), state.logStored(), "NA", 0, 0, 0);
            for (int stepIndex = 0; stepIndex < chainLength; stepIndex++) {
                //System.out.println(stepIndex);
                //store();
                state.store();
                likelihood.store();
                prior.store();


                String storedClust = state.logStored();

                int currProposalIndex;
                if(weights == null){
                    currProposalIndex = stepIndex%proposalMoves.length;
                }else{
                    currProposalIndex = getMoveIndex(stepIndex);
                }
                //System.out.println("mcmc: "+stepIndex+" "+proposalMoves.length+" "+currProposalIndex);
                logHR = proposalMoves[currProposalIndex].proposal();

                propLogLik = likelihood.getLogLikelihood();
                propLogPrior = prior.getLogLikelihood();
                propLogPost = propLogLik + propLogPrior;
                logMHR = propLogPost - currLogPost + logHR;
                String propClust = state.log();


                double draw = Math.log(Randomizer.nextDouble());
                //boolean accept = false;
                if (logMHR >= 0.0 || draw < logMHR) {
                    //System.out.println("accepted: "+ accept+"," + currLogLik+" "+ currLogPrior+ " "+propLogLik+" "+ propLogPrior);
                    //System.out.println("accept");

                    //accept = true;

                    currLogPost = propLogPost;
                    currLogPrior = propLogPrior;
                    currLogLik = propLogLik;
                } else {
                    //System.out.println("reject");
                    state.restore();
                    likelihood.restore();
                    prior.restore();
                }

            /*if(accepted){
                System.out.println("accepted "+ currLogLik+" "+ currLogPrior);
            }*/


                if (((stepIndex + 1) % logEvery) == 0) {
                    //System.out.println("log " + currLogLik + " " + currLogPrior);
                    log(output, currLogPost, currLogLik, currLogPrior, stepIndex + 1, state.log(), storedClust, propClust, logHR, logMHR, draw);
                }


            }
            output.close();
        }catch(Exception e){
            throw new RuntimeException(e);
        }


    }

    private int getMoveIndex(int stepIndex){
        int currMoveIndex = cumSumWeights.length - 1;
        double r = cumSumWeights[currMoveIndex]%stepIndex;
        for(int moveIndex = 0; moveIndex < cumSumWeights.length; moveIndex++){
            if(r > cumSumWeights[moveIndex]){
                currMoveIndex = moveIndex - 1;
                break;
            }

        }
        return currMoveIndex;
    }



    private void log(PrintStream output, double posterior, double likelihood,
                     double prior, int state, String currClust, String storedClust, String propClust,
                     double logHR, double logMHR, double draw){

        output.println(state + "\t" + posterior + "\t" + likelihood + "\t" + prior+ "\t"
                + currClust+ "\t"+ storedClust +"\t"+ propClust+"\t"+logHR+"\t"+logMHR+"\t"+ draw );

    }


}
