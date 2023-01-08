package jovami.handler;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jovami.App;
import jovami.MainTest;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.store.BundleStore;
import jovami.model.store.ExpListStore.Restriction;
import jovami.util.Pair;

/**
 * ShortestPathHandlerTest
 */
public class ShortestPathHandlerTest {

    private App app;
    private HubNetwork network;
    private ShortestPathHandler handler;
    private final List<Restriction> rests = List.of(Restriction.values());

    @BeforeEach
    void setup() {
        this.setup(false);
    }

    void setup(boolean big) {
        MainTest.resetSingleton();
        this.app = App.getInstance();

        MainTest.readData(big);
        this.network = this.app.hubNetwork()
                               .transitiveClosure()
                               .addSelfCycles();

        new NearestHubToClientsHandler().findNearestHubs();
        this.handler = new ShortestPathHandler();
    }

    // Helper methods to avoid writing the same test code every time
    private User getUser(String locId) {
        var usr = this.app.userStore().getUser(locId);
        assertTrue(usr.isPresent());
        return usr.get();
    }

    private void checkNoDupes(List<User> route) {
        assertEquals(Set.copyOf(route).size(), route.size(), "Route contained duplicate locations!");
    }

    private void checkDistMatch(List<Distance> dists, List<User> route) {
        assertEquals(route.size(), dists.size()+1, "dists.size() should've been one less than route.size()");

        final int len = route.size();
        for (int i = 0; i < len-1; i++) {
            Distance expected = this.network.edge(route.get(i), route.get(i+1)).getWeight();
            assertEquals(expected, dists.get(i), "Distances did not match!");
        }
    }

    @SuppressWarnings("unused")
    private void checkNoMissingOrExtra(List<User> route, String... expLocIds) {
        var expectedUsers = Stream.of(expLocIds)
                                  .map(this::getUser)
                                  .collect(Collectors.toSet());
        checkNoMissingOrExtra(route, expectedUsers);
    }

    private void checkNoMissingOrExtra(List<User> route, Set<User> expectedUsers) {
        var excess = new HashSet<>(route);
        excess.removeAll(expectedUsers);
        assertTrue(excess.isEmpty(), "Route had extra vertices!!");

        var missing = new HashSet<>(expectedUsers);
        route.forEach(missing::remove);
        assertTrue(missing.isEmpty(), "Route had missing vertices!!");
    }

    private void checkRightTotal(List<Distance> dists, Distance expected) {
        var actual = dists.stream()
                          .reduce(Distance.zero, Distance.sum);

        assertEquals(expected, actual, "Total distance did not match with the expected!!");
    }

    /**
     * Exaustive permutations test
     */
    @Test
    void testSeveralPermutations() {
        final int maxDays = 5;

        IntStream
            .rangeClosed(1, maxDays)
            .boxed()
            .flatMap(i -> rests.stream().map(r -> new Pair<>(i, r)))
            .forEach(p -> {
                     int day = p.first();
                     Restriction r = p.second();

                     System.out.printf("SMALL: Testing for day %d, with restriction \"%s\"\n", day, r);
                     setup(false);
                     dayRestrictionTest(day, r);

                     // RIP PC :/
                     // System.out.printf("BIG: Testing for day %d, with restriction \"%s\"\n", day, r);
                     // setup(true);
                     // this.handler.setDayRestriction(day, r);
                     // dayRestrictionTest(day, r);
            });
    }


    private void dayRestrictionTest(int day, Restriction r) {
        final int minTop = 1;
        final int maxTop = 10;

        switch (r) {
            case NONE -> {
                var bundles = new ExpBasketListHandler().expBasketsList().get(day);
                this.handler.setDayRestriction(day, r);
                routeTest(bundles);
            }
            case PRODUCERS -> IntStream
                    .range(minTop, maxTop)
                    .forEach(top -> {
                        System.out.printf("\t-> Testing top %d producers\n", top);
                        var bs = new ExpListNProducersHandler().expListNProducers(top).get(day);
                        this.handler.setDayRestriction(day, r);
                        routeTest(bs);
                    });
        }
        System.out.println("Success!!");
    }

    private void routeTest(List<Bundle> bundles) {
        var data = this.handler.shortestRoute();

        var route = data.first();
        var dists = data.second();
        var total = data.third();

        assertFalse(route.isEmpty());
        assertFalse(dists.isEmpty());
        assertNotEquals(0, total.getDistance(), "Distance was zero!!");

        checkNoDupes(route);
        checkDistMatch(dists, route);
        checkRightTotal(dists, total);

        var points = new HashSet<User>();
        BundleStore
            .producersPerHub(bundles)
            .forEach((hub, prods) -> {
                 points.add(hub);
                 points.addAll(prods);
            });

        checkNoMissingOrExtra(route, points);
    }


    @Test
    void testInvalidDay() {
        int day = 0;

        new ExpBasketListHandler().expBasketsList();
        new ExpListNProducersHandler().expListNProducers(1);

        rests.forEach(r -> assertFalse(this.handler.setDayRestriction(day, r)));

        // setup(true);
        // new ExpBasketListHandler().expBasketsList();
        // new ExpListNProducersHandler().expListNProducers(1);
        // rests.forEach(r -> assertFalse(this.handler.setDayRestriction(day, r)));
    }

    @Test
    void testEmptyBundle() {
        final int maxDays = 5;
        IntStream
            .rangeClosed(1, maxDays)
            .forEach(this::testEmptyBundleDay);
    }

    private void testEmptyBundleDay(int day) {
        rests.forEach(r -> {
            MainTest.resetSingleton();
            this.handler = new ShortestPathHandler();

            assertFalse(this.handler.setDayRestriction(day, r));
            assertThrows(IllegalStateException.class, this.handler::shortestRoute);

            App.getInstance().expListStore().addExpList(r, new ExpList());

            assertFalse(this.handler.setDayRestriction(day, r));
            var data = this.handler.shortestRoute();

            assertTrue(data.first().isEmpty());
            assertTrue(data.second().isEmpty());
            assertEquals(data.third(), Distance.zero);

            assertTrue(this.handler.ordersByHub().isEmpty());
        });
    }
}
