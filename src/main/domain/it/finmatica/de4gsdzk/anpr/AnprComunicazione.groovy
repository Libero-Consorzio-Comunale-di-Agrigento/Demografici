package it.finmatica.de4gsdzk.anpr

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaPratica
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANPCIU_V_ZK")
class AnprComunicazione extends GsdBaseDomain {

    @Id
    @Column(name = "ID_OPERAZIONE")
    Long id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SERVIZIO", nullable = true)
    AnprEndPointServizio servizio

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ARCHIVIO_RIF", nullable = true)
    AnprTipoArchivio archivioRif

    @Column(name = "ID_RIF", updatable = false, insertable = false)
    Long idRif

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_INVIO_WS")
    Boolean inviato

    @Convert(converter = GsdBaseDomain.BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNULLAMENTO", updatable = false, insertable = false)
    Boolean flagAnnullamento

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "D_DATA_INVIO_WS", nullable = false, updatable = false, insertable = false)
    Date dataInvio

    @Column(name = "NOTE_WS_VIS", nullable = true, updatable = false, insertable = false)
    String noteWSAnpr

    @Column(name = "INFO_WS_VIS", nullable = true, updatable = false, insertable = false)
    String infoWSAnsc

    @Column(name = "ID_OPERAZIONE_ANPR")
    Long idANPR

    @Column(name = "ESITO_ANPR", nullable = false)
    String esito

    @Column(name = "DES_ESITO_ANPR", nullable = false, updatable = false, insertable = false)
    String esitoDescrizione

    @Column(name = "DES_EVENTO", nullable = false, updatable = false, insertable = false)
    String variazione

    @Column(name = "DES_EVENTO_DETTAGLIO", nullable = false, updatable = false, insertable = false)
    String dettaglio

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_ANATPR", nullable = true, updatable = false, insertable = false)
    AnaPratica pratica

    @Column(name = "MATRICOLA")
    Integer matricola

    @Column(name = "NOTE_WS", nullable = true)
    String noteWS

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_OPERAZIONE")
    AnprDatiAggiuntiviComunicazione datiAggiuntivi

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Id"),
                                              Etichette.getEtichetta("Servizio"),
                                              Etichette.getEtichetta("Variazione_Pratica"),
                                              Etichette.getEtichetta("Dettaglio"),
                                              Etichette.getEtichetta("Annullata"),
                                              Etichette.getEtichetta("Comunicazioni_Per"),
                                              Etichette.getEtichetta("Fitri_Ws"),
                                              Etichette.getEtichetta("Archivio_Riferimento")]

}
