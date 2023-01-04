package jovami.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;

import jovami.App;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.bundles.Order;
import jovami.model.bundles.Product;
import jovami.model.bundles.ProductStock;
import jovami.model.bundles.Stock;
import jovami.model.shared.UserType;
import jovami.model.store.BundleStore;
import jovami.model.store.ExpListStore;
import jovami.util.Triplet;

public class ExpListStats {

    private App app;
    private ExpListStore expStore;

    public ExpListStats(){
        app = App.getInstance();
        expStore = app.expListStore();
    }
    
    /*CABAZ
    */
    public void bundleStats (Bundle bundle,ExpList expList){
        //nº de produtos totalmente satisfeitos
        int numFullyDelivered = 0;
        
        //TODO
        //nº de produtos parcialmente satisfeitos, 
        //int numPartialyDelivered = 0;

        //nºde produtos não satisfeitos
        int numNotDelivered = 0;

        boolean fullyDelivered = true;
        
        ArrayList<User> producers = new ArrayList<>();

        for (Order order : bundle.getOrdersList()) {
            if(order.isDelivered()){
                numFullyDelivered++;

                if(!producers.contains(order.getProducer()))
                    producers.add(order.getProducer());

            }else{
                //partialyDelivered = true;
                numNotDelivered++;
            }
        }

        //nº de produtores que forneceram o cabaz.
        int numProducers = producers.size();

        //percentagem total do cabaz satisfeito
        float perc = (numFullyDelivered*100)/(bundle.getOrdersList().size());
        
    }
    
    /*CLIENT
    */
    public Triplet<Integer,Integer,Integer> clientStats (User client,ExpList expList){
        //nº de cabazes totalmente satisfeitos
        int totalSatisfied=0;
        //nº de cabazes parcialmente satisfeitos
        int partialyStatisfied=0; 
        
        ArrayList<User> deliv = new ArrayList<>(); 

        for (Entry<Integer, ArrayList<Bundle>> entry : expList.getBundleStore().getBundles().entrySet()){
            
            for (Bundle bundle : entry.getValue()) {

                if(bundle.getClient()==client){
                    if(bundle.isDelivered())        totalSatisfied++;
                    if(bundle.isPartialDelivered()) partialyStatisfied++;
                    
                    for (Order order : bundle.getOrdersList()) {
                        if(!deliv.contains(order.getProducer()))
                        deliv.add(order.getProducer());
                    }
                }
            }
        }
        
        //nºde fornecedores distintos que forneceram todos os seus cabazes
        int difProducers = deliv.size();
        return new Triplet<Integer,Integer,Integer>(totalSatisfied,partialyStatisfied,difProducers);
    }
    
    
    /*PRODUTOR
    */
    
    public void producerStats (User producer,ExpList expList){
        BundleStore bundles = expList.getBundleStore();
        
        // nº de cabazes fornecidos totalmente
        int totalFullFilled=0;
        boolean fullFilledBundle;
        
        //nº de cabazes fornecidos parcialmente
        int partialFullFilled=0; 
        boolean partialFilledBundle;
        
        ArrayList<User> difClients= new ArrayList<>();

        // nº de clientes distintos fornecidos
        int numDifClients;

        // nº de hubs fornecidos.
        int numDifHubs=0;
        
        
        for (Entry<Integer, ArrayList<Bundle>> entry : bundles.getBundles().entrySet()){

            for (Bundle bundle : entry.getValue()) {
                partialFilledBundle=false;
                fullFilledBundle=true;
                
                for (Order order : bundle.getOrdersList()) {
                    if(order.getProducer().equals(producer)){
                        partialFilledBundle=true;
                        
                        if(!difClients.contains(bundle.getClient())){
                            difClients.add(bundle.getClient());
                            
                                if(bundle.getClient().getUserType()==UserType.COMPANY){
                                    if(!difClients.contains(bundle.getClient())){
                                        numDifHubs++;
                                    }
                                }
                            } 
                            
                        }else{
                            fullFilledBundle=false;
                        }
                }
                if(partialFilledBundle == true) partialFullFilled++;
                if(fullFilledBundle == true) totalFullFilled++;
            }
        }

        numDifClients=difClients.size();

        // nº de produtos totalmente esgotados
        int numOutOfStock = outOfStock(producer, expList);
    }

    private int outOfStock(User producer, ExpList expList) {
        Stock stock= expList.getStockStore().getStock(producer);

        int totalOutOfStock=0;
        boolean outOfStock;

        for (Entry<Product,HashMap<Integer,ProductStock>> entrys: stock.getProductStock().entrySet()) {
            outOfStock=true;

            for (ProductStock dayProductStock : entrys.getValue().values()) {
                if((dayProductStock.getStash()) > 0.0f){
                    outOfStock=false;
                    break;
                }
            }
            
            if(outOfStock) totalOutOfStock++;
        }
        return totalOutOfStock;
    }


    /*
     * HUB
     */
    public void hubStats (User hub,ExpList expList){
        
        ArrayList<User> clientsAssociatedHub= new ArrayList<>();
        // nº de clientes distintos que recolhem cabazes em cada hub
        int numDifClientsForHub;
        
        for (ArrayList<Bundle> bundlesList :  expList.getBundleStore().getBundles().values()) {
            for (Bundle bundle : bundlesList) {
                if(bundle.getClient().getNearestHub().equals(hub) && !clientsAssociatedHub.contains(bundle.getClient())){
                    clientsAssociatedHub.add(bundle.getClient());
                }
            }    
        }
        numDifClientsForHub = clientsAssociatedHub.size();
    
        // TODO
        //      nº de produtores distintos que fornecem cabazes para o hub.
    }

    /*
    CABAZ
     * nº de produtos totalmente satisfeitos
     *      nº de produtos parcialmente satisfeitos,
     * nºde produtos não satisfeitos
     * percentagem total do cabaz satisfeito
     * nº de produtores que forneceram o cabaz.

    HUB
     * nº de clientes distintos que recolhem cabazes em cada hub
     * nº de produtores distintos que fornecem cabazes para o hub.

    CLIENT
     * nº de cabazes totalmente satisfeitos
     * nº de cabazes parcialmente satisfeitos
     * nºde fornecedores distintos que forneceram todos os seus cabazes    

    PRODUTOR
     * nº de cabazes fornecidos totalmente
     * nº de cabazes fornecidos parcialmente
     * nº de produtos totalmente esgotados
     * nº de clientes distintos fornecidos
     * nº de hubs fornecidos.
    */
}
