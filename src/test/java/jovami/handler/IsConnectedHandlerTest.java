package jovami.handler;

import jovami.MainTest;
import jovami.handler.data.NearestHubToClientsData;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class IsConnectedHandlerTest {

    IsConnectedHandler handler;

    @BeforeEach
    void setUp() {
        MainTest.resetSingleton();
        NearestHubToClientsData.loadData();
        new CSVLoaderHandler().populateNetwork();
        handler = new IsConnectedHandler();
    }

    @Test
    void minReachability() {
        assertEquals(272, handler.minReachability().get());
    }
}