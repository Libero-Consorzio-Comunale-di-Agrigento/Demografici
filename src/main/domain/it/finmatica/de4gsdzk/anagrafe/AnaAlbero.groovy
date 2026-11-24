package it.finmatica.de4gsdzk.anagrafe

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.NotFound
import org.hibernate.annotations.NotFoundAction

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.Table

@Entity
@Table(name = "ANADTA")
@ToString(includeNames = true, includeFields = true, excludes = "terminalista")
@EqualsAndHashCode(includes = "codice")
class AnaAlbero {

    @Id
    @Column(name = "COD_TA")
    Integer codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = true)
    @UtenteUpd
    @NotFound(action = NotFoundAction.IGNORE)
    Ad4Utente terminalista

    static final List<Map> etichetteDomain = [
        Etichette.getEtichetta("Codice"),
        Etichette.getEtichetta("Descrizione")
    ]
}