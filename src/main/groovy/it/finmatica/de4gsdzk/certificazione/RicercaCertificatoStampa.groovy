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
            params.add([etichetta    : Etichette.getEtichetta("Data_emissione"),
                        etichettaFrom: Etichette.getEtichetta("Dal"),
                        etichettaTo  : Etichette.getEtichetta("Al"),
                        isRange      : true,
                        fromDate     : dataEmissioneDal,
                        toDate       : dataEmissioneAl])
        }
        if (terminalista) {
            params.add([etichetta: Etichette.getEtichetta("Terminalista"), value: "${terminalista.cognomeNome} (${terminalista.id})"])
        }
        return params
    }

    static final List<Map> etichetteRicercaCerDesc = [Etichette.getEtichetta("Effettua_Ricerca"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"), Etichette.getEtichetta("Tutti"), Etichette.getEtichetta("Dal"), Etichette.getEtichetta("Al"),
                                                      Etichette.getEtichetta("Tipo_pagamento"), Etichette.getEtichetta("Terminalista"), Etichette.getEtichetta("Modalita_rilascio"),
                                                      Etichette.getEtichetta("Data_emissione"),
                                                      Etichette.getEtichetta("Escludi_annullati"),
                                                      Etichette.getEtichetta("Stampa_Solo_Carta_Identita"), Etichette.getEtichetta("Stampa_Solo_Carta_Identita_tooltip"),
                                                      Etichette.getEtichetta("Stampa_Solo_Bollo"), Etichette.getEtichetta("Stampa_Solo_Bollo_tooltip")]

}
