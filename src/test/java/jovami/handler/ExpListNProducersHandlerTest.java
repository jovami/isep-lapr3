package jovami.handler;

import jovami.App;
import jovami.MainTest;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.LinkedList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ExpListNProducersHandlerTest {

    private ExpListNProducersHandler handler;
    private NearestHubToClientsHandler nearestHubToClientsHandler;
    private App app;

    @BeforeEach
    public void setup() {
        MainTest.resetSingleton();
        this.app = App.getInstance();
        this.handler = new ExpListNProducersHandler();
    }
    @Test
    void expListNProducersDay() {
    }

    @Test
    void expListNProducers() {
    }

    @Test
    void testExpListNProducersDay() {
    }

    //TODO: finish after Marco's corrections
    @Test
    void selectProducerForOrder() {
        MainTest.readData(false);
        new NearestHubToClientsHandler().findNearestHubs();
        int day = 1;
        int nProd = 3;

        /*
         * For bundle 1
         */
        {
            LinkedList<Bundle> expList = handler.expListNProducers(day, nProd).get(day);
            Bundle bundle = expList.get(0); //for bundle one
            var orders = bundle.getOrders();

            String[] expected = {"P1", "P2", "P3"};
            for (int i = 0; i < 3; i++) {
                var actual = orders.next().getProducer().getUserID();
                assertEquals(actual, expected[i]);
            }

            int expectedListSize = 14;
            assertEquals(expList.size(), expectedListSize);
        }
    }

    @Test
    void testExpListNProducers() {
    }

    @Test
    void findProducersSmall() {
        MainTest.readData(false);   // read small file
        String[] expected = {"P1", "P2", "P3"};
        List<User> actual = handler.findProducers();

        /*
         * Checks producers for small files
         */
        for (int i = 0; i < expected.length; i++) {
            assertEquals(actual.get(i).getUserID(), expected[i]);
        }

        /*
         * Checks number of producers found
         */

        int expectedSize = 3;
        assertEquals(actual.size(), expectedSize);
    }

    @Test
    void findProducersBig() {
        MainTest.readData(true);   // read big file
        String[] expected = {"P27", "P12", "P39", "P25", "P45", "P42", "P52", "P15", "P16", "P29"};
        List<User> actual = handler.findProducers();

        /*
         * Checks 10 first producers for big files
         */
        for (int i = 0; i < expected.length; i++) {
            assertEquals(actual.get(i).getUserID(), expected[i]);
        }

        /*
         * Checks number of producers found
         */

        int expectedSize = 60;
        assertEquals(actual.size(), expectedSize);
    }
}