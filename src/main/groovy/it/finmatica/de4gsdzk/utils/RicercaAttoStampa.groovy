package it.finmatica.de4gsdzk.utils

class RicercaAttoStampa extends RicercaAtto{

    ENaturaAtto natura

    ESesso sesso
    ETipoLuogoEvento tipoLuogoEvento
    ETipoIndividuiAtto tipoIndividuiAtto
    Boolean escludiAnnullati
    Boolean escludiANSC

    Integer annoDa
    Integer annoA

    Date dataEventoDa
    Date dataEventoA

    Date dataRegistrazioneDa
    Date dataRegistrazioneA

    RicercaAttoStampa() {
        super()
    }

    RicercaAttoStampa(ETipoAtto tipoAtto) {
        super(tipoAtto)
    }

    RicercaAttoStampa(ETipoAtto tipoAtto, EStatoAtto stato, Boolean escludiAnnullati, Boolean escludiANSC) {
        super(tipoAtto, stato)
        this.escludiAnnullati = escludiAnnullati
        this.escludiANSC = escludiANSC
    }

    Boolean hasSesso(){
        return ( (tipoAtto == ETipoAtto.MOR) || (tipoAtto == ETipoAtto.NAS) || (tipoAtto == ETipoAtto.CIT) )
    }

    Boolean hasTipoLuogoEvento(){
        return ( (tipoAtto == ETipoAtto.MOR) || (tipoAtto == ETipoAtto.NAS) || (tipoAtto == ETipoAtto.MAT) || (tipoAtto == ETipoAtto.UCI))
    }

    Boolean isDoppioSoggetto(){
        return ( (tipoAtto == ETipoAtto.PUB) || (tipoAtto == ETipoAtto.MAT) || (tipoAtto == ETipoAtto.PVU) || (tipoAtto == ETipoAtto.UCI) )
    }

    Boolean isIMatrimonio(){
        return ( (tipoAtto == ETipoAtto.MAT) || (tipoAtto == ETipoAtto.UCI) )
    }

    Boolean hasTipoAttoInfo(){
        return (tipoAtto == ETipoAtto.CIT)
    }

    static final List<Map> etichetteRicercaStampaDesc = [Etichette.Estrazioni, Etichette.Luogo, Etichette.Sesso, Etichette.Escludi_annullati,
                                                         Etichette.Tipo_Individui, Etichette.Anno, Etichette.Data_Evento,
                                                         Etichette.Data_Registrazione, Etichette.Da, Etichette.A, Etichette.Tutti, Etichette.Tutte]

}
