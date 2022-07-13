package model;

public class DummyLikelihood implements Probability {
    public double getLogLikelihood(){
        return 0.0;
    }

    public void store(){}

    public void restore(){}

    public String log(){
        return "" + 0.0;
    }

    public String logStored(){
        return "" + 0.0;
    }
}
