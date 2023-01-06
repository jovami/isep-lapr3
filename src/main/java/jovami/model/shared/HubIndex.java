package jovami.model.shared;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/*
    HUB
    * nº de clientes distintos que recolhem cabazes em cada hub
    * nº de produtores distintos que fornecem cabazes para o hub.
*/
public enum HubIndex {
    
    DIF_CLIENTS(0),
    DIF_PRODUCERS(1);

    private static Map<Integer, HubIndex> lookup;

    static {
        var values = HubIndex.values();
        lookup = new HashMap<>(values.length);
        for (var type : values)
            lookup.put(type.prefix, type);
        lookup = Collections.unmodifiableMap(lookup);
    }

    public final int prefix;
    
    public int getPrefix(){
        return prefix;
    }


    public static HubIndex getType(int prefix) {
        return lookup.get(prefix);
    }

    HubIndex(int i) {
        this.prefix = i;
    }
}
