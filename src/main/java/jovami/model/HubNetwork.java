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
import jovami.util.graph.map.MapVertex;

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

    @Override
    public Collection<Edge<User, Distance>> outgoingEdges(User vert) {

        Collection<Edge<User, Distance>> edges = super.outgoingEdges(vert);

        var list = new ArrayList<Edge<User, Distance>>();

        edges.forEach(a -> {
            Distance dist = a.getWeight();

            if(dist.getLocID1().equals(a.getVDest().getLocationID()) && dist.getLocID2().equals(a.getVOrig().getLocationID())){
                list.add(new Edge<>(a.getVOrig(), a.getVDest(), new Distance(dist.getLocID2(), dist.getLocID1(), dist.getDistance())));
            }else{
                list.add(a);
            }
        });

        return list;
    }
}
