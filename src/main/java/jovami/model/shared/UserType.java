package jovami.model.shared;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/**
 * UserType
 */
public enum UserType {

    PRODUCER('P'),
    CLIENT('C'),
    COMPANY('E');

    private static Map<Character, UserType> lookup;

    static {
        var values = UserType.values();
        lookup = new HashMap<>(values.length);
        for (var type : values)
            lookup.put(type.prefix, type);
        lookup = Collections.unmodifiableMap(lookup);
    }

    public final char prefix;

    public static UserType getType(char prefix) {
        return lookup.get(prefix);
    }

    UserType(char s) {
        this.prefix = s;
    }
}
