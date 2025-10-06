package it.finmatica.de4gsdzk.anagrafe

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANADEV_X_STATO")
class AnaStato {
    @Id
    @Column(name = "COD_EV")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione
}
