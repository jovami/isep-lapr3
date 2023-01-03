package jovami.handler;

import jovami.App;
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

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

public class ExpBasketListHandler {

    private final HubNetwork hubNetwork;
    private BundleStore bundleStore;
    private StockStore stockStore;
    private final ExpListStore expStore;
    private ExpList expList;


    public ExpBasketListHandler() {
        App app = App.getInstance();
        this.hubNetwork = app.hubNetwork();
        this.bundleStore = app.bundleStore();
        this.stockStore = app.stockStore();
        this.expStore= app.expListStore();
    }

    public LinkedList<Bundle> expBasketsListDay(int day) {
        var result = new LinkedList<Bundle>();
        var bundles = bundleStore.getBundles(day);
        var producers = findProducers();

        for (Bundle bundle : bundles) {
            computeBundle(day, bundle, producers);

            result.add(bundle);
        }
        return result;
    }

    private void computeBundle(int day, Bundle bundle, List<User> producers) {
        var orders = bundle.getOrders();
        while (orders.hasNext()) {
            var order = orders.next();
            selectProducer(day, order, producers);
        }
    }

    private void selectProducer(int day, Order order, List<User> producers) {
        Product product = order.getProduct();
        float quantity = order.getQuantity();

        for (User producer : producers) {
            var producerStock = stockStore.getStock(producer);
            if (producerStock != null) {
                if (producerStock.retrieveFromStock(product, day, quantity)) {
                    order.setProducer(producer);
                    order.setDelivered();
                    return;
                }
            }
        }
    }

    public HashMap<Integer, LinkedList<Bundle>> expBasketsList() {
        expList = new ExpList();
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

    private List<User> findProducers() {
        return hubNetwork.vertices().stream()
                .filter(u -> u.getUserType() == UserType.PRODUCER)
                .toList();
    }


}
