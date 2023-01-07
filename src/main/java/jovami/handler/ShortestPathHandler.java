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

    // TODO: make this not scuffed
    private int day;
    private BundleStore bStore;

    public ShortestPathHandler() {
        this.app = App.getInstance();
    }

    public boolean setDayRestriction(int day, Restriction r) {
        this.day = day;

        var expList = this.app.expListStore().getExpList(r);
        if (expList == null)
            return false;
        this.bStore = expList.getBundleStore();

        return this.bStore != null;
    }

    public Triplet<List<User>, List<Distance>, Distance> shortestRoute() {
        var map = this.bStore.producersPerHub(this.day);

        var closure = this.app.hubNetwork().transitiveClosure();
        var components = new LinkedList<Graph<User, Distance>>();
        var hubs = new LinkedList<User>();
        map.forEach((k, v) -> {
            var subgraph = closure.subNetwork(k, v);
            components.add(subgraph);
            hubs.add(k);
        });

        var route = TSP.fromComponents(components, hubs,
                                       HubNetwork.distCmp, HubNetwork::getZero);

        var dists = new LinkedList<Distance>();
        // TODO: check if Distance.zero is correct here
        var dist = TSP.getDists(closure, Distance.zero, HubNetwork.distSum,
                                route, dists);

        return new Triplet<>(route, dists, dist);
    }

    public Map<User, List<List<Order>>> ordersByHub() {
        return this.bStore.ordersByHub(this.day);
    }
}
