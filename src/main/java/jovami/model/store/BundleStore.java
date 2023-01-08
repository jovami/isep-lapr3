package jovami.model.store;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;

import jovami.model.bundles.Bundle;

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
}