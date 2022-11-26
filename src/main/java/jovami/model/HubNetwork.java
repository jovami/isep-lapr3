package jovami.model;

import java.util.Collection;

import jovami.util.Triplet;
import jovami.util.graph.Graph;
import jovami.util.graph.map.MapGraph;

/**
 * HubNetwork
 */
public class HubNetwork extends MapGraph<User, Distance> {

    public HubNetwork() {
        this(false);
    }

	public HubNetwork(boolean directed) {
		super(directed);
	}

    public HubNetwork(Graph<User,Distance> graph) {
        super(graph);
    }

    public boolean addVertices(Collection<User> users) {
        int oldNum = numVerts;
        users.forEach(this::addVertex);

        return oldNum != numVerts;
    }

    public boolean addEdges(Collection<Triplet<User, User, Distance>> dists) {
        int oldNum = numEdges;

        dists.forEach(e -> this.addEdge(e.first(), e.second(), e.third()));

        return oldNum != numEdges;
    }
}
