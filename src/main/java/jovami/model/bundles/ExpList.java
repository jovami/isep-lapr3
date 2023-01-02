package jovami.model.bundles;

import jovami.App;
import jovami.model.store.BundleStore;
import jovami.model.store.StockStore;

public class ExpList {

    //deep copy from bundles and productStocks
    private final App app;
    private int day;
    private final StockStore stockCopy;
    private final BundleStore bundleCopy;

    public ExpList(){
        app=App.getInstance();
        stockCopy=app.deepCopyStockStore();
        bundleCopy=app.deepCopyBundleStore();
        setDay(0);
    }

    public void setDay(int day){
        this.day = day;
    }

    public int getDay(){
        return this.day;
    }

    public StockStore getStockStore(){
        return this.stockCopy;
    }

    public BundleStore getBundleStore(){
        return this.bundleCopy;
    }

    
}
