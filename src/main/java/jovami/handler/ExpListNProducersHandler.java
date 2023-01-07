package jovami.handler;

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

import java.util.*;

/**
 * The ExpListNProducersHandler class is responsible for handling requests to
 * compute the expedition list for the N closest producers.
 */
public class ExpListNProducersHandler {

    private final HubNetwork network;
    private final UserStore userStore;

    //should this always be final?
    private final ExpListStore expStore;
    private BundleStore bundleStore;
    private StockStore stockStore;
    private ExpList expList;
    /**
     * Instantiates a new Expedition List for the N closest producers handler.
     */
    public ExpListNProducersHandler() {
        App app = App.getInstance();
        this.network = app.hubNetwork();
        this.userStore = app.userStore();
        this.expStore= app.expListStore();
    }
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

        //TODO: exception for non valid inputs
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

    public void selectProducerForOrder(int day, Order order, List<Distance> producers){
        Product orderedProduct = order.getProduct();
        float orderedQuantity = order.getQuantity();

        boolean flag=false;
        Pair<User,Float> max = new Pair<>(null, 0.f);

        for (Distance p : producers){
            var producer = userStore.getUser(p.getLocID1()).orElseThrow();
            var producerStock = stockStore.getStock(producer);
            if(producerStock!=null){

                float producerStash = producerStock.getStashAvailable(orderedProduct, day, orderedQuantity);

                if (producerStash>=orderedQuantity) {
                    producerStock.retrieveFromStock(day, orderedProduct, orderedQuantity);
                    order.setProducer(producer);
                    //TODO MUDAR PRODUCERSTASH PARA AQUILO QUE ELE VAI RETIRAR?
                    order.setQntDelivered(orderedQuantity);

                    flag = true;
                    return;
                }else if(max.second() < producerStash){
                        max=new Pair<>(producer,producerStash);
                }
            }
        }

        if(max.second()==0.0f){
            order.setState(DeliveryState.NOT_SATISFIED);
            return;
        }

        if(!flag){
            stockStore.getStock(max.first()).retrieveFromStock( day,orderedProduct, max.second().floatValue());
            order.setProducer(max.first());
            order.setQntDelivered(max.second());
        }       

    }

    private List<Distance> getNearestProducersToHub(List<User> producers, int nProducers, User hub) {
        PriorityQueue<Distance> distances = new PriorityQueue<>(Distance.cmp);
        producers.forEach(producer ->
                distances.offer(network.shortestPath(producer, hub, new LinkedList<>())));

        List<Distance> nearestProducers = new ArrayList<>();
        for (int i = 0; i < nProducers; i++) {
            nearestProducers.add(distances.poll());
        }
        return nearestProducers;
    }

    public HashMap<Integer,LinkedList<Bundle>> expListNProducers(int day, int nProducers){
        expList = new ExpList();
        bundleStore = expList.getBundleStore();
        stockStore = expList.getStockStore();

        int size=bundleStore.size();
        HashMap<Integer,LinkedList<Bundle>> hash=new HashMap<>(size);

        for (int i = 1; i <= size; i++) {
            hash.put(i,expListNProducersDay(i, nProducers));
        }
        expStore.addExpListProdRestrict(expList);

        return hash;
    }

    public List<User> findProducers(){
        return network.vertices().stream()
                .filter(u -> u.getUserType() == UserType.PRODUCER)
                .toList();
    }

}
