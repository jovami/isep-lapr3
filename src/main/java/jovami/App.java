package jovami;

/**
 * App
 * Singleton-pattern based class
 */
public class App {

    private App() {
        // Nothing for now
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
