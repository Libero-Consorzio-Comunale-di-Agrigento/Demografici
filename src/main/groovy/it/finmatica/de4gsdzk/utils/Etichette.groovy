package it.finmatica.de4gsdzk.utils

import groovy.json.JsonSlurper
import groovy.util.logging.Slf4j

@Slf4j
class Etichette {

    private static final Map<String, Map<String, String>> etichetteMap = [:]

    static {
        InputStream jsonStream = Etichette.classLoader.getResourceAsStream('etichette/etichette.json')
        if (jsonStream == null) {
            throw new RuntimeException("File etichette.json non trovato nel classpath")
        }

        def json = new JsonSlurper().parse(jsonStream)
        json.each { Map.Entry<String, Map<String, String>> entry ->
            etichetteMap.put(entry.key, entry.value)
        }


    }

    static Map<String, String> getEtichetta(String nome) {
        Map<String, String> etichetta = etichetteMap[nome]
        if (etichetta == null) {
            if(isAmbienteLocale()){
                throw new IllegalArgumentException("Etichetta '${nome}' non trovata")
            } else {
                log.error("Etichetta '${nome}' non trovata")
                return [codice: "", defaultValue: ""]
            }

        }
        return etichetta
    }

    private static boolean isAmbienteLocale() {
        String env = System.getProperty("env") ?: System.getenv("ENV")
        return env?.toLowerCase() == "local"
    }


}
