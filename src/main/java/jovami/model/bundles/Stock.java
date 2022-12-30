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
    public boolean retrieveFromStock(Product product, int day, float qntToRetrieve){
        if(qntToRetrieve < 0)
            return false;

        ProductStock prodStockForThatDay;
        int sum = 0;

        //ver para os ultimos dois dias se há stock
        for (int i = day-DELTA_DAYS; i <= day; i++) {
            if(i >= FIRST_DAY){
                //stock para um produto num determinado dia
                prodStockForThatDay = stock.get(i).get(product);

                if(prodStockForThatDay!=null){
                    sum+=prodStockForThatDay.getStash();
                    //apenas se houver uma quantidade suficiente nos ultimos dois dias e que retiramos do stock

                    if(sum>=qntToRetrieve){
                        for (int j = day-DELTA_DAYS; j <= i; j++) {
                            if(j >= FIRST_DAY) {
                                //stock para um produto num determinado dia
                                prodStockForThatDay = stock.get(j).get(product);

                                if (prodStockForThatDay != null) {
                                    if(prodStockForThatDay.retrieveStock(qntToRetrieve)){
                                        qntToRetrieve=0;
                                    }else{
                                        float stash = prodStockForThatDay.getStash();
                                        prodStockForThatDay.retrieveStock(stash);
                                        qntToRetrieve -= stash;
                                    }
                                }
                            }
                        }
                        break;
                    }
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