package state;

public interface State extends Loggable {
    public void store();
    public void restore();
    public String getLabel();
}
