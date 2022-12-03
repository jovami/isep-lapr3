package jovami.handler;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.util.graph.Algorithms;
import jovami.util.graph.Edge;
import jovami.util.graph.Graph;

public class MinimumDistanceHandler {
    private final App app;
    private final HubNetwork hubNetwork;


    public MinimumDistanceHandler() {
        this.app = App.getInstance();
        this.hubNetwork = app.hubNetwork();
    }

    public Graph<User, Distance> getMinimalUserNetwork(){
        return Algorithms.kruskalMST(hubNetwork, HubNetwork.distCmp);
    }

    public int getMinimumCost(Graph<User, Distance> mst){
        int minimumCost=0;
        for (Edge<User,Distance> edge: mst.edges()) {
            minimumCost = minimumCost + edge.getWeight().getDistance();
        }
        return minimumCost;
    }

}
