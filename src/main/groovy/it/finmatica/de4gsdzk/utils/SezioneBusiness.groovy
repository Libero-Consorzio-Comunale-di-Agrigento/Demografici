package it.finmatica.de4gsdzk.utils

class SezioneBusiness {

    private final String id
    private final Map<String, String> etichetta
    private final List<SezioneBusiness> subSezioni

    SezioneBusiness(String id, Map<String, String> etichetta) {
        this.id = id
        this.etichetta = etichetta
        this.subSezioni = []
    }

    String getId() {
        return id
    }

    Map<String, String> getEtichetta() {
        return etichetta
    }

    List<SezioneBusiness> getSubSezioni() {
        return subSezioni
    }

    void addSubSezione(SezioneBusiness subSezione) {
        this.subSezioni.add(subSezione)
    }

}

