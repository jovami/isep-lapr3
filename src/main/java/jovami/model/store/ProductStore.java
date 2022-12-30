package jovami.model.store;

import java.util.HashMap;
import java.util.Iterator;

import jovami.model.bundles.Product;

public class ProductStore {

    private HashMap<String,Product> products;

    public ProductStore() {
        this(2 << 4);
    }

    public ProductStore(int initialCapacity) {
        this.products = new HashMap<String,Product>(initialCapacity);
    }

    public Iterator<Product> getIterator(){
        return this.products.values().iterator();
    }

    public Product getProduct(String productName){
        return products.get(productName);
    }

    public void addProduct(Product product){
        products.put(product.getName(), product);
    }
}
