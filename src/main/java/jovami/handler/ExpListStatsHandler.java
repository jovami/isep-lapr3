package jovami.handler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Optional;
import java.util.Map.Entry;

import jovami.App;
import jovami.model.User;
import jovami.model.bundles.*;
import jovami.model.shared.DeliveryState;
import jovami.model.shared.UserType;
import jovami.model.store.BundleStore;
import jovami.model.store.ExpListStore;
import jovami.model.store.ExpListStore.Restriction;

public class ExpListStatsHandler {

    private final App app;
    private final ExpListStore expStore;

    public ExpListStatsHandler(){
        app = App.getInstance();
        expStore = app.expListStore();
    }


    public ExpList getExpList(Restriction r){
        return expStore.getExpList(r);
    }


    public User getUser(String userId){
        Optional<User> opt = app.userStore().getUserByID(userId);
        if(opt.isPresent())
            return opt.get();

        return null;
    }

    /*CABAZ
    */
    public ArrayList<Float> bundleStats (Bundle bundle,ExpList expList){
        //nº de produtos totalmente satisfeitos
        float numFullyDelivered = 0;

        //TODO
        //nº de produtos parcialmente satisfeitos,
        float numPartialyDelivered = 0;

        //nºde produtos não satisfeitos
        float numNotDelivered = 0;


        ArrayList<User> producers = new ArrayList<>();

        for (Order order : bundle.getOrdersList()) {
            if(order.getState()==DeliveryState.TOTALLY_SATISTFIED){
                numFullyDelivered++;

                if(!producers.contains(order.getProducer()))
                    producers.add(order.getProducer());

            }else{
                //partialyDelivered = true;
                numNotDelivered++;
            }
        }

        //nº de produtores que forneceram o cabaz.
        float numProducers = producers.size();

        //percentagem total do cabaz satisfeito
        float perc = (numFullyDelivered*100)/(bundle.getOrdersList().size());

        ArrayList<Float> res = new ArrayList<>();
        res.add(numFullyDelivered);

        //TODO: partial will be used?
        res.add(numPartialyDelivered);

        res.add(numNotDelivered);
        res.add(perc);
        res.add(numProducers);

        return res;
    }

    /*CLIENT
    */

    public ArrayList<Integer> clientStats (User client,ExpList expList){
        //nº de cabazes totalmente satisfeitos
        int totalSatisfied=0;
        //nº de cabazes parcialmente satisfeitos
        int partialyStatisfied=0;

        ArrayList<User> deliv = new ArrayList<>();

        for (Entry<Integer, ArrayList<Bundle>> entry : expList.getBundleStore().getBundles().entrySet()){

            for (Bundle bundle : entry.getValue()) {

                if(bundle.getClient()==client){
                    if(bundle.getState()==DeliveryState.TOTALLY_SATISTFIED)        totalSatisfied++;
                    if(bundle.getState()== DeliveryState.PARTIALLY_SATISFIED) partialyStatisfied++;

                    for (Order order : bundle.getOrdersList()) {
                        if(!deliv.contains(order.getProducer()))
                        deliv.add(order.getProducer());
                    }
                }
            }
        }

        //nºde fornecedores distintos que forneceram todos os seus cabazes
        int numProducers = deliv.size();
        ArrayList<Integer> res = new ArrayList<>(3);
        res.add(totalSatisfied);
        res.add(partialyStatisfied);
        res.add(numProducers);
        return res;
    }

    /*PRODUTOR
    */

    public ArrayList<Integer> producerStats (User producer,ExpList expList){
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
                    if(order.getState()==DeliveryState.TOTALLY_SATISTFIED){

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
                }
                if(partialFilledBundle) partialFullFilled++;
                if(fullFilledBundle) totalFullFilled++;
            }
        }

        numDifClients=difClients.size();

        // nº de produtos totalmente esgotados
        int numOutOfStock = outOfStock(producer, expList);

        ArrayList<Integer> res = new ArrayList<>();
        res.add(totalFullFilled);
        res.add(partialFullFilled);
        res.add(numOutOfStock);
        res.add(numDifClients);
        res.add(numDifHubs);
        return res;
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
    public ArrayList<Integer> hubStats (User hub,ExpList expList){

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

        //nº de produtores distintos que fornecem cabazes para o hub.
        int numProducers=getProducerPerHub(expList, hub);

        ArrayList<Integer> res = new ArrayList<>();
        res.add(numDifClientsForHub);
        res.add(numProducers);

        return res;
    }

    private int getProducerPerHub(ExpList expList,User hub){

        HashSet<User> difProducers=new HashSet<>();

        for (ArrayList<Bundle> iter : expList.getBundleStore().getBundles().values()) {
            for (Bundle iterBundle : iter) {
                if(iterBundle.getClient().getNearestHub().equals(hub)){
                    for (Order iterOrder : iterBundle.getOrdersList()) {

                        if(!difProducers.contains(iterOrder.getProducer())){
                            difProducers.add(iterOrder.getProducer());
                        }
                    }
                }
            }
        }
        return difProducers.size();
    }

}
