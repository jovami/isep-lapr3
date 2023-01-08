package jovami.model.store;

import java.util.EnumMap;
import java.util.Map;

import jovami.model.bundles.ExpList;

public class ExpListStore {

    public enum Restriction {
        NONE {
            @Override
            public String toString() {
                return "No Restrictions";
            }
        },
        PRODUCERS {
            @Override
            public String toString() {
                return "N closest producers to hub";
            }
        };

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


    public void addExpList(Restriction r, ExpList expList) {
        this.listExp.put(r, expList);
    }

    public void addExpListNoRestrict(ExpList expList) {
        this.addExpList(Restriction.NONE, expList);
    }

    public void addExpListProdRestrict(ExpList expList) {
        this.addExpList(Restriction.PRODUCERS, expList);
    }
}
