package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IRiferimentoCertificatoDomain
import it.finmatica.de4gsdzk.certificazione.embed.Beneficiario
import it.finmatica.de4gsdzk.certificazione.embed.EnteRichiedente
import it.finmatica.de4gsdzk.certificazione.embed.Richiedente
import it.finmatica.de4gsdzk.integrazioni.documentale.IDocumentoEsterno
import it.finmatica.de4gsdzk.integrazioni.documentale.IFileDocumentoEsterno
import it.finmatica.de4gsdzk.pagamento.WspaPagamentoInviatoDettaglio
import it.finmatica.de4gsdzk.utils.DomainUtils
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "CERCEM_V")
class CerCertificatoEmesso extends GsdBaseDomain implements IRiferimentoCertificatoDomain, IDocumentoEsterno, IFileDocumentoEsterno {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ANNO_EMISSIONE", nullable = true)
    Integer annoEmissione

    @Column(name = "PROGR_EMISSIONE", nullable = false)
    Integer progressivoEmissione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EMISSIONE", nullable = true)
    Date dataEmissione

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="COD_CERTIFICATO", nullable = false)
    CerTipoCertificato tipoCertificato

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_STORICO", nullable = true)
    Date dataStorico

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="TERMINALISTA", nullable = false)
    CerTerminalista terminalista

    @Column(name = "NOME_TERMINALISTA", nullable = true)
    String cognomeNomeTerminalista

    @Column(name = "QUALIFICA_TERMINALISTA", nullable = true)
    String qualificaTerminalista

    //@Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_TERMINALISTA_IN_STAMPA", nullable = true)
    String flagInStampaTerminalista

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="MODALITA_RILASCIO", nullable = true)
    CerModalitaRilascio modalitaRilascio

    @Column(name = "DES_MODALITA_RILASCIO_LIBERA", nullable = true)
    String descrizioneModalitaStampaLibera

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="TIPO_PAGAMENTO", nullable = true)
    CerTipoPagamento tipoPagamento

    @Column(name = "SEGRETERIA")
    BigDecimal segreteria

    @Column(name = "STATO_CIVILE")
    BigDecimal statoCivile

    @Column(name = "CARTA_IDENTITA")
    BigDecimal cartaIdentita

    @Column(name = "RIMBORSO_ST")
    BigDecimal rimborsoStampati

    @Column(name = "BOLLO")
    BigDecimal bollo

    BigDecimal getTotale() {
        return (segreteria ?: new BigDecimal(0)) +
                (statoCivile ?: new BigDecimal(0)) +
                (cartaIdentita ?: new BigDecimal(0)) +
                (rimborsoStampati ?: new BigDecimal(0)) +
                (bollo ?: new BigDecimal(0))
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "ANNULLAMENTO", nullable = true)
    ETipoSiNo annullamento

    @Column(name = "NOTE_ANNULLAMENTO", nullable = true)
    String noteAnnullamento

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "UTENTE_ANNULLAMENTO", nullable = true)
    CerTerminalista terminalistaAnnullamento

    @Column(name = "D_DATA_ANNULLAMENTO", nullable = true)
    Date dataAnnullamento

    Boolean isAnnullato() {
        return annullamento == ETipoSiNo.SI
    }

    @Column(name = "UTENTE_RIPRISTINO", nullable = true)
    String utenteRipristino

    @Column(name = "D_DATA_RIPRISTINO", nullable = true)
    Date dataRipristino

    @Version
    @Column(nullable = false)
    Long version

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CERDTR", nullable = true)
    CerTipoRichiedente tipoRichiedente

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_RICHIEDENTE", nullable = true)
    private Boolean flagRichiedente

    @Embedded
    Richiedente richiedente

    @Embedded
    Beneficiario beneficiario

    @Embedded
    EnteRichiedente enteRichiedente

    @Column(name = "ID_DOCUMENTO_GDM", nullable = true)
    Long idDocumentoEsterno

    @Column(name = "ID_OGGETTO_FILE_GDM", nullable = true)
    Long idFileEsterno

    @Column(name = "NOME_ALLEGATO", nullable = true)
    String nomeAllegato

    @Column(name = "ALLEGATO_BLOB", nullable = true)
    @Lob
    byte[] blobAllegato

    String getIdEmissione() {
        DomainUtils.calculateIdEmissione(annoEmissione, progressivoEmissione)
    }

    @Override
    String getNome() {
        return this.nomeAllegato
    }

    @Override
    void setDocumento(IDocumentoEsterno de) {
        this.idDocumentoEsterno = de.idDocumentoEsterno
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ANPR", nullable = true)
    Boolean generazioneEsterna

    @OneToOne(mappedBy = "certificatoEmesso", fetch = FetchType.LAZY)
    WspaPagamentoInviatoDettaglio pagamentoInviatoDettaglio

    @Column(name = "RICHIEDENTE_LISTA", nullable = true, updatable = false, insertable = false)
    String richiedenteLista

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////   ZK     ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    Boolean isDownloadAllegatoEnabled() {
        return !isAnnullato() && hasAllegato()
    }

    Boolean hasAllegato() {
        (this.idDocumentoEsterno != null && this.idFileEsterno != null) || (this.blobAllegato != null)
    }

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// GENERALI////////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    // TODO: sposta etichette emissione su EmissioneCertificatoViewModel
    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Progressivo_emissione"), Etichette.getEtichetta("Anno_emissione"), Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Cognome_Nome"), Etichette.getEtichetta("Richiedente"), Etichette.getEtichetta("Nazionalita"),
                                              Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Data"), Etichette.getEtichetta("Numero_copie"),
                                              Etichette.getEtichetta("Matricola"), Etichette.getEtichetta("Comune_Nascita"), Etichette.getEtichetta("Documento_riconoscimento"), Etichette.getEtichetta("Data_Rilascio"), Etichette.getEtichetta("Numero"), Etichette.getEtichetta("Annullato"),
                                              Etichette.getEtichetta("Data_emissione"), Etichette.getEtichetta("Beneficiario"),
                                              Etichette.getEtichetta("Tipo_Certificato"), Etichette.getEtichetta("Modalita_rilascio"),
                                              Etichette.getEtichetta("Da"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Consolato"),
                                              Etichette.getEtichetta("Diritti_segreteria"), Etichette.getEtichetta("Diritti_segreteria_abbr"),
                                              Etichette.getEtichetta("Diritti_stato_civile"), Etichette.getEtichetta("Diritti_stato_civile_abbr"),
                                              Etichette.getEtichetta("Diritti_carta_identita"), Etichette.getEtichetta("Diritti_carta_identita_abbr"),
                                              Etichette.getEtichetta("Rimborso_stampati"), Etichette.getEtichetta("Rimborso_stampati_abbr"),
                                              Etichette.getEtichetta("Bollo"), Etichette.getEtichetta("Totale"),
                                              Etichette.getEtichetta("Terminalista"), Etichette.getEtichetta("Tipo_pagamento"), Etichette.getEtichetta("Generazione_certificato_ADS"), Etichette.getEtichetta("Generazione_certificato_forzata_ANPR")]

    @PrePersist
    void beforeInsert() {
        flagRichiedente = tipoRichiedente?.isAltroRichiedente()

        if(beneficiario != null){
            beneficiario.beforeInsert()
        }
        if(richiedente != null){
            richiedente.beforeInsert()
        }
    }

    @PreUpdate
    void beforeUpdate() {
        flagRichiedente = tipoRichiedente?.isAltroRichiedente()

        if(beneficiario != null){
            beneficiario.beforeUpdate()
        }
        if(richiedente != null){
            richiedente.beforeUpdate()
        }
    }

    @PostLoad
    void postLoad() {
        try {
            if (tipoCertificato != null && tipoCertificato.id == null) {
                tipoCertificato = null
            }
        } catch (EntityNotFoundException e) {
            log.error(e.message, e)
            tipoCertificato = null
        }

        try {
            if (modalitaRilascio != null && modalitaRilascio.id == null) {
                modalitaRilascio = null
            }
        } catch (EntityNotFoundException e) {
            log.error(e.message, e)
            modalitaRilascio = null
        }

        try {
            if (terminalista != null && terminalista.id == 0) {
                terminalista = null
            }
        }catch (EntityNotFoundException e) {
            log.error(e.message, e)
            terminalista = null
        }

        try {
            if (terminalistaAnnullamento != null && terminalistaAnnullamento.id == 0) {
                terminalistaAnnullamento = null
            }
        } catch (EntityNotFoundException e) {
            log.error(e.message, e)
            terminalistaAnnullamento = null
        }

        try {
            if (tipoPagamento != null && tipoPagamento.id == 0) {
                tipoPagamento = null
            }
        } catch (EntityNotFoundException e) {
            log.error(e.message, e)
            tipoPagamento = null
        }

    }
}
