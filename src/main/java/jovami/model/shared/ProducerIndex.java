package jovami.model.shared;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

/* 
    PRODUTOR
    * nº de cabazes fornecidos totalmente
    * nº de cabazes fornecidos parcialmente
    * nº de produtos totalmente esgotados
    * nº de clientes distintos fornecidos
    * nº de hubs fornecidos.
*/

public enum ProducerIndex {
    
    BUNDLES_TOTALLY_PROVIDED(0),
    BUNDLES_PARTIALLY_PROVIDED(1),
    PROD_OUT_OF_STOCK(2),
    DIF_CLIENTS(3),
    DIF_HUBS(4);

    private static Map<Integer, ProducerIndex> lookup;

    static {
        var values = ProducerIndex.values();
        lookup = new HashMap<>(values.length);
        for (var type : values)
            lookup.put(type.prefix, type);
        lookup = Collections.unmodifiableMap(lookup);
    }

    public final int prefix;

    public int getPrefix(){
        return prefix;
    }

    public static ProducerIndex getType(int prefix) {
        return lookup.get(prefix);
    }

    ProducerIndex(int i) {
        this.prefix = i;
    }
}
