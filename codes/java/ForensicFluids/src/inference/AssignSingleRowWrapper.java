package inference;

import state.TypeList;
import state.TypeListWithUnknown;
import utils.Randomizer;

public class AssignSingleRowWrapper extends AssignSingleRow implements ProposalMove{

    private TypeList typeList;
    public AssignSingleRowWrapper(TypeList typeList){
        this.typeList = typeList;
    }

    public double proposal(){
        int updateTypeIndex = 0;
        //System.out.println("typeCount: " + typeList.getTypeCount());
        if(typeList.getTypeCount() > 1){
            updateTypeIndex = Randomizer.nextInt(typeList.getTypeCount());
        }
        int[] setSizes = typeList.getSubTypeSetSizes(updateTypeIndex);
        int typeSize = 0;
        for(int i = 0; i < setSizes.length;i++){
            typeSize+=setSizes[i];
        }

        while(typeSize == 1){
            updateTypeIndex = Randomizer.nextInt(typeList.getTypeCount());

            setSizes = typeList.getSubTypeSetSizes(updateTypeIndex);
            typeSize = 0;
            for(int i = 0; i < setSizes.length;i++){
                typeSize+=setSizes[i];
            }


        }
        //System.out.println("Single row wrapper updateTypeIndex: "+updateTypeIndex);


        double temp=  SingleRowMove(typeList.getSubTypeList(updateTypeIndex));
        typeList.setTypeUpdate(updateTypeIndex);
        /*int[] setSizes = typeList.getSubTypeSetSizes(updateTypeIndex);
        for(int i = 0; i < setSizes.length; i++){
            if(setSizes[i] > 0){
                for(int j = 0; j < setSizes[i]; j++){
                    System.out.print(typeList.getObs(updateTypeIndex, i, j)+" ");
                }
                System.out.println();

            }

        }*/
        if(typeList instanceof TypeListWithUnknown){
            ((TypeListWithUnknown)typeList).updateMap();
        }


        /*setSizes = typeList.getSubTypeSetSizes(0);
        if(setSizes[0] >0){
            System.out.println("000X: "+typeList.getObs(0, 0,0));
        }*/

        return temp;
    }
}
