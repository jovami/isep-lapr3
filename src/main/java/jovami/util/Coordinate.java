package jovami.util;

import java.awt.geom.Point2D;

/**
 * Coordinate
 */
public final class Coordinate extends Point2D {

    /**
     * The constant MAX_LAT.
     */
    public static final double MAX_LAT = 90.0;
    /**
     * The constant MIN_LAT.
     */
    public static final double MIN_LAT = -MAX_LAT;

    /**
     * The constant MAX_LON.
     */
    public static final double MAX_LON = 180.0;
    /**
     * The constant MIN_LON.
     */
    public static final double MIN_LON = -MAX_LON;

    private double latitude;
	private double longitude;

    /**
     * Instantiates a new Coordinate.
     *
     * @param latitude  the latitude
     * @param longitude the longitude
     */
    public Coordinate(double latitude, double longitude) {
        this.setLocation(latitude, longitude);
    }

    /**
     * Instantiates a new Coordinate.
     *
     * @param other the other
     */
    public Coordinate(Coordinate other) {
        this(other.latitude, other.longitude);
    }

    /**
     * Gets latitude.
     *
     * @return the latitude
     */
    public double getLatitude() {
        return this.latitude;
    }

    /**
     * Gets longitude.
     *
     * @return the longitude
     */
    public double getLongitude() {
        return this.longitude;
    }

    private boolean validLatitude(double lat) {
        return java.lang.Double.compare(lat, MAX_LAT) <= 0
            && java.lang.Double.compare(lat, MIN_LAT) >= 0;
    }

    private boolean validLongitude(double lon) {
        return java.lang.Double.compare(lon, MAX_LON) <= 0
            && java.lang.Double.compare(lon, MIN_LON) >= 0;
    }

    @Override
    public void setLocation(double latitude, double longitude) {
        if (!validLatitude(latitude) || !validLongitude(longitude))
            throw new IllegalArgumentException(
                String.format("Invalid longitude/latitude: %f/%f", latitude, longitude));

        this.latitude = latitude;
        this.longitude = longitude;
    }

    @Override
    public double getX() {
        return this.getLongitude();
    }

    @Override
    public double getY() {
        return this.getLatitude();
    }

    @Override
    public String toString() {
        return String.format("Coordinates: %.2f°%c; %.2f°%c",
                this.latitude, this.latitude >= 0 ? 'N' : 'S',
                this.longitude, this.longitude >= 0 ? 'E' : 'W');
    }
}
