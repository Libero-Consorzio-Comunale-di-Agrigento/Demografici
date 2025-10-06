package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Id
import javax.persistence.MappedSuperclass

@MappedSuperclass
class CivRichiamoBaseDomain extends GsdBaseDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "TIPO_ATTO")
    Integer tipoAtto

    @Column(name = "RICHIAMO", nullable = false)
    Integer richiamo

    @Column(name = "PROGR_DETTAGLIO", nullable = true)
    Integer progressivo
    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// GENERALI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Richiamo, Etichette.Progressivo, Etichette.Tipo_Atto]

}
