package jovami.model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.function.BinaryOperator;

import jovami.util.Triplet;
import jovami.util.graph.Algorithms;
import jovami.util.graph.Graph;
import jovami.util.graph.map.MapGraph;

/**
 * HubNetwork
 */
public class HubNetwork extends MapGraph<User, Distance> {

    public static final Comparator<Distance> distCmp;
    public static final BinaryOperator<Distance> distSum;
    public static final Distance distZero;

    static {
        distCmp  = Distance.cmp;
        distSum  = Distance.sum;
        distZero = Distance.zero;
    }

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
