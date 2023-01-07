package jovami.model.store;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

import jovami.model.User;

/**
 * UserStore
 */
public class UserStore implements Iterable<User> {

    private final Map<String, User> users;

    /**
     * Instantiates a new User store.
     */
    public UserStore() {
        this(1 << 4);
    }

    /**
     * Instantiates a new User store.
     *
     * @param initialCapacity the initial capacity
     */
    public UserStore(int initialCapacity) {
        this.users = new LinkedHashMap<>(initialCapacity);
    }

    /**
     * Size int.
     *
     * @return the int
     */
    public int size() {
        return this.users.size();
    }

    private boolean addUser(User user) {
        return this.users.putIfAbsent(user.getLocationID(), user) == null;
    }

    /**
     * Add user boolean.
     *
     * @param userID     the user id
     * @param locationID the location id
     * @param latitude   the latitude
     * @param longitude  the longitude
     * @return the boolean
     */
    public boolean addUser(String userID, String locationID,
                           double latitude, double longitude) {
        var user = new User(userID, locationID, latitude, longitude);
        return this.addUser(user);
    }

    /**
     * Gets user.
     *
     * @param key the key
     * @return the user
     */
    public Optional<User> getUser(String key) {
        return Optional.ofNullable(this.users.get(key));
    }

    public Optional<User> getUserByID(String id) {
        for (User user : users.values()) {
            if (user.getUserID().equals(id))
                return Optional.of(user);
        }
        return Optional.empty();
    }

    @Override
    public Iterator<User> iterator() {
        return this.users.values().iterator();
    }
}
