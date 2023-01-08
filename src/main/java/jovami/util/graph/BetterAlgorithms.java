package jovami.util.graph;

import jovami.util.graph.map.MapGraph;

import java.util.*;
import java.util.function.BinaryOperator;

public class BetterAlgorithms {

    /**
     * Checks if two vertices have a connection via a breadth-first search
     *
     * @param g         Graph instance
     * @param source    The source vertex
     * @param dest      The intended destination
     */
    public static <V, E> boolean hasConnection(Graph<V, E> g, V source, V dest) {
        if (source == null || dest == null || !g.validVertex(source) || !g.validVertex(dest))
            return false;
        else if (g.key(source) == g.key(dest))
            return true;

        Queue<V> queue = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];

        queue.offer(source);

        V next;
        while ((next = queue.poll()) != null) {
            for (V vAdj : g.adjVertices(next)) {
                if (g.key(vAdj) == g.key(dest))
                    return true;
                else if (!visited[g.key(vAdj)]) {
                    queue.offer(vAdj);
                    visited[g.key(vAdj)] = true;
                }
            }
        }

        return false;
    }

    /**
     * Computes the shortest path distance between a vertex and all vertices in a poll
     * @param <V>               Class that represents a vertex
     * @param <E>               Class that represents the distance between two connected vertices
     * @param g                 The graph to search in
     * @param vOrig             The source vertex
     * @param pool              Pool of destinations for which to compute the shortest path distance
     * @param ce                Comparator between elements of type E
     * @param sum               Sum two elements of type E
     * @param zero              Neutral element of the sum in elements of type E
     * @return                  LinkedList of all the distances computed
     */
    public static <V, E> LinkedList<E>
    shortestPathsForPool(Graph<V,E> g, V vOrig, List<V> pool,
                         Comparator<E> ce, BinaryOperator<E> sum, E zero)
    {
        var dists = new LinkedList<E>();

        // Required by shortestPath()
        var tmp = new LinkedList<V>();

        for (V dest : pool) {   // O(V)
            // O(V^2)
            dists.push(Algorithms.shortestPath(g, vOrig, dest, ce, sum, zero, tmp));
        }

        // Net complexity: O(V^3)
        return dists;
    }

    public static <V,E> Graph<V,E> getUndirectedGraph(Graph<V,E> g) {
        Objects.requireNonNull(g);

        if (!g.isDirected())
            return g;

        Graph<V,E> newGraph = g.clone();    // O(V*E)

        for (var e : newGraph.edges())      // O(E)
            newGraph.addEdge(e.getVDest(), e.getVOrig(), e.getWeight());

        // Net complexity: O(V*E)
        return newGraph;
    }

    public static <V,E> boolean isConnected(Graph<V, E> g) {
        Objects.requireNonNull(g);

        g = getUndirectedGraph(g);  // O(V*E)

        // O(V*E)
        return Algorithms.BreadthFirstSearch(g, g.vertex(0)).size() == g.numVertices();
    }


    public static <V,E> Graph<V,E> kruskalMST(Graph<V,E> g, Comparator<E> ce) {   //O(E*log E)
        PriorityQueue<Edge<V,E>> lstEdges = new PriorityQueue<>(Comparator.comparing(Edge::getWeight, ce));

        Graph<V, E> mst = new MapGraph<>(g.isDirected());

        for (V vertex : g.vertices()) {             // O(V)
            mst.addVertex(vertex);
        }

        lstEdges.addAll(g.edges());                 // O(E)

        // Kruskal stops when V-1 edges are 'selected'
        int n = g.numVertices() - 1;

        while (n > 0 && !lstEdges.isEmpty()) {      // O(V)
            Edge<V, E> e1 = lstEdges.poll();
            if (!hasConnection(mst, e1.getVOrig(), e1.getVDest())) { // O(V*E)
                mst.addEdge(e1.getVOrig(), e1.getVDest(), e1.getWeight());
                n--;
            }
        }

        // O(V^2*E)
        return mst;
    }
}
