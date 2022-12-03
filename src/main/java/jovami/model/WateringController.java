package jovami.model;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.SortedSet;
import java.util.TreeSet;

import jovami.model.shared.WateringFrequency;
import jovami.util.Pair;
import jovami.util.Triplet;

/**
 * WateringController
 */
public class WateringController {


    public static final long MAX_DAYS = 30;

    private final LocalDate startedDate;
    private final LocalDate endDate;

    private final SortedSet<LocalTime> wateringHours;
    private final LinkedHashMap<String, Pair<Integer, WateringFrequency>> plotData;

    public WateringController() {
        this(2 << 4);
    }

    public WateringController(int expectedPlots) {
        this.startedDate = LocalDate.now();
        this.endDate = startedDate.plusDays(MAX_DAYS);

        this.wateringHours = new TreeSet<>(LocalTime::compareTo);
        this.plotData = new LinkedHashMap<>(expectedPlots);
    }

    //========================== Getters && Setters ========================//

    public boolean addWateringHour(LocalTime time) {
        Objects.requireNonNull(time);
        return this.wateringHours.add(time);
    }

    public boolean addWateringHours(Collection<LocalTime> times) {
        Objects.requireNonNull(times);
        if (times.isEmpty())
            return false;
        return this.wateringHours.addAll(times);
    }

    public boolean addPlotData(Triplet<String, Integer, WateringFrequency> data) {
        return this.addPlotData(data.first(), data.second(), data.third());
    }

    public boolean addPlotData(String plotID, int duration, WateringFrequency frequency) {
        Objects.requireNonNull(plotID);

        return this.plotData.putIfAbsent(plotID, new Pair<>(duration, frequency)) == null;
    }

    public LocalDate[] getValidRange() {
        return new LocalDate[] { this.startedDate, this.endDate };
    }

    //================================ Impl ================================//

    private Optional<LocalTime> previousWateringHour(LocalTime time) {
        try {
            return Optional.of(this.wateringHours.headSet(time).last());
        } catch (NullPointerException e) {
            return Optional.empty();
        }
    }

    public List<Pair<String, Long>> currentlyWatering() {
        LocalDateTime now = LocalDateTime.now();
        int dayOfMonth = now.getDayOfMonth();
        LocalTime nowTime = now.toLocalTime();

        if (now.toLocalDate().isAfter(this.endDate))
            throw new IllegalStateException(
                String.format("This WateringController expired at %s", this.endDate));

        var opt = previousWateringHour(nowTime);
        if (opt.isEmpty())
            return Collections.emptyList();

        LocalTime previous = opt.get();

        var plots = new LinkedList<Pair<String, Long>>();

        // TODO: check if this is really the better way of iterating
        var keys = this.plotData.keySet();
        for (var key : keys) {
            var pair = this.plotData.get(key);
            if (pair.second() == WateringFrequency.EVERYDAY     // always include 'EVERYDAY'
            || ((pair.second().i ^ dayOfMonth) & 1) == 0) {     // check if same parity
                /* We only want plots currently being watered so we need to check that
                 * (timeStarted + duration) is after nowTime; i.e., the difference is > 0
                 */
                long timeDiff = Duration.between(nowTime, previous.plusMinutes(pair.first()))
                                        .toMinutes();

                if (timeDiff > 0)
                    plots.add(new Pair<>(key, timeDiff));
            }
        }

        return plots;
    }
}
