package jovami.graph;

import java.util.*;
import java.util.function.BinaryOperator;

public class Algorithms {

    /**
     * Performs breadth-first search of a Graph starting in a vertex
     *
     * @param g    Graph instance
     * @param vert vertex that will be the source of the search
     * @return a LinkedList with the vertices of breadth-first search
     */
    public static <V, E> LinkedList<V> BreadthFirstSearch(Graph<V, E> g, V vert) {
        if (!g.vertices().contains(vert))
            return null;

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
        if (!g.vertices().contains(vert))
            return null;

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
<<<<<<< development
<<<<<<< development

    /**
     * Computes shortest-path distance from a source vertex to all reachable
     * vertices of a graph g with non-negative edge weights
=======

    /**
     * Computes shortest-path distance from a source vertex to all reachable
<<<<<<< development
     * vertices of a graph g with unweighted edge weights
>>>>>>> feat(esinf/graphs): implementation of a method to calculate the shortest path using Dijkstra algorithm for unweighted graphs
=======
     * vertices of a graph g with non-negative edge weights
>>>>>>> feat(esinf/graphs): implementation of a new version of the Dijkstra algorithm
     * This implementation uses Dijkstra's algorithm
     *
     * @param g        Graph instance
     * @param vOrig    Vertex that will be the source of the path
<<<<<<< development
<<<<<<< development
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
                if(!visited[g.key(vAdj)] && ce.compare(dist[g.key(vAdj)], sum.apply(dist[g.key(vOrig)], edge.getWeight())) > 0){
                    dist[g.key(vAdj)] = sum.apply(dist[g.key(vOrig)], edge.getWeight());
                    pathKeys[g.key(vAdj)] = vOrig;
                    visited[g.key(vAdj)] = true;
                }
            }
            vOrig = getVertMinDist(g, visited, dist, ce);
        }
    }

    private static <V,E> V getVertMinDist(Graph<V,E> g, boolean[] visited, E[] dist, Comparator<E> ce) {
        V result = null;
        E min = dist[1];

        int i;
        for (i = 2; i < dist.length; i++) {
            if (!visited[i] && ce.compare(min, dist[i]) > 0) {
                min = dist[i];
                result = g.vertex(i);
            }
        }

        return result;
    }

    /** Shortest-path between two vertices
     *
     * @param g graph
     * @param vOrig origin vertex
     * @param vDest destination vertex
     * @param ce comparator between elements of type E
     * @param sum sum two elements of type E
     * @param zero neutral element of the sum in elements of type E
     * @param shortPath returns the vertices which make the shortest path
     * @return if vertices exist in the graph and are connected, true, false otherwise
     */
    public static <V, E> E shortestPath(Graph<V, E> g, V vOrig, V vDest,
                                        Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                        LinkedList<V> shortPath) {
        if (!g.validVertex(vOrig) || !g.validVertex(vDest))
            return null;

        @SuppressWarnings("unchecked")
        var dist = (E[]) new Object[g.numVertices()];
        @SuppressWarnings("unchecked")
        var pathKeys = (V[]) new Object[g.numVertices()];

        var visited = new boolean[g.numVertices()];

        for(V vert : g.vertices()){
            dist[g.key(vert)] = null;
            pathKeys[g.key(vert)] = null;
            visited[g.key(vert)] = false;
        }
        dist[g.key(vOrig)] = zero;

        shortestPathDijkstra(g, vOrig, Comparator.nullsLast(ce), sum, zero, visited, pathKeys, dist);
        V v = vDest;
        E minDist = zero;

        while (v != vOrig && v != null) {
            shortPath.push(v);
            minDist = sum.apply(minDist, dist[g.key(v)]);
            v = pathKeys[g.key(v)]; // predecessor
        }
        if (v != null) {
            shortPath.push(v);
            minDist = sum.apply(minDist, dist[g.key(v)]);
        }

        return minDist;
    }
=======
>>>>>>> feat(graphs): implementation of a a method allPaths that returns all possible paths from a vertex to another
=======
     * @param pathKeys minimum path vertices keys
     * @param dist     minimum distances
     */
    private static <V, E> int[] shortestPathDijkstraUnweighted(Graph<V, E> g, V vOrig,
                                                            int[] pathKeys, double[] dist) {
        PriorityQueue<V> auxQueue = new PriorityQueue<>(g.vertices());

        for (V vert : g.vertices()) {
            dist[g.key(vert)] = Double.MAX_VALUE;
            pathKeys[g.key(vert)] = -1;
        }
        auxQueue.add(vOrig);
        dist[g.key(vOrig)] = 0;

        while (!auxQueue.isEmpty()) {
            auxQueue.remove(vOrig);
            for (V vAdj : g.adjVertices(vOrig)) {
                if (dist[g.key(vAdj)] == Double.MAX_VALUE) {
                    dist[g.key(vAdj)] = dist[g.key(vOrig)] + 1;
                    pathKeys[g.key(vAdj)] = g.key(vOrig);
                    auxQueue.add(vAdj);
                }
            }
        }
        return pathKeys;
    }

<<<<<<< development
    
>>>>>>> feat(esinf/graphs): implementation of a method to calculate the shortest path using Dijkstra algorithm for unweighted graphs
=======
    private static <V, E> int[] shortestPathDijkstraWeighted(Graph<V,E> g, V vOrig, boolean[] visited,
                                                             int[] path, double[] dist){
        for (V vert : g.vertices()) {
            dist[g.key(vert)] = Double.MAX_VALUE;
            path[g.key(vert)] = -1;
=======
     * @param visited  set of previously visited vertices
     * @param pathKeys minimum path vertices keys
     * @param dist     minimum distances
     */
    private static <V, E> void shortestPathDijkstra(Graph<V, E> g, V vOrig,
                                                    Comparator<E> ce, BinaryOperator<E> sum, E zero,
                                                    boolean[] visited, V[] pathKeys, E[] dist) {
        for(V vert : g.vertices()){
            dist[g.key(vert)] = null;
            pathKeys[g.key(vert)] = null;
>>>>>>> feat(esinf/graphs): implementation of a new version of the Dijkstra algorithm
            visited[g.key(vert)] = false;
        }
        dist[g.key(vOrig)] = zero;

        while (vOrig != null) {
            visited[g.key(vOrig)] = true;
            for (V vAdj : g.adjVertices(vOrig)) {
                Edge<V,E> edge = g.edge(vOrig, vAdj);
                if(!visited[g.key(vAdj)] && ce.compare(dist[g.key(vAdj)], sum.apply(dist[g.key(vOrig)], edge.getWeight())) >= 0){
                    dist[g.key(vAdj)] = sum.apply(dist[g.key(vOrig)], edge.getWeight());
                    pathKeys[g.key(vAdj)] = vOrig;
                }
            }
            vOrig = g.vertex(getVertMinDist(visited, dist, ce));
        }
    }

    private static <E> int getVertMinDist(boolean[] visited, E[] dist, Comparator<E> ce) {
        E min = dist[0];
        int i = 0;
        for (i = 1; i < dist.length; i++) {
            if (!visited[i] && ce.compare(min, dist[i]) > 0)
                min = dist[i];
        }

        return i;
    }
<<<<<<< development
>>>>>>> feat(esinf/graphs): implementation of a method to calculate the shortest path using Dijkstra algorithm for weighted graphs
=======

>>>>>>> feat(esinf/graphs): implementation of a new version of the Dijkstra algorithm
}
