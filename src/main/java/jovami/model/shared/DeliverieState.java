package jovami.model.shared;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public enum DeliverieState {
 
    TOTALLY_SATISTFIED(0),
    PARTIALLY_SATISFIED(1),
    NOT_SATISFIED(2);

    private static Map<Integer, DeliverieState> lookup;

    static {
        var values = DeliverieState.values();
        lookup = new HashMap<>(values.length);
        for (var type : values)
            lookup.put(type.prefix, type);
        lookup = Collections.unmodifiableMap(lookup);
    }

    public final int prefix;

    public static DeliverieState getType(int prefix) {
        return lookup.get(prefix);
    }

    DeliverieState(int i) {
        this.prefix = i;
    }
}

