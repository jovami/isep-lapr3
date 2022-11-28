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
        int oldNum = this.numVerts;
        users.forEach(this::addVertex);

        return oldNum != this.numVerts;
    }

    public boolean addEdges(Collection<Triplet<User, User, Distance>> dists) {
        int oldNum = this.numEdges;

        dists.forEach(e -> this.addEdge(e.first(), e.second(), e.third()));

        return oldNum != this.numEdges;
    }

    public Distance shortestPath(User origin, User dest, LinkedList<User> path) {
        return Algorithms.shortestPath(this, origin, dest, distCmp, distSum, distZero, path);
    }

    public List<LinkedList<User>> shortestPaths(User origin, ArrayList<Distance> dists) {
        var paths = new ArrayList<LinkedList<User>>();
        if (!dists.isEmpty())
            dists.clear();

        Algorithms.shortestPaths(this, origin, distCmp, distSum, distZero, paths, dists);
        return paths;
    }

    public LinkedList<Distance>
    shortestPathsForPool(User origin, List<User> pool)
    {
        return Algorithms.shortestPathsForPool(this, origin, pool, distCmp, distSum, distZero);
    }
}
