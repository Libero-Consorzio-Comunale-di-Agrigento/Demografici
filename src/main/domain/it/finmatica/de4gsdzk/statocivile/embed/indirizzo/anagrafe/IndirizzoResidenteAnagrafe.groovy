package it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IIndirizzoAnagrafe
import it.finmatica.de4gsdzk.utils.IIndirizzoResidente

import javax.persistence.*

@Embeddable
class IndirizzoResidenteAnagrafe implements IIndirizzoResidente, IIndirizzoAnagrafe {

    @Column(name = "INDIRIZZO_RES", insertable = false, updatable = false)
    String via

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_RES", updatable = false, insertable = false)),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_RES", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_RES", updatable = false, insertable = false)),
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

    @Column(name = "CAP_RES", nullable = true, insertable = false, updatable = false)
    String cap

    @Override
    String getViaFormatted() {
        return via
    }

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Via")]

}
