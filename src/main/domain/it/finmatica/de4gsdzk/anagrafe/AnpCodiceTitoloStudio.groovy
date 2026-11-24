package it.finmatica.de4gsdzk.anagrafe

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANPT11")
class AnpCodiceTitoloStudio implements Comparable<AnpCodiceTitoloStudio> {

    @Id
    @Column(name = "CODICE")
    String codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Override
    int compareTo(AnpCodiceTitoloStudio other) {
        String codiceA = this.codice ?: ""
        String codiceB = other.codice ?: ""

        boolean aIsNumeric = codiceA.matches(/^\d+$/)
        boolean bIsNumeric = codiceB.matches(/^\d+$/)

        if (aIsNumeric && bIsNumeric) {
            // Entrambi numerici: ordina per valore numerico
            return codiceA.toInteger() <=> codiceB.toInteger()
        } else if (aIsNumeric) {
            // Solo questo è numerico: viene prima
            return -1
        } else if (bIsNumeric) {
            // Solo l'altro è numerico: l'altro viene prima
            return 1
        } else {
            // Entrambi alfabetici: ordina alfabeticamente
            return codiceA <=> codiceB
        }
    }
}