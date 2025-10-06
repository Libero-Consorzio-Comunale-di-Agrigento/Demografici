package it.finmatica.de4gsdzk.ansc

import it.finmatica.de4gsdzk.GsdBaseDomain

import javax.persistence.*

@Entity
@Table(name = "ANSJSN_CAMPI")
class AnscCampo extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_SEZIONE", nullable = false)
    AnscSezione sezione

    @Column(name = "CAMPO", nullable = false)
    String campo

    @Column(name = "CAMPO_DB", nullable = true)
    String campoDb

    @Column(name = "SEQUENZA", nullable = false)
    Integer sequenza

}

