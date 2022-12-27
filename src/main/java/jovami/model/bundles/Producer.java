package jovami.model.bundles;

import jovami.model.User;

public class Producer extends User {

    private Stock stock;

    public Producer(String userID, String locationID, double latitude, double longitude) {
        super(userID, locationID, latitude, longitude);
        stock = new Stock();
    }
}
