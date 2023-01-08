package jovami.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.PriorityQueue;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.bundles.Order;
import jovami.model.bundles.Product;
import jovami.model.shared.DeliveryState;
import jovami.model.shared.UserType;
import jovami.model.store.BundleStore;
import jovami.model.store.ExpListStore;
import jovami.model.store.StockStore;
import jovami.model.store.UserStore;
import jovami.util.Pair;

/**
 * The ExpListNProducersHandler class is responsible for handling requests to
 * compute the expedition list for the N closest producers.
 */
public class ExpListNProducersHandler {

    private final HubNetwork network;
    private final UserStore userStore;
    private final ExpListStore expStore;
    private BundleStore bundleStore;
    private StockStore stockStore;
    private List<User> producers;

    /**
     * Instantiates a new Expedition List for the N closest producers handler.
     */
    public ExpListNProducersHandler() {
        App app = App.getInstance();
        this.network = app.hubNetwork();
        this.userStore = app.userStore();
        this.expStore= app.expListStore();

        this.setProducers();
    }
    /**
     * Computes the expedition list for the N closest producers for the given day.
     *
     * @param day the day for which to compute the expedition list
     * @param nProducers the number of closest producers to include in the list
     * @return the computed expedition list
     */
    public LinkedList<Bundle> expListNProducersDay(int day, int nProducers) {

        var result = new LinkedList<Bundle>();
        var bundles = bundleStore.getBundles(day);

        for(Bundle bundle : bundles) {                                          // O(b*inside); b => num bundles
            var hub = bundle.getClient().getNearestHub();                       // O(1)
            var nearestProdsToHub = getNearestProducersToHub(nProducers, hub);  // O(V)
            computeBundle(day, bundle, nearestProdsToHub);                      // O(o*V*n)

            result.add(bundle);                                                 // O(1)
        }

        // O(b*o*V*n)
        return result;
    }

    private void computeBundle(int day, Bundle bundle, List<Distance> nearestProdsToHub){
        var orders = bundle.getOrders();
        while(orders.hasNext()) {                                   // O(o*inside); o => num orders
            var order = orders.next();                              // O(1)
            selectProducerForOrder(day, order, nearestProdsToHub);  // O(V*n)
        }

        // Net complexity: O(o*V*n)
    }

    public void selectProducerForOrder(int day, Order order, List<Distance> producers){
        Product orderedProduct = order.getProduct();
        float orderedQuantity = order.getQuantity();

        boolean flag=false;
        Pair<User,Float> max = new Pair<>(null, 0.f);

        for (Distance p : producers) {                                                      // O(V*inside)
            var producer = userStore.getUser(p.getLocID1()).orElseThrow();                  // O(1)
            var producerStock = stockStore.getStock(producer);                              // O(1)
            if(producerStock!=null) {                                                       // O(1)

                float producerStash = producerStock.getStashAvailable(orderedProduct, day); // O(n)

                if (producerStash>=orderedQuantity) {                                       // O(1)
                    producerStock.retrieveFromStock(day, orderedProduct, orderedQuantity);  // O(n)
                    order.setProducer(producer);                                            // O(1)
                    order.setQntDelivered(orderedQuantity);                                 // O(1)

                    return;
                }else if(max.second() < producerStash){
                        max=new Pair<>(producer,producerStash);                             // O(1)
                }
            }
        }

        if(max.second()==0.0f) {                                                            // O(1)
            order.setState(DeliveryState.NOT_SATISFIED);                                    // O(1)
            return;
        }

        if(!flag) {                                                                         // O(1)
            // O(n)
            stockStore.getStock(max.first()).retrieveFromStock( day,orderedProduct, max.second());
            order.setProducer(max.first());
            order.setQntDelivered(max.second());
        }

        // Net complexity: O(V*n)
    }

    private List<Distance> getNearestProducersToHub(int nProducers, User hub) {
        PriorityQueue<Distance> distances = new PriorityQueue<>(Distance.cmp);
        // O(V)
        producers.forEach(producer ->
                distances.offer(network.shortestPath(producer, hub, new LinkedList<>())));

        List<Distance> nearestProducers = new ArrayList<>();
        for (int i = 0; i < nProducers; i++) {                  // O(1), nProducers is constant at runtime
            nearestProducers.add(distances.poll());             // O(1)
        }

        // O(V)
        return nearestProducers;
    }

    public HashMap<Integer,LinkedList<Bundle>> expListNProducers(int nProducers) {
        ExpList expList = new ExpList();
        bundleStore = expList.getBundleStore();
        stockStore = expList.getStockStore();
        nProducers = checkNProducers(nProducers);

        int size = bundleStore.size();
        HashMap<Integer,LinkedList<Bundle>> hash = new HashMap<>(size);

        for (int i = 1; i <= size; i++) {                       // O(b); b => num bundles
            hash.put(i,expListNProducersDay(i, nProducers));
        }
        expStore.addExpListProdRestrict(expList);               // O(1)

        // Net complexity: O(b)
        return hash;
    }

    private void setProducers() {
        // O(V)
        this.producers = network.vertices()
                                .stream()
                                .filter(u -> u.getUserType() == UserType.PRODUCER)
                                .toList();
    }

    public int checkHigherDay(HashMap<Integer,LinkedList<Bundle>> expList) {
        int lastDay = -1;

        for (int d : expList.keySet()) {
            if (d > lastDay) {
                lastDay = d;
            }
        }

        // O(n)
        return lastDay;
    }

    public int checkNProducers(int n) {
        if (n < 1)
            n = 0;

        // O(1)
        return Math.min(n, producers.size());
    }

    public List<User> getProducers() {
        return producers;
    }
}
