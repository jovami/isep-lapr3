package jovami.handler;

import jovami.MainTest;
import jovami.handler.data.NearestHubToClientsData;
import jovami.model.Distance;
import jovami.model.HubNetwork;
import jovami.model.User;
import jovami.model.store.UserStore;
import jovami.util.Triplet;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Objects;

import static org.junit.jupiter.api.Assertions.*;

class NearestHubToClientsHandlerTest {
    NearestHubToClientsHandler handler;
    HubNetwork network;
    UserStore userStore;

    @BeforeEach
    void setUp() {
        MainTest.resetSingleton();
        NearestHubToClientsData.loadData();
        new CSVLoaderHandler().populateNetwork();
        handler = new NearestHubToClientsHandler();
        network = handler.getNetwork();
        userStore = handler.getUserStore();
    }

    @Test
    void findNearestHubs() {
        var actual = handler.findNearestHubs();
        var expectedDist = new ArrayList<Triplet<User, User, Distance>>();

        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT1").get(),
                handler.getUserStore().getUser("CT9").get(),
                new Distance("CT1",  "CT9", 132161)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT2").get(),
                handler.getUserStore().getUser("CT14").get(),
                new Distance("CT2",  "CT14", 114913)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT3").get(),
                handler.getUserStore().getUser("CT4").get(),
                new Distance( "CT3",  "CT4", 157223)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT15").get(),
                handler.getUserStore().getUser("CT4").get(),
                new Distance("CT15",  "CT4", 200821)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT16").get(),
                        handler.getUserStore().getUser("CT9").get(),
                        new Distance("CT16",  "CT9", 103704)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT12").get(),
                        handler.getUserStore().getUser("CT9").get(),
                        new Distance("CT12",  "CT9", 186700)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT7").get(),
                        handler.getUserStore().getUser("CT14").get(),
                        new Distance("CT7",  "CT14", 95957)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT8").get(),
                        handler.getUserStore().getUser("CT14").get(),
                        new Distance("CT8",  "CT14", 207558)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT13").get(),
                        handler.getUserStore().getUser("CT14").get(),
                        new Distance("CT13",  "CT14", 89813)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT14").get(),
                        handler.getUserStore().getUser("CT14").get(),
                        new Distance("CT14",  "CT14", 0)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT11").get(),
                        handler.getUserStore().getUser("CT11").get(),
                        new Distance("CT11",  "CT11", 0)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT5").get(),
                        handler.getUserStore().getUser("CT5").get(),
                        new Distance("CT5",  "CT5", 0)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT9").get(),
                        handler.getUserStore().getUser("CT9").get(),
                        new Distance("CT9",  "CT9", 0)));
        expectedDist.add(
                new Triplet<>(handler.getUserStore().getUser("CT4").get(),
                        handler.getUserStore().getUser("CT4").get(),
                        new Distance("CT4",  "CT4", 0)));

        expectedDist.forEach( d -> {
            var act = actual.poll();
            assert act != null;
            assertEquals(d.first(), act.first());
            assertEquals(d.second(), act.second());
            assertEquals(d.third(), act.third());
        });
    }
}