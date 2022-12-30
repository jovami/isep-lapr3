package jovami.handler;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.Order;
import jovami.model.bundles.Product;
import jovami.model.shared.UserType;
import jovami.model.store.BundleStore;
import jovami.model.store.StockStore;
import jovami.model.store.UserStore;

import java.util.*;

/**
 * The ExpListNProducersHandler class is responsible for handling requests to
 * compute the expedition list for the N closest producers.
 */
public class ExpListNProducersHandler {

    private final App app;
    private final HubNetwork network;
    private final UserStore userStore;
    private final BundleStore bundleStore;
    private final StockStore stockStore;

    /**
     * Instantiates a new Expedition List for the N closest producers handler.
     */
    public ExpListNProducersHandler() {
        this.app = App.getInstance();
        this.network = app.hubNetwork();
        this.userStore = app.userStore();

        this.bundleStore = app.bundleStore();
        this.stockStore = app.stockStore();
    }

    /**
     * Computes the expedition list for the N closest producers for the given day.
     *
     * @param day the day for which to compute the expedition list
     * @param nProducers the number of closest producers to include in the list
     * @return the computed expedition list
     */
    public LinkedList<Bundle> expListNProducers(int day, int nProducers){
        var result = new LinkedList<Bundle>();
        var bundles = bundleStore.getBundles(day);
        var producers = findProducers();

        while(bundles.hasNext()){
            var bundle = bundles.next();
            var hub = bundle.getClient().getNearestHub();
            var nearestProdsToHub = getNearestProducersToHub(producers, nProducers, hub);
            computeBundle(day, bundle, nearestProdsToHub);

            result.add(bundle);
        }
        return result;
    }

    private void computeBundle(int day, Bundle bundle, List<Distance> nearestProdsToHub){
        var orders = bundle.getOrders();
        while(orders.hasNext()){
            var order = orders.next();
            selectProducerForOrder(day, order, nearestProdsToHub);
        }
    }

    private void selectProducerForOrder(int day, Order order, List<Distance> producers){
        Product orderedProduct = order.getProduct();
        float orderedQuantity = order.getQuantity();

        for (Distance p : producers){
            var producer = userStore.getUser(p.getLocID1()).orElseThrow();
            var producerStock = stockStore.getStock(producer);

            if(producerStock.retrieveFromStock(orderedProduct, day, orderedQuantity)) {
                order.setProducer(producer);
                return;
            }
        }
    }

    private List<Distance> getNearestProducersToHub(List<User> producers, int nProducers, User hub) {
        PriorityQueue<Distance> distances = new PriorityQueue<>(Distance.cmp);
        producers.forEach(producer -> {
            distances.offer(network.shortestPath(producer, hub, new LinkedList<>()));
        });

        List<Distance> nearestProducers = new ArrayList<>();
        for (int i = 0; i < nProducers && !distances.isEmpty(); i++) {
            nearestProducers.add(distances.poll());
        }
        return nearestProducers;
    }

    private List<User> findProducers(){
        return network.vertices().stream()
                .filter(u -> u.getUserType() == UserType.PRODUCER)
                .toList();
    }
}
