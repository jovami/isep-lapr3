package jovami.model.store;

import java.util.ArrayList;
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

    public BundleStore getCopy(){
        return new BundleStore(this.bundles);
    }

    // TODO: better way of doing this?
    public Map<User,Set<User>> producersPerHub(int day) {
        Map<User, Set<User>> ret = new HashMap<>();

        for (Bundle b : this.bundles.get(day)) {
            User hub = b.getClient().getNearestHub();

            if(ret.get(hub) == null)
                ret.put(hub, new HashSet<>());
            var producers = ret.get(hub);

            for (Order o : b.getOrdersList())
                producers.add(o.getProducer());
        }

        return ret;
    }

    // TODO: better way of doing this?
    public Map<User, List<List<Order>>> ordersByHub(int day) {
        Map<User, List<List<Order>>> ret = new HashMap<>();

        for (Bundle b : this.bundles.get(day)) {
            User hub = b.getClient().getNearestHub();

            if(ret.get(hub) == null)
                ret.put(hub, new LinkedList<>());
            ret.get(hub).add(b.getOrdersList());
        }

        return ret;
    }
}
