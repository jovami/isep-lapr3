package jovami.model.shared;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/* 
    CLIENT
    * nº de cabazes totalmente satisfeitos
    * nº de cabazes parcialmente satisfeitos
    * nºde fornecedores distintos que forneceram todos os seus cabazes    
 */
public enum ClientIndex {
    
    TOTALLY_SATISTFIED(0),
    PARTIALLY_SATISFIED(1),
    NUM_PRODUCERS(2);

    private static Map<Integer, ClientIndex> lookup;

    static {
        var values = ClientIndex.values();
        lookup = new HashMap<>(values.length);
        for (var type : values)
            lookup.put(type.prefix, type);
        lookup = Collections.unmodifiableMap(lookup);
    }

    public final int prefix;
    
    public int getPrefix(){
        return prefix;
    }


    public static ClientIndex getType(int prefix) {
        return lookup.get(prefix);
    }

    ClientIndex(int i) {
        this.prefix = i;
    }
}
