package jovami.model.bundles;

import jovami.model.User;
import jovami.model.exceptions.InvalidUserTypeException;
import jovami.model.shared.UserType;

public class Order {
    
    private Producer producer;
    private Product product;
    private float quantity;
    private boolean delivered;

    public Order(Product prod, float quantity){
        this.product = prod;
        this.quantity = quantity;
        this.producer = null;
    }

    public void setProducer(Producer producer){
        //catch users that are not producers
        if(producer.getUserType()!=UserType.PRODUCER)
            throw new InvalidUserTypeException();
        this.producer=producer;
    }

    public User getProducer(){
        return this.producer;
    }

    public float getQuantity(){
        return this.quantity;
    }
    
    public boolean doesFullfill(float quantityToCompare){
        return this.quantity <= quantityToCompare;
    }
    
    public Product getProduct(){
        return this.product;
    }

    public void setDelivered(){
        this.delivered=true;
    }

    public Boolean isDelivered(){
        return this.delivered;
    }


}
