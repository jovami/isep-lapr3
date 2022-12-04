package jovami.model.store;

import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Set;

import jovami.model.Distance;

/**
 * DistanceStore
 */
public class DistanceStore implements Iterable<Distance> {

    private final Set<Distance> distances;

    /**
     * Instantiates a new Distance store.
     */
    public DistanceStore() {
        this(2 << 4);
    }

    /**
     * Instantiates a new Distance store.
     *
     * @param initialCapacity the initial capacity
     */
    public DistanceStore(int initialCapacity) {
        this.distances = new LinkedHashSet<>(initialCapacity);
    }

    /**
     * Size int.
     *
     * @return the int
     */
    public int size() {
        return this.distances.size();
    }

    private boolean addDistance(Distance dist) {
        return this.distances.add(dist);
    }

    /**
     * Add distance boolean.
     *
     * @param orig     the orig
     * @param dest     the dest
     * @param distance the distance
     * @return the boolean
     */
    public boolean addDistance(String orig, String dest, int distance) {
        var dist = new Distance(orig, dest, distance);
        return this.addDistance(dist);
    }

    /**
     * Add distances boolean.
     *
     * @param dists the dists
     * @return the boolean
     */
    public boolean addDistances(Collection<Distance> dists) {
        return this.distances.addAll(dists);
    }

	@Override
	public Iterator<Distance> iterator() {
        return this.distances.iterator();
	}
}
