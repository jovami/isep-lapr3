package jovami.handler;

import jovami.App;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.bundles.*;
import jovami.model.shared.DeliveryState;
import jovami.model.shared.UserType;
import jovami.model.store.BundleStore;
import jovami.model.store.ExpListStore;
import jovami.model.store.StockStore;
import jovami.util.Pair;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

public class ExpBasketListHandler {

    private final HubNetwork hubNetwork;
    private BundleStore bundleStore;
    private StockStore stockStore;
    private final ExpListStore expStore;


    public ExpBasketListHandler() {
        App app = App.getInstance();
        this.hubNetwork = app.hubNetwork();
        this.expStore= app.expListStore();
    }

    public LinkedList<Bundle> expBasketsListDay(int day) { // O(n^3)
        var result = new LinkedList<Bundle>();
        var bundles = bundleStore.getBundles(day);
        var producers = findProducers();

        for (Bundle bundle : bundles) {
            computeBundle(day, bundle, producers);

            result.add(bundle);
        }
        return result;
    }

    private void computeBundle(int day, Bundle bundle, List<User> producers) { // 0(n^2)
        var orders = bundle.getOrders();
        while (orders.hasNext()) {
            var order = orders.next();
            selectProducer(day, order, producers);
        }
    }

    private void selectProducer(int day, Order order, List<User> producers) { // O(n)
        Product product = order.getProduct();
        boolean flag=false;
        float quantityToRetrieve = order.getQuantity();
        Pair<User,Float> max = new Pair<>(null, 0.f);

        for (User producer : producers) {
            var producerStock = stockStore.getStock(producer);
            if (producerStock != null) {

                //caso nao consiga retirar completamente de um stock, retorna -1
                float stockProducer = producerStock.getStashAvailable(product, day);

                if (stockProducer>=quantityToRetrieve) {
                    producerStock.retrieveFromStock(day, product, quantityToRetrieve);
                    order.setProducer(producer);

                    order.setQntDelivered(quantityToRetrieve);
                    return;
                }else if(max.second() < stockProducer){
                        max=new Pair<>(producer,stockProducer);
                }
            }
        }

        if(max.second()==0.0f){
            order.setState(DeliveryState.NOT_SATISFIED);
            return;
        }

        if(stockStore.getStock(max.first())==null){
            System.out.println();
        }

        if(!flag){
            stockStore.getStock(max.first()).retrieveFromStock( day,product, max.second());
            order.setProducer(max.first());
            order.setQntDelivered(max.second());
        }       

    }

    public HashMap<Integer, LinkedList<Bundle>> expBasketsList() { // 0(n^4)
        ExpList expList = new ExpList();
        bundleStore = expList.getBundleStore();
        stockStore = expList.getStockStore();

        int size = bundleStore.size();
        HashMap<Integer, LinkedList<Bundle>> hash = new HashMap<>(size);

        for (int i = 1; i <= size; i++) {
            hash.put(i, expBasketsListDay(i));
        }
        expStore.addExpListNoRestrict(expList);
        return hash;
    }

    public List<User> findProducers(){
        return hubNetwork.vertices().stream()
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
        return lastDay;
    }

}
