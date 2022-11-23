package jovami.model;

import java.awt.geom.Point2D;

/**
 * Coordinate
 */
public final class Coordinate extends Point2D {

    public static final double MAX_LAT = 90.0;
    public static final double MIN_LAT = -MAX_LAT;

    public static final double MAX_LON = 180.0;
    public static final double MIN_LON = -MAX_LON;

    private double latitude;
	private double longitude;

    public Coordinate(double latitude, double longitude) {
        this.setLocation(latitude, longitude);
    }

    public Coordinate(Coordinate other) {
        this(other.latitude, other.longitude);
    }

    public double getLatitude() {
        return this.latitude;
    }

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
