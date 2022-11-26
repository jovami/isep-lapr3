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

    public UserStore() {
        this(1 << 4);
    }

    public UserStore(int initialCapacity) {
        this.users = new LinkedHashMap<>(initialCapacity);
    }

    private boolean addUser(User user) {
        return this.users.putIfAbsent(user.getLocationID(), user) == null;
    }

    public boolean addUser(String userID, String locationID,
                           double latitude, double longitude)
    {
        var user = new User(userID, locationID, latitude, longitude);
        return this.addUser(user);
    }

    public Optional<User> getUser(String key) {
        return Optional.ofNullable(this.users.get(key));
    }

    @Override
    public Iterator<User> iterator() {
        return this.users.values().iterator();
    }
}
