package jovami.model.csv;

import java.util.List;

/**
 * CSVParser
 */
public interface CSVParser {

    void parse(List<String[]> data);
}
