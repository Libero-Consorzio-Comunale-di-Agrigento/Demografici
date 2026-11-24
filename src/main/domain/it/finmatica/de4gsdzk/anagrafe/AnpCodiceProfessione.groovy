package it.finmatica.de4gsdzk.anagrafe

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANPT10")
class AnpCodiceProfessione {

    @Id
    @Column(name = "CODICE")
    Integer codice

    @Column(name = "DESCRIZIONE")
    String descrizione
}