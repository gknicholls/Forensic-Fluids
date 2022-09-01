package state;

public class UnlabelledTypeWrapperParameter extends Parameter{

    private TypeListWithUnknown typeList;
    public UnlabelledTypeWrapperParameter(String label, TypeListWithUnknown typelist){
        super(label);
        this.typeList = typelist;
    }

    public double getValue(int index){
        return typeList.getUnknownObsTypeIndex(index);
    }

    public int getDimension(){
        return typeList.getUnknownObsCount();
    }

    public String getLabel(){
        String str = "";
        for(int i = 0; i < getDimension(); i++){
            if(i > 0){
                str += "\t";
            }
            str += label+"."+i;
        }
        return str;
    }

    public String log(){
        String str = "";
        for(int i = 0; i < getDimension(); i++){
            if(i > 0){
                str += "\t";
            }
            str += getValue(i);
        }
        return str;
    }

    public void store(){}
    public void restore(){}

}
