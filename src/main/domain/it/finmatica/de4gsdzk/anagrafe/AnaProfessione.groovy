package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANADPR")
class AnaProfessione {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "COD_PR", nullable = false)
    Integer codice

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = false)
    ESesso sesso

    @Column(name = "DESCRIZIONE")
    String descrizione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CODICE_ANPR", referencedColumnName = "CODICE")
    AnpCodiceProfessione codiceAnpr

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    Ad4Utente terminalista

    static List<Map> etichetteDomain = [
        Etichette.getEtichetta("Codice"),
        Etichette.getEtichetta("Sesso"),
        Etichette.getEtichetta("Descrizione"),
        Etichette.getEtichetta("Codice_ANPR")
    ]

    @Override
    boolean equals(Object o) {
        if (this.is(o)) return true
        if (!(o instanceof AnaProfessione)) return false
        AnaProfessione that = (AnaProfessione) o
        return id != null && id == that.id
    }

    @Override
    int hashCode() {
        return id?.hashCode() ?: 0
    }

    @Override
    String toString() {
        return "AnaProfessione{id='${id}', codice=${codice}, sesso=${sesso}, descrizione='${descrizione}'}"
    }
}