package model;

import cluster.State;

public interface Likelihood extends State {
    public double getLogLikelihood();

}
