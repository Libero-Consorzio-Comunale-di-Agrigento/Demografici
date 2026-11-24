package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "AD4_UTENTI_GSD")
class Ad4UtentiGsd extends GsdBaseDomain {

    @Id
    @Column(name = "UTENTE")
    String utente

    @Override
    Object getId() {
        return this.utente
    }

    @Column(name = "COGNOME")
    String cognome

    @Column(name = "NOME")
    String nome

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [
        Etichette.getEtichetta("Utente"),
        Etichette.getEtichetta("Cognome"),
        Etichette.getEtichetta("Nome")
    ]

    @Override
    boolean equals(Object o) {
        if (this.is(o)) return true
        if (getClass() != o?.class) return false

        Ad4UtentiGsd that = (Ad4UtentiGsd) o

        if (utente != that.utente) return false

        return true
    }

    @Override
    int hashCode() {
        return (utente != null ? utente.hashCode() : 0)
    }

    @Override
    String toString() {
        return "Ad4UtentiGsd{" +
                "utente='" + utente + '\'' +
                ", cognome='" + cognome + '\'' +
                ", nome='" + nome + '\'' +
                '}'
    }


}