package it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia


import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IIndirizzoResidente

import javax.persistence.Column
import javax.persistence.Embeddable
import javax.persistence.Embedded

@Embeddable
class IndirizzoResidenteFamiglia implements IIndirizzoResidente {

    @Embedded
    IndirizzoCivico indirizzo

    IndirizzoCivico getIndirizzo() {
        if (indirizzo == null) {
            indirizzo = new IndirizzoCivico()
        }
        return indirizzo
    }

    @Column(name = "CIVICO_INTERNO", insertable = false, updatable = false)
    String civicoInternoFormatted

    @Column(name = "CIVICO_ESTERNO", insertable = false, updatable = false)
    String civicoEsternoFormatted

    @Override
    String getViaFormatted() {
        return "$indirizzo.via.denominazione ${civicoEsternoFormatted?:""} ${civicoInternoFormatted?:""}"
    }

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Via")]

}
