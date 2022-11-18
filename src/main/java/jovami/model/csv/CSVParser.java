package jovami.model.csv;

import java.util.List;

/**
 * CSVParser
 */
public interface CSVParser {

    public void parse(List<String[]> data);
}
