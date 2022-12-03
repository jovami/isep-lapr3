package jovami.handler;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
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

    private static enum CSVFiles {
        USERS("clientes-produtores_%s.csv", CSVHeader.USERS),
        DISTANCES("distancias_%s.csv", CSVHeader.DISTANCES),

        // Special snowflake
        BUNDLES("cabazes_%s.csv", CSVHeader.BUNDLES);

        private final String fname;
        private final CSVHeader header;

        private static final String PREFIX = "/csvfiles";

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

    public CSVLoaderHandler() {
        app = App.getInstance();

        parsers = new HashMap<>(1 << 2, 1.0F);

        parsers.put(CSVHeader.USERS, new UserParser());
        parsers.put(CSVHeader.DISTANCES, new DistanceParser());

        // Special snowflakes
        parsers.put(CSVHeader.BUNDLES, new BundleParser());
        parsers.put(CSVHeader.BUNDLES_SMALL, new BundleParser());
    }


    public void loadResources(boolean loadBig)
    {
        for (var fileEnum : CSVFiles.values()) {
            String fpath = fileEnum.path(loadBig);
            List<String[]> data;

            try {
                data = CSVReader.readFromResources(fpath,
                        fileEnum == CSVFiles.BUNDLES && !loadBig
                        ? CSVHeader.BUNDLES_SMALL
                        : fileEnum.header);
            } catch (IOException e) {
                e.printStackTrace();
                return;
            }

            if (fileEnum != CSVFiles.BUNDLES)
                this.parsers.get(fileEnum.header).parse(data);

            /* NOTE: bundles are disabled because they're not yet needed */
            // if (fileEnum == CSVFiles.BUNDLES && !loadBig)
            //     ;// FIXME: parse differently
            // else
            //     parsers.get(fileEnum.header).parse(data);
        }
    }

    public void loadInteractive(Map<CSVHeader, File> files)
    {
        files.forEach((header, file) -> {
            List<String[]> data;
            try {
                data = CSVReader.readCSV(file, header);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
                return;
            }

            this.parsers.get(header).parse(data);
        });
    }

    public boolean populateNetwork() {
        var users = this.app.userStore();
        var distances = this.app.distanceStore();

        var network = this.app.hubNetwork();

        int edges = network.numEdges();
        int verts = network.numVertices();


        users.forEach(network::addVertex);

        distances.forEach(distance -> {
            var orig = users.getUser(distance.getLocID1());
            var dest = users.getUser(distance.getLocID2());

            if (orig.isPresent() && dest.isPresent())
                network.addEdge(orig.get(), dest.get(), distance);
        });

        return edges < network.numEdges() || verts < network.numVertices();
    }
}
