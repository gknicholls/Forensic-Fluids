package cluster;

public interface State extends Loggable {
    public void store();
    public void restore();
}
