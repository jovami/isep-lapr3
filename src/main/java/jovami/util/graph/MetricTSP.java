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

        for (V vert : g.vertices()) {                       // O(V)
            int k = g.key(vert);
            dist[k] = null;
            pathKeys[k] = null;
            visited[k] = false;
        }
        dist[g.key(vOrig)] = zero;

        // O(V*E)
        mstPrimImpl(g, Comparator.nullsLast(ce), vOrig, visited, pathKeys, dist);
        // O(V) mstBuild()
        // Net complexity: O(V*E)
        return mstBuild(g, pathKeys, dist);
    }

    private static <V,E> void mstPrimImpl(Graph<V,E> g, Comparator<E> ce,
                                          V vOrig, boolean[] visited,
                                          V[] pathKeys, E[] dist)
    {
        while (vOrig != null) {                                             // O(V*inside)
            int origKey = g.key(vOrig);                                     // O(1)
            visited[origKey] = true;                                        // O(1)
            for (var edge : g.outgoingEdges(vOrig)) {                       // O(E*inside)
                int vAdj = g.key(edge.getVDest());                          // O(1)
                E weight = edge.getWeight();                                // O(1)
                if (!visited[vAdj] && ce.compare(dist[vAdj], weight) > 0) { // O(1)
                    dist[vAdj] = weight;                                    // O(1)
                    pathKeys[vAdj] = vOrig;
                }
            }
            vOrig = Algorithms.getVertMinDist(g, visited, dist, ce);        // O(V)
        }

        // Net complexity: O(V*E)
    }

    private static <V,E> Graph<V,E> mstBuild(Graph<V,E> g, V[] pathKeys, E[] dist) {
        Graph<V,E> mst = new MapGraph<>(g.isDirected());

        for (int i = 0; i < pathKeys.length; i++) {         // O(V*inside)
            V dest = g.vertex(i);                           // O(1)

            if (pathKeys[i] == null)                        // O(1)
                mst.addVertex(dest);                        // O(1)
            else
                mst.addEdge(pathKeys[i], dest, dist[i]);    // O(1)
        }

        // Net complexity: O(V)
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
     * @see <a href="https://ocw.mit.edu/courses/6-046j-design-and-analysis-of-algorithms-spring-2015/">...</a>
     * @apiNote g must be a complete graph
     */
    public static <V,E> LinkedList<V>
    twosApproximation(Graph<V,E> g, V vOrig, Comparator<E> ce, E zero)
    {
        ensureNonNull(g, vOrig, ce, zero);

        var mst = mstPrim(g, vOrig, ce, zero);              // O(V*E)

        var tour = Algorithms.DepthFirstSearch(mst, vOrig); // O(V*E)

        /* NOTE:
         * We don't need to shortcut over any vertices
         * because our DFS implementation does that for us.
         * We use push() rather than offer() to finish the cycle
         * since our DFS impl returns the list in reverse
         * order of traversal.
         */
        if (tour.size() > 1)                                // O(1)
            tour.push(vOrig);                               // O(1)
        // Net complexity: O(V*E)
        return tour;
    }


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

    //
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
