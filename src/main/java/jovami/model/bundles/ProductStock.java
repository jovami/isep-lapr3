package jovami.model.bundles;

public class ProductStock {
    // Esta classe presume que está a ser associada previamente a um produto

    //dia de registo
    private final int day;

    //produto a ser registado
    private final Product product;

    //quantidade que o produtor registou naquele dia para aquele produto
    private final float provided;

/*
    quantidade que ainda esta por ser usado(será atualizada ao decorrer do programa)
    começa com o valor max(valor igual ao stock inicialmente registado ) e irá ser atualizado ao longo do programa
    
    ex: produtor produziu 5
    
    INICIALMENTE:
        provided=5;
        stash=5

    CLIENTE FAZ PEDIDO DE 3:
        provided=5;
        stash=2;
    */
    private float stash;
    
    public ProductStock(Product product,float provided, int day){
        this.day = day;
        this.product = product;
        this.provided = provided;
        this.stash = provided;
    }

    public float getStash(){
        return this.stash;
    }

    public float getProvided(){
        return this.provided;
    }

    public int getDay(){
        return this.day;
    }

    public Product getProduct(){
        return this.product;        
    }

    public boolean retrieveStock(float retrieve){
        float delta = stash - retrieve;

        if(delta >= 0){
            this.stash-=retrieve;
            return true;
        }
        return false;
    }

    public ProductStock getCopy() {
        return new ProductStock(product, provided, day);
    }
    
}
