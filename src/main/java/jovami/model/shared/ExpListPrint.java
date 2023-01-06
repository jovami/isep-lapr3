package jovami.model.shared;

import jovami.model.bundles.Bundle;

public class ExpListPrint {
    public static void bundlePrint(Bundle a) {
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
    }


}