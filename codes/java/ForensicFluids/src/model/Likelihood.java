package model;

import state.State;

public interface Likelihood extends State {
    public double getLogLikelihood();

}
