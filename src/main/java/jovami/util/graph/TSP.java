package jovami.util.graph;

import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.function.BinaryOperator;
import java.util.function.Function;

/**
 * TSP2
 */
public class TSP {


    private static void ensureNonNull(Object... objs) {
        for (var obj : objs)
            Objects.requireNonNull(obj);
    }


    private static <E> void maybeClear(Collection<E> col) {
        if (!col.isEmpty())
            col.clear();
    }


    public static <V,E> Graph<V,E>
    getCompleteGraph(Graph<V,E> g, Comparator<E> ce, BinaryOperator<E> sum)
    {
        ensureNonNull(g, ce, sum);

        int v = g.numVertices();
        int e = g.numEdges();

        /* NOTE: we dont need to divide v*(v-1) by 2
         * since numEdges() returns double of the 'actual' edges */
        if (v * (v-1) != e)
            return Algorithms.minDistGraph(g, ce, sum);
        return g;
    }


    private static <V,E> List<V> mergeRoutes(List<List<V>> routes) {
        var result = new LinkedList<V>();

        // Lookup set
        Set<V> aux = new HashSet<>();

        for (var route : routes) {              // O(h); h => num of hubs
            for (var vert : route) {            // O(V)
                if (!aux.contains(vert)) {      // O(1)
                    aux.add(vert);              // O(1)
                    result.add(vert);           // O(1)
                }
            }
        }

        // Net complexity: O(h*V)
        return result;
    }

    private static <V,E> List<V>
    componentTSP(Graph<V,E> g, V vOrig, Comparator<E> ce, E zero)
    {
        var tour = MetricTSP.twosApproximation(g, vOrig, ce, zero); // O(V*E)

        final int len = tour.size();                                // O(1)

        // Singleton case
        if (len == 1)
            return tour;

        // O(1)
        final int res = ce.compare(g.edge(tour.get(0), tour.get(1))
                                    .getWeight(),
                                   g.edge(tour.get(len-2), tour.get(len-1))
                                    .getWeight());
        /* NOTE:
         * For each component, we're not really really interested in
         * the full cycle; rather, we only want one path to vOrig
         * that spans the entire graph.
         * =======
         * Since the first and last elements of the tour are vOrig,
         * we simply pick whichever edge is cheaper.
         * =======
         * In the case where the first edge is the cheapest,
         * vOrig will no longer be the end vertex of our route,
         * and thus we need to reverse the list.
         */
        if (res < 0) {
            tour.removeLast();              // O(1)
            Collections.reverse(tour);      // O(V)
        } else {
            tour.pop();                     // O(V)
        }

        // Net complexity: O(V*E)
        return tour;
    }

    public static <V,E> List<V>
    fromComponents(List<Graph<V,E>> components, List<V> starting,
                   Comparator<E> ce, Function<V,E> zeroSupplier)
    {
        ensureNonNull(components, starting, ce, zeroSupplier);

        final int compSize = components.size();

        if (compSize != starting.size())
            return Collections.emptyList();

        var routes = new LinkedList<List<V>>();
        for (int i = 0; i < compSize; i++) {                    // O(h*inside); h => num of hubs
            var comp = components.get(i);                       // O(1)
            var vert = starting.get(i);                         // O(1)
            var zero = zeroSupplier.apply(vert);                // O(1)

            routes.offer(componentTSP(comp, vert, ce, zero));   // O(1) offer, O(V*E) componentTSP
        }

        // O(V) merge
        // Net complexity: O(h*V*E)
        return mergeRoutes(routes);
    }

    public static <V,E> E
    getDists(Graph<V,E> g, E zero, BinaryOperator<E> sum, List<V> route, List<E> dists)
    {
        ensureNonNull(g, zero, sum, route, dists);
        maybeClear(dists);

        E total = zero;
        final int size = route.size();                                      // O(1)
        for (int i = 1; i < size; i++) {                                    // O(V*inside)
            // NOTE: We don't need to check if edge exists due to floyd-warshall
            E weight = g.edge(route.get(i-1), route.get(i)).getWeight();    // O(1)
            dists.add(weight);                                              // O(1)
            total = sum.apply(total, weight);                               // O(1)
        }

        // Net complexity: O(V)
        return total;
    }
}
