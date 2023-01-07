package jovami.handler;

import jovami.App;
import jovami.MainTest;
import jovami.handler.data.NearestHubToClientsData;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class IsConnectedHandlerTest {

    IsConnectedHandler handler;
    private App app;

    @BeforeEach
    void setUp() {
        MainTest.resetSingleton();
        this.app = App.getInstance();
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