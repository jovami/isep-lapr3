package jovami.util.graph;

import java.util.Collection;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.function.BinaryOperator;

import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.util.Triplet;

/**
 * TSP2
 */
public class TSP2 {
    // TODO: make things generic whenever possible
    private static <E> void maybeClear(Collection<E> col) {
        if (!col.isEmpty())
            col.clear();
    }

    private static <V,E> Graph<V,E>
    getCompleteGraph(Graph<V,E> g, Comparator<E> ce, BinaryOperator<E> sum)
    {
        int v, e;
        v = g.numVertices();
        e = g.numEdges();

        /* NOTE: we dont need to divide v*(v-1) by 2
         * since numEdges() returns double of the 'actual' edges */
        if (v * (v-1) != e)
            return Algorithms.minDistGraph(g, ce, sum);
        return g;
    }


    public Triplet<List<User>, List<Distance>, Distance>
    travelingSalesman(HubNetwork g, Set<User> s, User u)
    {
        // TODO: temporary
        var tours = new LinkedList<LinkedList<User>>();




        var tour = mergePaths(tours);

        var dists = new LinkedList<Distance>();
        // TODO: check Distance.zero
        var dist = getDists(g, Distance.zero, HubNetwork.distSum, tour, dists);

        return new Triplet<>(tour, dists, dist);
    }

    private <V,E> E getDists(Graph<V,E> g, E zero, BinaryOperator<E> sum,
                             List<V> tour, List<E> dists) {
        maybeClear(dists);

        E dist = zero;
        final int size = tour.size();
        for (int i = 1; i < size; i++) {
            // We don't need to check if edge exists due to floyd-warshall
            E weight = g.edge(tour.get(i-1), tour.get(i))
                        .getWeight();
            dists.add(weight);
            dist = sum.apply(dist, weight);
        }

        return dist;
    }

    private <V,E> List<V> mergePaths(List<LinkedList<V>> tours) {

        var result = new LinkedList<V>();

        // Lookup set
        Set<V> aux = new HashSet<>();

        for (var tour : tours) {
            for (var vert : tour) {
                if (!aux.contains(vert)) {
                    aux.add(vert);
                    tour.add(vert);
                }
            }
        }

        return result;
    }
}
