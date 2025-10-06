package it.finmatica.de4gsdzk.utils

enum ETipoFormulaAggiuntiva {

    CIA_INT("CIA_INT"), // Intestazione Copia Integrale
    CIA_TXT("CIA_TXT"), // Testo Copia Integrale
    CIA_FIR("CIA_FIR")  // FIrma Copia Integrale

    final String id

    private ETipoFormulaAggiuntiva(String id) {
        this.id = id
    }

    Map getEtichettaDesc(){
        switch(this) {
            case CIA_INT: return Etichette.Intestazione_CIA
            case CIA_TXT: return Etichette.Testo_CIA
            case CIA_FIR: return Etichette.Firma_CIA
        }
        return null
    }

}
