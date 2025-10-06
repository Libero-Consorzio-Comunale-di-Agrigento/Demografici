package it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IIndirizzoNonResidente

import javax.persistence.AttributeOverride
import javax.persistence.AttributeOverrides
import javax.persistence.Column
import javax.persistence.Embeddable

@Embeddable
class IndirizzoNonResidenteFamiglia implements IIndirizzoNonResidente {

    @Column(name = "VIA_RES", nullable = false)
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

    static final List<Map> etichetteDomain = [Etichette.Via, Etichette.Comune]
}
