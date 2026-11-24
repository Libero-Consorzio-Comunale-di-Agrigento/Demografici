package it.finmatica.de4gsdzk.utils

class RicercaRubricaNascite extends RicercaAtto {

    ESesso sesso
    Date dataNascitaDa
    Date dataNascitaA

    Integer codiceComuneAttoNascita
    String descrizioneComuneAttoNascita
    Integer codiceProvinciaAttoNascita

    Integer annoRegistrazione
    Integer annoRegistrazioneDa
    Integer annoRegistrazioneA

    Date dataRegistrazioneDa
    Date dataRegistrazioneA

    RicercaRubricaNascite() {}

    static final List<Map> etichetteRicercaRubricaDesc = [Etichette.getEtichetta("Estrazioni"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A")]

}
