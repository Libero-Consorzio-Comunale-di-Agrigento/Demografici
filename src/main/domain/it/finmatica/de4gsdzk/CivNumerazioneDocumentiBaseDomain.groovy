package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.Column
import javax.persistence.Id
import javax.persistence.MappedSuperclass
import javax.persistence.Version

@MappedSuperclass
abstract class CivNumerazioneDocumentiBaseDomain {

    @Id
    @Column(name = "ID", nullable = false)
    Long id

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "NUMERO", nullable = false)
    Integer numero

    @Version
    @Column(nullable = false)
    Long version

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Registro"), Etichette.getEtichetta("Numero")]

}
