package state;

public class Parameter implements State{
    private double[] values;
    private double[] storedValues;
    private double upperBound;
    private double lowerBound;
    private boolean[] update;
    private String name;
    public Parameter(String name, double[] values){
        this(name, values, Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY);

    }

    public Parameter(String name, double[] values, double lower){
        this(name, values, Double.POSITIVE_INFINITY, 0.0);

    }

    public Parameter(String name, double[] values, double upper, double lower){
        this.values = values;
        storedValues = new double[values.length];
        this.upperBound = upper;
        this.lowerBound = lower;
        this.name = name;
        update = new boolean[values.length];
        for(int i = 0; i < update.length; i++){
            update[i] = true;
        }
    }

    public int getDimension(){
        return values.length;
    }

    public boolean isUpdated(int index){
        return update[index];
    }

    public void setValue(int index, double value){
        values[index] = value;
        update[index] = true;

    }

    public double getValue(int index){
        return values[index];

    }



    public void store(){
        for(int i = 0; i < update.length; i++){
            update[i] = false;
        }
        System.arraycopy(values, 0, storedValues, 0, values.length);
    }

    public void restore(){
        double[] tmp = values;
        values = storedValues;
        storedValues = tmp;

    }


    public String printLabel(){
        String str = "";
        for(int i = 0; i < values.length; i++){
            if(i > 0){
                str = "\t";
            }
            str += name+"."+i;
        }
        return str;
    }

    public String log(){
        String str = "";
        for(int i = 0; i < values.length; i++){
            if(i > 0){
                str = "\t";
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
