package model;

import state.State;

public interface Probability extends State {
    public double getLogLikelihood();

}