package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "ELEDSE")
class EleSezione extends GsdBaseDomain{

    @Id
    @Column(name = "SEZIONE")
    Integer sezione

    @Override
    Object getId() {
        return sezione
    }
}
