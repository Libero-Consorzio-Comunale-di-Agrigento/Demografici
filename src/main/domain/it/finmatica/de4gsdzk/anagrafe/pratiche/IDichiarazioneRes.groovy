package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.utils.EConteggio

interface IDichiarazioneRes extends IDichiarazionePratica {
    //Per Modello APR4, valide solo per iscrizioni e cancellazioni
    EConteggio getConteggio()

    Integer getNumero()
    Integer getAnno()
    String getIdDichiarazione()

}