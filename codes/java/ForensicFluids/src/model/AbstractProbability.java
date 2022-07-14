package model;

import state.State;

public abstract class AbstractProbability extends AbstractState {
    public AbstractProbability(String label) {
        super(label);
    }

    public abstract double getLogLikelihood();

}