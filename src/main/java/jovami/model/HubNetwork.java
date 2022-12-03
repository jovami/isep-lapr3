package jovami.model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.function.BinaryOperator;

import jovami.util.Triplet;
import jovami.util.graph.Algorithms;
import jovami.util.graph.Edge;
import jovami.util.graph.Graph;
import jovami.util.graph.map.MapGraph;

/**
 * HubNetwork
 */
public class HubNetwork extends MapGraph<User, Distance> {

    public static final Comparator<Distance> distCmp;
    public static final BinaryOperator<Distance> distSum;

    static {
        distCmp  = Distance.cmp;
        distSum  = Distance.sum;
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
        return Algorithms.shortestPath(this, origin, dest, distCmp, distSum, generateZero(origin), path);
    }

    public List<LinkedList<User>> shortestPaths(User origin, ArrayList<Distance> dists) {
        var paths = new ArrayList<LinkedList<User>>();
        if (!dists.isEmpty())
            dists.clear();

        Algorithms.shortestPaths(this, origin, distCmp, distSum, generateZero(origin), paths, dists);
        return paths;
    }

    public LinkedList<Distance>
    shortestPathsForPool(User origin, List<User> pool)
    {
        return Algorithms.shortestPathsForPool(this, origin, pool, distCmp, distSum, generateZero(origin));
    }

    private Distance generateZero(User vert){
        return new Distance(vert.getLocationID(), vert.getLocationID(), 0);
    }

    // TODO: check if we still need to override this
    @Override
    public Collection<Edge<User, Distance>> outgoingEdges(User vert) {

        Collection<Edge<User, Distance>> edges = super.outgoingEdges(vert);

        var list = new ArrayList<Edge<User, Distance>>();

        edges.forEach(e -> {
            Distance dist = e.getWeight();

            if (dist.getLocID1().equals(e.getVDest().getLocationID())
            &&  dist.getLocID2().equals(e.getVOrig().getLocationID()))
                list.add(new Edge<>(e.getVOrig(), e.getVDest(), dist.reverse()));
            else
                list.add(e);

        });

        return list;
    }

    @Override
    public boolean addEdge(User vOrig, User vDest, Distance weight) {
        boolean ok = super.addEdge(vOrig, vDest, weight);

        if (ok && !this.isDirected) {
            var edge = this.edge(vDest, vOrig);
            var w = edge.getWeight();
            edge.setWeight(w.reverse());
        }

        return ok;
    }
}
