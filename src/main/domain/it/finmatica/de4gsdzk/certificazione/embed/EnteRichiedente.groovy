package it.finmatica.de4gsdzk.certificazione.embed

import it.finmatica.de4gsdzk.ansc.AnscConsolato
import it.finmatica.de4gsdzk.statocivile.embed.Comune

import javax.persistence.*

@Embeddable
class EnteRichiedente {

    @Column(name = "ENTE_RICHIEDENTE", nullable = true)
    String denominazione

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ENTE_RICHIEDENTE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ENTE_RICHIEDENTE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ENTE_RICHIEDENTE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ENTE_RICHIEDENTE", updatable = false, insertable = false))
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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CONSOLATO_ANSC_RICHIEDENTE", nullable = true)
    AnscConsolato consolato
}
