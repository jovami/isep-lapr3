package jovami.ui;

import jovami.handler.ExpListNProducersHandler;
import jovami.util.io.InputReader;

public class ExpListNProducersUI implements UserStory {

    private final ExpListNProducersHandler handler;


    public ExpListNProducersUI() {
        this.handler = new ExpListNProducersHandler();
    }

    @Override
    public void run() {
        int initDay = InputReader.readInteger("Day for expedition list:");
        int initN = InputReader.readInteger("Closest N producers to hub:");

        try{
            handler.setProducers();
            int nProd = handler.checkNProducers(initN);
            var exp = handler.expListNProducers(nProd);
            int day = handler.checkDayForExp(initDay,exp);
            var expList = handler.expListNProducers(nProd).get(day);

            System.out.println("Day: " + day + " | " + "Closest " + nProd + " producers to the hubs");
            expList.forEach(a -> {
                var orders = a.getOrders();
                if (orders.hasNext()) {
                    System.out.println("\nBundle for client: " + a.getClient().getUserID()
                            + " | Hub for pickup: " + a.getClient().getNearestHub().getUserID());
                    System.out.printf(" -> Product | Ordered | Delivered | Supplied by\n");
                }
                while (orders.hasNext()) {
                    var order = orders.next();
                    if (order.getProducer() == null) {
                        System.out.printf(" -> %-8s|   %-6.1f|    %-6.1f | " +
                                        "There were no producers to fulfill this order\n",
                                order.getProduct().getName(),
                                order.getQuantity(),
                                order.getQuantityDelivered());
                    } else {

                        System.out.printf(" -> %-8s|   %-6.1f|    %-6.1f | %s\n",
                                order.getProduct().getName(),
                                order.getQuantity(),
                                order.getQuantityDelivered(),
                                order.getProducer().getUserID());
                    }
                }

            });
        } catch (Exception e) {
            System.err.println("Aborting...");
            throw new RuntimeException(e);
        }
    }
}