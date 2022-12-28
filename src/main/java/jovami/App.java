package jovami;

import jovami.model.HubNetwork;
import jovami.model.store.*;

/**
 * App
 * Singleton-pattern based class
 */
public final class App {

    private final UserStore userStore;
    private final DistanceStore distStore;
    private final ProductStore productStore;
    private final BundleStore bundleStore;
    private final StockStore stockStore;
    private final WateringControllerStore wcStore;

    private final HubNetwork network;

    private App() {
        this.userStore = new UserStore();
        this.distStore = new DistanceStore();
        this.productStore = new ProductStore();
        this.bundleStore = new BundleStore();
        this.stockStore = new StockStore();
        this.wcStore = new WateringControllerStore();

        this.network = new HubNetwork();
    }

    public UserStore userStore() {
        return this.userStore;
    }

    public DistanceStore distanceStore() {
        return this.distStore;
    }

    public ProductStore productStore() {
        return this.productStore;
    }

    public BundleStore bundleStore() {
        return this.bundleStore;
    }

    public StockStore stockStore() {
        return this.stockStore;
    }

    public WateringControllerStore wateringControllerStore() {
        return this.wcStore;
    }

    public HubNetwork hubNetwork() {
        return this.network;
    }

    /* singleton pattern */
    private static App singleton = null;
    public static App getInstance() {
        if (singleton == null) {
            synchronized(App.class) {
                singleton = new App();
            }
        }
        return singleton;
    }
}
