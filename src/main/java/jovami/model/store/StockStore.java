package jovami.model.store;

import java.util.LinkedHashMap;
import java.util.Map.Entry;

import jovami.model.User;
import jovami.model.bundles.Stock;

public class StockStore {


    private final LinkedHashMap<User, Stock> stocks;

    public StockStore() {
        this(2 << 4);
    }


    public StockStore(LinkedHashMap<User, Stock> originStocks) {
        this(originStocks.size());
        //DEEP copy
        for (Entry<User, Stock> iterator : originStocks.entrySet()) {
            this.stocks.put(iterator.getKey(), iterator.getValue().getCopy());
        }
    }


    public StockStore(int initialCapacity) {
        this.stocks = new LinkedHashMap<>(initialCapacity);
    }

    public boolean addProducer(User producer) {
        if (existUser(producer))
            return false;
        else {
            stocks.put(producer, new Stock());
            return true;
        }
    }

    public boolean existUser(User producer) {
        return stocks.get(producer)!=null;

    }

    public LinkedHashMap<User,Stock> getStocks(){
        return this.stocks;
    }

    public Stock getStock(User producer){
        for (Entry<User,Stock> pair : stocks.entrySet()) {
            if (pair.getKey().equals(producer)){
                return pair.getValue();
            }
        }
        return null;
    }

    public StockStore getCopy() {
        return new StockStore(this.stocks);
    }

    public User getUser(Stock stockToFind) {

        for (Entry<User, Stock> keys : stocks.entrySet()) {
            if (keys.getValue().equals(stockToFind))
                return keys.getKey();
        }
        return null;
    }


}