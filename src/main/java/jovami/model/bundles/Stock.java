package jovami.model.bundles;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;


public class Stock {
    //este stock está dentro de um produtor 
    //numero de dias que temos de considerar que um produto é válido
    public final static int DELTA_DAYS = 2;

    //Valor do primeiro dia (evitar os "numeros mágicos")
    public final static int FIRST_DAY = 1;

    //Estrutura de dados que gere todos os stock de um produto para um determinado
    // Chave1 -> cada um dos dias corresponde a outro hashMap,
    // Chave2 ->  chave é o Produto, e o valor correspondente é o stock do produto

    //Interpretação
    //naquele dia(chave1) e para aquele produto(chave 2) temos um Product stock
    private final HashMap<Product,HashMap<Integer,ProductStock>> stock;

    public Stock(){
        this(2 << 4);
    }
    public Stock(int initialCapacity){
        stock = new HashMap<>( initialCapacity);
    }
    
    public Stock(HashMap<Product,HashMap<Integer,ProductStock>> originStock){
        this(originStock.size());

        for (Entry<Product,HashMap<Integer,ProductStock>> allStock  : originStock.entrySet()) {
            this.stock.put(allStock.getKey(),new HashMap<Integer,ProductStock>());

            for (Entry<Integer,ProductStock> dayStock : allStock.getValue().entrySet()) {

                this.stock.get(allStock.getKey()).put(dayStock.getKey(),dayStock.getValue().getCopy());
            }
        }
        // //TODO: optimize using streams??
        // this.stock = stock.entrySet().stream().collect(Collectors.toMap(
        //     e -> e.getKey(), e -> this.stock.get(e.getKey()).entrySet().stream().collect(
        //         Collectors.toMap(j -> j.getKey(), j-> j.getValue()))));
        
    }

    //Interpretação
    //naquele dia(chave1) e para aquele produto(chave 2) temos um Product stock
    public Stock getCopy(){
        return new Stock(this.stock);
    } 


    //retorna null caso não exista o dia
    public ArrayList<ProductStock> getStocks(int day) {
        ArrayList<ProductStock> array=new ArrayList<>();
        for (Entry<Product,HashMap<Integer,ProductStock>>productStock : this.stock.entrySet()) {
            array.add(productStock.getValue().get(day));
            
        }

        return array;
    }

    //TODO how to handle product(string??)
    public void addProductStock(Product product, float provided, int day) {
        stock.putIfAbsent(product, new HashMap<>(2 << 4));
        ProductStock ps = new ProductStock(product, provided, day);
        stock.get(product).putIfAbsent(day, ps);

    }

    //retorna true se houver stock suficiente contando com os ultimos dias
    public float getStashAvailable(Product product, int day) {

        HashMap<Integer,ProductStock> tmp= stock.get(product);

        ProductStock prodStockForThatDay;
        float sumStash = 0;

        //ver para os ultimos dois dias se há stock
        if(tmp!=null){
            for (int i = day-DELTA_DAYS; i <= day; i++) {
                if(i >= FIRST_DAY){
                    //stock para um produto num determinado dia
                    prodStockForThatDay = tmp.get(i);

                    if(prodStockForThatDay!=null){
                        sumStash+=prodStockForThatDay.getStash();
                        //apenas se houver uma quantidade suficiente nos ultimos dois dias e que retiramos do stock
                    }
                }
            }
        }
        return  sumStash;
    }


    public float retrieveFromStock(int day, Product product, float qntToRetrieve) {
        
        HashMap<Integer,ProductStock> tmp = stock.get(product);
        ProductStock prodStockForThatDay;

        float missingToRetrieve=qntToRetrieve;

        for (int j = day - DELTA_DAYS; j <= day; j++) {
            if (j >= FIRST_DAY) {
                // stock para um produto num determinado dia
                prodStockForThatDay = tmp.get(j);

                if (prodStockForThatDay != null) {
                    if (prodStockForThatDay.retrieveStock(missingToRetrieve)) {
                        missingToRetrieve = 0;
                    } else {
                        float stash = prodStockForThatDay.getStash();
                        prodStockForThatDay.retrieveStock(stash);
                        missingToRetrieve -= stash;
                    }
                }
            }
        }

        return missingToRetrieve;
    }

    public HashMap<Product,HashMap<Integer,ProductStock>> getProductStock() {
        return this.stock;
    }
}
