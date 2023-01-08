package jovami.handler;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.time.Clock;
import java.util.Collections;
import java.util.List;

import jovami.App;
import jovami.model.WateringController;
import jovami.model.csv.CSVHeader;
import jovami.model.csv.CSVReader;
import jovami.model.csv.WateringControllerParser;
import jovami.util.Pair;

/**
 * WateringControllerHandler
 */
public class WateringControllerHandler {

    private final App app;
    private final WateringControllerParser parser;

    /**
     * Instantiates a new Watering controller handler.
     */
    public WateringControllerHandler() {
        this.app = App.getInstance();
        this.parser = new WateringControllerParser();
    }

    private void load(List<String[]> data) {
        parser.parse(data);
    }

    /**
     * Currently watering list.
     *
     * @return the list
     */
    public List<Pair<String, Long>> currentlyWatering(Clock clk) {
        var opt = this.app.wateringControllerStore().getActiveController();

        if (opt.isPresent()) {
            WateringController ctrl = opt.get();
            return ctrl.currentlyWatering(clk);
        }

        return Collections.emptyList();
    }


    /**
     * Load default.
     *
     * @throws IOException the io exception
     */
    public void loadDefault()
    throws IOException
    {
        String DEFAULT = "/csvfiles/rega_exemplo.csv";
        load(CSVReader.readFromResources(DEFAULT, CSVHeader.NO_HEADER));
    }

    /**
     * Load file.
     *
     * @param file the file
     * @throws FileNotFoundException the file not found exception
     */
    public void loadFile(File file)
    throws FileNotFoundException
    {
        load(CSVReader.readCSV(file, CSVHeader.NO_HEADER));
    }
}
