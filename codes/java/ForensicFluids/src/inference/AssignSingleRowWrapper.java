package inference;

import cluster.TypeList;
import utils.Randomizer;

public class AssignSingleRowWrapper extends AssignSingleRow implements ProposalMove{

    public static double proposal(TypeList typesList){
        int updateTypeIndex = Randomizer.nextInt(typesList.getTypeCount());
        return SingleRowMove(typesList.getSubTypeList(updateTypeIndex));

    }
}
