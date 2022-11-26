package jovami.ui;

import java.io.File;
import java.util.LinkedHashMap;

import jovami.handler.CSVLoaderHandler;
import jovami.model.csv.CSVHeader;
import jovami.util.io.InputReader;

/**
 * CSVLoaderUI
 */
public class CSVLoaderUI implements UserStory {

    private final CSVLoaderHandler handler;

    public CSVLoaderUI() {
        this.handler = new CSVLoaderHandler();
    }

    @Override
    public void run() {
        try {
            if (InputReader.confirm("Load default files?", true))
                loadResources();
            else
                loadInteractive();
        } catch (RuntimeException e) {
            System.err.println("Aborting...");
            throw e;
        }

        System.out.println("Data loaded with success!!");

        if (this.handler.populateNetwork())
            System.out.println("Hub Network populated with success!!");
    }

    private void loadResources()
    {
        boolean loadBig = InputReader.readLine("Load big or small files?")
                                     .trim()
                                     .toLowerCase()
                                     .matches("^big");

        this.handler.loadResources(loadBig);
    }

    private void loadInteractive()
    {
        var files = new LinkedHashMap<CSVHeader, File>(3, 1.0F);

        files.put(CSVHeader.USERS,      InputReader.getFile("Insert the path to the Clients/Producers file:"));
        files.put(CSVHeader.DISTANCES,  InputReader.getFile("Insert the path to the Distances file:"));

        /* NOTE: bundles are disabled because they're not yet needed */
        // {
        //     path = InputReader.readLine("Insert the path to the Bundles file:");
        //     File f = new File(path);
        //     if (!f.isFile() || !f.canRead())
        //         throw new RuntimeException();

        //     // FIXME: Make this not stupid
        //     boolean big = InputReader.confirm("Is this file similar to the 'big' file?");

        //     var data = CSVReader.readCSV(f, !big ? CSVHeader.BUNDLES_SMALL : CSVFiles.BUNDLES.header);

        //     if (!big)
        //         ;// FIXME: parse differently
        //     else
        //         parsers.get(CSVFiles.BUNDLES).parse(data);
        // }

        this.handler.loadInteractive(files);
    }
}
