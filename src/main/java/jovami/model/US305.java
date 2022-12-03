package jovami.model;

import jovami.App;
import jovami.handler.MinimumDistanceHandler;
import jovami.ui.UserStory;
import jovami.util.graph.Algorithms;
import jovami.util.graph.Edge;
import jovami.util.graph.Graph;

import java.util.Comparator;

public class US305 implements UserStory {

    private final MinimumDistanceHandler handler;

    public US305() {
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
