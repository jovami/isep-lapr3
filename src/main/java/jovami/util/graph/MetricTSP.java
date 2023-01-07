package jovami.util.graph;

import java.util.Comparator;
import java.util.LinkedList;
import java.util.Objects;

import jovami.util.graph.map.MapGraph;

/**
 * TSP
 */
public class MetricTSP {

    private static void ensureNonNull(Object... objs) {
        for (var obj : objs) {
            Objects.requireNonNull(obj);
        }
    }

    public static <V,E> Graph<V,E>
    mstPrim(Graph<V,E> g, V vOrig, Comparator<E> ce, E zero) {
        ensureNonNull(g, vOrig, ce, zero);

        @SuppressWarnings("unchecked")
        var dist = (E[]) new Object[g.numVertices()];
        @SuppressWarnings("unchecked")
        var pathKeys = (V[]) new Object[g.numVertices()];

        var visited = new boolean[g.numVertices()];

        for (V vert : g.vertices()) {
            int k = g.key(vert);
            dist[k] = null;
            pathKeys[k] = null;
            visited[k] = false;
        }
        dist[g.key(vOrig)] = zero;

        mstPrimImpl(g, ce, vOrig, visited, pathKeys, dist);
        return mstBuild(g, pathKeys, dist);
    }

    private static <V,E> void mstPrimImpl(Graph<V,E> g, Comparator<E> ce,
                                          V vOrig, boolean[] visited,
                                          V[] pathKeys, E[] dist)
    {
        while (vOrig != null) {
            int origKey = g.key(vOrig);
            visited[origKey] = true;
            for (var edge : g.outgoingEdges(vOrig)) {
                int vAdj = g.key(edge.getVDest());
                E weight = edge.getWeight();
                if (!visited[vAdj] && ce.compare(dist[vAdj], weight) > 0) {
                    dist[vAdj] = weight;
                    pathKeys[vAdj] = vOrig;
                }
            }
            vOrig = Algorithms.getVertMinDist(g, visited, dist, ce);
        }
    }

    private static <V,E> Graph<V,E> mstBuild(Graph<V,E> g, V[] pathKeys, E[] dist) {
        Graph<V,E> mst = new MapGraph<>(g.isDirected());

        for (int i = 0; i < pathKeys.length; i++) {
            V dest = g.vertex(i);

            if (pathKeys[i] == null)
                mst.addVertex(dest);
            else
                mst.addEdge(pathKeys[i], dest, dist[i]);
        }

        return mst;
    }

    /**
     * Two's approximation of a TSP over a metric space
     * @param g     the TSP graph
     * @param vOrig the vertex to start/end at
     * @param ce    edge Comparator
     * @param zero  the E class equivalent of the arithmetic zero
     *
     * @return the resulting TSP tour
     *
     * @see https://ocw.mit.edu/courses/6-046j-design-and-analysis-of-algorithms-spring-2015/
     * @apiNote g must be a complete graph
     */
    public static <V,E> LinkedList<V>
    twosApproximation(Graph<V,E> g, V vOrig, Comparator<E> ce, E zero)
    {
        ensureNonNull(g, vOrig, ce, zero);

        var mst = mstPrim(g, vOrig, ce, zero);

        var tour = Algorithms.DepthFirstSearch(mst, vOrig);

        /* NOTE:
         * We don't need to shortcut over any vertices
         * because our DFS implementation does that for us.
         * We use push() rather than offer() to finish the cycle
         * since our DFS impl returns the list in reverse
         * order of traversal.
         */
        if (tour.size() > 1)
            tour.push(vOrig);
        return tour;
    }

    // TODO: delete this since we're not using Christofides' algorithm
    // private static <V,E> Graph<V,E> oddDegreeSubgraph(Graph<V,E> g) {
    //     var list = new ArrayList<V>(g.numVertices());

    //     for (V v : g.vertices()) {
    //         if ((g.outDegree(v) & 1) == 1)
    //             list.add(v);
    //     }

    //     final int size = list.size();
    //     var odg = new MatrixGraph<V,E>(g.isDirected(), size);

    //     for (int i = 0; i < size; i++) {
    //         V v1 = list.get(i);

    //         for (int j = 0; j < size; j++) {
    //             var edge = g.edge(v1, list.get(j));
    //             if (edge != null)
    //                 odg.addEdge(edge.getVOrig(), edge.getVDest(), edge.getWeight());
    //         }
    //     }

    //     // TODO: check if this is needed
    //     // if (odg.numVertices() != size)
    //     //     list.forEach(odg::addVertex);

    //     return odg;
    // }

    // public static <V,E> Graph<V,E> perfectMatchingGraph(Graph<V,E> g)
    // {

    //     return null;
    // }

    // // private static <V,E> void
    // // hieholzerCircuit(Graph<V,E> g, V vOrig, Set<Pair<V,V>> visited, ) {

    // // }


    // public static <V,E> Graph<V,E>
    // travelingSalesman(Graph<V,E> g, V vOrig,
    //                    Comparator<E> ce, BinaryOperator<E> sum,
    //                    E zero)
    // {
    //     ensureNonNull(g, vOrig, ce, sum, zero);

    //     if (g.isDirected())
    //         throw new UnsupportedOperationException("TSP not implemented for directed graphs!");

    //     g = getCompleteGraph(g, ce, sum);
    //     var mst = mstPrim(g, vOrig, ce, zero);

    //     var pmg = perfectMatchingGraph(oddDegreeSubgraph(g));


    //     var pmgEdges = pmg.edges();
    //     for (var edge : pmgEdges) {
    //         mst.addEdge(edge.getVOrig(), edge.getVDest(), edge.getWeight());
    //     }



    //     return mst;
    // }
}
