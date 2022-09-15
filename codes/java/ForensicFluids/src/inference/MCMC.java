package inference;

import state.State;
import model.AbstractProbability;
import utils.Randomizer;

import java.io.File;
import java.io.PrintStream;
import java.io.PrintWriter;

public class MCMC {
    private AbstractProbability[] probs;
    private ProposalMove[] proposalMoves;
    private State[] states;
    private int chainLength;
    private int logEvery;
    private String outputFilePath;
    private double[] weights;
    private double[] cumSumWeights;


    public MCMC(AbstractProbability[] probs,
                ProposalMove proposalMove,
                State[] states,
                int chainLength,
                int logEvery,
                String outputFilePath){
        this.probs = probs;
        this.proposalMoves = new ProposalMove[]{proposalMove};
        this.states = states;
        this.chainLength = chainLength;
        this.logEvery = logEvery;



        this.outputFilePath = outputFilePath;

    }

    public MCMC(AbstractProbability[] probs,
                ProposalMove[] proposalMoves,
                double[] weights,
                State[] states,
                int chainLength,
                int logEvery,
                String outputFilePath){
        this.probs = probs;
        this.proposalMoves = proposalMoves;
        this.weights = weights;
        this.states = states;
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
            for(int i = 0; i < cumSumWeights.length; i++){
                cumSumWeights[i] = cumSumWeights[i]/ cumSumWeights[cumSumWeights.length - 1];
            }
        }


    }

    public void run(){
        try {
            double startTime = System.currentTimeMillis();

            File outputFile = new File(outputFilePath);
            if(outputFile.exists()){
                throw new RuntimeException("File already exists" +outputFilePath);
            }

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
            for(State state:states){
                labels += "\t" + state.getLabel();
                //labels += "\tstored." + state.getLabel();
                //labels += "\tprop." + state.getLabel();
            }
            labels += "\tlogHR\tlogMHR\tdraw";


            output.println(labels);
            log(output, currLogPost, probs, 0, states, 0, 0, 0);
            for (int stepIndex = 0; stepIndex < chainLength; stepIndex++) {
                //System.out.println(stepIndex);
                //store();
                for(State state:states) {
                    state.store();
                }


                for(AbstractProbability prob:probs){
                    prob.store();
                }
                //likelihood.store();
                //prior.store();

                /*String[] storedLog = new String[states.length];
                for(int stateIndex = 0; stateIndex < states.length; stateIndex++){
                    storedLog[stateIndex] =  states[stateIndex].logStored();
                }*/
                //String storedClust = state.logStored();

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

                /*String[] propLog = new String[states.length];
                for(int stateIndex = 0; stateIndex < states.length; stateIndex++){
                    propLog[stateIndex] =  states[stateIndex].logStored();
                }*/
                //String propClust = state.log();


                double draw = Math.log(Randomizer.nextDouble());
                //boolean accept = false;
                //System.out.println("mcmc2: "+ draw +" "+ logMHR);
                if (logMHR >= 0.0 || draw < logMHR) {
                    //System.out.println("accepted: "+ accept+"," + currLogLik+" "+ currLogPrior+ " "+propLogLik+" "+ propLogPrior);
                    //System.out.println("accept");

                    //accept = true;

                    currLogPost = propLogPost;
                    //currLogPrior = propLogPrior;
                    //currLogLik = propLogLik;
                    proposalMoves[currProposalIndex].countAccept(ProposalMove.ACCEPT);
                } else {
                    //System.out.println("reject1");
                    for(State state:states){
                        state.restore();
                    }
                    //System.out.println("between");


                    //System.out.println(probs.length);
                    for(int probIndex = 0; probIndex < probs.length; probIndex++){
                        //System.out.println(probs[probIndex].getClass());
                        probs[probIndex].restore();
                    }
                    //System.out.println("reject2");
                    proposalMoves[currProposalIndex].countAccept(ProposalMove.REJECT);


                }

            /*if(accepted){
                System.out.println("accepted "+ currLogLik+" "+ currLogPrior);
            }*/


                if (((stepIndex + 1) % logEvery) == 0) {
                    log(output, currLogPost, probs, stepIndex + 1, states, logHR, logMHR, draw);
                }


            }
            output.close();

            double endTime = System.currentTimeMillis();

            proposalPerformance(outputFilePath+".ops", proposalMoves, endTime - startTime);
        }catch(Exception e){
            throw new RuntimeException(e);
        }


    }

    private int getMoveIndex(int stepIndex){
        int currMoveIndex = 0;
        //double r = stepIndex%cumSumWeights[cumSumWeights.length - 1];
        double r = Randomizer.nextDouble();

        for(int moveIndex = 0; moveIndex < cumSumWeights.length; moveIndex++){
            //System.out.println("proposal: "+r+" "+cumSumWeights[moveIndex]+" "+cumSumWeights[cumSumWeights.length - 1]);
            currMoveIndex = moveIndex;
            if(r < cumSumWeights[moveIndex]){
                break;
            }

        }
        //System.out.println("currMoveIndex: " +currMoveIndex);

        return currMoveIndex;
    }



    private void log(PrintStream output, double posterior, AbstractProbability[] probs, int step, State[] states,
                     double logHR, double logMHR, double draw){


        output.print(step + "\t" + posterior);

        for(AbstractProbability prob:probs){
            output.print( "\t" + prob.log());
        }

        for(State state:states){
            output.print( "\t" + state.log());
        }

        output.println("\t" + logHR + "\t" + logMHR+ "\t" + draw);

    }

    private void proposalPerformance(String outputFilePath, ProposalMove[] proposals, double runtime){
        try{

            PrintWriter proposalWriter = new PrintWriter(outputFilePath);
            double acceptCount = 0;
            double rejectCount = 0;

            proposalWriter.println("# Seed for random number generation: " + Randomizer.getSeed());
            runtime = runtime/1000.0;
            if(runtime < 60.0){
                proposalWriter.println("# Total calculation time: "+ runtime +" seconds.");
            }else{
                runtime = runtime/60.0;
                if(runtime < 60.0){
                    proposalWriter.println("# Total calculation time: "+ runtime +" minutes.");
                }else{
                    runtime = runtime/60.0;
                    proposalWriter.println("# Total calculation time: "+ runtime +" hours.");
                }
            }



            for(ProposalMove proposal: proposals){
                acceptCount = proposal.getAcceptCount();
                rejectCount = proposal.getRejectCount();
                proposalWriter.println(proposal.getClass()+"\t"+
                        acceptCount+"\t"+
                        rejectCount+"\t"+
                        acceptCount/rejectCount);
            }
            proposalWriter.close();

        }catch(Exception e){
            throw new RuntimeException(e);
        }

    }


}
