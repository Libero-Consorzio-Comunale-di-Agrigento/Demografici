package it.finmatica.de4gsdzk.certificazione


import it.finmatica.de4gsdzk.utils.Etichette

class RicercaCertificatoStampa extends BaseRicercaCertificato {

    RicercaCertificatoStampaRiepilogo riepilogo

    Boolean soloCartaIdentita
    Boolean soloBollo

    RicercaCertificatoStampa() {
        this.escludiAnnullati = Boolean.FALSE
        this.riepilogo = new RicercaCertificatoStampaRiepilogo()
    }

    @Override
    void setDataEmissioneDal(Date dataEmissioneDal) {
        super.setDataEmissioneDal(dataEmissioneDal)
        riepilogo.setDataFineRiepilogo(dataEmissioneDal)
    }

    Boolean getStampaFondoCassa() {
        (dataEmissioneDal == dataEmissioneAl) && (terminalista != null)
    }

    // TODO: convert to object
    List<Map> getLabelBuilderParams() {
        List<Map> params = []
        if (dataEmissioneDal || dataEmissioneAl) {
            params.add([etichetta    : Etichette.Data_emissione,
                        etichettaFrom: Etichette.Dal,
                        etichettaTo  : Etichette.Al,
                        isRange      : true,
                        fromDate     : dataEmissioneDal,
                        toDate       : dataEmissioneAl])
        }
        if (terminalista) {
            params.add([etichetta: Etichette.Terminalista, value: "${terminalista.cognomeNome} (${terminalista.id})"])
        }
        return params
    }

    static final List<Map> etichetteRicercaCerDesc = [Etichette.Effettua_Ricerca, Etichette.Da, Etichette.A, Etichette.Tutti, Etichette.Dal, Etichette.Al,
                                                      Etichette.Tipo_pagamento, Etichette.Terminalista, Etichette.Modalita_rilascio,
                                                      Etichette.Data_emissione,
                                                      Etichette.Escludi_annullati,
                                                      Etichette.Stampa_Solo_Carta_Identita, Etichette.Stampa_Solo_Carta_Identita_tooltip,
                                                      Etichette.Stampa_Solo_Bollo, Etichette.Stampa_Solo_Bollo_tooltip]

}
