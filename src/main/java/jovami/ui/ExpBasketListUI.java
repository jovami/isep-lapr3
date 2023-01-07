package jovami.ui;

import jovami.handler.ExpBasketListHandler;
import jovami.util.io.InputReader;

public class ExpBasketListUI implements UserStory {

    private final ExpBasketListHandler handler;


    public ExpBasketListUI() {
        this.handler = new ExpBasketListHandler();
    }

    @Override
    public void run() {
        int day = InputReader.readInteger("Day for expedition list:");

        try{
            var expList = handler.expBasketsList().get(day);

            expList.forEach(a -> {
                var orders = a.getOrders();
                if(orders.hasNext()) {
                    System.out.println("\nBundle for client: " + a.getClient().getUserID()
                            + " | Hub for pickup: " + a.getClient().getNearestHub().getUserID());
                    System.out.printf(" -> Product | Ordered | Delivered | Supplied by\n");
                }
                while(orders.hasNext()){
                    var order = orders.next();
                    if (order.getProducer() == null) {

                        System.out.printf(" -> %-8s|   %-6.1f|    %-6.1f | " +
                                        "There were no producers to fulfill this order\n",
                                order.getProduct().getName(),
                                order.getQuantity(),
                                order.getQuantityDelivered());
                    }else {

                        System.out.printf(" -> %-8s|   %-6.1f|    %-6.1f | %s\n",
                                order.getProduct().getName(),
                                order.getQuantity(),
                                order.getQuantityDelivered(),
                                order.getProducer().getUserID());
                    }
                }
            });
        }catch (Exception e){
            System.err.println("Aborting...");
            throw new RuntimeException(e);
        }
    }
}
