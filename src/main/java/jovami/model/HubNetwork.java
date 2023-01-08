package jovami.model;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.function.BinaryOperator;

import jovami.util.Triplet;
import jovami.util.graph.Algorithms;
import jovami.util.graph.BetterAlgorithms;
import jovami.util.graph.Edge;
import jovami.util.graph.Graph;
import jovami.util.graph.map.MapGraph;

/**
 * HubNetwork
 */
public class HubNetwork extends MapGraph<User, Distance> {

    /**
     * The constant distCmp.
     */
    public static final Comparator<Distance> distCmp;
    /**
     * The constant distSum.
     */
    public static final BinaryOperator<Distance> distSum;

    static {
        distCmp  = Distance.cmp;
        distSum  = Distance.sum;
    }

    /**
     * Instantiates a new Hub network.
     */
    public HubNetwork() {
        this(false);
    }

    /**
     * Instantiates a new Hub network.
     *
     * @param directed the directed
     */
    public HubNetwork(boolean directed) {
		super(directed);
	}

    public HubNetwork(boolean directed, Collection<User> users) {
        this(directed);
        this.addVertices(users);
    }

    public HubNetwork(Graph<User,Distance> g) {
        this(g.isDirected(), g.vertices());
        this.addEdges(g.edges()
                       .stream()
                       .map(e -> new Triplet<>(e.getVOrig(), e.getVDest(), e.getWeight()))
                       .toList()
        );
    }

    public static Distance getZero(User vert){
        var locID = vert.getLocationID();
        return new Distance(locID, locID, 0);
    }

    /**
     * Add vertices boolean.
     *
     * @param users the users
     * @return the boolean
     */
    public boolean addVertices(Collection<User> users) {
        int oldNum = this.numVerts;
        users.forEach(this::addVertex);

        return oldNum != this.numVerts;
    }

    /**
     * Add edges boolean.
     *
     * @param dists the dists
     * @return the boolean
     */
    public boolean addEdges(Collection<Triplet<User, User, Distance>> dists) {
        int oldNum = this.numEdges;
        dists.forEach(t -> this.addEdge(t.first(), t.second(), t.third()));

        return oldNum != this.numEdges;
    }

    public HubNetwork subNetwork(User u, Collection<User> users) {
        var sub = new HubNetwork(this.isDirected, users);
        sub.addVertex(u);

        var verts = sub.vertices();
        final int size = verts.size();

        for (int i = 0; i < size; i++) {                    // O(V*inside)
            User u1 = verts.get(i);                         // O(1)
                                                            // O(1)
            for (User u2 : verts) {                         // O(V*inside)
                var edge = this.edge(u1, u2);               // O(1)
                if (edge != null)                           // O(1)
                    sub.addEdge(u1, u2, edge.getWeight());  // O(1)
            }
        }

        // Net complexity: O(V^2)
        return sub;
    }

    public HubNetwork addSelfCycles() {
        // O(V)
        this.vertices().forEach(v -> this.addEdge(v, v, getZero(v)));
        return this;
    }

    public HubNetwork transitiveClosure() {
        return new HubNetwork(Algorithms.minDistGraph(this, distCmp, distSum));
    }

    /**
     * Shortest path distance.
     *
     * @param origin the origin
     * @param dest   the dest
     * @param path   the path
     * @return the distance
     */
    public Distance shortestPath(User origin, User dest, LinkedList<User> path) {
        return Algorithms.shortestPath(this, origin, dest,
                                       distCmp, distSum, getZero(origin), path);
    }

    /**
     * Shortest paths list.
     *
     * @param origin the origin
     * @param dists  the dists
     * @return the list
     */
    public List<LinkedList<User>> shortestPaths(User origin, ArrayList<Distance> dists) {
        var paths = new ArrayList<LinkedList<User>>();
        if (!dists.isEmpty())
            dists.clear();

        Algorithms.shortestPaths(this, origin, distCmp, distSum,
                                 getZero(origin), paths, dists);
        return paths;
    }

    /**
     * Shortest paths for pool linked list.
     *
     * @param origin the origin
     * @param pool   the pool
     * @return the linked list
     */
    public LinkedList<Distance> shortestPathsForPool(User origin, List<User> pool) {
        return BetterAlgorithms.shortestPathsForPool(this, origin, pool,
                                               distCmp, distSum, getZero(origin));
    }

    //==================== Overrides ====================//

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

        if (ok && !this.isDirected
            && this.key(vOrig) != this.key(vDest))
        {
            var edge = this.edge(vDest, vOrig);
            Distance w = edge.getWeight();
            edge.setWeight(w.reverse());
        }

        return ok;
    }
}
