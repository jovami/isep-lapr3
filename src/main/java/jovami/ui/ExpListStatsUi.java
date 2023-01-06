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

public class ExpListStatsUi implements UserStory{
    ExpListStatsHandler handler;
    private final List<Restriction> restrictions;
    // Restriction[] restrictions = Restriction.values();


    public ExpListStatsUi(){
        handler = new ExpListStatsHandler();
        this.restrictions = Arrays.asList(Restriction.values());
    }

    @Override
    public void run(){
        //showing statistics to the 4 types

        //for which type expedition list



        ExpList expList;
        do {
            int i = InputReader.showAndSelectIndex(this.restrictions,
                                                   "Types of expedition lists:");
            expList = this.handler.getExpList(this.restrictions.get(i));
        } while (expList == null);


        int day;
        do {
            day = InputReader.readInteger("Choose a day:");
        } while(expList.getBundleStore().getBundles(day)==null);


        //client
        System.out.println("Calculating stats related to clients:");

        HashMap<User,int[]> clientStats = handler.getAllClientsStats(day, expList);


        System.out.println("|Client|Bundles fully|Bundles partialy|Producers");
        for (Entry<User, int[]> iterClient : clientStats.entrySet()) {
            System.out.printf("|%s|%d|%d|%d\n",iterClient.getKey().getUserID()
                              ,iterClient.getValue()[ClientIndex.TOTALLY_SATISTFIED.getPrefix()]
                              ,iterClient.getValue()[ClientIndex.PARTIALLY_SATISFIED.getPrefix()]
                              ,iterClient.getValue()[ClientIndex.NUM_PRODUCERS.getPrefix()]
            );
        }

        //printing stats

        //producer
        System.out.println("Calculating stats related to producer:");

        HashMap<User,int[]> producerStats=handler.getAllProducersStats(day, expList);

        System.out.println("|Producer|B fully|B partialy|Out Of Stock|Clients|Hubs");
        for (Entry<User, int[]> iterProducer : producerStats.entrySet()) {
            System.out.printf("|%s|%d|%d|%d|%d|%d\n",iterProducer.getKey().getUserID()
                              ,iterProducer.getValue()[ProducerIndex.BUNDLES_TOTALLY_PROVIDED.getPrefix()]
                              ,iterProducer.getValue()[ProducerIndex.BUNDLES_PARTIALLY_PROVIDED.getPrefix()]
                              ,iterProducer.getValue()[ProducerIndex.PROD_OUT_OF_STOCK.getPrefix()]
                              ,iterProducer.getValue()[ProducerIndex.DIF_CLIENTS.getPrefix()]
                              ,iterProducer.getValue()[ProducerIndex.DIF_HUBS.getPrefix()]
            );
        }



        System.out.println("Calculating stats related to hub:");
        //hub
        HashMap<User,int[]> hubStats=handler.getAllHubsStats(day, expList);


        System.out.println("|Hub|Clients|Producers");
        for (Entry<User, int[]> iterHub : hubStats.entrySet()) {
            System.out.printf("|%s|%d|%d\n",iterHub.getKey().getUserID()
                              ,iterHub.getValue()[HubIndex.DIF_CLIENTS.getPrefix()]
                              ,iterHub.getValue()[HubIndex.DIF_PRODUCERS.getPrefix()]
            );
        }


        //bundle
        System.out.println("Calculating stats related to bundle:");

        HashMap<Bundle,float[]> bundleStats=handler.getAllbundlesStats(day,expList);


        System.out.println("Day "+day);
        System.out.println("|Bundle|fully|partialy|Not deliveredClients|Perc|Producers");
        for (Entry<Bundle, float[]> iterBundle : bundleStats.entrySet()) {

            if(Float.isNaN(iterBundle.getValue()[BundleIndex.PERC_TOTAL_SATISFIED.getPrefix()])){
                //quando o valor for nan, o que fazer??
                //TODO joao, como estou a usar floats, a casos em que este valor nao é sequer um numero, e aparece como NAN, ve como achas que fica melhor, 
                //deixar assim, ou nem imprimir a linha relacionada(quando isto acontece quer dizer que o cabaz pedido n teve nenhum pedido)

            }

            System.out.printf("|%5s|%10.1f|%10.1f|%10.1f|%10.2f|%10.2f\n",iterBundle.getKey().getClient().getUserID()
                              ,iterBundle.getValue()[BundleIndex.FULLY_DELIVERED.getPrefix()]
                              ,iterBundle.getValue()[BundleIndex.PARTIALY_DELIVERED.getPrefix()]
                              ,iterBundle.getValue()[BundleIndex.NOT_DELIVERED.getPrefix()]
                              ,iterBundle.getValue()[BundleIndex.PERC_TOTAL_SATISFIED.getPrefix()]
                              ,iterBundle.getValue()[BundleIndex.NUM_PRODUCERS.getPrefix()]
            );
        }
    }
}
