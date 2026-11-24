package it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IComunicazioneProtocollo
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANACOM_PROT_V")
class AnaComunicazioneProtocollo extends GsdBaseDomain implements IComunicazioneProtocollo {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "OGGETTO", nullable = true)
    String oggetto

    @Column(name = "OGGETTO_INFO", nullable = true, updatable = false, insertable = false)
    String oggettoInfo

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="CODICE_CO", nullable = false)
    AnaComunicazione comunicazione

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

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Oggetto")]

}
