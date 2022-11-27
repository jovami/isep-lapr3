package jovami.model.store;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;

import jovami.model.WateringController;
import jovami.model.shared.WateringFrequency;
import jovami.util.Triplet;

/**
 * WateringControllerStore
 */
public class WateringControllerStore implements Iterable<WateringController> {

    private final LinkedHashMap<LocalDate, WateringController> store;

    public WateringControllerStore() {
        this(2 << 4);
    }

    public WateringControllerStore(int initialCapacity) {
        this.store = new LinkedHashMap<>(initialCapacity);
    }

    private boolean addController(WateringController ctrl) {
        return this.store.putIfAbsent(ctrl.getValidRange()[0], ctrl) == null;
    }

    public boolean addController(Collection<LocalTime> times,
            List<Triplet<String, Integer, WateringFrequency>> plotData)
    {
        var ctrl = new WateringController(plotData.size());

        ctrl.addWateringHours(times);
        plotData.forEach(ctrl::addPlotData);

        return this.addController(ctrl);
    }

    public int size() {
        return this.store.size();
    }

    public boolean clearExpired() {
        int oldSize = this.size();

        LocalDate now = LocalDate.now();

        /* NOTE: LinkedHashMap throws concurrency exception
         * when attempting to remove <K,V> pairs while iterating
         * so we have to resort to collecting the expired keys
         * and removing them after the map iteration
         */
        var expired = new ArrayList<LocalDate>();

        this.store.forEach((k, v) -> {
            if (v.getValidRange()[1].compareTo(now) >= 0)
                expired.add(k);
        });

        expired.forEach(this.store::remove);

        return this.size() != oldSize;
    }


    @Override
    public Iterator<WateringController> iterator() {
        return this.store.values().iterator();
    }


}
