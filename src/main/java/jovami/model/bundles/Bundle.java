package jovami.model.bundles;

import java.util.ArrayList;
import java.util.Iterator;

import jovami.model.User;
import jovami.model.shared.UserType;

public class Bundle {

    // dias sao dados como
    private int day;
    
    // cliente que encomendou o cabaz
    private User client;
    
    // lista de pedidos(produtor, quantidade e produto)
    // TODO usar um set?(previne pedidos iguais para o mesmo cabaz)
    private ArrayList<Order> orders;
    
    //TODO needed?? uma vez que todas as encomendas sao expedidas no mesmo dia, caso estejam ou nao completas
    // entregue
    private boolean delivered;

    //Constructors
    private Bundle(User client, int day){
        this.orders = new ArrayList<>(2 << 4);
        if(setClient(client)){
            setDay(day);
            delivered = false;
        }
    }

    //SETS
    private boolean setClient(User client){
        if(client.getUserType()==UserType.CLIENT || client.getUserType()==UserType.COMPANY){
            this.client = client;
            return true;
        }
        return false;
    }

    public void setDelivered(){
        this.delivered=true;
    }

    private void setDay(int day){
        this.day=day;
    }

    //GETTERS
    public Iterator<Order> getOrders(){
        return orders.iterator();
    }

    public int getDay() {
        return this.day;
    }
    public boolean isDelivered(){
        return this.delivered;
    }


    //Orders handlers

    //TODO set orders delivered


    public boolean addNewOrder(Product product,float quantity) {
        return this.orders.add(new Order(product, quantity));
    }


    //Overrides
    @Override
    public boolean equals(Object o){
        if(this == o)
            return true;
        if(!(o instanceof Bundle otherBundle))
            return false;
        return this.day == otherBundle.day 
            && this.client == otherBundle.client 
            && this.orders.equals(otherBundle.orders);
    }

    @Override 
    public String toString(){
        return String.format("Cliente: %s\nDay: %i\nDelivered:\n--------------\n%s\n ",this.client,this.day,this.orders.toString(),this.delivered);
    }
}