package jovami.handler;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import jovami.App;
import jovami.model.csv.BundleParser;
import jovami.model.csv.CSVHeader;
import jovami.model.csv.CSVParser;
import jovami.model.csv.CSVReader;
import jovami.model.csv.DistanceParser;
import jovami.model.csv.UserParser;

/**
 * CSVLoaderHandler
 */
public class CSVLoaderHandler {

    private final App app;

    private enum CSVFiles {
        USERS("clientes-produtores_%s.csv", CSVHeader.USERS),
        DISTANCES("distancias_%s.csv", CSVHeader.DISTANCES),
        // Special snowflake
        BUNDLES("cabazes_%s.csv", CSVHeader.BUNDLES);

        private final String fname;
        private final CSVHeader header;

        private static final String PREFIX = "/csvfiles";

        /**
         * Path string.
         *
         * @param big the big
         * @return the string
         */
        public String path(boolean big) {
            String type = big ? "big" : "small";
            return String.format("%s/%s/%s",
                    PREFIX, type, this.fname.formatted(type));
        }

        CSVFiles(String s, CSVHeader h) {
            this.fname = s;
            this.header = h;
        }
    }

    private final Map<CSVHeader, CSVParser> parsers;

    /**
     * Instantiates a new Csv loader handler.
     */
    public CSVLoaderHandler() {
        app = App.getInstance();

        this.parsers = new EnumMap<>(CSVHeader.class);

        this.parsers.put(CSVHeader.USERS, new UserParser());
        this.parsers.put(CSVHeader.DISTANCES, new DistanceParser());

        // Special snowflakes
        this.parsers.put(CSVHeader.BUNDLES, new BundleParser());
        this.parsers.put(CSVHeader.BUNDLES_SMALL, new BundleParser());
    }


    /**
     * Load resources.
     *
     * @param loadBig the load big
     */
    public void loadResources(boolean loadBig)
    {
        for (var fileEnum : CSVFiles.values()) {                    // O(1) (enum values)
            String fpath = fileEnum.path(loadBig);
            List<String[]> data;

            try {
                data = CSVReader.readFromResources(fpath,           // O(l*c);
                        fileEnum == CSVFiles.BUNDLES && !loadBig    // l => lines of the file(s)
                        ? CSVHeader.BUNDLES_SMALL                   // c => columns of the file(s)
                        : fileEnum.header);
            } catch (IOException e) {
                e.printStackTrace();
                return;
            }

            this.parsers.get(fileEnum.header).parse(data);      // get: O(1); parse: O(l)
        }

        // Net complexity: O(l*c)
    }

    /**
     * Load interactive.
     *
     * @param files the files
     */
    public void loadInteractive(Map<CSVHeader, File> files)
    {
        files.forEach((header, file) -> {                           // O(1) (keys => enum values)
            List<String[]> data;
            try {
                data = CSVReader.readCSV(file, header);             // O(l*c)
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                return;
            }

            this.parsers.get(header).parse(data);                   // O(l)
        });

        // Net complexity: O(l*c)
    }

    /**
     * Populate network.
     *
     * @return the boolean
     */
    public boolean populateNetwork() {
        var users = this.app.userStore();
        var distances = this.app.distanceStore();

        var network = this.app.hubNetwork();

        int edges = network.numEdges();                             // O(1)
        int verts = network.numVertices();                          // O(1)


        users.forEach(network::addVertex);                          // O(V) ~ O(l)

        distances.forEach(distance -> {                             // O(E)
            var orig = users.getUser(distance.getLocID1());         // O(1)
            var dest = users.getUser(distance.getLocID2());         // O(1)

            if (orig.isPresent() && dest.isPresent())
                network.addEdge(orig.get(), dest.get(), distance);  // O(1)
        });

        // Net complexity: O(E), since E ~ V^2
        return edges < network.numEdges() || verts < network.numVertices();
    }
}
