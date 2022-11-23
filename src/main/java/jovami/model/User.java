package jovami.model;

import java.util.Objects;

import org.apache.commons.lang3.StringUtils;

import jovami.model.shared.UserType;

/**
 * User
 */
public class User {

    private String userID;
    private final UserType userType;
    private final Coordinate coords;
    private String locationID;

    public User(String userID, UserType type, String locationID,
                double latitude, double longitude)
    {
        // Null checks
        Objects.requireNonNull(type);

        this.userType = type;
        this.coords = new Coordinate(latitude, longitude);

        this.setLocationID(locationID);
        this.setUserID(userID);
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
        else if (id.charAt(0) != this.userType.prefix)
            throw new IllegalArgumentException(
                String.format(
                    "User ID does not match the user type!! Expected: %s",
                    StringUtils.capitalize(this.userType.name())));

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
