package jovami.handler;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.bundles.Order;
import jovami.model.store.BundleStore;
import jovami.model.store.ExpListStore.Restriction;
import jovami.util.Triplet;
import jovami.util.graph.Graph;
import jovami.util.graph.TSP;

/**
 * ShortestPathHandler
 */
public class ShortestPathHandler {
    private final App app;


    private int day;
    private BundleStore bStore;

    public ShortestPathHandler() {
        this.app = App.getInstance();
    }

    public boolean setDayRestriction(int day, Restriction r) {
        if (day < 1)
            return false;
        this.day = day;

        var expList = this.app.expListStore().getExpList(r);
        if (expList == null)
            return false;
        this.bStore = expList.getBundleStore();

        return this.bStore != null && !this.bStore.isEmpty();
    }

    public Triplet<List<User>, List<Distance>, Distance> shortestRoute() {
        if (this.bStore == null)
            throw new IllegalStateException();
        var map = this.bStore.producersPerHub(this.day);                // O(h*V)

        var closure = this.app.hubNetwork().transitiveClosure();        // O(V^3)
        var components = new LinkedList<Graph<User, Distance>>();
        var hubs = new LinkedList<User>();
        map.forEach((k, v) -> {                                         // O(h*inside); h => num of hubs
            var subgraph = closure.subNetwork(k, v).addSelfCycles();    // O(V^2) sub(); O(V) add()
            components.add(subgraph);                                   // O(1)
            hubs.add(k);                                                // O(1)
        });

        // O(h*V*E) ~ O(h*V^3) > O(h*V^2)
        var route = TSP.fromComponents(components, hubs, HubNetwork.distCmp, HubNetwork::getZero);
        var dists = new LinkedList<Distance>();

        // O(V)
        var dist = TSP.getDists(closure, Distance.zero, HubNetwork.distSum, route, dists);

        // Net complexity: O(h*V*E) ~ O(V^4)
        return new Triplet<>(route, dists, dist);
    }

    public Map<User, List<List<Order>>> ordersByHub() {
        return this.bStore.ordersByHub(this.day);
    }
}
