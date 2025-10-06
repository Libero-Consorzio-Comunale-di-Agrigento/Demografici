package it.finmatica.de4gsdzk.anagrafe

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANADEV")
class AnaCodiceEvento {
    @Id
    @Column(name = "COD_EV")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione
}
