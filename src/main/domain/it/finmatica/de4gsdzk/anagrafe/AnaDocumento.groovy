package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdDocumentoEsternoBaseDomain
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ENaturaDocumento
import it.finmatica.de4gsdzk.utils.ETipoSN
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IDownloadable

import javax.persistence.*

@Entity
@Table(name = "ANADOC_V")
class AnaDocumento extends GsdDocumentoEsternoBaseDomain implements IDownloadable {

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "PROGR_DOCUMENTO", nullable = false)
    Integer progressivo

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA", nullable = false)
    AnaAnagrafe anagrafe

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TIPO_DOCUMENTO", nullable = false)
    AnaTipoDocumento tipoDocumento

    @Column(name = "NUMERO", nullable = true)
    String numero

    @Enumerated(EnumType.STRING)
    @Column(name = "NATURA_DOCUMENTO", nullable = true)
    ENaturaDocumento natura

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EMISSIONE", nullable = true)
    Date dataEmissione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ENTE_EMISSIONE", nullable = true)
    AnaEnte ente

    @Embedded
    @AttributeOverrides([@AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ENTE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ENTE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ENTE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ENTE", updatable = false, insertable = false))])
    private Comune comuneEnte

    Comune getComuneEnte() {
        if (comuneEnte == null) {
            comuneEnte = new Comune()
        }
        return comuneEnte
    }

    void setComuneEnte(Comune c) {
        this.comuneEnte = c
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_SCADENZA", nullable = true)
    Date dataScadenza

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_SCADENZA_ILLIMITATA", nullable = true)
    Boolean scadenzaIllimitata

    @Enumerated(EnumType.STRING)
    @Column(name = "ESPATRIO", nullable = true)
    ETipoSN espatrio

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CATEGORIA", nullable = true)
    AnaCategoria categoria

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MOTIVO_DOCUMENTO", nullable = true)
    AnaMotivoRilascio motivoRilascio

    @Column(name = "NOTE", nullable = false)
    String note

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG", nullable = true)
    Date dataRegistrazione

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "documento")
    List<AnaDocumentoAllegato> allegati

    Long getNumeroAllegati() {
        return allegati.size()
    }

    @Override
    boolean canDownload() {
        return idDocumentoEsterno != null && allegati.any({ it.canDownload() })
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Tipo_Documento"), Etichette.getEtichetta("Natura_Documento"), Etichette.getEtichetta("Del"), Etichette.getEtichetta("Numero"),
                                              Etichette.getEtichetta("Data_emissione"), Etichette.getEtichetta("Data_Scadenza"), Etichette.getEtichetta("Scadenza_Illimitata"),
                                              Etichette.getEtichetta("Espatrio"), Etichette.getEtichetta("Categoria"), Etichette.getEtichetta("Ente"), Etichette.getEtichetta("Comune_Ente"), Etichette.getEtichetta("Allegati"),
                                              Etichette.getEtichetta("Note"), Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Altri_Dati"),Etichette.getEtichetta("Allegato"),
                                              Etichette.getEtichetta("Nessun_Documento_Presente"), Etichette.getEtichetta("Progressivo"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Motivo_Rilascio")]

}
