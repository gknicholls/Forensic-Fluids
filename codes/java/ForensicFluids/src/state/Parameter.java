package state;

import model.AbstractState;

public class Parameter extends AbstractState {
    private double[] values;
    private double[] storedValues;
    private double upperBound;
    private double lowerBound;
    private boolean[] update;
    private boolean anyUpdate;




    public Parameter(String label, double[] values){
        this(label, values, Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY);

    }

    public Parameter(String label, double[] values, double lower){
        this(label, values, Double.POSITIVE_INFINITY, 0.0);

    }

    public Parameter(String label, double[] values, double upper, double lower){
        super(label);
        this.values = values;
        storedValues = new double[values.length];
        this.upperBound = upper;
        this.lowerBound = lower;
        update = new boolean[values.length];
        for(int i = 0; i < update.length; i++){
            update[i] = true;
        }
        anyUpdate = true;
    }

    public int getDimension(){
        return values.length;
    }

    public boolean isUpdated(int index){
        return update[index];
    }

    public boolean isUpdated(){
        return anyUpdate;
    }

    public void setValue(int index, double value){
        values[index] = value;
        update[index] = true;
        anyUpdate = true;

    }

    public double getValue(){
        return values[0];

    }

    public double getValue(int index){
        return values[index];

    }

    public double getLowerBound() {
        return lowerBound;
    }

    public double getUpperBound(){
        return upperBound;
    }

    public void store(){
        for(int i = 0; i < update.length; i++){
            update[i] = false;
        }
        System.arraycopy(values, 0, storedValues, 0, values.length);
        anyUpdate = false;
    }

    public void restore(){
        double[] tmp = values;
        values = storedValues;
        storedValues = tmp;

    }


    public String getLabel(){
        String str = "";
        for(int i = 0; i < values.length; i++){
            if(i > 0){
                str += "\t";
            }
            str += label+"."+i;
        }
        return str;
    }

    public String log(){
        String str = "";
        for(int i = 0; i < values.length; i++){
            if(i > 0){
                str += "\t";
            }
            str += values[i];
        }
        return str;
    }

    public String logStored(){
        String str = "";
        for(int i = 0; i < storedValues.length; i++){
            if(i > 0){
                str = "\t";
            }
            str += storedValues[i];
        }
        return str;
    }

}
