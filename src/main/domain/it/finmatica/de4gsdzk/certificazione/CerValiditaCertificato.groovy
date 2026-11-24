package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Table

@Entity
@Table(name = "CERDVC")
class CerValiditaCertificato extends GsdBaseDomain {

    @Id
    @Column(name = "COD_VC")
    Integer id

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "DESCR_STAMPA_1", nullable = false)
    String descrizioneStampa

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Descrizione_stampa")]
}
