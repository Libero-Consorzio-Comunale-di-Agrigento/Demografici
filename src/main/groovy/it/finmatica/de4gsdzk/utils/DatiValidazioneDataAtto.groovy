package it.finmatica.de4gsdzk.utils

class DatiValidazioneDataAtto {
    Date dataAtto
    boolean dataAttoMandatory

    DatiValidazioneDataAtto(Date dataAtto, boolean dataAttoMandatory) {
        this.dataAtto = dataAtto
        this.dataAttoMandatory = dataAttoMandatory
    }
}
