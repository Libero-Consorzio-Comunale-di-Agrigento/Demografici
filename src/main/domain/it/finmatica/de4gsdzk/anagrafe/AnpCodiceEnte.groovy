package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANPT32")
class AnpCodiceEnte {

    @Id
    @Column(name = "CODICE")
    String codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    static List<Map> etichetteDomain = [
            Etichette.getEtichetta("Codice"),
            Etichette.getEtichetta("Descrizione")
    ]

    @Override
    boolean equals(Object obj) {
        if (this.is(obj)) return true
        if (obj == null || getClass() != obj.getClass()) return false
        AnpCodiceEnte that = (AnpCodiceEnte) obj
        return Objects.equals(codice, that.codice)
    }

    @Override
    int hashCode() {
        return Objects.hash(codice)
    }

    @Override
    String toString() {
        return "Anpt32{codice='${codice}', descrizione='${descrizione}'}"
    }
}
