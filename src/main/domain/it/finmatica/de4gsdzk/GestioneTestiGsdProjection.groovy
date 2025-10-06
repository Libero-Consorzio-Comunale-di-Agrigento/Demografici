package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.EAmbito
import it.finmatica.de4gsdzk.utils.EGruppo

@groovy.transform.TupleConstructor
class GestioneTestiGsdProjection {
    Long id
    String codice
    String descrizione
    EGruppo gruppo
    EAmbito ambito
}
