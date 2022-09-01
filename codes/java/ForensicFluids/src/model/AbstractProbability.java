package model;

import state.State;

public abstract class AbstractProbability extends AbstractState {
    protected double logP;
    protected double storedLogP;
    public AbstractProbability(String label) {
        super(label);
    }

    public abstract double getLogLikelihood();

    public void store(){
        storedLogP = logP;
    }

    public void restore(){
        storedLogP = logP;
    }

    public String log() {
        return ""+logP;
    }

    public String logStored() {
        return ""+storedLogP;
    }


}