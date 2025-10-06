package it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IIndirizzoAnagrafe
import it.finmatica.de4gsdzk.utils.IIndirizzoNonResidente

import javax.persistence.AttributeOverride
import javax.persistence.AttributeOverrides
import javax.persistence.Column
import javax.persistence.Embeddable

@Embeddable
class IndirizzoNonResidenteAnagrafe implements IIndirizzoNonResidente, IIndirizzoAnagrafe {

    @Column(name = "INDIRIZZO_RES", nullable = false, insertable = false, updatable = false)
    String via

    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_RES", insertable = false, updatable = false)),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_RES", insertable = false, updatable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_RES", insertable = false, updatable = false)),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_RES", insertable = false, updatable = false))
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

    @Column(name = "CAP_RES", nullable = true, insertable = false, updatable = false)
    String cap

    static final List<Map> etichetteDomain = [Etichette.Via, Etichette.Comune]

}
