package jovami.model.csv;

import java.util.List;

/**
 * CSVParser
 */
public interface CSVParser {

    /**
     * Parse.
     *
     * @param data the data
     */
    void parse(List<String[]> data);
}
