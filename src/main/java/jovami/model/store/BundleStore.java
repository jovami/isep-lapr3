package jovami.model.store;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import jovami.model.bundles.Bundle;

public class BundleStore{

    private final HashMap<Integer,ArrayList<Bundle>> bundles; // key -> day, each day has a list of bundles

    public BundleStore(){
        this(2 << 4);
    }

    public BundleStore(int initialCapacity) {
        this.bundles = new HashMap<>(initialCapacity);
    }

    public void addNewDay(int day) {
        bundles.put(day, new ArrayList<Bundle>(2 << 4));
    }

    public boolean addBundle(Bundle newBundle){
        int day = newBundle.getDay();

        if(bundles.get(day)==null)
            addNewDay(day);

        return bundles.get(day).add(newBundle);
    }

    //all bundles for a given day
    public Iterator<Bundle> getBundles(int day){
        return bundles.get(day).iterator();
    }

    public ArrayList<Bundle> getBundlesArray(int day){
        return bundles.get(day);
    }

    //TODO needed?
    //returns a iterator with all bundles from the previous 2 days, that were not delivered
    public Iterator<Bundle> getUndelivered(int day){
        ArrayList<Bundle> undelivered = new ArrayList<Bundle>();

        for (int i = day-2; i < day; i++) {
            if(day>=1){
                //TODO OPTIMIZE
                //bundles.get(i);
                for (Bundle bundle : bundles.get(i)) {
                    if(bundle.isDelivered()==false)
                        undelivered.add(bundle);
                }
            }
        }
        return undelivered.iterator();
    }

    public int size() {
        return this.bundles.size();
    }
}