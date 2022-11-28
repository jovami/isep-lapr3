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
 * US304
 */
public class NearestHubToClientsHandler {

    private final App app;
    private final HubNetwork network;
    private final UserStore userStore;

    public NearestHubToClientsHandler() {
        this.app = App.getInstance();
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
        for (User u : network.vertices()) {
            switch (u.getUserType()) {
                case COMPANY:
                    companies.add(u);
                case CLIENT: /* FALLTHROUGH */
                    clients.add(u);
                    break;
                default: // Do nothing
            }
        }

        for (User client : clients) {
            var companyDist = nearestHub(client, companies);

            if (companyDist.isPresent()) {
                Distance d = companyDist.get();
                list.add(new Triplet<>(client, userStore.getUser(d.getLocID2()).get(), d));
            }
        }

        return list;
    }

    private Optional<Distance> nearestHub(User client, List<User> companies) {
        var dists = this.network.shortestPathsForPool(client, companies);

        // Closest Hubs first
        dists.sort(Distance.cmp);

        for (Distance d : dists) {
            if (userStore.getUser(d.getLocID2()).isPresent())
                return Optional.of(d); // NOTE: User is guaranteed to be a company because of findNearestHubs()
        }

        // Nothing found :(

        return Optional.empty();
    }
}
