package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione

class RicercaAnnotazione {

    Date dal
    Date al

    String idAttoAnsc

    EStatoAnnotazione stato

    CivFormulaAnnotazione formulaDfa

    RicercaAnnotazione() {}

    Integer ufficio
    Integer anno
    Integer atto
    Integer parte
    private String serie
    String getSerie() {
        return serie
    }
    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    void cancella() {
        ufficio = null
        anno = null
        atto = null
        parte = null
        serie = null
        idAttoAnsc = null
    }

    static final List<Map> etichetteRicercaAnnDesc = [Etichette.Id_Atto_Ansc, Etichette.Ufficio, Etichette.Anno, Etichette.Numero_Atto, Etichette.Parte, Etichette.Serie,
                                                      Etichette.Effettua_Ricerca, Etichette.Stato, Etichette.Da, Etichette.A, Etichette.Tutte]

}
