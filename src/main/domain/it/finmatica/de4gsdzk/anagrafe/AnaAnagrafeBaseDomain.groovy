package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
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
abstract class AnaAnagrafeBaseDomain extends GsdAnagrafeBaseDomain implements IConiugabile {

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
    String rapportoParentela

    @Column(name = "SEQUENZA_PAR")
    Integer sequenzaParentela

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_FAM")
    Date dataInizioParentela

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_SENZA_FISSA_DIMORA", nullable = true)
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

    static final List<Map> etichetteDomain = GsdAnagrafeBaseDomain.etichetteDomain +
            [Etichette.Ultimo_Evento,
             Etichette.Data, Etichette.Comune, Etichette.Comune_Atto,
             Etichette.Nascita, Etichette.Atto_Nascita, Etichette.Atto_Nascita_Trascritto,
             Etichette.Matrimonio, Etichette.Atto_Matrimonio, Etichette.Atto_Matrimonio_Trascritto,
             Etichette.Unione_Civile, Etichette.Atto_Unione_Civile, Etichette.Atto_Unione_Civile_Trascritto,
             Etichette.Morte, Etichette.Atto_Morte, Etichette.Atto_Morte_Trascritto,
             Etichette.Comune_Atto, Etichette.Atto, Etichette.Atto_Trascritto,
             Etichette.Note, Etichette.Cognome_Padre, Etichette.Nome_Padre,Etichette.Cognome_Madre, Etichette.Nome_Madre,
             Etichette.Coniuge, Etichette.Contraente,
             Etichette.Professione, Etichette.Titolo_Studio, Etichette.Pensionato,
             Etichette.Rapporto_Parentela, Etichette.Inibizione_Espatrio,
             Etichette.Senza_Fissa_Dimora,
             Etichette.Documento_identita, Etichette.Documento_Soggiorno,
             Etichette.Altri_Dati,
             Etichette.Dati_Censimento,  Etichette.Anno, Etichette.Sezione, Etichette.Foglio, Etichette.Edificio, Etichette.Questionario
            ] as List<Map>
}
