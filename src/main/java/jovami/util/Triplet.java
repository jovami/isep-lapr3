package jovami.util;

/**
 * Triplet
 * Simple storage record to temporarily
 * save related objects
 */
public record Triplet<T, S, U>(T first, S second, U third) {

    @Override
    public String toString() {
        return String.format("<%s, %s, %s>", first, second, third);
    }
}
