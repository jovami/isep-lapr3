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
    private User nearestHub;

    /**
     * Instantiates a new User.
     *
     * @param userID     the user id
     * @param locationID the location id
     * @param latitude   the latitude
     * @param longitude  the longitude
     */
    public User(String userID, String locationID,
                double latitude, double longitude)
    {
        this.coords = new Coordinate(latitude, longitude);

        this.setLocationID(locationID);
        this.setUserID(userID);

        this.userType = UserType.getType(this.userID.charAt(0));

        if (this.userType == null)
            throw new IllegalArgumentException("Unknown UserType for ID: " + this.userID);

        this.nearestHub = null;
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

    public void setNearestHub(User nearestHub){
        this.nearestHub = nearestHub;
    }

    //===================== Getters =====================//

    /**
     * Gets user id.
     *
     * @return the user id
     */
    public String getUserID() {
        return this.userID;
    }

    /**
     * Gets user type.
     *
     * @return the user type
     */
    public UserType getUserType() {
        return this.userType;
    }

    /**
     * Gets coords.
     *
     * @return the coords
     */
    public Coordinate getCoords() {
        return new Coordinate(this.coords);
    }

    /**
     * Gets location id.
     *
     * @return the location id
     */
    public String getLocationID() {
        return this.locationID;
    }

    public User getNearestHub() {
        return this.nearestHub;
    }
    //==================== Overrides ====================//

    @Override
    public int hashCode() {
        return Objects.hash(this.userID, this.coords, this.userType, this.locationID);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof User u))
            return false;

        return this.userID.equals(u.userID)
            && this.coords.equals(u.coords)
            && this.userType == u.userType
            && this.locationID.equals(u.locationID);
    }

    @Override
    public String toString() {
        return String.format("%s", this.userID);
    }
}
