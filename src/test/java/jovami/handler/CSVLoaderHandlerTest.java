package jovami.handler;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Arrays;
import java.util.LinkedList;

import jovami.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import jovami.App;
import jovami.MainTest;
import jovami.model.Distance;

/**
 * CSVLoaderHandlerTest
 */
public class CSVLoaderHandlerTest {

    private CSVLoaderHandler handler;
    private App app;

    @BeforeEach
    void BeforeEach() {
        MainTest.resetSingleton();

        this.handler = new CSVLoaderHandler();
        this.app = App.getInstance();
    }

    @Test
    void populateEmpty() {
        // Make sure it's reset
        MainTest.resetSingleton();

        this.handler.populateNetwork();
        var network = this.app.hubNetwork();

        assertEquals(0, network.numVertices());
        assertEquals(0, network.numEdges());
    }

    @Test
    void testPopulate() {
        var dists = Arrays.asList(
                new String[] { "CT4","CT3","157223" },
                new String[] { "CT4","CT9","162527" },
                new String[] { "CT5","CT9","90186" },
                new String[] { "CT5","CT6","100563" },
                new String[] { "CT5","CT17","111134" }
        );

        var users = Arrays.asList(
                new String[] { "CT1","40.6389","-8.6553","C1" },
                new String[] { "CT2","38.0333","-7.8833","C2" },
                new String[] { "CT3","41.5333","-8.4167","C3" },
                new String[] { "CT4","41.8","-6.75","E5" },
                new String[] { "CT5","39.823","-7.4931","E3" },
                new String[] { "CT6","40.2111","-8.4291","P2" },
                new String[] { "CT9","40.5364","-7.2683","E4" },
                new String[] { "CT17","40.6667","-7.9167","P1" }
        );

        MainTest.readUsers(users, dists);
        this.handler.populateNetwork();

        var network = this.app.hubNetwork();
        assertEquals(users.size(), network.numVertices());

        // if the graph is undirected, we will have double the edges
        assertEquals(dists.size() * (network.isDirected() ? 1 : 2), network.numEdges());


        {
            System.out.println("Checking vertices...");

            var expectedUsers = users.stream()
                                     .map(u -> u[3])
                                     .sorted(String::compareTo)
                                     .toList();

            var actualUsers = network.vertices()
                                     .stream()
                                     .map(User::getUserID)
                                     .sorted(String::compareTo)
                                     .toList();

            assertEquals(expectedUsers, actualUsers);

            System.out.println("All of the correct vertices were added!!");
        }


        {
            System.out.println("Checking edges...");

            //================ Expected ================//
            var expectedIn = new LinkedList<String>();
            var expectedOut = new LinkedList<String>();
            var expectedDist = new LinkedList<Integer>();

            dists.forEach(entry -> {
                int d = Integer.parseUnsignedInt(entry[2]);

                expectedIn.add(entry[0]);
                expectedOut.add(entry[1]);
                expectedDist.add(d);

                if (!network.isDirected()) {
                    expectedIn.add(entry[1]);
                    expectedOut.add(entry[0]);
                    expectedDist.add(d);
                }
            });

            expectedIn.sort(String::compareTo);
            expectedOut.sort(String::compareTo);
            expectedDist.sort(Integer::compareTo);

            //================ Actual ================//
            var actualIn = new LinkedList<String>();
            var actualOut = new LinkedList<String>();
            var actualDist = new LinkedList<Integer>();

            network.edges().forEach(e -> {
                Distance weight = e.getWeight();

                actualIn.add(weight.getLocID1());
                actualOut.add(weight.getLocID2());
                actualDist.add(weight.getDistance());
            });

            actualIn.sort(String::compareTo);
            actualOut.sort(String::compareTo);
            actualDist.sort(Integer::compareTo);

            //================ Check ================//
            assertEquals(expectedIn, actualIn);
            assertEquals(expectedOut, actualOut);
            assertEquals(expectedDist, actualDist);

            System.out.println("All of the correct edges were added!!");
        }
    }
}
