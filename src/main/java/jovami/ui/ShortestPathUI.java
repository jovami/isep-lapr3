package jovami.ui;

import java.util.List;
import java.util.Map;

import jovami.handler.ShortestPathHandler;
import jovami.model.Distance;
import jovami.model.User;
import jovami.model.bundles.Order;
import jovami.util.io.InputReader;

/**
 * ShortestPathUI
 */
public class ShortestPathUI implements UserStory {
    private final ShortestPathHandler handler;

    public ShortestPathUI() {
        this.handler = new ShortestPathHandler();
    }

	@Override
	public void run() {
        int day = InputReader.readInteger("Day of the expedition list: ");

        if (!this.handler.setDay(day)) {
            System.err.println("error: no valid export list for that day");
            return;
        }

        // TODO: change variable name
        var stuff = this.handler.shortestRoute();
        printPath(stuff.first(), stuff.second());
        System.out.printf("\nTotal distance: %dm\n\n", stuff.third().getDistance());

        var orders = this.handler.ordersByHub();
        printOrders(orders);
	}

    private void printPath(List<User> users, List<Distance> dists) {
        final int size = users.size();

        System.out.println("Path to take:");
        for (int i = 1; i < size; i++) {
            System.out.printf("%5s -> %-5s (%dm)\n", users.get(i-1),
                              users.get(i), dists.get(i-1).getDistance());
        }
    }

    private void printOrders(Map<User, List<List<Order>>> map) {
        System.out.println("Bundles delivered in each hub:");

        map.forEach((hub, bundles) -> {
            System.out.printf("Hub %s bundles:\n", hub);

            for (var bundle : bundles)
                System.out.printf("\t%s\n", bundle);
            System.out.println();
        });
    }
}
