package jovami.util.graph;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.function.BinaryOperator;

import jovami.util.graph.matrix.MatrixGraph;

public class Algorithms {

    /**
     * Performs breadth-first search of a Graph starting in a vertex
     *
     * @param g    Graph instance
     * @param vert vertex that will be the source of the search
     * @return a LinkedList with the vertices of breadth-first search
     */
    public static <V, E> LinkedList<V> BreadthFirstSearch(Graph<V, E> g, V vert) {
        if (!g.validVertex(vert))                                                       //O(1)
            return new LinkedList<>();

        LinkedList<V> qbfs = new LinkedList<>();
        LinkedList<V> qaux = new LinkedList<>();
        boolean[] visited = new boolean[g.numVertices()];

        qbfs.add(vert);
        qaux.add(vert);
        visited[g.key(vert)] = true;

        while (!qaux.isEmpty()) {
            vert = qaux.getFirst();
            qaux.removeFirst();
            for (V vAdj : g.adjVertices(vert)) {
                if (!visited[g.key(vAdj)]) {
                    qbfs.add(vAdj);
                    qaux.add(vAdj);
                    visited[g.key(vAdj)] = true;
                }
            }
        }
        return qbfs;
    }



    /**
     * Performs depth-first search starting in a vertex
     *
     * @param g       Graph instance
     * @param vOrig   vertex of graph g that will be the source of the search
     * @param visited set of previously visited vertices
     * @param qdfs    return Stack with vertices of depth-first search
     */
    private static <V, E> void DepthFirstSearch(Graph<V, E> g, V vOrig, boolean[] visited, LinkedList<V> qdfs) {
        if (visited[g.key(vOrig)])
            return;

        qdfs.push(vOrig);
        visited[g.key(vOrig)] = true;

        for (V vAdj : g.adjVertices(vOrig)) {
            DepthFirstSearch(g, vAdj, visited, qdfs);
        }
    }

    /**
     * Performs depth-first search starting in a vertex
     *
     * @param g    Graph instance
     * @param vert vertex of graph g that will be the source of the search
     * @return a LinkedList with the vertices of depth-first search
     */
    public static <V, E> LinkedList<V> DepthFirstSearch(Graph<V, E> g, V vert) {
        if (!g.validVertex(vert))                                                       //O(1)
            return new LinkedList<>();

        boolean[] visited = new boolean[g.numVertices()];
        LinkedList<V> qdfs = new LinkedList<>();

        DepthFirstSearch(g, vert, visited, qdfs);
        return qdfs;
    }

    /**
     * Returns all paths from vOrig to vDest
     *
     * @param g       Graph instance
     * @param vOrig   Vertex that will be the source of the path
     * @param vDest   Vertex that will be the end of the path
     * @param visited set of discovered vertices
     * @param path    stack with vertices of the current path (the path is in reverse order)
     * @param paths   ArrayList with all the paths (in correct order)
     */
    private static <V, E> void allPaths(Graph<V, E> g, V vOrig, V vDest, boolean[] visited,
                                        LinkedList<V> path, ArrayList<LinkedList<V>> paths) {
        path.push(vOrig);
        visited[g.key(vOrig)] = true;
        for (V vAdj : g.adjVertices(vOrig)) {
            if (vOrig.equals(vDest)) {
                path.push(vDest);
                paths.add(path);
                path.pop();
            } else {
                if (visited[g.key(vAdj)])
                    allPaths(g, vAdj, vDest, visited, path, paths);
            }
            path.pop();
        }
    }

    /**
     * Returns all paths from vOrig to vDest
     *
     * @param g     Graph instance
     * @param vOrig information of the Vertex origin
     * @param vDest information of the Vertex destination
     * @return paths ArrayList with all paths from vOrig to vDest
     */
    public static <V, E> ArrayList<LinkedList<V>> allPaths(Graph<V, E> g, V vOrig, V vDest) {
        if (!g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        boolean[] visited = new boolean[g.numVertices()];
        ArrayList<LinkedList<V>> paths = new ArrayList<>();
        LinkedList<V> path = new LinkedList<>();

        allPaths(g, vOrig, vDest, visited, path, paths);
        return paths;
    }

    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
     * This implementation uses Dijkstra's algorithm
     *
     * @param g        Graph instance
     * @param vOrig    Vertex that will be the source of the path
     * @param visited  set of previously visited vertices
     * @param pathKeys minimum path vertices keys
     * @param dist     minimum distances
     */
    private static <V, E> void shortestPathDijkstra(Graph<V, E> g, V vOrig,
                                                    Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                    boolean[] visited, V[] pathKeys, E[] dist) {
        while (vOrig != null) {
            visited[g.key(vOrig)] = true;
            for (var edge : g.outgoingEdges(vOrig)) {
                V vAdj = edge.getVDest();
                E distSum = sum.apply(dist[g.key(vOrig)], edge.getWeight());
                if (!visited[g.key(vAdj)] && ce.compare(dist[g.key(vAdj)], distSum) > 0) {
                    dist[g.key(vAdj)] = distSum;
                    pathKeys[g.key(vAdj)] = vOrig;
                }
            }
            vOrig = getVertMinDist(g, visited, dist, ce);
        }
    }

    protected static <V, E> V getVertMinDist(Graph<V, E> g, boolean[] visited, E[] dist, Comparator<E> ce) {
        V result = null;
        E min = null;

        int i;
        for (i = 0; i < dist.length; i++) {                     // O(V*inside)
            if (!visited[i] && ce.compare(min, dist[i]) > 0) {  // O(1)
                min = dist[i];                                  // O(1)
                result = g.vertex(i);                           // O(1)
            }
        }

        // Net complexity: O(V)
        return result;
    }


    /**
     * Shortest-path between two vertices
     *
     * @param g         graph
     * @param vOrig     origin vertex
     * @param vDest     destination vertex
     * @param ce        comparator between elements of type E
     * @param sum       sum two elements of type E
     * @param zero      neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */
    public static <V, E> E shortestPath(Graph<V, E> g, V vOrig, V vDest,
                                        Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                        LinkedList<V> shortPath) {
        if (vOrig == null || vDest == null || !g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        shortPath.clear();

        if (g.key(vOrig) == g.key(vDest)) {
            shortPath.push(vDest);
            return zero;
        }

        @SuppressWarnings("unchecked")
        var dist = (E[]) new Object[g.numVertices()];
        @SuppressWarnings("unchecked")
        var pathKeys = (V[]) new Object[g.numVertices()];

        var visited = new boolean[g.numVertices()];

        for (V vert : g.vertices()) {
            dist[g.key(vert)] = null;
            pathKeys[g.key(vert)] = null;
            visited[g.key(vert)] = false;
        }
        dist[g.key(vOrig)] = zero;

        shortestPathDijkstra(g, vOrig, Comparator.nullsLast(ce), sum, zero, visited, pathKeys, dist);

        if (pathKeys[g.key(vDest)] == null)
            return null;

        E minDist = dist[g.key(vDest)];

        getPath(g, vOrig, vDest, pathKeys, shortPath);

        return minDist;
    }

    /**
     * Shortest-path between a vertex and all other vertices
     *
     * @param g     graph
     * @param vOrig start vertex
     * @param ce    comparator between elements of type E
     * @param sum   sum two elements of type E
     * @param zero  neutral element of the sum in elements of type E
     * @param paths returns all the minimum paths
     * @param dists returns the corresponding minimum distances
     */
    public static <V, E> void shortestPaths(Graph<V, E> g, V vOrig,
                                            Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                            ArrayList<LinkedList<V>> paths, ArrayList<E> dists)
    {
        paths.clear();
        dists.clear();

        for (V vert : g.vertices()) {
            LinkedList<V> newPaths = new LinkedList<>();
            dists.add(g.key(vert), shortestPath(g, vOrig, vert, ce, sum, zero, newPaths));
            paths.add(g.key(vert), newPaths);
        }
    }


    /**
     * Extracts from pathKeys the minimum path between voInf and vdInf
     * The path is constructed from the end to the beginning
     *
     * @param g        Graph instance
     * @param vOrig    information of the Vertex origin
     * @param vDest    information of the Vertex destination
     * @param pathKeys minimum path vertices keys
     * @param path     stack with the minimum path (correct order)
     */
    private static <V, E> void getPath(Graph<V, E> g, V vOrig, V vDest,
                                       V[] pathKeys, LinkedList<V> path) {

        V v = vDest;

        while (pathKeys[g.key(v)] != null) {
            path.push(v);
            v = pathKeys[g.key(v)]; // predecessor
        }
        if (v != null && g.key(vOrig) == g.key(v))
            path.push(v);
    }

    /**
     * Calculates the minimum distance graph using Floyd-Warshall
     *
     * @param g   initial graph
     * @param ce  comparator between elements of type E
     * @param sum sum two elements of type E
     * @return the minimum distance graph
     */
    public static <V, E> MatrixGraph<V, E> minDistGraph(Graph<V, E> g, Comparator<E> ce, BinaryOperator<E> sum) {
        int n = g.numVertices();
        var matrix = new MatrixGraph<>(g);

        for (int k = 0; k < n; k++) {
            for(int i = 0; i < n; i++){
                if(i != k && matrix.edge(i, k) != null){
                    for (int j = 0; j < n; j++){
                        if(i != j && k != j && matrix.edge(k, j) != null){
                            E weight = sum.apply(matrix.edge(i, k).getWeight(), matrix.edge(k, j).getWeight());
                            var edge = matrix.edge(i, j);
                            if (edge == null || ce.compare(edge.getWeight(), weight) > 0)
                                matrix.addEdge(matrix.vertex(i), matrix.vertex(j), weight);
                        }
                    }
                }
            }
        }
        return matrix;
    }


}

