package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaTipoDocumento
import it.finmatica.de4gsdzk.anpr.AnprTipoCertificatoEsterno
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.TipoAttoUtils

import javax.persistence.*

@Entity
@Table(name = "CERDCE_V")
class CerTipoCertificato extends GsdBaseDomain {
    private static Integer TIPO_ARCHIVIO_ANAGRAFE = 0

    @Id
    @Column(name = "COD_CERTIFICATO")
    private String id
    String getId() { id }
    void setId(String id) { this.id = id?.toUpperCase() }

    @Column(name = "DESCRIZIONE", nullable = false)
    String descrizione

    @Column(name = "DESCRIZIONE_ESTESA", nullable = true, updatable = false, insertable = false)
    String descrizioneEstesa

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "CODICE_ANPR", nullable = true)
    CerTipoCertificatoEsternoBaseDomain tipoCertificatoEsterno

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_DISMESSO", nullable = true)
    Boolean flagDismesso

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ON_LINE", nullable = true)
    Boolean flagOnLine

    @Column(name = "TIPO_ARCHIVIO", nullable = true)
    private Integer tipoArchivio

    ETipoAtto getTipoAttoEnum() {
        if(tipoArchivio == null || tipoArchivio == TIPO_ARCHIVIO_ANAGRAFE) {
            return null
        }
        return TipoAttoUtils.fromValoreDefault(this.tipoArchivio.intValue())
    }

    void setTipoAttoEnum(ETipoAtto tipoAtto) {
        this.tipoArchivio = tipoAtto?.valore
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CERCTC", nullable = true)
    CerCategoriaTipoCertificato categoriaTipoCertificato

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FILTRO", nullable = true)
    CerFiltro filtro

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_CONTROLLO", nullable = true)
    CerCodiceControllo codiceControllo

    @OneToMany(mappedBy = "tipoCertificato", fetch = FetchType.LAZY)
    List<CerTipoCertificatoTariffaDiritto> tipoCertificatoTariffaDirittoList = []

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_NUMERA_DOCUMENTO_ANA", nullable = true)
    Boolean flagNumeraDocumentoAnagrafe

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_DOCUMENTO_ANA", nullable = true)
    AnaTipoDocumento tipoDocumentoAnagrafe

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_FIRMA", nullable = true)
    CerFirma firma

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VALIDITA", nullable = true)
    CerValiditaCertificato validita

    Boolean isGenerazioneEsterna() {
        tipoCertificatoEsterno != null
    }

    Boolean isStatoCivile() {
        categoriaTipoCertificato.isStatoCivile()
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_ANNOTAZIONI_CIV", nullable = true)
    Boolean flagAnnotazioni

    Boolean isAnagrafe() {
        categoriaTipoCertificato.isAnagrafe()
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "STORICO", nullable = true)
    ETipoSiNo flagStorico

    Boolean isStorico() {
        flagStorico == ETipoSiNo.SI
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_SFA", nullable = true)
    Boolean flagStatoDiFamiglia

    @Column(name = "TIPO_CERTIFICATO_ANSC", nullable = true, updatable = false, insertable = false)
    Integer tipoCertificatoAnsc

    Boolean shouldGenerateDocumentoAnagrafico() {
        return flagNumeraDocumentoAnagrafe && tipoDocumentoAnagrafe != null
    }

    Boolean shouldRecoverDocumentoAnagrafico() {
        return !flagNumeraDocumentoAnagrafe && tipoDocumentoAnagrafe != null
    }

    Boolean canUseAnpr() {
        return isGenerazioneEsterna() && (tipoCertificatoEsterno instanceof AnprTipoCertificatoEsterno)
    }

    @PrePersist
    void beforeInsert() {
        if (categoriaTipoCertificato.isAnagrafe()) {
            tipoArchivio = TIPO_ARCHIVIO_ANAGRAFE
        }
    }

    @PreUpdate
    void beforeUpdate() {
        if (categoriaTipoCertificato.isAnagrafe()) {
            tipoArchivio = TIPO_ARCHIVIO_ANAGRAFE
        }
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Codice"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Categoria_Tipo_Certificato"),
                                              Etichette.getEtichetta("Tipo_firma"),
                                              Etichette.getEtichetta("Beneficiario"), Etichette.getEtichetta("Filtro"), Etichette.getEtichetta("Codice_controllo"), Etichette.getEtichetta("Validita"),
                                              Etichette.getEtichetta("Dismesso"), Etichette.getEtichetta("Tipo_Certificato_esterno"), Etichette.getEtichetta("Modello"), Etichette.getEtichetta("Formato_testo"),
                                              Etichette.getEtichetta("Tipi_di_Atto"), Etichette.getEtichetta("Controllo_Annotazioni"),
                                              Etichette.getEtichetta("Storico"), Etichette.getEtichetta("Stato_di_famiglia"), Etichette.getEtichetta("Documento_Individuo"),
                                              Etichette.getEtichetta("Tipo_Documento"), Etichette.getEtichetta("Numero")]
}
