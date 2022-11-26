package jovami.handler;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

import jovami.App;
import jovami.model.csv.CSVHeader;
import jovami.model.csv.CSVReader;
import jovami.model.csv.WateringControllerParser;

/**
 * WateringControllerHandler
 */
public class WateringControllerHandler {

    private final String DEFAULT = "/csvfiles/rega_exemplo.csv";

    private final App app;
    private final WateringControllerParser parser;

    public WateringControllerHandler() {
        this.app = App.getInstance();
        this.parser = new WateringControllerParser();
    }

    private void load(List<String[]> data) {
        parser.parse(data);
    }


    public void loadDefault()
    throws IOException
    {
        load(CSVReader.readFromResources(DEFAULT, CSVHeader.NO_HEADER));
    }

    public void loadFile(File file)
    throws FileNotFoundException
    {
        load(CSVReader.readCSV(file, CSVHeader.NO_HEADER));
    }
}
