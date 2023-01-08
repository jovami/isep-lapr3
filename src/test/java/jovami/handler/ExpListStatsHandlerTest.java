package jovami.handler;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map.Entry;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jovami.App;
import jovami.MainTest;
import jovami.handler.data.DataLoader;
import jovami.model.User;
import jovami.model.bundles.Bundle;
import jovami.model.shared.BundleIndex;
import jovami.model.shared.ClientIndex;
import jovami.model.shared.HubIndex;
import jovami.model.shared.ProducerIndex;
import jovami.model.store.ExpListStore;
import jovami.model.store.ExpListStore.Restriction;

public class ExpListStatsHandlerTest {

    private ExpListStatsHandler handler;
    private ExpListStore store;
    final DataLoader data = new DataLoader();

    @BeforeEach
    public void setup() {
        MainTest.resetSingleton();
        App app = App.getInstance();
        this.store = app.expListStore();
        handler = new ExpListStatsHandler();

    }

    @Test
    void checkHubsNoRestrictions() {
        MainTest.readData(false);
        ExpBasketListHandler computeHandler = new ExpBasketListHandler();
        // compute expedition lists
        computeHandler.expBasketsList();
        NearestHubToClientsHandler nHub = new NearestHubToClientsHandler();
        nHub.findNearestHubs();

        LinkedHashMap<User, int[]> hubStats;
        List<List<String[]>> expecetedHubStats = data.statsHubExpNoRestrict();

        assertEquals(5, expecetedHubStats.size());

        for (int day = 1; day <= expecetedHubStats.size(); day++) {
            List<String[]> list = expecetedHubStats.get(day - 1);

            hubStats = handler.getAllHubsStats(day, store.getExpList(Restriction.NONE));
            int i = 0;
            for (Entry<User, int[]> real : hubStats.entrySet()) {

                assertEquals(real.getKey().getUserID(), list.get(i)[0]);
                int clientsInd = HubIndex.DIF_CLIENTS.getPrefix();
                int producersInd = HubIndex.DIF_PRODUCERS.getPrefix();

                assertEquals(Integer.parseInt(list.get(i)[clientsInd + 1]), real.getValue()[clientsInd]);
                assertEquals(Integer.parseInt(list.get(i)[producersInd + 1]), real.getValue()[producersInd]);

                i++;
            }
        }
    }

    @Test
    void checkProducersNoRestrictions() {
        MainTest.readData(false);
        ExpBasketListHandler computeHandler = new ExpBasketListHandler();
        // compute expedition lists
        computeHandler.expBasketsList();

        LinkedHashMap<User, int[]> producerStats;
        List<List<String[]>> expectedProducerStats = data.statsProducerExpNoRestrict();

        assertEquals(5, expectedProducerStats.size());

        for (int day = 1; day < expectedProducerStats.size(); day++) {
            List<String[]> list = expectedProducerStats.get(day - 1);
            producerStats = handler.getAllProducersStats(day, store.getExpList(Restriction.NONE));

            int i = 0;
            for (Entry<User, int[]> real : producerStats.entrySet()) {

                assertEquals(real.getKey().getUserID(), list.get(i)[0]);
                int totalInd = ProducerIndex.BUNDLES_TOTALLY_PROVIDED.getPrefix();
                int partInd = ProducerIndex.BUNDLES_PARTIALLY_PROVIDED.getPrefix();
                int outOfStock = ProducerIndex.PROD_OUT_OF_STOCK.getPrefix();
                int clientsInd = ProducerIndex.DIF_CLIENTS.getPrefix();
                int hubInd = ProducerIndex.DIF_HUBS.getPrefix();

                assertEquals(real.getValue()[totalInd], Integer.parseInt(list.get(i)[totalInd + 1]));
                assertEquals(real.getValue()[partInd], Integer.parseInt(list.get(i)[partInd + 1]));
                assertEquals(real.getValue()[outOfStock], Integer.parseInt(list.get(i)[outOfStock + 1]));
                assertEquals(real.getValue()[clientsInd], Integer.parseInt(list.get(i)[clientsInd + 1]));
                assertEquals(real.getValue()[hubInd], Integer.parseInt(list.get(i)[hubInd + 1]));

                i++;

            }
        }
    }

    @Test
    void checkBundlesNoRestrictions() {
        MainTest.readData(false);
        ExpBasketListHandler computeHandler = new ExpBasketListHandler();
        // compute expedition lists
        computeHandler.expBasketsList();

        LinkedHashMap<Bundle, float[]> bundleStats;
        List<List<String[]>> expectedBundleStats = data.statsBundleExpNoRestrict();
        assertEquals(5, expectedBundleStats.size());

        for (int day = 1; day < expectedBundleStats.size(); day++) {
            List<String[]> list = expectedBundleStats.get(day - 1);

            int i = 0;
            bundleStats = handler.getAllbundlesStats(day, store.getExpList(Restriction.NONE));
            for (Entry<Bundle, float[]> real : bundleStats.entrySet()) {

                assertEquals(real.getKey().getClient().getUserID(), list.get(i)[0]);
                int percInd = BundleIndex.PERC_TOTAL_SATISFIED.getPrefix();

                if (!Float.isNaN(real.getValue()[percInd])) {
                    assertEquals(real.getValue()[percInd], Float.parseFloat(list.get(i)[percInd + 1]), 0.1d);
                }

                int partInd = BundleIndex.PARTIALY_DELIVERED.getPrefix();
                int numProducersInd = BundleIndex.NUM_PRODUCERS.getPrefix();
                int fullInd = BundleIndex.FULLY_DELIVERED.getPrefix();
                int notDeliveredInd = BundleIndex.NOT_DELIVERED.getPrefix();

                assertEquals(real.getValue()[partInd], Float.parseFloat(list.get(i)[partInd + 1]), 0.1d);
                assertEquals(real.getValue()[numProducersInd], Float.parseFloat(list.get(i)[numProducersInd + 1]),
                        0.1d);
                assertEquals(real.getValue()[fullInd], Float.parseFloat(list.get(i)[fullInd + 1]), 0.1d);
                assertEquals(real.getValue()[notDeliveredInd], Float.parseFloat(list.get(i)[notDeliveredInd + 1]),
                        0.1d);

                i++;
            }
        }
    }

    @Test
    void checkClientNoRestrictions() {
        MainTest.readData(false);
        ExpBasketListHandler computeHandler = new ExpBasketListHandler();
        // compute expedition lists
        computeHandler.expBasketsList();
        LinkedHashMap<User, int[]> clientStats;
        List<List<String[]>> expectedClienteStats = data.statsClientExpNoRestrict();
        assertEquals(5, expectedClienteStats.size());

        for (int day = 1; day < expectedClienteStats.size(); day++) {
            List<String[]> list = expectedClienteStats.get(day - 1);
            clientStats = handler.getAllClientsStats(day, store.getExpList(Restriction.NONE));


            int i = 0;
            for (Entry<User, int[]> real : clientStats.entrySet()) {

                assertEquals(real.getKey().getUserID(), list.get(i)[0]);
                int partInd = ClientIndex.PARTIALLY_SATISFIED.getPrefix();
                int numProducersInd = ClientIndex.NUM_PRODUCERS.getPrefix();
                int totalInd = ClientIndex.TOTALLY_SATISTFIED.getPrefix();

                assertEquals(real.getValue()[partInd], Integer.parseInt(list.get(i)[partInd + 1]));
                assertEquals(real.getValue()[numProducersInd], Integer.parseInt(list.get(i)[numProducersInd + 1]));
                assertEquals(real.getValue()[totalInd], Integer.parseInt(list.get(i)[totalInd + 1]));

                i++;

            }
        }
    }

}
