package jovami.ui;

import jovami.handler.ExpListNProducersHandler;
import jovami.model.HubNetwork;
import jovami.model.store.BundleStore;
import jovami.model.store.ProductStore;
import jovami.model.store.UserStore;
import jovami.util.io.InputReader;

public class ExpListNProducersUI implements UserStory {

    private final ExpListNProducersHandler handler;


    public ExpListNProducersUI() {
        this.handler = new ExpListNProducersHandler();
    }

    @Override
    public void run() {
        int day = InputReader.readInteger("Day for expedition list:");
        int nProd = InputReader.readInteger("Closest N producers to hub:");

        try{
            var expList = handler.expListNProducers(day, nProd).get(day);

            expList.forEach(a -> {
                var orders = a.getOrders();
                if(orders.hasNext())
                    System.out.println("\nBundle for client: " + a.getClient().getUserID()
                            + " | Hub for pickup: " + a.getClient().getNearestHub().getUserID());
                while(orders.hasNext()){
                    var order = orders.next();
                    if (order.getProducer() == null) {
                        System.out.println(" -> Product: " + order.getProduct().getName()
                                + "  | Quantity: " + order.getQuantity()
                                + " | There were no producers to fulfill this order");
                    }else {
                        System.out.println(" -> Product: " + order.getProduct().getName()
                                + " | Quantity: " + order.getQuantity()
                                + " | Supplied by: " + order.getProducer().getUserID());
                    }
                }
            });
        }catch (Exception e){
            System.err.println("Aborting...");
            throw new RuntimeException(e);
        }
    }
}