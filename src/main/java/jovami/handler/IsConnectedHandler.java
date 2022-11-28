package jovami.handler;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.util.graph.Algorithms;
import java.util.Optional;

public class IsConnectedHandler {
    private final App app;
    private final HubNetwork network;

    private final boolean connected;

    public IsConnectedHandler() {
        this.app = App.getInstance();
        this.network = app.hubNetwork();
        this.connected = Algorithms.isConnected(network);
    }

    public Optional<Integer> minReachability(){
        if (connected){
            var matrix = Algorithms.minDistGraph(network, Distance.cmp, Distance.sum);
            return Optional.of(matrix.numEdges());
        }
        return Optional.empty();
    }
}
