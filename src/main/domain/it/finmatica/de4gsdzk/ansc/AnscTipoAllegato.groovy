package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANST09")
class AnscTipoAllegato extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione

}

