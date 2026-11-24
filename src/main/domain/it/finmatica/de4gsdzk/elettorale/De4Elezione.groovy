package it.finmatica.de4gsdzk.elettorale

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.OneToOne
import javax.persistence.Table

@Entity
@Table(name = "ELEELE_V")
class De4Elezione {

    @Id
    @Column(name = "ELEZIONE")
    Long id

    @Column(name = "DESCRIZIONE")
    String descrizione

    @OneToOne
    @JoinColumn(name = "ID_ELEDCE", nullable = false)
    EleElezione elezione
}
