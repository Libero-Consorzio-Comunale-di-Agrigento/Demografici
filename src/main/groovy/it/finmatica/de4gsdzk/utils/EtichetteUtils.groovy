package it.finmatica.de4gsdzk.utils

class EtichetteUtils {

    static String getEtichetta(Map<String, String> etichette, Map<String, String> etichetta) {
        return (etichetta ? (String) etichette.get(etichetta.codice) : "")
    }

    static String getEtichetta(Map<String, String> etichette, String codiceEtichetta) {
        return (codiceEtichetta ? (String) etichette.get(codiceEtichetta) : "")
    }

    static String getEtichettaEnum(Map<String, String> etichette, Enum e) {
        return e ? getEtichetta(etichette, e.getEtichettaDesc() as Map) : ""
    }
}
