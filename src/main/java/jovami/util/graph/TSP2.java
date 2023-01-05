package jovami.util.graph;

import java.util.Collection;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.function.BinaryOperator;

/**
 * TSP2
 */
public class TSP2 {

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

        for (var route : routes) {
            for (var vert : route) {
                if (!aux.contains(vert)) {
                    aux.add(vert);
                    route.add(vert);
                }
            }
        }

        return result;
    }


    private static <V,E> List<V>
    bruteforceComponent(Graph<V,E> g, Comparator<E> ce, BinaryOperator<E> sum)
    {
        // TODO: implementation
        return null;
    }

    public static <V,E> List<V>
    tspFromComponents(List<Graph<V,E>> components, Comparator<E> ce, BinaryOperator<E> sum)
    {
        ensureNonNull(components, ce, sum);

        var routes = new LinkedList<List<V>>();
        for (var comp : components) {
            routes.offer(bruteforceComponent(comp, ce, sum));
        }

        return mergeRoutes(routes);
    }

    public static <V,E> E
    getDists(Graph<V,E> g, E zero, BinaryOperator<E> sum, List<V> route, List<E> dists)
    {
        ensureNonNull(g, zero, sum, route, dists);
        maybeClear(dists);

        E dist = zero;
        final int size = route.size();
        for (int i = 1; i < size; i++) {
            // We don't need to check if edge exists due to floyd-warshall
            E weight = g.edge(route.get(i-1), route.get(i))
                        .getWeight();
            dists.add(weight);
            dist = sum.apply(dist, weight);
        }

        return dist;
    }
}
