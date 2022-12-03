package jovami.model.csv;

import java.util.List;

import jovami.App;
import jovami.model.exceptions.InvalidCSVFileException;

/**
 * UserParser
 */
public class UserParser implements CSVParser {

    private final App app;

    private static enum UserColumns {
        LOC_ID(0),
        LATITUDE(1),
        LONGITUDE(2),
        USER_ID(3);

        private int col;
        UserColumns(int col) {
            this.col = col;
        }
    }

    public UserParser() {
        app = App.getInstance();
    }

    @Override
    public void parse(List<String[]> data) {
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

            this.app.userStore().addUser(userID, locID, latitude, longitude);
        });
    }
}
