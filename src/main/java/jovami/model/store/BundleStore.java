package jovami.model.store;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.Order;

public class BundleStore{

    private final HashMap<Integer,ArrayList<Bundle>> bundles; // key -> day, each day has a list of bundles

    public BundleStore(){
        this(2 << 4);
    }

    public BundleStore(HashMap<Integer,ArrayList<Bundle>> bundles){
        this(bundles.size());
        //DEEP copy
        for (Entry<Integer,ArrayList<Bundle>> it : bundles.entrySet()) {
            ArrayList<Bundle>copy = new ArrayList<>(it.getValue().size());

            for (Bundle bundle : it.getValue()) {
                copy.add(bundle.getCopy());
            }
            this.bundles.put(it.getKey(),copy);
        }

    }

    public BundleStore(int initialCapacity) {
        this.bundles = new HashMap<>(initialCapacity);
    }

    public void addNewDay(int day) {
        bundles.put(day, new ArrayList<>(2 << 4));
    }

    public boolean addBundle(Bundle newBundle){
        int day = newBundle.getDay();

        if(bundles.get(day)==null)
            addNewDay(day);

        return bundles.get(day).add(newBundle);
    }


    public ArrayList<Bundle> getBundles(int day){
        return bundles.get(day);
    }

    public HashMap<Integer,ArrayList<Bundle>> getBundles(){
        return bundles;

    }
    public int getSize(){
        return bundles.size();
    }

    public int size() {
        return this.bundles.size();
    }

    public boolean isEmpty() {
        return this.size() == 0;
    }

    public BundleStore getCopy(){
        return new BundleStore(this.bundles);
    }


    public Map<User,Set<User>> producersPerHub(int day) {
        return producersPerHub(this.bundles.get(day));
    }

    public static Map<User, Set<User>> producersPerHub(List<Bundle> bList) {
        Map<User, Set<User>> ret = new HashMap<>();

        if (bList == null)
            return Collections.emptyMap();              // O(1)

        for (Bundle b : bList) {                        // O(n*inside); n => num of bundles
            User hub = b.getClient().getNearestHub();   // O(1)

            // O(1)
            ret.computeIfAbsent(hub, k -> new HashSet<>());          // O(1)
            var producers = ret.get(hub);

            for (Order o : b.getOrdersList()) {         // O(m*inside); m => num of orders
                var p = o.getProducer();                // O(1)
                if (p != null)                          // O(1)
                    producers.add(p);                   // O(1)
            }
        }

        // Net complexity: O(n*m)
        return ret;
    }

    public Map<User, List<List<Order>>> ordersByHub(int day) {
        Map<User, List<List<Order>>> ret = new HashMap<>();

        var bList = this.bundles.get(day);              // O(1)
        if (bList == null)
            return Collections.emptyMap();              // O(1)

        for (Bundle b : bList) {                        // O(n*inside); n => num of bundles
            User hub = b.getClient().getNearestHub();   // O(1)

            // O(1)
            ret.computeIfAbsent(hub, k -> new LinkedList<>());       // O(1)
            ret.get(hub).add(b.getOrdersList());        // O(1) for get(), add() and getOrdersList()
        }

        // Net complexity: O(n)
        return ret;
    }
}
