package it.finmatica.de4gsdzk

import javax.persistence.Column
import javax.persistence.MappedSuperclass
import javax.persistence.Temporal
import javax.persistence.TemporalType

@MappedSuperclass
abstract class CivVisualizzazioneDocumentiBaseDomain extends GsdBaseDomain {

    @Column(name = "ANNO", nullable = true)
    Integer annoProtocollo

    @Column(name = "PROTOCOLLO", nullable = false)
    Integer numeroProtocollo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROTOCOLLO", nullable = false)
    Date dataProtocollo

    @Column(name = "COGNOME", nullable = true)
    String cognome

    @Column(name = "NOME", nullable = true)
    String nome

    String getNominativo() {
        (cognome?:"") + ((cognome && nome)?" ":"") + (nome?:"")
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

}
