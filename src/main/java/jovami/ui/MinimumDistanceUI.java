package jovami.ui;

import jovami.handler.MinimumDistanceHandler;
import jovami.model.Distance;
import jovami.model.User;
import jovami.util.graph.Edge;
import jovami.util.graph.Graph;

public class MinimumDistanceUI implements UserStory {

    private final MinimumDistanceHandler handler;

    public MinimumDistanceUI() {
        this.handler = new MinimumDistanceHandler();
    }

    @Override
    public void run() {
        Graph<User,Distance> mst =handler.getMinimalUserNetwork();
        printGraph(mst);
        System.out.printf("Minimum Cost: %d\n",handler.getMinimumCost(mst));
    }

    private void printGraph(Graph<User,Distance> mst) {
        System.out.println("Minimum Distance Network:\n");
        System.out.println("VOrig -> VDest (Distance)");
        for (Edge<User,Distance> edge: mst.edges()) {
            System.out.printf("%-5s ->  %-5s (%dm)\n",edge.getVOrig().getUserID(),
                    edge.getVDest().getUserID(),edge.getWeight().getDistance());
        }
    }
}
