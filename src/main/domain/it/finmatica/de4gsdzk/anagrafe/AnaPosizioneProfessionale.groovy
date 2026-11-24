package it.finmatica.de4gsdzk.anagrafe

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
@Table(name = "ANADPP")
class AnaPosizioneProfessionale {

    @Id
    @Column(name = "COD_PP")
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

    boolean equals(o) {
        if (this.is(o)) return true
        if (getClass() != o?.class) return false
        AnaPosizioneProfessionale that = (AnaPosizioneProfessionale) o
        if (codice != that.codice) return false
        return true
    }

    int hashCode() {
        return (codice != null ? codice.hashCode() : 0)
    }

    String toString() {
        return "AnaPosizioneProfessionale{codice=$codice, descrizione='$descrizione'}"
    }
}
