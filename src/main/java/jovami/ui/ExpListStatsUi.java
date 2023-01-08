package jovami.ui;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;

import jovami.handler.ExpListStatsHandler;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.bundles.ExpList;
import jovami.model.shared.BundleIndex;
import jovami.model.shared.ClientIndex;
import jovami.model.shared.HubIndex;
import jovami.model.shared.ProducerIndex;
import jovami.model.store.ExpListStore.Restriction;
import jovami.util.io.InputReader;

public class ExpListStatsUI implements UserStory {
    final ExpListStatsHandler handler;
    private final List<Restriction> restrictions;
    // Restriction[] restrictions = Restriction.values();


    public ExpListStatsUI() {
        handler = new ExpListStatsHandler();
        this.restrictions = Arrays.asList(Restriction.values());
    }

    @Override
    public void run() {
        //Net complexity: O(n^3) -> computing producers stats


        ExpList expList;
        do {
            int i = InputReader.showAndSelectIndex(this.restrictions,
                    "Types of expedition lists:");
            expList = this.handler.getExpList(this.restrictions.get(i));
        } while (expList == null);


        int day;
        do {
            day = InputReader.readInteger("Choose a day:");
        } while (expList.getBundleStore().getBundles(day) == null);


        //client
        System.out.println("\tCalculating stats related to clients:\n");

        HashMap<User, int[]> clientStats = handler.getAllClientsStats(day, expList);    //O(n^2)

        System.out.println("\tBundle represented as 'B'");
        System.out.println("Client | B.Full | B.Partial | Producers");
        for (Entry<User, int[]> iterClient : clientStats.entrySet()) {                  //O(n)
            System.out.printf("-> %-4s|   %-5d|     %-6d|     %d\n", iterClient.getKey().getUserID()
                    , iterClient.getValue()[ClientIndex.TOTALLY_SATISTFIED.getPrefix()]
                    , iterClient.getValue()[ClientIndex.PARTIALLY_SATISFIED.getPrefix()]
                    , iterClient.getValue()[ClientIndex.NUM_PRODUCERS.getPrefix()]
            );
        }



        try {
            Thread.sleep(1500);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        //producer
        System.out.println("\n\tCalculating stats related to producer\n");

        //printing stats


        HashMap<User, int[]> producerStats = handler.getAllProducersStats(day, expList);       //O(n^3)

        System.out.println("Producer | B.full | B.Partial | Out Of Stock | Clients | Hubs");
        for (Entry<User, int[]> iterProducer : producerStats.entrySet()) {//O(n)
            System.out.printf("-> %-6s|   %-5d|     %-6d|      %-8d|    %-5d|  %d\n", iterProducer.getKey().getUserID()
                    , iterProducer.getValue()[ProducerIndex.BUNDLES_TOTALLY_PROVIDED.getPrefix()]
                    , iterProducer.getValue()[ProducerIndex.BUNDLES_PARTIALLY_PROVIDED.getPrefix()]
                    , iterProducer.getValue()[ProducerIndex.PROD_OUT_OF_STOCK.getPrefix()]
                    , iterProducer.getValue()[ProducerIndex.DIF_CLIENTS.getPrefix()]
                    , iterProducer.getValue()[ProducerIndex.DIF_HUBS.getPrefix()]
            );
        }


        try {
            Thread.sleep(1500);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println("\n\tCalculating stats related to hub\n");


        //hub
        HashMap<User, int[]> hubStats = handler.getAllHubsStats(day, expList);                                       //O(n^2)


        System.out.println("  Hub | Clients | Producers");
        for (Entry<User, int[]> iterHub : hubStats.entrySet()) {                                                      //O(n)
            System.out.printf("-> %s |    %-5d|     %d\n", iterHub.getKey().getUserID()
                    , iterHub.getValue()[HubIndex.DIF_CLIENTS.getPrefix()]
                    , iterHub.getValue()[HubIndex.DIF_PRODUCERS.getPrefix()]
            );
        }


        //bundle
        System.out.println("\n\tCalculating stats related to bundle\n");

        HashMap<Bundle, float[]> bundleStats = handler.getAllbundlesStats(day, expList);                               //O(n^2)


        System.out.println("\nSupplied represented as 'S'");
        System.out.println("Clients With Non Integer Values Did Not Ordered Anything for That Day\n");
        System.out.println("Bundle | Fully S | Partially S | Not S | Fully S % | Producers");
        for (Entry<Bundle, float[]> iterBundle : bundleStats.entrySet()) {                                             //O(n)                

            if (Float.isNaN(iterBundle.getValue()[BundleIndex.PERC_TOTAL_SATISFIED.getPrefix()])) {
                System.out.printf("-> %-4s| ------- | ----------- | ----- | --------- | --------\n",
                        iterBundle.getKey().getClient().getUserID());
            } else {

                System.out.printf("-> %-4s|    %-5d|      %-7d|   %-4d|   %-8.2f|     %d\n"
                        , iterBundle.getKey().getClient().getUserID()
                        , (int) iterBundle.getValue()[BundleIndex.FULLY_DELIVERED.getPrefix()]
                        , (int) iterBundle.getValue()[BundleIndex.PARTIALY_DELIVERED.getPrefix()]
                        , (int) iterBundle.getValue()[BundleIndex.NOT_DELIVERED.getPrefix()]
                        , iterBundle.getValue()[BundleIndex.PERC_TOTAL_SATISFIED.getPrefix()]
                        , (int) iterBundle.getValue()[BundleIndex.NUM_PRODUCERS.getPrefix()]
                );
            }
        }
    }
}
