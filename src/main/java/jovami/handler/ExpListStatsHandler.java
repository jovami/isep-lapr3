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

    private final ExpListStore expStore;

    private final int NUMSTATSHUB = 2;
    private final int NUMSTATSCLIENT = 3;
    private final int NUMSTATSPRODUTOR = 5;
    private final int NUMSTATSBUNDLE = 5;

    public ExpListStatsHandler(){
        App app = App.getInstance();
        expStore = app.expListStore();
    }


    public ExpList getExpList(Restriction r){
        return expStore.getExpList(r);
    }

    /*CABAZ
    */
    public LinkedHashMap<Bundle,float[]> getAllbundlesStats (int day,ExpList expList){          //Net complexity: O(n^2)
        LinkedHashMap<Bundle,float []> res = new LinkedHashMap<>();

        for (Bundle iterBundle : expList.getBundleStore().getBundles(day)) {    	            //O(n*inside)
            res.computeIfAbsent(iterBundle, k -> new float[NUMSTATSBUNDLE]);                    //O(1)

            statsEachBundle(iterBundle, res.get(iterBundle));                                   //O(n)
        }
        return res;
    }


    protected void statsEachBundle(Bundle bundle, float[] res){                                 //Net complexity: O(n)

        float numFullyDelivered = 0;

        //nº de produtos parcialmente satisfeitos,
        float numPartialyDelivered = 0;

        //nºde produtos não satisfeitos
        float numNotDelivered = 0;


        HashSet<User> producers = new HashSet<>();

        for (Order order : bundle.getOrdersList()) {                                            //O(n*inside)
            if(order.getState()==DeliveryState.TOTALLY_SATISTFIED){                             //O(1)
                numFullyDelivered++;                                                            //O(1)
                producers.add(order.getProducer());                                             //O(1)

            }else if(order.getState() == DeliveryState.PARTIALLY_SATISFIED){                    //O(1)
                    numPartialyDelivered++;                                                     //O(1)
                    producers.add(order.getProducer());                                         //O(1)

            }else{
                numNotDelivered++;                                                              //O(1)
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



    public LinkedHashMap<User,int[]> getAllClientsStats(int day,ExpList expList){              //Net complexity O(n^2)

        LinkedHashMap<User,int []> res = new LinkedHashMap<>();

        for (Bundle iterBundle : expList.getBundleStore().getBundles(day)) {                    //O(n*inside)
            //uma empresa é um cliente, e é também um hub   
            res.computeIfAbsent(iterBundle.getClient(), k -> new int[NUMSTATSCLIENT]);          //O(1)
            clientStats(iterBundle.getClient(), iterBundle,res.get(iterBundle.getClient()));    //O(n)
        }

        return res;

    }

    protected void clientStats (User client,Bundle bundle, int[] arr){              //O(n)
        //nº de cabazes totalmente satisfeitos
        int totalSatisfied=arr[ClientIndex.TOTALLY_SATISTFIED.getPrefix()];         //O(1)

        //nº de cabazes parcialmente satisfeitos
        int partialyStatisfied=arr[ClientIndex.PARTIALLY_SATISFIED.getPrefix()];    //O(1)

        HashSet<User> deliv=new HashSet<>();                                        //O(1)

        if(bundle.getClient()==client){                                             //O(1)
            switch (bundle.getState()) {                                            //O(1)
                case TOTALLY_SATISTFIED -> totalSatisfied++;                        //O(1)
                case PARTIALLY_SATISFIED -> partialyStatisfied++;                   //O(1)
                default -> {}
            }

            if(bundle.getOrdersList().size()!=0) {
                for (Order order : bundle.getOrdersList()) {//o(n*inside)
                    if(order.getProducer()!=null)                                   //O(1)
                        deliv.add(order.getProducer());                             //O(1)
                }
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

    public LinkedHashMap<User,int[]> getAllProducersStats(int day, ExpList expList){                    //Net complexity: O(n^3)

        LinkedHashMap<User,int []> res = new LinkedHashMap<>();

        for(Entry<User,Stock> producerStock: expList.getStockStore().getStocks().entrySet()){           //O(n*inside)
            res.computeIfAbsent(producerStock.getKey(), k -> new int[NUMSTATSPRODUTOR]);                //O(1)
            producerStockStats(day, res.get(producerStock.getKey()), producerStock.getValue());         //O(n)
            producerBundleStats(producerStock.getKey(),day, expList,res.get(producerStock.getKey()));   //O(n^2)
        }

        return res;

    }


    protected void producerStockStats(int day, int[] res, Stock producerStock) {                        //Net complexity: O(n)

        int outOfStock=res[ProducerIndex.PROD_OUT_OF_STOCK.getPrefix()];                                //O(1)

        for(ProductStock product : producerStock.getStocks(day)){                                       //O(n*inside)
            if(product!=null){                                                                          //O(1)
                if(producerStock.getStashAvailable(product.getProduct(), day)==0){                      //O(1)
                    outOfStock++;                                                                       //O(1)
                }
            }
        }

        res[ProducerIndex.PROD_OUT_OF_STOCK.getPrefix()]=outOfStock;                                    //O(1)
    }


    protected void producerBundleStats (User producer,int day,ExpList expList,int[] res){           //O(n^2)
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

        for (Bundle bundle : bundles.getBundles(day)) {                                         //O(n*inside)
            // assumindo que cada bundle e sempre fullfilled por um
            doesFullfil = true;
            doesPartialFill = false;

            if(!bundle.getOrdersList().isEmpty()){
                for (Order order : bundle.getOrdersList()){                                     //O(n*inside)

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

                if (doesFullfil)
                    totalFullFilled++;
                else if (doesPartialFill)
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

    public LinkedHashMap<User,int[]> getAllHubsStats(int day, ExpList expList){                         //Net complexity: O(n^2)

        LinkedHashMap<User,int []> res = new LinkedHashMap<>();

        //keep track de clientes e produtores já existentes
        HashMap<User,Pair<HashSet<User>,HashSet<User>>> difClientsProducerPerHub=new LinkedHashMap<>();

        for (Bundle iterBundle : expList.getBundleStore().getBundles(day)) {                            //O(n*inside)

            User hub=iterBundle.getClient().getNearestHub();                                            //O(1)

            Pair<HashSet<User>,HashSet<User>>pair=difClientsProducerPerHub.get(hub);                    //O(1)

            if(pair==null){
                difClientsProducerPerHub.put(hub,new Pair<>(new HashSet<>(), new HashSet<>()));         //O(1)
                pair=difClientsProducerPerHub.get(hub);
            }

            //adicionar o cliente
            pair.first().add(iterBundle.getClient());                                                   //O(1)

            for (Order iterOrder : iterBundle.getOrdersList()) {                                        //O(n*inside)
                //adicionar o produtor
                if(iterOrder.getProducer()!=null)                                                       //O(1)
                    pair.second().add(iterOrder.getProducer());                                         //O(1)
            }
        }


        for (Entry<User,Pair<HashSet<User>,HashSet<User>>> iterPair : difClientsProducerPerHub.entrySet()) {   //O(n)
            int[] arr = new int[NUMSTATSHUB];
            arr[HubIndex.DIF_CLIENTS.getPrefix()]=iterPair.getValue().first().size();
            arr[HubIndex.DIF_PRODUCERS.getPrefix()]=iterPair.getValue().second().size();
            res.put(iterPair.getKey(),arr);
        }

        return res;
    }
}
