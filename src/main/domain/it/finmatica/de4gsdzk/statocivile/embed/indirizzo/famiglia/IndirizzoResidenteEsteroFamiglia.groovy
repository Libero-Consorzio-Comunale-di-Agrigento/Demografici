package it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia


import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IIndirizzoResidenteEstero

import javax.persistence.AttributeOverride
import javax.persistence.AttributeOverrides
import javax.persistence.Column
import javax.persistence.Embeddable

@Embeddable
class IndirizzoResidenteEsteroFamiglia implements IIndirizzoResidenteEstero {

    @Column(name = "VIA_AIRE", nullable = false)
    String via

    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_AIRE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_AIRE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_AIRE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_AIRE", updatable = false, insertable = false))
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

    @Column(name = "ZIPCODE", nullable = true)
    String zipcode

    @Column(name = "PROVINCIA_CONTEA", nullable = true)
    String provinciaContea

    @Column(name = "PRESSO", nullable = true)
    String presso

    @Column(name = "COD_CONSOLATO_AIRE", nullable = true, updatable = false, insertable = false)
    String codiceConsolato

    @Column(name = "SEDE_CONSOLATO_AIRE", nullable = true, updatable = false, insertable = false)
    String sedeConsolato

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Via"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Zipcode"), Etichette.getEtichetta("Provincia_Contea"), Etichette.getEtichetta("Presso"), Etichette.getEtichetta("Consolato"), Etichette.getEtichetta("Sede")]
}
