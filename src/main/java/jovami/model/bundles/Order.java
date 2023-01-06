package jovami.model.bundles;

import jovami.model.User;
import jovami.model.shared.DeliveryState;
import jovami.model.shared.UserType;

//pedido individual de um unico produto, presente nos cabazes
public class Order {

    //Produtor que vai fornecer aquele produto
    private User producer;

    //Produto pedido
    private final Product product;

    //Quantidade pedida
    private final float qntOrder;

    //Quantidade fornecida
    private float qntDelivered;

    //para saber se foi entregue(necessário para a us 311)
    private DeliveryState state;

    public Order(Product prod, float quantity){
        this.product = prod;
        this.qntOrder = quantity;
        this.producer = null;
        this.state = DeliveryState.NOT_SATISFIED;
    }

    private Order(Product prod, float quantity,User producer, DeliveryState state){
        this.product = prod;
        this.qntOrder = quantity;
        this.producer = producer;
        this.state = state;
    }

    //Overrides
    @Override
    public boolean equals(Object o){
        if(this == o)
            return true;
        if(!(o instanceof Order otherOrder))
            return false;
        return this.product == otherOrder.product
            && this.qntOrder == otherOrder.qntOrder
            && this.producer == otherOrder.producer
            && this.state == otherOrder.state;
    }

    @Override
    public String toString() {
        return String.format("%s (%.2fkg)", this.product, this.qntDelivered);
    }

    public Order getCopy(){
        return new Order(this.product, this.qntOrder, this.producer, this.state);
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
        return this.qntOrder;
    }

    public void setQntDelivered(float qntDelivered){

        if(qntDelivered>=qntOrder){
            this.qntDelivered = qntOrder;
            setState(DeliveryState.TOTALLY_SATISTFIED);
        }else{
            setState(DeliveryState.PARTIALLY_SATISFIED);
            this.qntDelivered=qntDelivered;

        }

    }

    public float getQuantityDelivered(){
        return this.qntDelivered;
    }

    public Product getProduct(){
        return this.product;
    }

    public void setState(DeliveryState state){
        this.state=state;
    }

    public DeliveryState getState(){
        return this.state;
    }


}
