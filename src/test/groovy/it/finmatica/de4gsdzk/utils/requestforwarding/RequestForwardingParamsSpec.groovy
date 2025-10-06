package it.finmatica.de4gsdzk.utils.requestforwarding


import spock.lang.Specification

class RequestForwardingParamsSpec extends Specification {
    void "RequestForwardingParams dovrebbe conservare i valori a partire da una mappa chiave valore"() {
        given:
        Map<String, String> mappa = new HashMap<>()
        mappa.put("a", "b")
        mappa.put("c", "d")

        when:
        RequestForwardingParams requestForwardingParams = new RequestForwardingParams(mappa)

        then:
        requestForwardingParams.get("a") == "b"
        requestForwardingParams.get("c") == "d"
        requestForwardingParams.get("d") == null
    }
}
