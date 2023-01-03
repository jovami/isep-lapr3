package jovami.model.store;

import java.util.ArrayList;
import java.util.HashMap;

import jovami.App;
import jovami.model.bundles.ExpList;

public class ExpListStore {

    private final int EXP_NO_RESTRICTIONS = 0;
    private final int EXP_PROD_RESTRICTIONS = 1;

    private final HashMap<Integer, ExpList> listExp;

    public ExpListStore(){
        listExp=new HashMap<Integer,ExpList>(2<<4);
    }
    
    
    // public void ExpListStorae(){
    //     this(originStocks.size());
    //     //DEEP copy
    //     for (Pair<User,Stock>iterator : originStocks) {
    //         this.stocks.add(new Pair<User,Stock>(iterator.first(), iterator.second().getCopy()));
    //     }
    // }
    public void addExpListNoRestrict(ExpList expList){
        listExp.put(EXP_NO_RESTRICTIONS,expList);
    }    
 
    public void addExpListProdRestrict(ExpList expList){
        listExp.put(EXP_PROD_RESTRICTIONS,expList);
    }    
 
}