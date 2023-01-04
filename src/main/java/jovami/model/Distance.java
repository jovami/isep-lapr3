package jovami.model;

import java.util.Comparator;
import java.util.Objects;
import java.util.function.BinaryOperator;

/**
 * Distance
 */
public class Distance {

    private final String locID1;
    private final String locID2;
    private final int distance;

    /**
     * Compares two instances of {@code Distance} using their distance value
     */
    public static final Comparator<Distance> cmp;

    /**
     * Joins two instances of {@code Distance} by adding up their
     * distance values and joining their location ids
     */
    public static final BinaryOperator<Distance> sum;

    /**
     * The constant zero.
     */
    public static final Distance zero;

    static {
        zero = new Distance(null, null, 0);
        cmp = Comparator.nullsLast(Comparator.comparingInt(Distance::getDistance));
        sum = Distance::new;
    }

    private Distance(Distance d1, Distance d2) {
        Objects.requireNonNull(d1);
        Objects.requireNonNull(d2);

        if (d1.locID1 == null && d1.locID2 == null) {
            this.locID1 = d2.locID1;
            this.locID2 = d2.locID2;
            this.distance = d2.distance;
        } else if (d2.locID1 == null && d2.locID2 == null) {
            this.locID1 = d1.locID1;
            this.locID2 = d1.locID2;
            this.distance = d1.distance;
        } else {
            this.locID1 = d1.locID1;
            this.locID2 = d2.locID2;
            this.distance = d1.distance + d2.distance;
        }
    }

    /**
     * Instantiates a new Distance.
     *
     * @param locID1   the loc id 1
     * @param locID2   the loc id 2
     * @param distance the distance
     */
    public Distance(String locID1, String locID2, int distance) {
        this.locID1 = locID1;
        this.locID2 = locID2;
        this.distance = distance;
    }

    /**
     * Reverse distance.
     *
     * @param d the d
     * @return the distance
     */
    public static Distance reverse(Distance d) {
        return d.reverse();
    }

    /**
     * Reverse distance.
     *
     * @return the distance
     */
    public Distance reverse() {
        return new Distance(this.locID2, this.locID1, this.distance);
    }

    /**
     * Gets loc id 1.
     *
     * @return the loc id 1
     */
    public String getLocID1() {
        return this.locID1;
    }

    /**
     * Gets loc id 2.
     *
     * @return the loc id 2
     */
    public String getLocID2() {
        return this.locID2;
    }

    /**
     * Gets distance.
     *
     * @return the distance
     */
    public int getDistance() {
        return this.distance;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof Distance dist))
            return false;

        return this.locID1.equals(dist.locID1)
            && this.locID2.equals(dist.locID2)
            && this.distance == dist.distance;
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.locID1, this.locID2, this.distance);
    }

    @Override
    public String toString() {
        return String.format("%s -> %s: %d", this.locID1, this.locID2, this.distance);
    }
}
