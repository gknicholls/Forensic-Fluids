package inference;

public abstract class ProposalMove {

    protected int[] decisionCount;
    public ProposalMove(){
        decisionCount = new int[2];
    }
    public abstract double proposal();
    public static int ACCEPT = 1;
    public static int REJECT = 0;
    public void  countAccept(int decision){
        decisionCount[decision]++;
    }

    public int getAcceptCount(){
        return decisionCount[ACCEPT];
    }

    public int getRejectCount(){
        return decisionCount[REJECT];
    }
}
