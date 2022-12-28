package jovami.model.store;

import java.util.HashMap;

import jovami.model.User;
import jovami.model.bundles.Stock;
import jovami.model.shared.UserType;

public class StockStore {
    

    private final HashMap<User,Stock> stocks;

    public StockStore(){
        this(2 << 4);
    }

    public StockStore(int initialCapacity) {
        this.stocks = new HashMap<>(initialCapacity);
    }

    public boolean addProducer(User producer){
        return stocks.putIfAbsent(producer, new Stock()) == null;
    }

    public Stock getStock(User producer){
        return stocks.get(producer);
    }


}
