package inference;

import state.State;
import model.AbstractProbability;
import utils.Randomizer;

import java.io.PrintStream;

public class MCMC {
    private AbstractProbability[] probs;
    private ProposalMove[] proposalMoves;
    private State state;
    private int chainLength;
    private int logEvery;
    private String outputFilePath;
    private double[] weights;
    private double[] cumSumWeights;


    public MCMC(AbstractProbability[] probs,
                ProposalMove proposalMove,
                State state,
                int chainLength,
                int logEvery,
                String outputFilePath){
        this.probs = probs;
        this.proposalMoves = new ProposalMove[]{proposalMove};
        this.state = state;
        this.chainLength = chainLength;
        this.logEvery = logEvery;



        this.outputFilePath = outputFilePath;

    }

    public MCMC(AbstractProbability[] probs,
                ProposalMove[] proposalMoves,
                double[] weights,
                State state,
                int chainLength,
                int logEvery,
                String outputFilePath){
        this.probs = probs;
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

            //double currLogLik = likelihood.getLogLikelihood();
            //double currLogPrior = prior.getLogLikelihood();
            //double currLogPost = currLogLik + currLogPrior;
            double currLogPost = 0;
            for(int probsIndex = 0; probsIndex < probs.length; probsIndex++){
                currLogPost += probs[probsIndex].getLogLikelihood();
            }
            double logHR, propLogLik, propLogPrior, propLogPost, logMHR;

            String labels = "STATE\tlog.posterior";
            for(AbstractProbability prob:probs){
                labels += "\t"+prob.getLabel();
            }
            labels += "\t"+state.getLabel()+"\tstored."+state.getLabel()+"\tprop."+state.getLabel()+"\tlogHR\tlogMHR\tdraw";


            output.println(labels);
            log(output, currLogPost, probs, 0, state.log(), state.logStored(), "NA", 0, 0, 0);
            for (int stepIndex = 0; stepIndex < chainLength; stepIndex++) {
                //System.out.println(stepIndex);
                //store();
                state.store();
                for(AbstractProbability prob:probs){
                    prob.store();
                }
                //likelihood.store();
                //prior.store();


                String storedClust = state.logStored();

                int currProposalIndex;
                if(weights == null){
                    currProposalIndex = stepIndex%proposalMoves.length;
                }else{
                    currProposalIndex = getMoveIndex(stepIndex);
                }
                //System.out.println("mcmc: "+stepIndex+" "+proposalMoves.length+" "+currProposalIndex);
                logHR = proposalMoves[currProposalIndex].proposal();

                //propLogLik = likelihood.getLogLikelihood();
                //propLogPrior = prior.getLogLikelihood();
                //propLogPost = propLogLik + propLogPrior;

                propLogPost = 0;
                for(int probsIndex = 0; probsIndex < probs.length; probsIndex++){
                    propLogPost += probs[probsIndex].getLogLikelihood();
                }
                logMHR = propLogPost - currLogPost + logHR;
                String propClust = state.log();


                double draw = Math.log(Randomizer.nextDouble());
                //boolean accept = false;
                if (logMHR >= 0.0 || draw < logMHR) {
                    //System.out.println("accepted: "+ accept+"," + currLogLik+" "+ currLogPrior+ " "+propLogLik+" "+ propLogPrior);
                    //System.out.println("accept");

                    //accept = true;

                    currLogPost = propLogPost;
                    //currLogPrior = propLogPrior;
                    //currLogLik = propLogLik;
                } else {
                    //System.out.println("reject");
                    state.restore();

                    for(AbstractProbability prob:probs){
                        prob.restore();
                    }


                }

            /*if(accepted){
                System.out.println("accepted "+ currLogLik+" "+ currLogPrior);
            }*/


                if (((stepIndex + 1) % logEvery) == 0) {
                    log(output, currLogPost, probs, stepIndex + 1, state.log(), storedClust, propClust, logHR, logMHR, draw);
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



    private void log(PrintStream output, double posterior, AbstractProbability[] probs, int state, String currClust, String storedClust, String propClust,
                     double logHR, double logMHR, double draw){


        output.print(state + "\t" + posterior);

        for(AbstractProbability prob:probs){
            output.print( "\t" + prob.log());
        }

        output.println("\t" + currClust+ "\t"+ storedClust +"\t"+ propClust+"\t"+logHR+"\t"+logMHR+"\t"+ draw );

    }


}
