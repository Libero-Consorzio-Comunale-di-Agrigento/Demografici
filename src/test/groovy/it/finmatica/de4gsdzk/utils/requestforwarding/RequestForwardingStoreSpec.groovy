package it.finmatica.de4gsdzk.utils.requestforwarding


import spock.lang.Specification

class RequestForwardingStoreSpec extends Specification {
    def "Dovrebbe memorizzare e recuperare un oggetto"() {
        given: "Un'istanza di RequestForwardingStore"
        RequestForwardingStore store = new RequestForwardingStore()
        def object = new Random().nextInt()

        when: "Un oggetto viene memorizzato"
        String requestId = store.storeObject(object)

        then: "L'ID della richiesta non dovrebbe essere nullo o vuoto"
        requestId != null
        !requestId.isEmpty()

        when: "L'oggetto viene recuperato e rimosso"
        def valoreRecuperato = store.retrieveObject(requestId)

        then: "Il valore recuperato dovrebbe essere lo stesso di quello memorizzato"
        valoreRecuperato == object

        and: "L'oggetto non dovrebbe più essere nello store"
        store.retrieveObject(requestId) == null
    }

    void "Dovrebbe memorizzare i parametri della richiesta"() {
        given: "Un'istanza di RequestForwardingStore"
        RequestForwardingStore store = new RequestForwardingStore()
        RequestForwardingParams mappa = new RequestForwardingParams([a: "b", c: "d"])

        when: "La mappa viene memorizzata"
        String requestId = store.storeRequestForwardingParams(mappa)

        then: "L'ID della richiesta non dovrebbe essere nullo o vuoto"
        requestId != null
        !requestId.isEmpty()

        when: "La mappa viene recuperata e rimossa"
        RequestForwardingParams valoreRecuperato = store.retrieveRequestForwardingParams(requestId)

        then: "Il valore recuperato dovrebbe essere lo stesso di quello memorizzato"
        valoreRecuperato == mappa

        and: "L'oggetto è nello store ma non contiene gli elemente"
        store.retrieveRequestForwardingParams(requestId) != null
        store.retrieveRequestForwardingParams(requestId).get("a") == null
        store.retrieveRequestForwardingParams(requestId).get("c") == null
    }
}

