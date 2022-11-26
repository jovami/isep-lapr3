package jovami.model;

import java.util.Objects;

import jovami.model.shared.UserType;
import jovami.util.Coordinate;

/**
 * User
 */
public class User {

    private String userID;
    private final UserType userType;
    private final Coordinate coords;
    private String locationID;

    public User(String userID, String locationID,
                double latitude, double longitude)
    {
        this.coords = new Coordinate(latitude, longitude);

        this.setLocationID(locationID);
        this.setUserID(userID);

        this.userType = UserType.getType(this.userID.charAt(0));

        if (this.userType == null)
            throw new IllegalArgumentException("Unknown UserType for ID: " + this.userID);
    }

    private void setLocationID(String locID) {
        Objects.requireNonNull(locID);
        if (locID.isEmpty())
            throw new IllegalArgumentException("Location ID cannot be empty!!");
        this.locationID = locID;
    }

    private void setUserID(String id) {
        Objects.requireNonNull(id);

        if (id.isEmpty())
            throw new IllegalArgumentException("User ID cannot be empty!!");
        this.userID = id;
    }

    //===================== Getters =====================//

    public String getUserID() {
        return this.userID;
    }

    public UserType getUserType() {
        return this.userType;
    }

    public Coordinate getCoords() {
        return new Coordinate(this.coords);
    }

    public String getLocationID() {
        return this.locationID;
    }
}
