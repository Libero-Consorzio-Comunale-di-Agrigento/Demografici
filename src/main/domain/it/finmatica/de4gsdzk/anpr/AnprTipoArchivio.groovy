package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ANPCIU_ARC_ZK")
class AnprTipoArchivio extends GsdBaseDomain {

    @Id
    @Column(name = "CODICE")
    String id

    @Column(name = "DESCRIZIONE")
    String descrizione
}
