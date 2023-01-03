package jovami.handler;

import jovami.MainTest;
import jovami.handler.data.DataLoader;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.Order;
import jovami.model.csv.BundleParser;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

class ExpBasketListHandlerTest extends ExpBasketListHandler {

    private ExpBasketListHandler handler;
    List<String[]> userList;
    List<String[]> distanceList;
    List<String[]> bundleList;
    List<List<String[]>> listResultDay1;
    List<List<String[]>> listResultDay2;
    List<List<String[]>> listResultDay4;
    DataLoader dataLoader = new DataLoader();


    @BeforeEach
    public void setup() {
        userList = dataLoader.addUsers();
        distanceList = dataLoader.addDistances();
        bundleList = dataLoader.addBundle();
        listResultDay1 = dataLoader.addDeliveredProducerDay1();
        listResultDay2 = dataLoader.addDeliveredProducerDay2();
        listResultDay4 = dataLoader.addDeliveredProducerDay4();


        MainTest.resetSingleton();
        handler = new ExpBasketListHandler();
        MainTest.readUsers(userList, distanceList);
        new CSVLoaderHandler().populateNetwork();
        BundleParser bp = new BundleParser();
        bp.parse(bundleList);
    }

    @Test
    void testExpBasketsListDay1() {
        LinkedList<Bundle> listPerDay = handler.expBasketsList().get(1);

        int size = listResultDay1.size();
        assertEquals(size, listPerDay.size());


        for (int i = 0; i < size; i++) {
            List<Order> orderList = listPerDay.get(i).getOrdersList();

            int sizePerBundle = listResultDay1.get(i).size();
            assertEquals(orderList.size(), sizePerBundle);

            for (int j = 0; j < listResultDay1.get(i).size(); j++) {
                List<String> expected = Arrays.stream(listResultDay1.get(i).get(j)).toList();

                if (orderList.get(j).getProducer() == null)
                    assertNull(expected.get(2));
                else {
                    String product = orderList.get(j).getProduct().getName();
                    float qtd = orderList.get(j).getQuantity();
                    String producer = orderList.get(j).getProducer().getUserID();
                    //dia, bundle, orders, order(x)

                    String qtdString = expected.get(1);
                    String commaToDot = qtdString.replaceAll(",", ".");
                    float qtdFloat = Float.parseFloat(commaToDot);

                    assertEquals(expected.get(0), product);
                    assertEquals(qtdFloat, qtd);
                    assertEquals(expected.get(2), producer);
                }
            }
        }
    }


    @Test
    void testExpBasketsListDay2() {
        LinkedList<Bundle> listPerDay = handler.expBasketsList().get(2);

        int size = listResultDay2.size();
        assertEquals(size, listPerDay.size());


        for (int i = 0; i < size; i++) {
            List<Order> orderList = listPerDay.get(i).getOrdersList();

            int sizePerBundle = listResultDay2.get(i).size();
            assertEquals(orderList.size(), sizePerBundle);

            for (int j = 0; j < listResultDay2.get(i).size(); j++) {
                List<String> expected = Arrays.stream(listResultDay2.get(i).get(j)).toList();

                if (orderList.get(j).getProducer() == null)
                    assertNull(expected.get(2));
                else {
                    String product = orderList.get(j).getProduct().getName();
                    float qtd = orderList.get(j).getQuantity();
                    String producer = orderList.get(j).getProducer().getUserID();
                    //dia, bundle, orders, order(x)

                    String qtdString = expected.get(1);
                    String commaToDot = qtdString.replaceAll(",", ".");
                    float qtdFloat = Float.parseFloat(commaToDot);

                    assertEquals(expected.get(0), product);
                    assertEquals(qtdFloat, qtd);
                    assertEquals(expected.get(2), producer);
                }
            }
        }
    }

    @Test
    void testExpBasketsListDay4() {
        LinkedList<Bundle> listPerDay = handler.expBasketsList().get(4);

        int size = listResultDay4.size();
        assertEquals(size, listPerDay.size());


        for (int i = 0; i < size; i++) {
            List<Order> orderList = listPerDay.get(i).getOrdersList();

            int sizePerBundle = listResultDay4.get(i).size();
            assertEquals(orderList.size(), sizePerBundle);

            for (int j = 0; j < listResultDay4.get(i).size(); j++) {
                List<String> expected = Arrays.stream(listResultDay4.get(i).get(j)).toList();

                if (orderList.get(j).getProducer() == null)
                    assertNull(expected.get(2));
                else {
                    String product = orderList.get(j).getProduct().getName();
                    float qtd = orderList.get(j).getQuantity();
                    String producer = orderList.get(j).getProducer().getUserID();
                    //dia, bundle, orders, order(x)

                    String qtdString = expected.get(1);
                    String commaToDot = qtdString.replaceAll(",", ".");
                    float qtdFloat = Float.parseFloat(commaToDot);

                    assertEquals(expected.get(0), product);
                    assertEquals(qtdFloat, qtd);
                    assertEquals(expected.get(2), producer);
                }
            }
        }
    }






}