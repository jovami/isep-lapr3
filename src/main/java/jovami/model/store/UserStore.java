package jovami.model.store;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import jovami.model.User;

/**
 * UserStore
 */
public class UserStore implements Iterable<User> {

    private final Map<String, User> users;

    public UserStore() {
        this(2 << 4);
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

    @Override
    public Iterator<User> iterator() {
        return this.users.values().iterator();
    }
}
