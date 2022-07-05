package inference;

import cluster.TypeList;
import utils.Randomizer;

public class AssignSingleRowWrapper extends AssignSingleRow{

    public static double SingleRowMoveInType(TypeList typesList){
        int updateTypeIndex = Randomizer.nextInt(typesList.getTypeCount());
        return SingleRowMove(typesList.getSubTypeList(updateTypeIndex));

    }
}
