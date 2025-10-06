package it.finmatica.de4gsdzk.utils

import it.finmatica.de4gsdzk.statocivile.CivNotaFormula

class FrammentoFormulaAnnotazione {

    private String testoFisso
    private CivNotaFormula notaFormula

    FrammentoFormulaAnnotazione(String testoFisso, CivNotaFormula notaFormula){
        this.testoFisso = testoFisso
        this.notaFormula = notaFormula
    }

    FrammentoFormulaAnnotazione(String testoFisso){
        this.testoFisso = testoFisso
        this.notaFormula = null
    }

    String getTestoFisso() {
        return testoFisso
    }

    void setTestoFisso(String testoFisso) {
        this.testoFisso = testoFisso
    }

    CivNotaFormula getNotaFormula() {
        return notaFormula
    }

    void setNotaFormula(CivNotaFormula notaFormula) {
        this.notaFormula = notaFormula
    }
}
