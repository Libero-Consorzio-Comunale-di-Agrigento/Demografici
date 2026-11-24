package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.NotFound
import org.hibernate.annotations.NotFoundAction

import javax.persistence.*

@Entity
@Table(name = "ANADMD")
class AnaMotivoRilascio {

    @Id
    @Column(name = "COD_MD", nullable = false)
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
        if (!(o instanceof AnaMotivoRilascio)) return false

        AnaMotivoRilascio that = (AnaMotivoRilascio) o

        if (codice != that.codice) return false

        return true
    }

    @Override
    int hashCode() {
        return (codice != null ? codice.hashCode() : 0)
    }

    @Override
    String toString() {
        return "AnaMotivoRilascio{" +
                "codice=" + codice +
                ", descrizione='" + descrizione + '\'' +
                '}'
    }
}
