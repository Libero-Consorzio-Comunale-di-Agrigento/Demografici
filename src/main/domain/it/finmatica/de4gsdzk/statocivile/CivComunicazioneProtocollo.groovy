package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "CIVCOM_PROT_V")
class CivComunicazioneProtocollo {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = false)
    Integer ufficio

    @Column(name = "ANNO", nullable = false)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Column(name = "OGGETTO", nullable = true)
    String oggetto

    @Column(name = "OGGETTO_INFO", nullable = true, updatable = false, insertable = false)
    String oggettoInfo

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_CO", nullable = false)
    CivComunicazione comunicazione

    @Column(name = "ANNO_PROTOCOLLO", nullable = true)
    Integer annoProtocollo

    @Column(name = "NUMERO_PROTOCOLLO", nullable = true)
    Integer numeroProtocollo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROTOCOLLO", nullable = true)
    Date dataProtocollo

    @Column(name = "NOTE_WS_PROT")
    String noteWSProtocollo

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Oggetto]

}
