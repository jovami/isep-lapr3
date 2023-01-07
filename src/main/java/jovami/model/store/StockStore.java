package jovami.model.store;

import java.util.ArrayList;

import jovami.model.User;
import jovami.model.bundles.Stock;
import jovami.util.Pair;

public class StockStore {


    private final ArrayList<Pair<User, Stock>> stocks;

    public StockStore() {
        this(2 << 4);
    }


    public StockStore(ArrayList<Pair<User, Stock>> originStocks) {
        this(originStocks.size());
        //DEEP copy
        for (Pair<User, Stock> iterator : originStocks) {
            this.stocks.add(new Pair<>(iterator.first(), iterator.second().getCopy()));
        }
    }


    public StockStore(int initialCapacity) {
        this.stocks = new ArrayList<>(initialCapacity);
    }

    public boolean addProducer(User producer) {
        if (existUser(producer))
            return false;
        else {
            stocks.add(new Pair<>(producer, new Stock()));
            return true;
        }
    }

    public boolean existUser(User producer) {
        for (Pair<User, Stock> pair : this.stocks) {
            if (pair.first().equals(producer)) {
                return true;
            }
        }
        return false;

    }

    public Stock getStock(User producer) {
        for (Pair<User, Stock> pair : stocks) {
            if (pair.first().equals(producer)) {
                return pair.second();
            }
        }
        return null;
    }

    public StockStore getCopy() {
        return new StockStore(this.stocks);
    }

    public User getUser(Stock stockToFind) {
        //todo clean
        for (Pair<User, Stock> keys : stocks) {
            if (keys.second().equals(stockToFind))
                return keys.first();
        }
        return null;
    }


}
