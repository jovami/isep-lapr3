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

    public DistanceStore() {
        this(2 << 4);
    }

    public DistanceStore(int initialCapacity) {
        this.distances = new LinkedHashSet<>(initialCapacity);
    }

    private boolean addDistance(Distance dist) {
        return this.distances.add(dist);
    }

    public boolean addDistance(String orig, String dest, int distance) {
        var dist = new Distance(orig, dest, distance);
        return this.addDistance(dist);
    }

    public boolean addDistances(Collection<Distance> dists) {
        return this.distances.addAll(dists);
    }

	@Override
	public Iterator<Distance> iterator() {
        return this.distances.iterator();
	}
}
