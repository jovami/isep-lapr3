package jovami.model.csv;

import java.util.List;

import jovami.App;
import jovami.model.exceptions.InvalidCSVFileException;

/**
 * UserParser
 */
public class UserParser implements CSVParser {

    private final App app;

    private enum UserColumns {
        LOC_ID(0),
        LATITUDE(1),
        LONGITUDE(2),
        USER_ID(3);

        private final int col;
        UserColumns(int col) {
            this.col = col;
        }
    }

    public UserParser() {
        app = App.getInstance();
    }

    /**
     * @param data the data
     */
    @Override
    public void parse(List<String[]> data) {
        // O(l); l => lines of the file
        data.forEach(line -> {
            String locID, userID;
            double latitude, longitude;

            locID = line[UserColumns.LOC_ID.col];

            try {
                latitude = Double.parseDouble(line[UserColumns.LATITUDE.col]);
                longitude = Double.parseDouble(line[UserColumns.LONGITUDE.col]);
            } catch (NumberFormatException e) {
                throw new InvalidCSVFileException("CSV File contained invalid coordinates!!");
            }

            userID = line[UserColumns.USER_ID.col];

            // O(1)
            this.app.userStore().addUser(userID, locID, latitude, longitude);
        });

        // Net Complexity: O(l)
    }
}
