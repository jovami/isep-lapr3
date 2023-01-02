package jovami.model.bundles;

import jovami.model.User;
import jovami.model.shared.UserType;

//pedido individual de um unico produto, presente nos cabazes
public class Order {
    
    //Produtor que vai fornecer aquele produto
    private User producer;

    //Produto pedido
    private Product product;

    //Quantidade pedida
    private float quantity;

    //para saber se foi entregue(necessário para a us 311)
    private boolean delivered;

    public Order(Product prod, float quantity){
        this.product = prod;
        this.quantity = quantity;
        this.producer = null;
        this.delivered = false;
    }

    private Order(Product prod, float quantity,User producer, boolean deliv){
        this.product = prod;
        this.quantity = quantity;
        this.producer = producer;
        this.delivered = deliv;
    }

    //Overrides
    @Override
    public boolean equals(Object o){
        if(this == o)
            return true;
        if(!(o instanceof Order otherOrder))
            return false;
        return this.product == otherOrder.product
            && this.quantity == otherOrder.quantity
            && this.producer == otherOrder.producer
            && this.delivered == otherOrder.delivered;
    }

    public Order getCopy(){
        return new Order(this.product, this.quantity, this.producer, this.delivered);
    }

    public boolean setProducer(User producer){
        //catch users that are not producers
        if(producer.getUserType()==UserType.PRODUCER){   
            this.producer=producer;
            return true;
        }else
            return false;
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
