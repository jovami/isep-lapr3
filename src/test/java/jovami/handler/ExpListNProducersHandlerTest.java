package jovami.handler;

import jovami.App;
import jovami.MainTest;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

class ExpListNProducersHandlerTest {

    private ExpListNProducersHandler handler;
    private App app;

    @BeforeEach
    public void setup() {
        MainTest.resetSingleton();
        this.app = App.getInstance();
        this.handler = new ExpListNProducersHandler();
    }

    @Test
    void testSelectProducerForOrderSmall() {
        MainTest.readData(false);
        new NearestHubToClientsHandler().findNearestHubs();
        int nProd = 2;

        {
            /*
             * Day 1
             */
            int day = 1;
            LinkedList<Bundle> expList = handler.expListNProducers(day, nProd).get(day);
            var bundlesData = Arrays.asList(
                    new String[]{"P1", "5.0", "P2", "2.0", "P1", "1.0"},
                    new String[]{"P2", "5.5", "P2", "1.5", "P2", "4.0", "P3", "1.0", "P3", "4.0", "P3", "3.0"},
                    new String[]{"P2", "7.5", "P1", "1", "P2", "0.5", "P1", "3.5"},
                    new String[]{},
                    new String[]{},
                    new String[]{"P1", "8.5", "P1", "9.0", null, "0"},
                    new String[]{},
                    new String[]{"P3", "2.5", "P3", "2.5", "P3", "2.5"},
                    new String[]{"P3", "2.5", "P2", "1.0"},
                    new String[]{},
                    new String[]{null, "0", "P3", "2", null, "0", "P3", "1.5", "P3", "5.5", "P3", "7.5", null, "0", null, "0", null, "0"},
                    new String[]{null, "0", null, "0", null, "0"},
                    new String[]{null, "0", "P1", "0.5", null, "0", null, "0", null, "0"},
                    new String[]{"P1", "1.5", null, "0", "P1", "8.5", null, "0"}
            );
            auxSelectProducerForOrder(bundlesData, expList);
        }
        {
            /*
             * Day 2
             */
            int day = 2;
            LinkedList<Bundle> expList = handler.expListNProducers(day, nProd).get(day);
            var bundlesData = Arrays.asList(
                    new String[]{"P1", "3.0", "P1", "6.0", "P2", "2.5", "P1", "4.0", "P2", "9.0", "P1", "3.0", null, "0", null, "0" },
                    new String[]{"P3", "9.0", "P2", "1.0", "P3", "1.5", "P2", "5.0","P2", "4.0", "P3", "5.0", "P3", "7.5", null, "0", "P2", "3"},
                    new String[]{null, "0", null, "0", "P1", "5.0",null, "0", "P2", "3.5"},
                    new String[]{"P1","0.5","P2","2.0",null, "0", "P1", "2.5"},
                    new String[]{ },
                    new String[]{ },
                    new String[]{"P3", "0.5", "P3", "4.5", "P2", "7.0", "P3", "1.5", "P3","6.0", "P3","1.5",null, "0",null, "0","P2", "2.0"},
                    new String[]{ },
                    new String[]{null, "0",null, "0","P2","0.5","P3","2.0",null, "0",null, "0"},
                    new String[]{"P2","4.5","P2", "3.0", null, "0", null, "0", null, "0"},
                    new String[]{null, "0", null, "0",null, "0",null, "0",},
                    new String[]{ },
                    new String[]{ },
                    new String[]{null, "0", null, "0", "P2", "2.5", "P1", "4.0", null, "0", "P1", "4.0", null, "0",null, "0",}
            );
            auxSelectProducerForOrder(bundlesData, expList);
        }
        {

            /*
             * Day 3
             */
            int day = 3;
            LinkedList<Bundle> expList = handler.expListNProducers(day, nProd).get(day);
            var bundlesData = Arrays.asList(
                    new String[]{"P2", "6.0", "P1", "6.0", "P1", "2.0", "P2", "6.0", "P2", "1.0", "P2", "3.0", "P1", "2.5" },
                    new String[]{"P2", "4.0", "P3", "3.0", "P3", "1.0"},
                    new String[]{ },
                    new String[]{"P1","1.5","P2","1.5",null, "0", "P1", "2.5", "P2", "4.0", "P2", "1.5" },
                    new String[]{ null, "0","P2","4.5",null, "0",},
                    new String[]{ null, "0","P2", "1.5","P2", "4.5",null, "0"},
                    new String[]{"P3", "5.5", "P3", "2.0", "P2", "0.5", null, "0" },
                    new String[]{"P3", "1.0","P3", "6.0","P3", "7.0",null, "0",null, "0",null, "0"},
                    new String[]{null, "0","P3","2.5",null, "0"},
                    new String[]{null, "0",null, "0",null, "0",null, "0",null, "0",null, "0",null, "0",null, "0"},
                    new String[]{"P3", "6.5", null, "0","P3", "5.5",null, "0",},
                    new String[]{ },
                    new String[]{null, "0","P1","2.0","P1","1.0","P1","2.5"},
                    new String[]{null, "0",null, "0",null, "0",null, "0",null, "0"}
            );
            auxSelectProducerForOrder(bundlesData, expList);
        }
        {
            /*
             * Day 4
             */
            int day = 4;
            LinkedList<Bundle> expList = handler.expListNProducers(day, nProd).get(day);
            var bundlesData = Arrays.asList(
                    new String[]{"P1", "1.5", "P1", "3.5", "P1", "1.0", null, "0",null, "0" },
                    new String[]{null, "0",null, "0",null, "0"},
                    new String[]{"P1", "1.0",null, "0",null, "0","P1", "4.0"},
                    new String[]{ },
                    new String[]{null, "0",null, "0",null, "0"},
                    new String[]{"P1", "7.5","P1", "8.0",null, "0",null, "0"},
                    new String[]{ },
                    new String[]{ },
                    new String[]{ },
                    new String[]{null, "0",null, "0",null, "0",null, "0",null, "0"},
                    new String[]{null, "0",null, "0",null, "0","P3", "0.5"},
                    new String[]{"P1", "0.5",null, "0",null, "0",null, "0"},
                    new String[]{ },
                    new String[]{ }
            );
            auxSelectProducerForOrder(bundlesData, expList);
        }
        {
            /*
             * Day 5
             */
            int day = 5;
            LinkedList<Bundle> expList = handler.expListNProducers(day, nProd).get(day);
            var bundlesData = Arrays.asList(
                    new String[]{"P1", "8.0", "P1", "7.0", null, "0", "P1", "1.5", "P1", "6.0","P2", "3.0","P1", "6.5","P2", "3.5" },
                    new String[]{ },
                    new String[]{"P2", "5.0","P1", "5.0","P1", "4.5","P2", "4.0","P1", "2.5" },
                    new String[]{ },
                    new String[]{"P1", "3.0","P1", "1.0",null, "0","P1","1.0","P1","2.0","P2","3.0","P1","7.0","P1","6.0", null, "0", "P2","2.5"},
                    new String[]{"P2", "1.0","P1", "2.5","P2", "1.5","P2", "2.0" },
                    new String[]{"P2", "2.0",null, "0",null, "0","P3", "4.0","P3", "6.5",null, "0","P3", "8.5","P3", "4.5" },
                    new String[]{ },
                    new String[]{null, "0","P2","0.5","P3","3.0",null, "0" },
                    new String[]{null, "0",null, "0", "P3", "4.5",null, "0",null, "0",null, "0","P2","5.0",null, "0","P2","2.0","P2","4.0"},
                    new String[]{ },
                    new String[]{null, "0",null, "0",null, "0",null, "0",null, "0"},
                    new String[]{null, "0",null, "0",null, "0",null, "0",null, "0"},
                    new String[]{null, "0",null, "0","P1","0.5",null, "0",null, "0",null, "0"}
            );
            auxSelectProducerForOrder(bundlesData, expList);
        }
    }

    void auxSelectProducerForOrder(List<String[]> bundlesData, LinkedList<Bundle> expList){
        for (int i = 0; i < expList.size(); i++) {
            Bundle b = expList.get(i);
            String[] expected = bundlesData.get(i);
            var orders = b.getOrders();
            int j = 0;

            if (orders.hasNext()){
                while (orders.hasNext()) {
                    var order = orders.next();
                    User producer = order.getProducer();

                    if (producer != null)
                        assertEquals(expected[j], producer.getUserID());
                    assertEquals(Float.valueOf(expected[j+1]), order.getQuantityDelivered());
                    j += 2;
                }
            } else {
                assertEquals(0, b.getOrdersList().size());
            }
        }
    }

    @Test
    void testFindProducersSmall() {
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
    void testFindProducersBig() {
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