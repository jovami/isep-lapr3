package jovami.handler;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import jovami.MainTest;
import jovami.handler.data.DataLoader;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.Order;

public class ExpBasketListHandlerTest extends ExpBasketListHandler {

    private ExpBasketListHandler handler;
    final DataLoader dataLoader = new DataLoader();
    List<List<String[]>> listResultDay1;
    List<List<String[]>> listResultDay2;
    List<List<String[]>> listResultDay3;
    List<List<String[]>> listResultDay4;
    List<List<String[]>> listResultDay5;


    @BeforeEach
    public void setup() {
        MainTest.resetSingleton();
        this.handler = new ExpBasketListHandler();
        listResultDay1 = dataLoader.addDeliveredProducerDay1();
        listResultDay2 = dataLoader.addDeliveredProducerDay2();
        listResultDay3 = dataLoader.addDeliveredProducerDay3();
        listResultDay4 = dataLoader.addDeliveredProducerDay4();
        listResultDay5 = dataLoader.addDeliveredProducerDay5();
    }

    @Test
    void testBasketsSmall() {
        MainTest.readData(false);

        HashMap<Integer, LinkedList<Bundle>> bundleList = handler.expBasketsList();
        testExpBasketsListDay(listResultDay1, bundleList, 1);
        testExpBasketsListDay(listResultDay2, bundleList, 2);
        testExpBasketsListDay(listResultDay3, bundleList, 3);
        testExpBasketsListDay(listResultDay4, bundleList, 4);
        testExpBasketsListDay(listResultDay5, bundleList, 5);
    }


    void testExpBasketsListDay(List<List<String[]>> data, HashMap<Integer, LinkedList<Bundle>> bundleList, int day) {
        LinkedList<Bundle> listPerDay = bundleList.get(day);

        int size = data.size();
        assertEquals(size, listPerDay.size());

        for (int i = 0; i < size; i++) {
            List<Order> orderList = listPerDay.get(i).getOrdersList();

            int sizePerBundle = data.get(i).size();
            assertEquals(orderList.size(), sizePerBundle);

            for (int j = 0; j < data.get(i).size(); j++) {
                List<String> expected = Arrays.stream(data.get(i).get(j)).toList();

                if (orderList.get(j).getProducer() == null)
                    assertNull(expected.get(2));
                else {
                    String product = orderList.get(j).getProduct().getName();
                    float qtdOrdered = orderList.get(j).getQuantity();
                    float qtdDelivered = orderList.get(j).getQuantityDelivered();
                    String producer = orderList.get(j).getProducer().getUserID();
                    //dia, bundle, orders, order(x)

                    assertEquals(expected.get(0), product);
                    assertEquals(Float.parseFloat(expected.get(1)), qtdOrdered);
                    assertEquals(Float.parseFloat(expected.get(2)), qtdDelivered);
                    assertEquals(expected.get(3), producer);
                }
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

    @Test
    void testCheckHigherDaySmall(){
        MainTest.readData(false);
        var exp = handler.expBasketsList();
        assertEquals(5, handler.checkHigherDay(exp));
    }
    @Test
    @Disabled
    void testCheckHigherDayBig(){
        MainTest.readData(true);
        var exp = handler.expBasketsList();
        assertEquals(5, handler.checkHigherDay(exp));
    }
}












