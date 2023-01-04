package jovami.handler;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import jovami.App;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.bundles.Order;
import jovami.model.store.ExpListStore;

/**
 * ShortestPathHandler
 */
public class ShortestPathHandler {
    private final App app;
    private final HubNetwork network;
    private final ExpListStore exportStore;

    public ShortestPathHandler() {
        this.app = App.getInstance();
        this.network = this.app.hubNetwork();
        this.exportStore = this.app.expListStore();
    }


    public Optional<?> tempname(int day) {

        return null;
    }

    public Map<User,Set<User>> producersPerHub(ExpList list, int day) {
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
