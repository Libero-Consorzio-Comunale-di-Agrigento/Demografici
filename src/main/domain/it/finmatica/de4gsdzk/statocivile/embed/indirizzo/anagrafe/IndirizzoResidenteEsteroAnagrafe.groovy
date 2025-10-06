package it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe


import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IIndirizzoAnagrafe
import it.finmatica.de4gsdzk.utils.IIndirizzoResidenteEstero

import javax.persistence.AttributeOverride
import javax.persistence.AttributeOverrides
import javax.persistence.Column
import javax.persistence.Embeddable

@Embeddable
class IndirizzoResidenteEsteroAnagrafe implements IIndirizzoResidenteEstero, IIndirizzoAnagrafe {

    @Column(name = "INDIRIZZO_RES", nullable = false)
    String via

    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_RES")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_RES", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_RES")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_RES", updatable = false, insertable = false))
    ])
    private Comune comune

    Comune getComune() {
        if (comune == null) {
            comune = new Comune()
        }
        return comune
    }

    void setComune(Comune c) {
        this.comune = c
    }

    @Column(name = "CAP_RES", nullable = true)
    String zipcode

    @Override
    void setCap(String cap) {
        this.zipcode = cap
    }

    @Override
    String getCap() {
        return this.zipcode
    }

    @Column(name = "PROVINCIA_CONTEA_AIR", nullable = true)
    String provinciaContea

    @Column(name = "PRESSO_AIR", nullable = true)
    String presso

    @Column(name = "COD_CONSOLATO_AIR", nullable = true)
    String codiceConsolato

    @Column(name = "SEDE_CONSOLATO_AIR", nullable = true)
    String sedeConsolato

    static final List<Map> etichetteDomain = [Etichette.Via, Etichette.Comune, Etichette.Zipcode, Etichette.Provincia_Contea, Etichette.Presso, Etichette.Consolato, Etichette.Sede]
}
