package model;

import state.Parameter;

public class Gamma extends AbstractProbability {
    private Parameter shape;
    private Parameter scale;
    private Parameter x;
    private GammaDistributionImpl distr;
    private boolean update;
    private double logP;
    private double storedLogP;

    public Gamma(String label,
                 Parameter shape,
                 Parameter scale,
                 Parameter x){
        super(label);
        this.shape = shape;
        this.scale = scale;
        this.x = x;
        distr = new GammaDistributionImpl(this.shape.getValue(), this.scale.getValue());
        update = false;

    }

    public Gamma(Parameter shape,
                 Parameter scale,
                 Parameter x){
        this("GammaDistr", shape, scale, x);

    }

    public double getLogLikelihood(){

        checkUpdate();

        if(update){
            logP = 0.0;
            int dim = x.getDimension();
            for(int index = 0; index < dim; index++){
                logP += Math.log(distr.density(this.x.getValue(index)));
            }
        }

        return logP;

    }

    private void checkUpdate(){
        if(shape.isUpdated()){
            distr.setAlpha(this.shape.getValue());
            update = true;
        }

        if(shape.isUpdated()){
            distr.setBeta(this.scale.getValue());
            update = true;
        }

        if(x.isUpdated()){
            update = true;
        }

    }

    public void store(){
       storedLogP = logP;
       update = false;
    }

    public void restore(){
        storedLogP = logP;
        update = false;
    }



    public String log() {
        return ""+logP;
    }

    public String logStored() {
        return ""+storedLogP;
    }
}
