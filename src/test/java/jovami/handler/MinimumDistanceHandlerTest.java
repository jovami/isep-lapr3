package jovami.handler;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jovami.MainTest;
import jovami.model.Distance;
import jovami.model.User;
import jovami.util.graph.Edge;
import jovami.util.graph.Graph;

public class MinimumDistanceHandlerTest {

    MinimumDistanceHandler minimumDistanceHandler;
    final List<String[]> userList = addUsers();
    final List<String[]> distanceList = addDistances();
    final List<Integer> weight = Arrays.asList(56717, 62877, 69282, 65574, 125105, 43598, 50467, 68957, 43598, 68957, 110133, 50467, 62877, 65574, 95957, 125105, 63448, 89813, 89813, 95957, 62655, 62655, 90186, 62879, 90186, 110133, 62879, 69282, 56717, 67584, 63448, 67584);

    @BeforeEach
    public void setup(){
        MainTest.resetSingleton();
        minimumDistanceHandler = new MinimumDistanceHandler();
        MainTest.readUsers(userList,distanceList);
        new CSVLoaderHandler().populateNetwork();
    }

    @Test
    void getMinimalUserNetwork() {
        Collection<Edge<User,Distance>> edge = minimumDistanceHandler.getMinimalUserNetwork().edges();

        assertEquals(32,edge.size());

        var vOrig=Arrays.asList("C1", "C1", "C1", "C2", "C2", "C3", "C3", "C3", "C4", "C5", "C5", "C6", "C6", "C7", "C7", "C8", "C9", "C9", "E1", "E1", "E2", "E3", "E3", "E4", "E4", "E5", "P1", "P1", "P2", "P2", "P3", "P3");
        var vDest=Arrays.asList("P2", "C6", "P1", "C7", "C8", "C4", "C6", "C5", "C3", "C3", "E5", "C3", "C1", "C2", "E1", "C2", "P3", "E1", "C9", "C7", "E3", "E2", "E4", "P1", "E3", "C5", "E4", "C1", "C1", "P3", "C9", "P2");
        int i=0;
        for (Edge<User, Distance> edges :edge) {
            assertEquals(vOrig.get(i), edges.getVOrig().getUserID());
            assertEquals(vDest.get(i), edges.getVDest().getUserID());
            assertEquals(weight.get(i), edges.getWeight().getDistance());
            i++;
        }
    }

    @Test
    void getMinimumCost() {
        Graph<User, Distance> mst = minimumDistanceHandler.getMinimalUserNetwork();
        int sum=0;
        for (Integer wei : weight) {
            sum = sum + wei;
        }
        assertEquals(sum, minimumDistanceHandler.getMinimumCost(mst));

    }

    public List<String[]> addDistances() {
        return Arrays.asList(
                new String[]{"CT10","CT13","63448"},
                new String[]{"CT10","CT6","67584"},
                new String[]{"CT10","CT1","110848"},
                new String[]{"CT10","CT5","125041"},
                new String[]{"CT12","CT3","50467"},
                new String[]{"CT12","CT1","62877"},
                new String[]{"CT12","CT15","70717"},
                new String[]{"CT11","CT5","62655"},
                new String[]{"CT11","CT13","121584"},
                new String[]{"CT11","CT10","142470"},
                new String[]{"CT14","CT13","89813"},
                new String[]{"CT14","CT7","95957"},
                new String[]{"CT14","CT2","114913"},
                new String[]{"CT14","CT8","207558"},
                new String[]{"CT13","CT7","111686"},
                new String[]{"CT16","CT3","68957"},
                new String[]{"CT16","CT17","79560"},
                new String[]{"CT16","CT12","82996"},
                new String[]{"CT16","CT9","103704"},
                new String[]{"CT16","CT4","110133"},
                new String[]{"CT15","CT3","43598"},
                new String[]{"CT17","CT9","62879"},
                new String[]{"CT17","CT1","69282"},
                new String[]{"CT17","CT6","73828"},
                new String[]{"CT1","CT6","56717"},
                new String[]{"CT2","CT7","65574"},
                new String[]{"CT2","CT8","125105"},
                new String[]{"CT2","CT11","163996"},
                new String[]{"CT4","CT3","157223"},
                new String[]{"CT4","CT9","162527"},
                new String[]{"CT5","CT9","90186"},
                new String[]{"CT5","CT6","100563"},
                new String[]{"CT5","CT17","111134"}
        );
    }

    public List<String[]> addUsers() {
        return Arrays.asList(
                new String[]{"CT1", "40.6389", "-8.6553", "C1"},
                new String[]{"CT2", "38.0333", "-7.8833", "C2"},
                new String[]{"CT3", "41.5333", "-8.4167", "C3"},
                new String[]{"CT15", "41.7", "-8.8333", "C4"},
                new String[]{"CT16", "41.3002", "-7.7398", "C5"},
                new String[]{"CT12", "41.1495", "-8.6108", "C6"},
                new String[]{"CT7", "38.5667", "-7.9", "C7"},
                new String[]{"CT8", "37.0161", "-7.935", "C8"},
                new String[]{"CT13", "39.2369", "-8.685", "C9"},
                new String[]{"CT14", "38.5243", "-8.8926", "E1"},
                new String[]{"CT11", "39.3167", "-7.4167", "E2"},
                new String[]{"CT5", "39.823", "-7.4931", "E3"},
                new String[]{"CT9", "40.5364", "-7.2683", "E4"},
                new String[]{"CT4", "41.8", "-6.75", "E5"},
                new String[]{"CT17", "40.6667", "-7.9167", "P1"},
                new String[]{"CT6", "40.2111", "-8.4291", "P2"},
                new String[]{"CT10", "39.7444", "-8.8072", "P3"}
                );
    }
}
