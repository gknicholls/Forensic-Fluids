package model;

import state.State;

public abstract class AbstractState implements State {
    protected String label;
    public AbstractState(String label){
        this.label = label;
    }

    public String getLabel(){
        return label;
    }

}
