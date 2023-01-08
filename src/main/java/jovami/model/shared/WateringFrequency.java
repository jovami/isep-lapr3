package jovami.model.shared;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * WateringFrequency
 */
public enum WateringFrequency {

    EVERYDAY(0, 't'),
    ODD_DAYS(1, 'i'),
    EVEN_DAYS(2, 'p');

    private static Map<Character, WateringFrequency> lookup;

    static {
        var values = WateringFrequency.values();
        lookup = new HashMap<>(values.length);
        for (var freq : values)
            lookup.put(freq.abbrev, freq);
        lookup = Collections.unmodifiableMap(lookup);
    }


    public final int i;
    private final char abbrev;

    public static WateringFrequency getFrequency(char abbrev) {
        var freq = lookup.get(abbrev);
        if (freq == null)
            throw new IllegalArgumentException("Unkown enum value");
        return freq;
    }

    WateringFrequency(int i, char c) {
        this.i = i;
        this.abbrev = c;
    }
}
