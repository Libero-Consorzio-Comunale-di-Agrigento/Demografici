package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CIVDAT_TIPI")
class CivDisposizioniAnticipateTrattamentoTipoAtto {

    @Id
    @Column(name = "CODICE")
    Integer id

    @Column(name = "DESCRIZIONE")
    String descrizione

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione")]

}
