package jovami.model.bundles;

import java.util.ArrayList;
import java.util.Iterator;

import jovami.model.User;
import jovami.model.shared.DeliveryState;
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
    private DeliveryState state;


    //Constructors
    public Bundle(User client, int day){
        this.orders = new ArrayList<>(2 << 4);
        if(setClient(client)){
            setDay(day);
            state=DeliveryState.NOT_SATISFIED;
        }
    }

    //Constructors for copy
    public Bundle(User client, int day,ArrayList<Order> orders,DeliveryState state){
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

    public void setState(DeliveryState state){
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

    public DeliveryState getState(){

        int fully = 0;
        int notSatisfied = 0;
        if(orders.size()!=0){

            for (Order iter : orders) {
                if(iter.getState()==DeliveryState.NOT_SATISFIED)
                notSatisfied++;

                if(iter.getState()==DeliveryState.TOTALLY_SATISTFIED)
                    fully++;
            }

            if(fully==orders.size()){
                return DeliveryState.TOTALLY_SATISTFIED;
            }else if(notSatisfied == orders.size()){
                return DeliveryState.NOT_SATISFIED;
            }
            return DeliveryState.PARTIALLY_SATISFIED;
        }
        return DeliveryState.NOT_SATISFIED;

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