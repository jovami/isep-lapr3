package jovami.handler;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.bundles.Order;
import jovami.model.store.ExpListStore;
import jovami.model.store.ExpListStore.Restriction;
import jovami.util.Triplet;
import jovami.util.graph.Graph;
import jovami.util.graph.TSP;

/**
 * ShortestPathHandler
 */
public class ShortestPathHandler {
    private final App app;
    private final ExpListStore exportStore;

    // TODO: make this not scuffed
    private int day;
    private ExpList expList;

    public ShortestPathHandler() {
        this.app = App.getInstance();
        this.exportStore = this.app.expListStore();
    }

    // FIXME: finish this
    public boolean aaaa(int day) {
        this.day = day;
        this.expList = this.exportStore.getExpList(Restriction.NONE);

        return expList != null;
    }

    public Triplet<List<User>, List<Distance>, Distance> shortestRoute() {
        var map = producersPerHub(this.expList, this.day);

        var closure = this.app.hubNetwork().transitiveClosure();
        var components = new LinkedList<Graph<User, Distance>>();
        var hubs = new LinkedList<User>();
        map.forEach((k, v) -> {
            var subgraph = closure.subNetwork(k, v);
            // TODO: make sure this is really not needed
            // var closure = TSP2.getCompleteGraph(subgraph, HubNetwork.distCmp,
            //                                     HubNetwork.distSum);
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

    // TODO: move this to somewhere like BundleStore?
    private Map<User,Set<User>> producersPerHub(ExpList list, int day) {
        Map<User, Set<User>> ret = new HashMap<>();

        var bundles = list.getBundleStore();
        for (Bundle bundle : bundles.getBundles(day)) {
            User hub = bundle.getClient().getNearestHub();

            if(ret.get(hub) == null)
                ret.put(hub, new HashSet<>());
            var producersList = ret.get(hub);

            for (Order order : bundle.getOrdersList())
                producersList.add(order.getProducer());
        }

        return ret;
    }
}
