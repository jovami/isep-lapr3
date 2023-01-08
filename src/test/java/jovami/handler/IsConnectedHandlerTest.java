package jovami.handler;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jovami.App;
import jovami.MainTest;

class IsConnectedHandlerTest {

    IsConnectedHandler handler;

    @BeforeEach
    void setUp() {
        MainTest.resetSingleton();
        App app = App.getInstance();
        handler = new IsConnectedHandler();
    }

    @Test
    void minReachabilitySmall() {
        MainTest.readData(false);
        var min = handler.minReachability();
        assertTrue(min.isPresent());
        assertNotNull(min.get());

        assertEquals(1, min.get());
    }

    @Test
    void minReachabilityBig() {
        MainTest.readData(true);
        var min = handler.minReachability();
        assertTrue(min.isPresent());
        assertNotNull(min.get());

        assertEquals(14, min.get());
    }
}
