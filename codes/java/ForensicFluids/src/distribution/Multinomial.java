package distribution;

import model.AbstractProbability;
import state.Parameter;
import state.UnlabelledTypeWrapperParameter;

public class Multinomial extends AbstractProbability {

    private double[] logProbs;
    private Parameter parameter;
    public Multinomial(String label,
                       Parameter parameter,
                       double[] probs){
        super(label);
        checkProbs(probs);
        this.parameter = parameter;
        logProbs = new double[probs.length];
        for(int probIndex = 0; probIndex < logProbs.length; probIndex++){
            logProbs[probIndex] = Math.log(probs[probIndex]);
        }

    }

    private void checkProbs(double[] probs){
        double sumProb = 0.0;
        for(int probIndex = 0; probIndex < probs.length; probIndex++){
            sumProb+=probs[probIndex];
        }
        if(Math.abs(1.0 - sumProb) > 1e-10){
            throw new RuntimeException();
        }

    }

    public double getLogLikelihood(){
        logP = 0.0;
        for(int paramIndex = 0; paramIndex < parameter.getDimension(); paramIndex++){
            logP += logProbs[(int)parameter.getValue(paramIndex)];
        }

        return logP;

    }





    public String log() {
        return ""+logP;
    }

    public String logStored() {
        return ""+storedLogP;
    }
}
