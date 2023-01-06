package jovami.model.store;

import java.util.EnumMap;
import java.util.Map;

import jovami.model.bundles.ExpList;

public class ExpListStore {

    public static enum Restriction {
        NONE,
        PRODUCERS;

        Restriction() {
        }
    }

    private final Map<Restriction, ExpList> listExp;

    public ExpListStore() {
        this.listExp = new EnumMap<>(Restriction.class);
    }

    public ExpList getExpList(Restriction r) {
        return this.listExp.get(r);
    }

    public ExpList getExpList() {
        return this.getExpList(Restriction.NONE);
    }


    public void addExpListNoRestrict(ExpList expList) {
        listExp.put(Restriction.NONE, expList);
    }

    public void addExpListProdRestrict(ExpList expList) {
        listExp.put(Restriction.PRODUCERS, expList);
    }
}
