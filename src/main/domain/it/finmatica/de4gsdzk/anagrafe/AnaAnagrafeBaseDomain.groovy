package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.AnagrafeBaseDomain
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.DocumentoIdentita
import it.finmatica.de4gsdzk.statocivile.embed.DocumentoSoggiorno
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe.IndirizzoNonResidenteAnagrafe
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe.IndirizzoResidenteAnagrafe
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.anagrafe.IndirizzoResidenteEsteroAnagrafe
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IIndirizzoAnagrafe

import javax.persistence.*

@MappedSuperclass
abstract class AnaAnagrafeBaseDomain extends AnagrafeBaseDomain implements IConiugabile {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "STATO")
    AnaStato stato

    @Convert(converter = EFascia.EnumFasciaToIntConverter.class)
    @Column(name = "FASCIA", nullable = false)
    EFascia fascia

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_NAZ", nullable = false)
    Date dataNazionalita

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_RES", nullable = false)
    Date dataResidenza

    @Column(name = "DES_RAPPORTO_PAR", updatable = false, insertable = false)
    String rapportoParentelaDescrizione

    @Column(name = "SEQUENZA_PAR")
    Integer sequenzaParentela

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_FAM")
    Date dataInizioParentela

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_SENZA_FISSA_DIMORA", nullable = true, updatable = false, insertable = false)
    Boolean senzaFissaDimora

    @Embedded
    DocumentoIdentita documentoIdentita

    @Embedded
    DocumentoSoggiorno documentoSoggiorno

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// INDIRIZZO /////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Embedded
    private IndirizzoResidenteAnagrafe indirizzoResidente

    @Embedded
    private IndirizzoResidenteEsteroAnagrafe indirizzoResidenteEstero

    @Embedded
    private IndirizzoNonResidenteAnagrafe indirizzoNonResidente

    IIndirizzoAnagrafe getIndirizzo() {
        return AnagrafeUtils.getIndirizzo(this.fascia,
                this.indirizzoResidente,
                this.indirizzoResidenteEstero,
                this.indirizzoNonResidente) as IIndirizzoAnagrafe
    }

    // TODO: rimuovi getter obsoleti
    Comune getComuneResidenza() {
        indirizzo?.comune
    }

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// NASCITA ///////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_NAS")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_NAS")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_NAS")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_NAS")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_NAS")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_NAS_DIGITALE"))
    ])
    EstremiAtto attoNascita

    EstremiAtto getAttoNascita() {
        if (attoNascita == null) {
            attoNascita = new EstremiAtto()
        }
        return attoNascita
    }

    void setAttoNascita(EstremiAtto attoNascita) {
        this.attoNascita = attoNascita
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_NAS")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_NAS", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_NAS")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_NAS", updatable = false, insertable = false))
    ])
    private Comune comuneAttoNascita

    Comune getComuneAttoNascita() {
        if (comuneAttoNascita == null) {
            comuneAttoNascita = new Comune()
        }
        return comuneAttoNascita
    }

    void setComuneAttoNascita(Comune comuneNascita) {
        this.comuneAttoNascita = comuneNascita
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_NAS_TR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_NAS_TR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_NAS_TR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_NAS_TR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_NAS_TR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_NAS_TR_DIGITALE"))
    ])
    EstremiAtto attoNascitaTrascritto

    EstremiAtto getAttoNascitaTrascritto() {
        if (attoNascitaTrascritto == null) {
            attoNascitaTrascritto = new EstremiAtto()
        }
        return attoNascitaTrascritto
    }

    void setAttoNascitaTrascritto(EstremiAtto attoNascitaTrascritto) {
        this.attoNascitaTrascritto = attoNascitaTrascritto
    }

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// MORTE /////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MOR", nullable = false)
    Date dataMorte

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_MOR")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_MOR", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_MOR")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_MOR", updatable = false, insertable = false))
    ])
    private Comune comuneMorte

    Comune getComuneMorte() {
        if (comuneMorte == null) {
            comuneMorte = new Comune()
        }
        return comuneMorte
    }

    void setComuneMorte(Comune comuneMorte) {
        this.comuneMorte = comuneMorte
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MOR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MOR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MOR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MOR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MOR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MOR_DIGITALE"))
    ])
    EstremiAtto attoMorte

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_MOR")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_MOR", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_MOR")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_MOR", updatable = false, insertable = false))
    ])
    private Comune comuneAttoMorte

    Comune getComuneAttoMorte() {
        if (comuneAttoMorte == null) {
            comuneAttoMorte = new Comune()
        }
        return comuneAttoMorte
    }

    void setComuneAttoMorte(Comune comuneMorte) {
        this.comuneAttoMorte = comuneMorte
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MOR_TR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MOR_TR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MOR_TR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MOR_TR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MOR_TR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MOR_TR_DIGITALE"))
    ])
    EstremiAtto attoMorteTrascritto

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// MATRIMONIO ////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MAT", nullable = false)
    Date dataMatrimonio

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_MAT")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_MAT", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_MAT")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_MAT", updatable = false, insertable = false))
    ])
    private Comune comuneMatrimonio

    Comune getComuneMatrimonio() {
        if (comuneMatrimonio == null) {
            comuneMatrimonio = new Comune()
        }
        return comuneMatrimonio
    }

    void setComuneMatrimonio(Comune comuneMatrimonio) {
        this.comuneMatrimonio = comuneMatrimonio
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MAT")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MAT")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MAT")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MAT")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MAT")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MAT_DIGITALE"))
    ])
    EstremiAtto attoMatrimonio

    EstremiAtto getAttoMatrimonio() {
        if (attoMatrimonio == null) {
            attoMatrimonio = new EstremiAtto()
        }
        return attoMatrimonio
    }

    void setAttoMatrimonio(EstremiAtto attoMatrimonio) {
        this.attoMatrimonio = attoMatrimonio
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_MAT")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_MAT", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_MAT")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_MAT", updatable = false, insertable = false))
    ])
    private Comune comuneAttoMatrimonio

    Comune getComuneAttoMatrimonio() {
        if (comuneAttoMatrimonio == null) {
            comuneAttoMatrimonio = new Comune()
        }
        return comuneAttoMatrimonio
    }

    void setComuneAttoMatrimonio(Comune comuneMatrimonio) {
        this.comuneAttoMatrimonio = comuneMatrimonio
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MAT_TR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MAT_TR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MAT_TR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MAT_TR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MAT_TR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MAT_TR_DIGITALE"))
    ])
    EstremiAtto attoMatrimonioTrascritto

    EstremiAtto getAttoMatrimonioTrascritto() {
        if (attoMatrimonioTrascritto == null) {
            attoMatrimonioTrascritto = new EstremiAtto()
        }
        return attoMatrimonioTrascritto
    }

    void setAttoMatrimonioTrascritto(EstremiAtto attoMatrimonioTrascritto) {
        this.attoMatrimonioTrascritto = attoMatrimonioTrascritto
    }

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// DIVORZIO //////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV", nullable = false)
    Date dataDivorzio

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_DIV")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_DIV", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_DIV")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_DIV", updatable = false, insertable = false))
    ])
    private Comune comuneDivorzio

    Comune getComuneDivorzio() {
        if (comuneDivorzio == null) {
            comuneDivorzio = new Comune()
        }
        return comuneDivorzio
    }

    void setComuneDivorzio(Comune comuneDivorzio) {
        this.comuneDivorzio = comuneDivorzio
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_DIV")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_DIV")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_DIV")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_DIV")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_DIV")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_DIV_DIGITALE"))
    ])
    EstremiAtto attoDivorzio

    EstremiAtto getAttoDivorzio() {
        if (attoDivorzio == null) {
            attoDivorzio = new EstremiAtto()
        }
        return attoDivorzio
    }

    void setAttoDivorzio(EstremiAtto attoDivorzio) {
        this.attoDivorzio = attoDivorzio
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_DIV")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_DIV", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_DIV")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_DIV", updatable = false, insertable = false))
    ])
    private Comune comuneAttoDivorzio

    Comune getComuneAttoDivorzio() {
        if (comuneAttoDivorzio == null) {
            comuneAttoDivorzio = new Comune()
        }
        return comuneAttoDivorzio
    }

    void setComuneAttoDivorzio(Comune comuneDivorzio) {
        this.comuneAttoDivorzio = comuneDivorzio
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV_GIU", nullable = true)
    Date dataDivorzioGiudicato

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV_ANN", nullable = true)
    Date dataDivorzioAnnotazione

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// VEDOVANZA //////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_VED", nullable = true)
    Date dataVedovanza

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_VED")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_VED", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_VED")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_VED", updatable = false, insertable = false))
    ])
    private Comune comuneVedovanza

    Comune getComuneVedovanza() {
        if (comuneVedovanza == null) {
            comuneVedovanza = new Comune()
        }
        return comuneVedovanza
    }

    void setComuneVedovanza(Comune comuneVedovanza) {
        this.comuneVedovanza = comuneVedovanza
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_VED")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_VED")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_VED")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_VED")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_VED")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_VED_DIGITALE"))
    ])
    EstremiAtto attoVedovanza

    EstremiAtto getAttoVedovanza() {
        if (attoVedovanza == null) {
            attoVedovanza = new EstremiAtto()
        }
        return attoVedovanza
    }

    void setAttoVedovanza(EstremiAtto attoVedovanza) {
        this.attoVedovanza = attoVedovanza
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_VED")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_VED", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_VED")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_VED", updatable = false, insertable = false))
    ])
    private Comune comuneAttoVedovanza

    Comune getComuneAttoVedovanza() {
        if (comuneAttoVedovanza == null) {
            comuneAttoVedovanza = new Comune()
        }
        return comuneAttoVedovanza
    }

    void setComuneAttoVedovanza(Comune comuneVedovanza) {
        this.comuneAttoVedovanza = comuneVedovanza
    }


    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// PADRE ///////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_PD", nullable = true)
    AnaAnagrafe padre

    @Column(name = "COGNOME_PD", nullable = true)
    String cognomePadre

    @Column(name = "NOME_PD", nullable = true)
    String nomePadre

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// MADRE ///////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA_MD", nullable = true)
    AnaAnagrafe madre

    @Column(name = "COGNOME_MD", nullable = true)
    String cognomeMadre

    @Column(name = "NOME_MD", nullable = true)
    String nomeMadre

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// FLAG TPR ///////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR_ENABLE_RES_I", nullable = true, updatable = false, insertable = false)
    Boolean flagResInsEnable

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR_ENABLE_RES_E", nullable = true, updatable = false, insertable = false)
    Boolean flagResVarEnable

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR_ENABLE_RES_C", nullable = true, updatable = false, insertable = false)
    Boolean flagResCancEnable

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR_ENABLE_RES_R", nullable = true, updatable = false, insertable = false)
    Boolean flagResRetEnable

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR_ENABLE_AIR_I", nullable = true, updatable = false, insertable = false)
    Boolean flagAirInsEnable

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR_ENABLE_AIR_E", nullable = true, updatable = false, insertable = false)
    Boolean flagAirVarEnable

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR_ENABLE_AIR_C", nullable = true, updatable = false, insertable = false)
    Boolean flagAirCancEnable

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_TPR_ENABLE_AIR_R", nullable = true, updatable = false, insertable = false)
    Boolean flagAirRetEnable

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// CENSIMENTO ////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    @Column(name = "ANNO_CENS", nullable = true)
    Integer annoCensimento

    @Column(name = "SEZIONE_CENS", nullable = true)
    Integer sezioneCensimento

    @Column(name = "FOGLIO_CENS", nullable = true)
    Long foglioCensimento

    @Column(name = "COD_EDIFICIO_CENS", nullable = true)
    Integer edificioCensimento

    @Column(name = "QUESTIONARIO_CENS", nullable = true)
    Long questionarioCensimento

    static final List<Map> etichetteDomain = AnagrafeBaseDomain.etichetteDomain +
            [Etichette.getEtichetta("Ultimo_Evento"),Etichette.getEtichetta("Individuo"),Etichette.getEtichetta("Atto"),Etichette.getEtichetta("Atto_Trascritto"),
             Etichette.getEtichetta("Data"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Comune_Atto"),
             Etichette.getEtichetta("Nascita"), Etichette.getEtichetta("Atto_Nascita"), Etichette.getEtichetta("Estremi_Atto_Nascita"),Etichette.getEtichetta("Atto_Nascita_Trascritto"),
             Etichette.getEtichetta("Estremi_Atto_Nascita_Trascritto"), Etichette.getEtichetta("Matrimonio"), Etichette.getEtichetta("Atto_Matrimonio"), Etichette.getEtichetta("Estremi_Atto_Matrimonio"),Etichette.getEtichetta("Estremi_Atto_Matrimonio_Trascritto"),
             Etichette.getEtichetta("Unione_Civile"), Etichette.getEtichetta("Atto_Unione_Civile"), Etichette.getEtichetta("Estremi_Atto_Unione_Civile"), Etichette.getEtichetta("Estremi_Atto_Unione_Civile_Trascritto"),
             Etichette.getEtichetta("Morte"), Etichette.getEtichetta("Atto_Morte"), Etichette.getEtichetta("Atto_Morte_Trascritto"),
             Etichette.getEtichetta("Comune_Atto"), Etichette.getEtichetta("Atto_Divorzio"), Etichette.getEtichetta("Estremi_Atto_Divorzio"), Etichette.getEtichetta("Divorzio"),
             Etichette.getEtichetta("Estremi_Atto_Scioglimento"), Etichette.getEtichetta("Scioglimento"),
             Etichette.getEtichetta("Note"), Etichette.getEtichetta("Atto_Vedovanza"), Etichette.getEtichetta("Estremi_Atto_Vedovanza"), Etichette.getEtichetta("Vedovanza"),
             Etichette.getEtichetta("Coniuge"), Etichette.getEtichetta("Contraente"), Etichette.getEtichetta("Situazione_al"),
             Etichette.getEtichetta("Professione"), Etichette.getEtichetta("Titolo_Studio"), Etichette.getEtichetta("Pensionato"),
             Etichette.getEtichetta("Rapporto_Parentela"), Etichette.getEtichetta("Data_Giudicato"), Etichette.getEtichetta("Data_Annotazione"),
             Etichette.getEtichetta("Senza_Fissa_Dimora"), Etichette.getEtichetta("Vedovanza"), Etichette.getEtichetta("Genitori"), Etichette.getEtichetta("Cognome_Padre"), Etichette.getEtichetta("Nome_Padre"),
             Etichette.getEtichetta("Documento_identita"), Etichette.getEtichetta("Documento_Soggiorno"), Etichette.getEtichetta("Cognome_Madre"), Etichette.getEtichetta("Nome_Madre"),
             Etichette.getEtichetta("Altri_Dati"), Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"),
             Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Id_Atto_Ansc"),
             Etichette.getEtichetta("Note"), Etichette.getEtichetta("Cognome_Padre"), Etichette.getEtichetta("Nome_Padre"), Etichette.getEtichetta("Cognome_Madre"), Etichette.getEtichetta("Nome_Madre"),
             Etichette.getEtichetta("Scioglimento"), Etichette.getEtichetta("Divorzio"), Etichette.getEtichetta("Data_Annotazione"), Etichette.getEtichetta("Data_Giudicato"),
             Etichette.getEtichetta("Inibizione_Espatrio"), Etichette.getEtichetta("Dati_Censimento"), Etichette.getEtichetta("Sezione"), Etichette.getEtichetta("Foglio"), Etichette.getEtichetta("Edificio"), Etichette.getEtichetta("Questionario")
            ] as List<Map>
}
