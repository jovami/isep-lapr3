package jovami.model.bundles;

import jovami.App;
import jovami.model.store.BundleStore;
import jovami.model.store.StockStore;

public class ExpList {

    private final StockStore stockCopy;
    private final BundleStore bundleCopy;

    public ExpList(){
        //deep copy from bundles and productStocks
        App app = App.getInstance();
        stockCopy= app.deepCopyStockStore();
        bundleCopy= app.deepCopyBundleStore();
    }


    public StockStore getStockStore(){
        return this.stockCopy;
    }

    public BundleStore getBundleStore(){
        return this.bundleCopy;
    }

    
}
