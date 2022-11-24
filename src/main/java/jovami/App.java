package jovami;

import jovami.model.store.DistanceStore;
import jovami.model.store.UserStore;
import jovami.model.store.WateringControllerStore;

/**
 * App
 * Singleton-pattern based class
 */
public final class App {

    private final UserStore userStore;
    private final DistanceStore distStore;
    private final WateringControllerStore wcStore;

    private App() {
        this.userStore = new UserStore();
        this.distStore = new DistanceStore();
        this.wcStore = new WateringControllerStore();
    }

    public UserStore userStore() {
        return this.userStore;
    }

    public DistanceStore distanceStore() {
        return this.distStore;
    }

    public WateringControllerStore wateringControllerStore() {
        return this.wcStore;
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
