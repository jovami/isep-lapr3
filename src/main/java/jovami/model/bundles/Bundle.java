package jovami.model.bundles;

import java.util.ArrayList;
import java.util.Iterator;

import jovami.model.User;
import jovami.model.shared.DeliverieState;
import jovami.model.shared.UserType;

//Cabazes
public class Bundle {

    // dia em que o cabaz foi pedido
    private int day;
    
    // cliente que encomendou o cabaz
    private User client;
    
    // TODO usar um set?(previne pedidos iguais para o mesmo cabaz)
    //Lista de todos os pedidos
    private ArrayList<Order> orders;
    
    //TODO needed?? uma vez que todas as encomendas sao expedidas no mesmo dia, caso estejam ou nao completas
    // para saber se o cabaz foi entregue
    private DeliverieState state;


    //Constructors
    public Bundle(User client, int day){
        this.orders = new ArrayList<>(2 << 4);
        if(setClient(client)){
            setDay(day);
            state=DeliverieState.NOT_SATISFIED;
        }
    }

    //Constructors for copy
    public Bundle(User client, int day,ArrayList<Order> orders,DeliverieState state){
        this(client,day);

        for (Order copyOrder : orders) {
            this.orders.add(copyOrder.getCopy());
        }
        
        this.state=state;
        
    }
        
    public Bundle getCopy(){
        return new Bundle(this.client,this.day,this.orders,this.state);
    }

    //SETS
    private boolean setClient(User client){
        if(client.getUserType()==UserType.CLIENT || client.getUserType()==UserType.COMPANY){
            this.client = client;
            return true;
        }
        return false;
    }

    public void setState(DeliverieState state){
        this.state = state;
    }

    private void setDay(int day){
        this.day=day;
    }

    //GETTERS
    public Iterator<Order> getOrders(){
        return orders.iterator();
    }

    public ArrayList<Order> getOrdersList(){return orders;}

    public int getDay() {
        return this.day;
    }

    public User getClient() {
        return this.client;
    }

    public DeliverieState getState(){

        int fully = 0;
        int notSatisfied = 0;
        
        for (Order iter : orders) {
            if(iter.getState()==DeliverieState.NOT_SATISFIED)
                notSatisfied++;

            if(iter.getState()==DeliverieState.TOTALLY_SATISTFIED)
                fully++;
        }

        if(fully==orders.size()){
            return DeliverieState.TOTALLY_SATISTFIED;
        }else if(notSatisfied == orders.size()){
            return DeliverieState.NOT_SATISFIED;
        }

        return DeliverieState.PARTIALLY_SATISFIED;
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
        return String.format("Client: %s\nDay: %d\nDelivered: %s\n--------------\n%s\n ",this.client,this.day,this.state,this.orders.toString());
    }

}