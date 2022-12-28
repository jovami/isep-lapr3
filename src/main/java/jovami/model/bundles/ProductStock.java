package jovami.model.bundles;

public class ProductStock {

    private final int day;
    private final Product product;
    private final float provided;
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
    
}
