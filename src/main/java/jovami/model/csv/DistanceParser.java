package jovami.model.csv;

import java.util.List;

import jovami.App;

/**
 * DistanceParser
 */
public class DistanceParser implements CSVParser {

    private final App app;

    private static enum DistanceColumns {
        LOC_ID_1(0),
        LOC_ID_2(1),
        LENGTH(2);

        private final int col;

        DistanceColumns(int i) {
            this.col = i;
        }
    }

    public DistanceParser() {
        this.app = App.getInstance();
    }

    @Override
    public void parse(List<String[]> data) {
        data.forEach(line -> {
            String loc1, loc2;
            int length;

            loc1 = line[DistanceColumns.LOC_ID_1.col];
            loc2 = line[DistanceColumns.LOC_ID_2.col];

            try {
                length = Integer.parseInt(line[DistanceColumns.LENGTH.col]);
            } catch (NumberFormatException e) {
                // TODO: add custom exception class
                throw new RuntimeException("CSV File contained invalid coordinates!!");
            }

            app.distanceStore().addDistance(loc1, loc2, length);
        });
    }
}