package jovami.handler;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.util.graph.BetterAlgorithms;
import jovami.util.graph.Edge;
import jovami.util.graph.Graph;

/**
 * MinimumDistanceHandler
 */
public class MinimumDistanceHandler {
    private final HubNetwork hubNetwork;


    /**
     * Instantiates a new Minimum distance handler.
     */
    public MinimumDistanceHandler() {
        App app = App.getInstance();
        this.hubNetwork = app.hubNetwork();
    }

    /**
     * Get minimal user network graph.
     *
     * @return the graph
     */
    public Graph<User, Distance> getMinimalUserNetwork(){
        return BetterAlgorithms.kruskalMST(hubNetwork, HubNetwork.distCmp);   //O(E*log E)
    }

    /**
     * Get minimum cost int.
     *
     * @param mst the mst
     * @return the int
     */
    public int getMinimumCost(Graph<User, Distance> mst){
        int minimumCost=0;
        for (Edge<User,Distance> edge: mst.edges()) {                   //O(E)
            minimumCost += edge.getWeight().getDistance();
        }
        return minimumCost;
    }
}
