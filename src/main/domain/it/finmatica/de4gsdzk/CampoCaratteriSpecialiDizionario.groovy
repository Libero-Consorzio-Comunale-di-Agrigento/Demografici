package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.EGruppo

import javax.persistence.*

@Entity
@Table(name = "GSDANA_UNICODE_DIZ")
class CampoCaratteriSpecialiDizionario {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "CODICE")
    String codice

    @Column(name = "DESCRIZIONE")
    String descrizione

    @Enumerated(EnumType.STRING)
    @Column(name = "MODULO_RIF")
    EGruppo gruppo


}
