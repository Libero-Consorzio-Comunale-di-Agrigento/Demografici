package it.finmatica.de4gsdzk.anagrafe

class DatiCivico {

    Long numCiv
    String suffisso
    Long interno
    String subInterno
    String scala
    String scalaEsterna
    String piano

    // Dettagli civico esterno
    Boolean flagMetrico
    String progrSnc
    Boolean flagLettera
    Boolean flagEsponente
    String colore

    // Dettagli civico interno (ANPR)
    String corte
    Long interno2
    String subInterno2
    String secondario
    Boolean flagNui
    String nui

    private static final Set<String> EXCLUDED = ['class', 'flags', 'numerics', 'numCiv'] as Set

    // Proxy per binding sicuro checkbox: ZK valuta @bind anche su componenti hidden
    private final Map flags = new AbstractMap() {
        Object get(Object key) {
            def val = DatiCivico.this."${key}"
            return val instanceof Boolean ? val : null
        }
        Object put(Object key, Object value) {
            if (key?.toString()?.startsWith('flag')) {
                DatiCivico.this."${key}" = value as Boolean
            }
            return value
        }
        Set entrySet() { Collections.emptySet() }
    }

    Map getFlags() { return flags }

    // Proxy per binding sicuro intbox: stessa ragione dei flags
    private final Map numerics = new AbstractMap() {
        Object get(Object key) {
            def val = DatiCivico.this."${key}"
            return val instanceof Number ? val.intValue() : null
        }
        Object put(Object key, Object value) {
            if (value instanceof Number) {
                DatiCivico.this."${key}" = value.longValue()
            }
            return value
        }
        Set entrySet() { Collections.emptySet() }
    }

    Map getNumerics() { return numerics }

    void reset(String property) {
        this."${property}" = null
    }

    void copyTo(Object entity) {
        this.properties.findAll { !(it.key in EXCLUDED) }.each { prop, value ->
            if (entity.hasProperty(prop)) {
                entity."${prop}" = value instanceof String ? value.toUpperCase() : value
            }
        }
        // numCiv in DatiCivico maps to numeroCivico in entities
        if (entity.hasProperty('numeroCivico')) {
            entity.numeroCivico = this.numCiv
        }
    }

    static DatiCivico fromEntity(Object entity) {
        DatiCivico dto = new DatiCivico()
        dto.properties.findAll { !(it.key in EXCLUDED) }.each { prop, _ ->
            if (entity?.hasProperty(prop)) {
                dto."${prop}" = entity."${prop}"
            }
        }
        // numeroCivico in entities maps to numCiv in DatiCivico
        if (entity?.hasProperty('numeroCivico')) {
            dto.numCiv = entity.numeroCivico
        }
        return dto
    }
}