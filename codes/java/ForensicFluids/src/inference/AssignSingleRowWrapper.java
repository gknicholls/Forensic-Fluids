package inference;

import cluster.TypeList;
import utils.Randomizer;

public class AssignSingleRowWrapper extends AssignSingleRow implements ProposalMove{

    private TypeList typeList;
    public AssignSingleRowWrapper(TypeList typeList){
        this.typeList = typeList;
    }

    public double proposal(){
        int updateTypeIndex = Randomizer.nextInt(typeList.getTypeCount());
        return SingleRowMove(typeList.getSubTypeList(updateTypeIndex));

    }
}
