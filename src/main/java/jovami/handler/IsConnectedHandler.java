package jovami.handler;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.util.graph.Algorithms;
import jovami.util.graph.BetterAlgorithms;

import java.util.LinkedList;
import java.util.Optional;

/**
 * IsConnectedHandler.
 */
public class IsConnectedHandler {
    private final HubNetwork network;

    private final boolean connected;

    public IsConnectedHandler() {
        App app = App.getInstance();
        this.network = app.hubNetwork();
        this.connected = BetterAlgorithms.isConnected(network);   // O(V*E)
    }

    /**
     * Min reachability calculation.
     *
     * @return the optional
     */
    public Optional<Integer> minReachability() {
        if (connected) {
            var list = new LinkedList<User>();
            var matrix = Algorithms.minDistGraph(network, Distance.cmp, Distance.sum);  // O(V^3) (Floyd-Warshall)
            User vOrig = matrix.vertex(0);
            var bfs = Algorithms.BreadthFirstSearch(matrix, vOrig);
            Algorithms.shortestPath(matrix, vOrig, bfs.get(bfs.size()-1), Distance.cmp, Distance.sum, Distance.zero, list);

            return Optional.of(list.size()-1);
        }
        // Net Complexity: O(V^3)
        return Optional.empty();
    }


}
