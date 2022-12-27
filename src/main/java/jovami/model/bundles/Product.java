package jovami.model.bundles;

public class Product{

    private String name;

    public Product(String name){
        setName(name);
    }

    public void setName(String name){
        this.name=name;
    }
    
    public String getNome(){
        return this.name;
    }
}