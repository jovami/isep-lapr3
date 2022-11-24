package jovami;

import jovami.model.store.UserStore;

/**
 * App
 * Singleton-pattern based class
 */
public class App {

    private UserStore userStore;

    private App() {
        this.userStore = new UserStore();
    }

    public UserStore userStore() {
        return this.userStore;
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
