package jovami.handler;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.util.graph.Algorithms;
import java.util.Optional;

/**
 * IsConnectedHandler.
 */
public class IsConnectedHandler {
    private final App app;
    private final HubNetwork network;

    private final boolean connected;

    public IsConnectedHandler() {
        this.app = App.getInstance();
        this.network = app.hubNetwork();
        this.connected = Algorithms.isConnected(network);   // O(V*E)
    }

    /**
     * Min reachability calculation.
     *
     * @return the optional
     */
    public Optional<Integer> minReachability() {
        if (connected) {
            var matrix = Algorithms.minDistGraph(network, Distance.cmp, Distance.sum);  // O(V^3) (Floyd-Warshall)
            return Optional.of(matrix.numEdges());  // O(1)
        }

        // Net Complexity: O(V^3)
        return Optional.empty();
    }
}
