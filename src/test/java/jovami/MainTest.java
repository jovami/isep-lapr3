package jovami;

import java.lang.reflect.Field;
import java.util.List;

import jovami.handler.CSVLoaderHandler;
import jovami.model.csv.BundleParser;
import org.junit.jupiter.api.BeforeEach;

import jovami.model.csv.DistanceParser;
import jovami.model.csv.UserParser;

/**
 * Unit test for simple App.
 */
public class MainTest {

    @BeforeEach
    public void beforeEach() {
        resetSingleton();
    }

    public static void readUsers(List<String[]> user, List<String[]> distance){
        new UserParser().parse(user);
        new DistanceParser().parse(distance);
    }

    public static void readBundles(List<String[]> bundles){
        new BundleParser().parse(bundles);
    }

    /**
     * Boolean big should be true if it's intended to read the big files, or false otherwise
     */
    public static void readData(boolean big){
        var csvLoaderHandler = new CSVLoaderHandler();
        csvLoaderHandler.loadResources(big);
        csvLoaderHandler.populateNetwork();
    }

    public static void resetSingleton() {
        try {
            Field instance = App.class.getDeclaredField("singleton");
            instance.setAccessible(true);
            instance.set(null, null);
        } catch (Exception e) {
            e.printStackTrace(); // Should not happen
        }
    }
}
