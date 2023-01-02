package jovami.handler;

import jovami.App;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.bundles.Order;
import jovami.model.bundles.Product;
import jovami.model.shared.UserType;
import jovami.model.store.BundleStore;
import jovami.model.store.ExpListStore;
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

    //should this always be final?
    private ExpListStore expStore;
    private BundleStore bundleStore;
    private StockStore stockStore;
    private ExpList expList;
    /**
     * Instantiates a new Expedition List for the N closest producers handler.
     */
    public ExpListNProducersHandler() {
        this.app = App.getInstance();
        this.network = app.hubNetwork();
        this.userStore = app.userStore();
    }
    
    //when processing the expedition list for a given day we must pre-process the previous days
    public HashMap<Integer,LinkedList<Bundle>> expListNProducers(int day, int nProducers){
        
        expList=new ExpList();
        bundleStore = expList.getBundleStore();
        stockStore = expList.getStockStore();

        int size=bundleStore.getSize();
        HashMap<Integer,LinkedList<Bundle>> hash=new HashMap<>(size);

        for (int i = 1; i <= size; i++) {
            hash.put(i,expListNProducersDay(i, nProducers));
        }

        return hash;
    }

    //TODO set bundles fully delivered

    /**
     * Computes the expedition list for the N closest producers for the given day.
     *
     * @param day the day for which to compute the expedition list
     * @param nProducers the number of closest producers to include in the list
     * @return the computed expedition list
     */
    public LinkedList<Bundle> expListNProducersDay(int day, int nProducers){

        var result = new LinkedList<Bundle>();
        var bundles = bundleStore.getBundles(day);

        if(bundles == null){
            System.out.println();
            bundles = bundleStore.getBundles(2);
        }
        var producers = findProducers();

        for(Bundle bundle : bundles) {       
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
            if(producerStock!=null)
                if(producerStock.retrieveFromStock(orderedProduct, day, orderedQuantity)) {
                    order.setProducer(producer);
                    order.setDelivered();
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
