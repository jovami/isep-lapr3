package jovami;

import java.lang.reflect.Field;
import java.util.List;

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
