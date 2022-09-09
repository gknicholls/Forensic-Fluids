package inference;

import state.Parameter;
import utils.Randomizer;

public class ScaleMove extends ProposalMove{

    private Parameter parameter;
    private double scaleFactor;

    public ScaleMove(Parameter parameter, double scaleFactor){
        super();
        this.parameter = parameter;
        this.scaleFactor = scaleFactor;
    }

    public double proposal(){
        int dim = parameter.getDimension();
        double scale = getScaler();

        int index = Randomizer.nextInt(dim);
        double currValue = parameter.getValue(index);

        if (currValue == 0) {

            return Double.NEGATIVE_INFINITY;
        }

        final double propValue = scale * currValue;

        if (isOutOfBounds(propValue, parameter)) {

            return Double.NEGATIVE_INFINITY;
        }

        parameter.setValue(index, propValue);

        return -Math.log(scale);
    }

    private double getScaler() {
        return (scaleFactor + (Randomizer.nextDouble() * ((1.0 / scaleFactor) - scaleFactor)));
    }

    public boolean isOutOfBounds(double value, Parameter param){
        boolean outOfBounds = false;
        if(value < param.getLowerBound() || value > param.getUpperBound()){
            outOfBounds = true;
        }
        return outOfBounds;
    }

}
