package jovami.model.store;

import java.util.HashMap;

import jovami.model.bundles.ExpList;

public class ExpListStore {

    private final int EXP_NO_RESTRICTIONS = 0;
    private final int EXP_PROD_RESTRICTIONS = 1;

    private final HashMap<Integer, ExpList> listExp;

    public ExpListStore(){
        listExp=new HashMap<Integer,ExpList>(2<<4);
    }

    //TODO MELHORAR ISTO
    public ExpList getExp(int i){
        return listExp.get(i);
    }
    
    public void addExpListNoRestrict(ExpList expList){
        listExp.put(EXP_NO_RESTRICTIONS,expList);
    }    
 
    public void addExpListProdRestrict(ExpList expList){
        listExp.put(EXP_PROD_RESTRICTIONS,expList);
    }    
 
}