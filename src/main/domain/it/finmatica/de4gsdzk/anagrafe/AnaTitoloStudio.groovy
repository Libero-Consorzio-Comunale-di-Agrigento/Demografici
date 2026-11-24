package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.FetchType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@Table(name = "ANADTS")
class AnaTitoloStudio {

    @Id
    @Column(name = "COD_TS")
    String codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Enumerated(EnumType.STRING)
    @Column(name = "GRUPPO", length = 2)
    EGruppoTitoloStudio gruppo

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CODICE_ANPR", referencedColumnName = "CODICE")
    AnpCodiceTitoloStudio codiceAnpr

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente terminalista

    static List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Gruppo"),
                                        Etichette.getEtichetta("Codice_ANPR")]
}
