package jovami.handler;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.store.UserStore;
import jovami.util.Triplet;

/**
 * NearestHubToClientsHandler
 */
public class NearestHubToClientsHandler {

    private final HubNetwork network;
    private final UserStore userStore;

    /**
     * Instantiates a new Nearest hub to clients handler.
     */
    public NearestHubToClientsHandler() {
        App app = App.getInstance();
        this.network = app.hubNetwork();
        this.userStore = app.userStore();
    }

    /**
     * Linked list filled with triplets including user1, user2 and the distance between each other.
     *
     * @return the linked list
     */
    public LinkedList<Triplet<User, User, Distance>> findNearestHubs() {
        LinkedList<Triplet<User, User, Distance>> list = new LinkedList<>();

        var companies = new ArrayList<User>();
        var clients = new ArrayList<User>();

        // Get all existing companies && clients to speed up the process
        for (User u : network.vertices()) {     // O(V)
            switch (u.getUserType()) {
                case COMPANY:
                    companies.add(u);
                case CLIENT: /* FALLTHROUGH */
                    clients.add(u);
                    break;
                default: // Do nothing
            }
        }

        for (User client : clients) {           // O(V)
            var companyDist = nearestHub(client, companies);    // O(V^3)

            if (companyDist.isPresent()) {
                Distance d = companyDist.get();
                var nearestHub = userStore.getUser(d.getLocID2()).get();
                list.add(new Triplet<>(client, nearestHub, d));
                client.setNearestHub(nearestHub);
            }
        }

        // O(V^4)
        return list;
    }

    private Optional<Distance> nearestHub(User client, List<User> companies) {
        // O(V^3)
        var dists = this.network.shortestPathsForPool(client, companies);

        // Closest Hubs first
        dists.sort(Distance.cmp);

        for (Distance d : dists) {  // O(E)
            if (userStore.getUser(d.getLocID2()).isPresent())
                return Optional.of(d); // NOTE: User is guaranteed to be a company because of findNearestHubs()
        }

        // Nothing found :(
        return Optional.empty();    // Net complexity: O(V^3)
    }
}
