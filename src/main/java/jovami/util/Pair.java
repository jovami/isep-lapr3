package jovami.util;

/**
 * Pair
 * Simple storage record to temporarily
 * save related objects
 */
public record Pair<T, S>(T first, S second) {

    @Override
    public String toString() {
        return String.format("<%s, %s>", first, second);
    }
}
