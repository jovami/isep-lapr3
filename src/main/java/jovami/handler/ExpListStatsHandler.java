package jovami.handler;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map.Entry;

import jovami.App;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.bundles.Order;
import jovami.model.bundles.ProductStock;
import jovami.model.bundles.Stock;
import jovami.model.shared.BundleIndex;
import jovami.model.shared.ClientIndex;
import jovami.model.shared.DeliveryState;
import jovami.model.shared.HubIndex;
import jovami.model.shared.ProducerIndex;
import jovami.model.store.BundleStore;
import jovami.model.store.ExpListStore;
import jovami.model.store.ExpListStore.Restriction;
import jovami.util.Pair;

public class ExpListStatsHandler {

    private App app;
    private ExpListStore expStore;

    private final int NUMSTATSHUB = 2;
    private final int NUMSTATSCLIENT = 3;
    private final int NUMSTATSPRODUTOR = 5;
    private final int NUMSTATSBUNDLE = 5;


    public ExpListStatsHandler(){
        app = App.getInstance();
        expStore = app.expListStore();
    }


    public ExpList getExpList(Restriction r){
        return expStore.getExpList(r);
    }

    /*CABAZ
    */
    public HashMap<Bundle,float[]> getAllbundlesStats (int day,ExpList expList){
        HashMap<Bundle,float []> res = new LinkedHashMap<>();

        for (Bundle iterBundle : expList.getBundleStore().getBundles(day)) {
            if(res.get(iterBundle)==null)
                res.put(iterBundle, new float[NUMSTATSBUNDLE]);

            statsEachBundle(iterBundle, res.get(iterBundle));
        }
        return res;
    }


    protected void statsEachBundle(Bundle bundle, float[] res){

        float numFullyDelivered = 0;

        //TODO
        //nº de produtos parcialmente satisfeitos,
        float numPartialyDelivered = 0;

        //nºde produtos não satisfeitos
        float numNotDelivered = 0;


        HashSet<User> producers = new HashSet<>();

        for (Order order : bundle.getOrdersList()) {
            if(order.getState()==DeliveryState.TOTALLY_SATISTFIED){
                numFullyDelivered++;
                producers.add(order.getProducer());

            }else if(order.getState() == DeliveryState.PARTIALLY_SATISFIED){
                    numPartialyDelivered++;
                    producers.add(order.getProducer());

            }else{
                numNotDelivered++;
            }
        }
        //nº de produtores que forneceram o cabaz.
        float numProducers = producers.size();

        //percentagem total do cabaz satisfeito
        float perc = (numFullyDelivered*100)/(bundle.getOrdersList().size());

        res[BundleIndex.FULLY_DELIVERED.getPrefix()]=numFullyDelivered;
        res[BundleIndex.PARTIALY_DELIVERED.getPrefix()]=numPartialyDelivered;
        res[BundleIndex.NOT_DELIVERED.getPrefix()]=numNotDelivered;
        res[BundleIndex.PERC_TOTAL_SATISFIED.getPrefix()]=perc;
        res[BundleIndex.NUM_PRODUCERS.getPrefix()]=numProducers;
    }
    /*CLIENT
    */


    //TODO change arraylist ot linked hashMap
    public HashMap<User,int[]> getAllClientsStats(int day,ExpList expList){

        HashMap<User,int []> res = new LinkedHashMap<>();

        for (Bundle iterBundle : expList.getBundleStore().getBundles(day)) {
            //uma empresa é um cliente, e é também um hub
            if(res.get(iterBundle.getClient())==null){
                res.put(iterBundle.getClient(), new int[NUMSTATSCLIENT]);
            }
            clientStats(iterBundle.getClient(), iterBundle,res.get(iterBundle.getClient()));
        }

        return res;

    }

    protected void clientStats (User client,Bundle bundle, int[] arr){
        //nº de cabazes totalmente satisfeitos
        int totalSatisfied=arr[ClientIndex.TOTALLY_SATISTFIED.getPrefix()];

        //nº de cabazes parcialmente satisfeitos
        int partialyStatisfied=arr[ClientIndex.PARTIALLY_SATISFIED.getPrefix()];

        HashSet<User> deliv=new HashSet<>();

        if(bundle.getClient()==client){
            if(bundle.getState()==DeliveryState.TOTALLY_SATISTFIED)        totalSatisfied++;
            if(bundle.getState()== DeliveryState.PARTIALLY_SATISFIED) partialyStatisfied++;

            for (Order order : bundle.getOrdersList()) {
                if(order.getProducer()!=null)
                    deliv.add(order.getProducer());
            }

        }

        //nºde fornecedores distintos que forneceram todos os seus cabazes
        int numProducers = deliv.size();

        arr[ClientIndex.TOTALLY_SATISTFIED.getPrefix()]=totalSatisfied;
        arr[ClientIndex.PARTIALLY_SATISFIED.getPrefix()]=partialyStatisfied;
        arr[ClientIndex.NUM_PRODUCERS.getPrefix()]=numProducers;

    }

    /*PRODUTOR
    */

    public HashMap<User,int[]> getAllProducersStats(int day, ExpList expList){

        HashMap<User,int []> res = new LinkedHashMap<>();

        for(Pair<User,Stock> producerStock: expList.getStockStore().getStocks()){//n*inside
            if(res.get(producerStock.first())==null){
                res.put(producerStock.first(), new int[NUMSTATSPRODUTOR]);
            }
            producerStockStats(day, res.get(producerStock.first()), producerStock.second());//n
            producerBundleStats(producerStock.first(),day, expList,res.get(producerStock.first()));//n2
        }

        //O(n3)
        return res;

    }


    protected void producerStockStats(int day, int[] res, Stock producerStock) {

        int outOfStock=res[ProducerIndex.PROD_OUT_OF_STOCK.getPrefix()];

        for(ProductStock product : producerStock.getStocks(day)){
            if(product!=null){
                if(producerStock.getStashAvailable(product.getProduct(), day)==0){
                    outOfStock++;
                }
            }
        }

        res[ProducerIndex.PROD_OUT_OF_STOCK.getPrefix()]=outOfStock;
    }


    protected void producerBundleStats (User producer,int day,ExpList expList,int[] res){
        BundleStore bundles = expList.getBundleStore();

        // nº de cabazes fornecidos totalmente
        int totalFullFilled = 0;
        boolean doesPartialFill;

        // nº de cabazes fornecidos parcialmente
        int partialFilled = 0;
        boolean doesFullfil;

        // nº de clientes distintos fornecidos
        int numDifClients = 0;

        // nº de hubs fornecidos.
        int numDifHubs = 0;

        // estrutura auxiliar para controlar clientes repetidos
        HashSet<User> difClients = new HashSet<>();

        for (Bundle bundle : bundles.getBundles(day)) {
            // assumindo que cada bundle e sempre fullfilled por um
            doesFullfil = true;
            doesPartialFill = false;

            if(!bundle.getOrdersList().isEmpty()){
                for (Order order : bundle.getOrdersList()){

                    // nao entregue
                    if (order.getProducer() != null) {

                        // caso o pedido não seja fornecido pelo produtor
                        // o cabaz já não é fornecido na totalidade pelo produtor
                        if (order.getProducer().equals(producer)) {
                            doesPartialFill = true;

                            // caso um dos pedidos do cabaz esteja fornecido parcialmente
                            // o cabaz já não é fornecido na totalidad pelo produtor
                            if (order.getState() == DeliveryState.PARTIALLY_SATISFIED) {
                                doesFullfil = false;
                            }

                            // caso o cliente ainda n tenha sido encontrado
                            if (difClients.add(bundle.getClient())) {
                                switch (bundle.getClient().getUserType()) {
                                    case COMPANY:
                                        numDifHubs++;
                                    case CLIENT: /* FALLTHROUGH */
                                        numDifClients++;
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }else {
                            doesFullfil = false;
                        }
                    } else {
                        doesFullfil = false;
                    }
                }

                if (doesFullfil == true)
                    totalFullFilled++;
                else if (doesPartialFill == true)
                    partialFilled++;
            }
        }

        res[ProducerIndex.BUNDLES_TOTALLY_PROVIDED.getPrefix()] = totalFullFilled;
        res[ProducerIndex.BUNDLES_PARTIALLY_PROVIDED.getPrefix()] = partialFilled;
        res[ProducerIndex.DIF_CLIENTS.getPrefix()] = numDifClients;
        res[ProducerIndex.DIF_HUBS.getPrefix()] = numDifHubs;
    }

    /*
     * HUB
     */

    public HashMap<User,int[]> getAllHubsStats(int day, ExpList expList){

        HashMap<User,int []> res = new LinkedHashMap<>();

        //keep track de clientes e produtores já existentes
        HashMap<User,Pair<HashSet<User>,HashSet<User>>> difClientsProducerPerHub=new LinkedHashMap<>();

        for (Bundle iterBundle : expList.getBundleStore().getBundles(day)) {

            User hub=iterBundle.getClient().getNearestHub();

            Pair<HashSet<User>,HashSet<User>>pair=difClientsProducerPerHub.get(hub);

            if(pair==null){
                difClientsProducerPerHub.put(hub,new Pair<>(new HashSet<>(), new HashSet<>()));
                pair=difClientsProducerPerHub.get(hub);
            }

            //adicionar o cliente
            pair.first().add(iterBundle.getClient());

            for (Order iterOrder : iterBundle.getOrdersList()) {
                //adicionar o produtor
                if(iterOrder.getProducer()!=null)
                    pair.second().add(iterOrder.getProducer());
            }
        }


        for (Entry<User,Pair<HashSet<User>,HashSet<User>>> iterPair : difClientsProducerPerHub.entrySet()) {
            int[] arr = new int[NUMSTATSHUB];
            arr[HubIndex.DIF_CLIENTS.getPrefix()]=iterPair.getValue().first().size();
            arr[HubIndex.DIF_PRODUCERS.getPrefix()]=iterPair.getValue().second().size();
            res.put(iterPair.getKey(),arr);
        }

        return res;
    }
}
