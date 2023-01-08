package jovami.util.graph;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import java.util.*;
import java.util.function.BinaryOperator;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jovami.util.graph.matrix.MatrixGraph;

/**
 * MetricTSPTest
 */
public class MetricTSPTest {

    private final Comparator<Integer> ceInt = Comparator.nullsLast(Integer::compare);
    private final BinaryOperator<Integer> sumInt = Integer::sum;

    private MatrixGraph<String, Integer> map;

    @BeforeEach
    void setup() {
        this.map = new MatrixGraph<>(false);
    }

    @SuppressWarnings("unused")
    private <V> void checkContentEquals(List<V> l1, List<V> l2, Comparator<? super V> cmp) {
        var ll1 = new ArrayList<>(l1);
        var ll2 = new ArrayList<>(l2);

        ll1.sort(cmp);
        ll2.sort(cmp);

        assertEquals(ll1, ll2);
    }

    private <E> E sum(List<E> l, E zero, BinaryOperator<E> op) {
        return l.stream().reduce(zero, op);
    }

    private int sum(List<Integer> l) {
        return this.sum(l, 0, Integer::sum);
    }

    private <V,E> void addSelfEdges(Graph<V,E> g, E zero) {
        g.vertices().forEach(v -> g.addEdge(v, v, zero));
    }

    @Test
    void testTwosExact() {

        map.addEdge("Porto", "Aveiro", 75);
        map.addEdge("Porto", "Braga", 60);

        var closure = Algorithms.minDistGraph(map, ceInt, sumInt);
        addSelfEdges(closure, 0);

        var vOrig = "Porto";
        var route = MetricTSP.twosApproximation(closure, vOrig, Comparator.nullsLast(ceInt), 0);

        var exp1 = List.of("Porto", "Aveiro", "Braga", "Porto");
        var exp2 = List.of("Porto", "Braga", "Aveiro", "Porto");

        if (!route.equals(exp1) && !route.equals(exp2))
            fail();

        var dists = new LinkedList<Integer>();
        int dist = TSP.getDists(closure, 0, sumInt, route, dists);

        assertEquals(vOrig, route.getFirst());
        assertEquals(vOrig, route.getLast());

        assertEquals(dist, sum(dists));

        assertEquals(60+75+135, dist);

        // Test Hub

    }

    @Test
    void testTwosApprox() {
        map.addEdge("A", "B", 2);
        map.addEdge("A", "C", 6);
        map.addEdge("A", "D", 4);
        map.addEdge("A", "E", 6);
        map.addEdge("B", "C", 6);
        map.addEdge("B", "D", 3);
        map.addEdge("B", "E", 4);
        map.addEdge("C", "D", 3);
        map.addEdge("C", "E", 6);
        map.addEdge("D", "E", 4);

        var closure = Algorithms.minDistGraph(map, ceInt, sumInt);
        addSelfEdges(closure, 0);

        var vOrig = "A";
        var route = MetricTSP.twosApproximation(closure, vOrig, Comparator.nullsLast(ceInt), 0);

        assertEquals(vOrig, route.getFirst());
        assertEquals(vOrig, route.getLast());

        var rt = new HashSet<>(route);
        map.vertices().forEach(rt::remove);

        assertEquals(Collections.emptySet(), rt);

        var dists = new LinkedList<Integer>();
        int dist = TSP.getDists(closure, 0, sumInt, route, dists);
        assertEquals(dist, sum(dists));

        int optimal = 20;
        System.out.println(dist);
        assertTrue(dist <= 2*optimal);
    }
}
