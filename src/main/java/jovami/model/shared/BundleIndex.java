package jovami.model.shared;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/*
    CABAZ
    * nº de produtos totalmente satisfeitos
    * nº de produtos parcialmente satisfeitos,
    * nºde produtos não satisfeitos
    * percentagem total do cabaz satisfeito
    * nº de produtores que forneceram o cabaz.
*/

public enum BundleIndex {
    
    FULLY_DELIVERED(0),

    PARTIALY_DELIVERED(1),
    
    NOT_DELIVERED(2),
    PERC_TOTAL_SATISFIED(3),
    NUM_PRODUCERS(4);

    private static Map<Integer, BundleIndex> lookup;

    static {
        var values = BundleIndex.values();
        lookup = new HashMap<>(values.length);
        for (var type : values)
            lookup.put(type.prefix, type);
        lookup = Collections.unmodifiableMap(lookup);
    }

    public final int prefix;
    
    public int getPrefix(){
        return prefix;
    }


    public static BundleIndex getType(int prefix) {
        return lookup.get(prefix);
    }

    BundleIndex(int i) {
        this.prefix = i;
    }
}
