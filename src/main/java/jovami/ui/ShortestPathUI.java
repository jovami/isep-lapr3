package jovami.ui;

import java.util.List;
import java.util.Map;

import jovami.handler.ShortestPathHandler;
import jovami.model.Distance;
import jovami.model.User;
import jovami.model.bundles.Order;
import jovami.model.store.ExpListStore.Restriction;
import jovami.util.io.InputReader;

/**
 * ShortestPathUI
 */
public class ShortestPathUI implements UserStory {
    private final ShortestPathHandler handler;
    private final List<Restriction> restrictions;

    public ShortestPathUI() {
        this.handler = new ShortestPathHandler();
        this.restrictions = List.of(Restriction.values());
    }

    @Override
    public void run() {
        final int day = InputReader.readInteger("Day of the expedition list: ");
        final int rIdx = InputReader.showAndSelectIndex(this.restrictions,
                                                        "Types of expedition lists:");

        if (!this.handler.setDayRestriction(day, this.restrictions.get(rIdx))) {
            System.err.println("error: no valid export list for that day");
            return;
        }


        final var stuff = this.handler.shortestRoute();
        printPath(stuff.first(), stuff.second());
        System.out.printf("\nTotal distance: %dm\n\n", stuff.third().getDistance());

        final var orders = this.handler.ordersByHub();
        printOrders(orders);
    }

    private void printPath(final List<User> users, final List<Distance> dists) {
        final int size = users.size();

        System.out.println("Path to take:");
        for (int i = 1; i < size; i++) {
            System.out.printf("%5s -> %-5s (%dm)\n", users.get(i-1),
                              users.get(i), dists.get(i-1).getDistance());
        }
    }

    private void printOrders(final Map<User, List<List<Order>>> map) {
        System.out.println("Bundles delivered in each hub:");

        map.forEach((hub, bundles) -> {
            int i = 0;
            System.out.printf("Hub %s bundles:\n", hub);

            for (final var b : bundles) {
                if (!b.isEmpty())
                    System.out.printf("\t%d. %s\n", ++i, b);
            }
            System.out.println();
        });
    }
}
