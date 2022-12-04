package jovami.model.csv;

import java.util.List;

import jovami.App;
import jovami.model.exceptions.InvalidCSVFileException;

/**
 * DistanceParser
 */
public class DistanceParser implements CSVParser {

    private final App app;

    private enum DistanceColumns {
        LOC_ID_1(0),
        LOC_ID_2(1),
        LENGTH(2);

        private final int col;

        DistanceColumns(int i) {
            this.col = i;
        }
    }

    /**
     * Instantiates a new Distance parser.
     */
    public DistanceParser() {
        this.app = App.getInstance();
    }

    /**
     * @param data the data
     */
    @Override
    public void parse(List<String[]> data) {
        // O(l); l => lines of the file
        data.forEach(line -> {
            String loc1, loc2;
            int length;

            loc1 = line[DistanceColumns.LOC_ID_1.col];
            loc2 = line[DistanceColumns.LOC_ID_2.col];

            try {
                length = Integer.parseUnsignedInt(line[DistanceColumns.LENGTH.col]);
            } catch (NumberFormatException e) {
                throw new InvalidCSVFileException("CSV File contained an invalid length!!");
            }

            // O(1)
            app.distanceStore().addDistance(loc1, loc2, length);
        });

        // Net Complexity: O(l)
    }
}
