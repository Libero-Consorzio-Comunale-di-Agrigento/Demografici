package it.finmatica.de4gsdzk.utils

enum ETipoFasciaEta {

    IQ("IQ"), // Infraquattordicenne
    SQ("SQ"), // Più di 14, meno di 18
    MG("MG")  // Maggiorenne

    final String id

    private ETipoFasciaEta(String id) {
        this.id = id
    }

}