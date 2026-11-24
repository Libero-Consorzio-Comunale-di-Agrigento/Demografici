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
@Table(name = "ANADTP")
class AnaTipoProvvedimento {

    @Id
    @Column(name = "COD_TP")
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

    @Override
    boolean equals(Object o) {
        if (this.is(o)) return true
        if (!(o instanceof AnaTipoProvvedimento)) return false
        AnaTipoProvvedimento that = (AnaTipoProvvedimento) o
        return codice != null && codice == that.codice
    }

    @Override
    int hashCode() {
        return Objects.hash(codice)
    }

    @Override
    String toString() {
        return "AnaTipoProvvedimento{codice=$codice, descrizione='$descrizione'}"
    }
}
