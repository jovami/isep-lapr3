package jovami.model.bundles;

import java.util.HashMap;
import java.util.Iterator;


public class Stock {
    public final static int DELTA_DAYS = 2;

    public final static int FIRST_DAY = 1;

    private final HashMap<Integer,HashMap<Product,ProductStock>> stock;

    public Stock(){
        stock = new HashMap<>( 2 << 4);
    }


    //retorna null caso não exista o dia
    public Iterator<ProductStock> getStocks(int day){
        if(stock.get(day)==null)
            return null;

        return stock.get(day).values().iterator();
    }
    
    //TODO how to handle product(string??)
    public void addProductStock(Product product,float provided,int day){
        stock.putIfAbsent(day, new HashMap<>(2 << 4));
        ProductStock ps = new ProductStock(product,provided,day);
        stock.get(day).putIfAbsent(product,ps);
        
    }

    //retorna true se houver stock suficiente contando com os ultimos dias
    public boolean retrieveFromStock(Product product, int day, int qntToRetrieve){

        if(qntToRetrieve < 0)
            return false;
        
        ProductStock prodStockForThatDay;

        //ver para os ultimos dois dias se há stock
        for (int i = day-DELTA_DAYS; i <= day; i++) {
            if(day >= FIRST_DAY){
                prodStockForThatDay = stock.get(i).get(product);

                if(!prodStockForThatDay.retrieveStock(qntToRetrieve)){
                    prodStockForThatDay.retrieveStock(prodStockForThatDay.getStash());
                    qntToRetrieve-=prodStockForThatDay.getStash();
                }
            }
        }
        
        return qntToRetrieve == 0;
    }
}

// ProductStock psi=stock.get(i).get(product);
// //check se a soma dos ultimos dias chega
// sum+=psi.getStash();

// //assim que a soma dos stocks existentes for suficiente para concluir qntToRetrieve
// if (sum>= qntToRetrieve){
// for (int j = day-2; j <= i; i++) {

// }
    // }
    //testes
    //System.out.printf("qntToRetrieve Should be 0, and sum qntToRetrieve must be equal or greater to qntToRetrieve\nqntToRetrieve: %i\nSum: %i\nqntToRetrieve:%i",qntToRetrieve,sum,qntToRetrieve);