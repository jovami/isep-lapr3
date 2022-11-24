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
    public static final Comparator<Distance> cmp =
        Comparator.comparingInt(Distance::getDistance);

    /**
     * Joins two instances of {@code Distance} by adding up their
     * distance values and joining their location ids
     */
    public static final BinaryOperator<Distance> sum = Distance::new;

    private Distance(Distance d1, Distance d2) {
        this.locID1 = d1.locID1;
        this.locID2 = d2.locID2;
        this.distance = d1.distance + d2.distance;
    }

    public Distance(String locID1, String locID2, int distance) {
        this.locID1 = locID1;
        this.locID2 = locID2;
        this.distance = distance;
    }

    public String getLocID1() {
        return this.locID1;
    }

    public String getLocID2() {
        return this.locID2;
    }

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
