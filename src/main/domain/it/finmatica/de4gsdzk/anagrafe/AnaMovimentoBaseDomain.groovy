package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.ad4.autenticazione.Ad4Utente
import it.finmatica.ad4.hibernate.UtenteUpd
import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.anagrafe.pratiche.AnaRapportoParentela
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.EStatoCivile
import it.finmatica.de4gsdzk.utils.Etichette
import org.hibernate.annotations.NotFound
import org.hibernate.annotations.NotFoundAction

import javax.persistence.*

@MappedSuperclass
abstract class AnaMovimentoBaseDomain extends GsdBaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "MATRICOLA")
    AnaAnagrafe anagrafe

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_EVE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_EVE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_EVE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_EVE", updatable = false, insertable = false))
    ])
    private Comune comuneEvento

    Comune getComuneEvento() {
        if (comuneEvento == null) {
            comuneEvento = new Comune()
        }
        return comuneEvento
    }

    void setComuneEvento(Comune comuneEvento) {
        this.comuneEvento = comuneEvento
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVE")
    Date dataEvento

    @Column(name = "DES_EVENTO")
    String descrizione

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TERMINALISTA", nullable = false)
    @UtenteUpd
    @NotFound(action = NotFoundAction.IGNORE)
    Ad4Utente utenteUpd

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SEN_PRIVACY", nullable = true)
    Boolean privato

    @Column(name = "COGNOME_PREC")
    String cognomePrecedente

    @Column(name = "COGNOME")
    String cognome

    @Column(name = "NOME_PREC")
    String nomePrecedente

    @Column(name = "NOME")
    String nome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_PREC")
    ESesso sessoPrecedente

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_PREC")
    Date dataNascitaPrecedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS")
    Date dataNascita

    @Convert(converter = EStatoCivile.EnumStatoCivileToStringConverter.class)
    @Column(name = "STATO_CIVILE_PREC")
    EStatoCivile statoCivilePrecedente

    @Column(name = "DES_STATO_CIVILE_PREC", nullable = true, updatable = false, insertable = false)
    String descrizioneStatoCivilePrecedente

    @Convert(converter = EStatoCivile.EnumStatoCivileToStringConverter.class)
    @Column(name = "STATO_CIVILE")
    EStatoCivile statoCivile

    @Column(name = "DES_STATO_CIVILE", nullable = true, updatable = false, insertable = false)
    String descrizioneStatoCivile

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_PREC", nullable = true)
    AnaCittadinanza nazionalitaPrecedente

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA", nullable = true)
    AnaCittadinanza nazionalita

    @Column(name = "COD_FISCALE_PREC")
    String codiceFiscalePrecedente

    @Column(name = "COD_FISCALE")
    String codiceFiscale

    @Column(name = "MATRICOLA_PD_PREC", nullable = true)
    Integer matricolaPadrePrecedente

    @Column(name = "MATRICOLA_PD", nullable = true)
    Integer matricolaPadre

    @Column(name = "COGNOME_PD_PREC")
    String cognomePadrePrecedente

    @Column(name = "NOME_PD_PREC")
    String nomePadrePrecedente

    @Column(name = "COGNOME_PD")
    String cognomePadre

    @Column(name = "NOME_PD")
    String nomePadre

    @Column(name = "MATRICOLA_MD_PREC", nullable = true)
    Integer matricolaMadrePrecedente

    @Column(name = "MATRICOLA_MD", nullable = true)
    Integer matricolaMadre

    @Column(name = "COGNOME_MD_PREC")
    String cognomeMadrePrecedente

    @Column(name = "NOME_MD_PREC")
    String nomeMadrePrecedente

    @Column(name = "COGNOME_MD")
    String cognomeMadre

    @Column(name = "NOME_MD")
    String nomeMadre


    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="TITOLO_STUDIO_PREC", nullable = true)
    AnaTitoloStudio titoloStudioPrecedente

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="TITOLO_STUDIO", nullable = true)
    AnaTitoloStudio titoloStudio

    @Column(name = "COD_PROF_PREC")
    Integer codiceProfessionePrecedente

    @Column(name = "COD_PROF")
    Integer codiceProfessione

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ID_ANADPR_PREC", nullable = true)
    AnaProfessione professionePrecedente

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ID_ANADPR", nullable = true)
    AnaProfessione professione

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ATTIVITA_PROF_PREC", nullable = true)
    AnaAttivita attivitaProfessionalePrecedente

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ATTIVITA_PROF", nullable = true)
    AnaAttivita attivitaProfessionale

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="POSIZIONE_PROF_PREC", nullable = true)
    AnaPosizioneProfessionale posizioneProfessionalePrecedente

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="POSIZIONE_PROF", nullable = true)
    AnaPosizioneProfessionale posizioneProfessionale

    @Column(name = "RAPPORTO_PAR_PREC")
    String codiceRapportoParentelaPrecedente

    @Column(name = "RAPPORTO_PAR")
    String codiceRapportoParentela

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ID_ANADRP_PREC", nullable = true)
    AnaRapportoParentela rapportoParentelaPrecedente

    @ManyToOne(fetch= FetchType.LAZY)
    @JoinColumn(name="ID_ANADRP", nullable = true)
    AnaRapportoParentela rapportoParentela

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "PENSIONATO_PREC")
    Boolean pensionatoPrecedente

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "PENSIONATO")
    Boolean pensionato

    @Column(name = "COD_FAM_PREC")
    Long codiceFamigliaPrecedente

    @Column(name = "COD_FAM")
    Long codiceFamiglia

    @Column(name = "COGNOME_INTESTATARIO_PREC")
    String cognomeIntestatarioPrecedente

    @Column(name = "NOME_INTESTATARIO_PREC")
    String nomeIntestatarioPrecedente

    @Column(name = "COGNOME_INTESTATARIO")
    String cognomeIntestatario

    @Column(name = "NOME_INTESTATARIO")
    String nomeIntestatario

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_FAM")
    Date dataInizioFamiglia

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COD_VIA_PREC", nullable = true)
    ArcVia viaPrecedente

    @Column(name = "NUM_CIV_PREC")
    Integer numeroCivicoPrecedente

    @Column(name = "SUFFISSO_PREC")
    String suffissoPrecedente

    @Column(name = "INTERNO_PREC")
    Integer internoPrecedente

    @Column(name = "SUB_INTERNO_PREC")
    String subInternoPrecedente

    @Column(name = "SCALA_PREC")
    String scalaPrecedente

    @Column(name = "PIANO_PREC")
    String pianoPrecedente

    @Column(name = "VIA_AIRE_PREC")
    String viaAirePrecedente

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_AIRE_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_AIRE_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_AIRE_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_AIRE_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneAirePrecedente

    Comune getComuneAirePrecedente() {
        if (comuneAirePrecedente == null) {
            comuneAirePrecedente = new Comune()
        }
        return comuneAirePrecedente
    }

    void setComuneAirePrecedente(Comune comuneAirePrecedente) {
        this.comuneAirePrecedente = comuneAirePrecedente
    }

    @Column(name = "ZIPCODE_PREC")
    String zipCodePrecedente

    @Column(name = "PROVINCIA_CONTEA_PREC")
    String provinciaConteaPrecedente

    @Column(name = "PRESSO_PREC")
    String pressoPrecedente

    @Embedded
    IndirizzoCivico indirizzo

    IndirizzoCivico getIndirizzo() {
        if (indirizzo == null) {
            indirizzo = new IndirizzoCivico()
        }
        return indirizzo
    }

    @Column(name = "VIA_AIRE")
    String viaAire

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_AIRE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_AIRE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_AIRE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_AIRE", updatable = false, insertable = false))
    ])
    private Comune comuneAire

    Comune getComuneAire() {
        if (comuneAire == null) {
            comuneAire = new Comune()
        }
        return comuneAire
    }

    void setComuneAire(Comune comuneAire) {
        this.comuneAire = comuneAire
    }

    @Column(name = "ZIPCODE")
    String zipCode

    @Column(name = "PROVINCIA_CONTEA")
    String provinciaContea

    @Column(name = "PRESSO")
    String presso

    @Column(name = "ANNO_PRATICA")
    Integer annoPratica

    @Column(name = "PRATICA")
    Integer pratica

    @Column(name = "MATRICOLA_CN_PREC", nullable = true)
    Integer matricolaConiugePrecedente

    @Column(name = "COGNOME_CN_PREC")
    String cognomeConiugePrecedente

    @Column(name = "NOME_CN_PREC")
    String nomeConiugePrecedente

    @Column(name = "MATRICOLA_CN", nullable = true)
    Integer matricolaConiuge

    @Column(name = "COGNOME_CN")
    String cognomeConiuge

    @Column(name = "NOME_CN")
    String nomeConiuge

    @Column(name = "ANNO_CENS_PREC")
    Integer annoCensimentoPrecedente

    @Column(name = "SEZIONE_CENS_PREC")
    Integer sezioneCensimentoPrecedente

    @Column(name = "FOGLIO_CENS_PREC")
    Integer foglioCensimentoPrecedente

    @Column(name = "COD_EDIFICIO_CENS_PREC")
    Integer edificioCensimentoPrecedente

    @Column(name = "ANNO_CENS")
    Integer annoCensimento

    @Column(name = "SEZIONE_CENS")
    Integer sezioneCensimento

    @Column(name = "FOGLIO_CENS")
    Integer foglioCensimento

    @Column(name = "COD_EDIFICIO_CENS")
    Integer edificioCensimento

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneNascitaPrecedente

    Comune getComuneNascitaPrecedente() {
        if (comuneNascitaPrecedente == null) {
            comuneNascitaPrecedente = new Comune()
        }
        return comuneNascitaPrecedente
    }

    void setComuneNascitaPrecedente(Comune comuneNascitaPrecedente) {
        this.comuneNascitaPrecedente = comuneNascitaPrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_NAS_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_NAS_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_NAS_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_NAS_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneAttoNascitaPrecedente

    Comune getComuneAttoNascitaPrecedente() {
        if (comuneAttoNascitaPrecedente == null) {
            comuneAttoNascitaPrecedente = new Comune()
        }
        return comuneAttoNascitaPrecedente
    }

    void setComuneAttoNascitaPrecedente(Comune comuneAttoNascitaPrecedente) {
        this.comuneAttoNascitaPrecedente = comuneAttoNascitaPrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_NAS_PREC")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_NAS_PREC")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_NAS_PREC")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_NAS_PREC")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_NAS_PREC")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_NAS_DIGITALE_PREC"))
    ])
    EstremiAtto attoNascitaPrecedente

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_NAS_TR_PREC")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_NAS_TR_PREC")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_NAS_TR_PREC")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_NAS_TR_PREC")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_NAS_TR_PREC")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_NAS_TR_DIGITALE_PREC"))
    ])
    EstremiAtto attoNascitaTrascrittoPrecedente

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS", updatable = false, insertable = false))
    ])
    private Comune comuneNascita

    Comune getComuneNascita() {
        if (comuneNascita == null) {
            comuneNascita = new Comune()
        }
        return comuneNascita
    }

    void setComuneNascita(Comune comuneNascita) {
        this.comuneNascita = comuneNascita
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

    void setComuneAttoNascita(Comune comuneAttoNascita) {
        this.comuneAttoNascita = comuneAttoNascita
    }

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
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_NAS_TR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_NAS_TR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_NAS_TR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_NAS_TR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_NAS_TR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_NAS_TR_DIGITALE"))
    ])
    EstremiAtto attoNascitaTrascritto

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_NAS_PREC")
    Boolean annoNascitaPrecedente

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_NAS")
    Boolean annoNascita

    @Column(name = "MATRICOLA_AIRE_PREC")
    String matricolaAirePrecedente

    @Column(name = "MATRICOLA_AIRE")
    String matricolaAire

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ISCR_AIRE")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ISCR_AIRE", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ISCR_AIRE")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ISCR_AIRE", updatable = false, insertable = false))
    ])
    private Comune comuneIscrizioneAire

    Comune getComuneIscrizioneAire() {
        if (comuneIscrizioneAire == null) {
            comuneIscrizioneAire = new Comune()
        }
        return comuneIscrizioneAire
    }

    void setComuneIscrizioneAire(Comune comuneIscrizioneAire) {
        this.comuneIscrizioneAire = comuneIscrizioneAire
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO_PREC")
    Boolean cfCalcolatoPrecedente

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO")
    Boolean cfCalcolato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "NO_CONTEGGIO")
    Boolean noConteggio

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG")
    Date dataRegistrazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_NAZ_PREC")
    Date dataNazionalitaPrecedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_INIZIO_NAZ")
    Date dataNazionalita

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MAT_PREC")
    Date dataMatrimonioPrecedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MAT")
    Date dataMatrimonio

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_VED_PREC")
    Date dataVedovanzaPrecedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_VED")
    Date dataVedovanza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV_PREC")
    Date dataDivorzioPrecedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV_GIU_PREC")
    Date dataDivorzioGiudicatoPrecedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV_ANN_PREC")
    Date dataDivorzioAnnotazionePrecedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV")
    Date dataDivorzio

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV_GIU")
    Date dataDivorzioGiudicato

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DIV_ANN")
    Date dataDivorzioAnnotazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MOR_PREC")
    Date dataMortePrecedente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MOR")
    Date dataMorte

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_MAT_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_MAT_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_MAT_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_MAT_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneMatrimonioPrecedente

    Comune getComuneMatrimonioPrecedente() {
        if (comuneMatrimonioPrecedente == null) {
            comuneMatrimonioPrecedente = new Comune()
        }
        return comuneMatrimonioPrecedente
    }

    void setComuneMatrimonioPrecedente(Comune comuneMatrimonioPrecedente) {
        this.comuneMatrimonioPrecedente = comuneMatrimonioPrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_MAT_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_MAT_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_MAT_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_MAT_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneAttoMatrimonioPrecedente

    Comune getComuneAttoMatrimonioPrecedente() {
        if (comuneAttoMatrimonioPrecedente == null) {
            comuneAttoMatrimonioPrecedente = new Comune()
        }
        return comuneAttoMatrimonioPrecedente
    }

    void setComuneAttoMatrimonioPrecedente(Comune comuneAttoMatrimonioPrecedente) {
        this.comuneAttoMatrimonioPrecedente = comuneAttoMatrimonioPrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MAT_PREC")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MAT_PREC")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MAT_PREC")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MAT_PREC")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MAT_PREC")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MAT_DIGITALE_PREC"))
    ])
    EstremiAtto attoMatrimonioPrecedente

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MAT_TR_PREC")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MAT_TR_PREC")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MAT_TR_PREC")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MAT_TR_PREC")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MAT_TR_PREC")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MAT_TR_DIGITALE_PREC"))
    ])
    EstremiAtto attoMatrimonioTrascrittoPrecedente

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

    void setComuneAttoMatrimonio(Comune comuneAttoMatrimonio) {
        this.comuneAttoMatrimonio = comuneAttoMatrimonio
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
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MAT_TR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MAT_TR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MAT_TR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MAT_TR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MAT_TR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MAT_TR_DIGITALE"))
    ])
    EstremiAtto attoMatrimonioTrascritto

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_MAT_PREC")
    Boolean annoMatrimonioPrecedente

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "ANNO_MAT")
    Boolean annoMatrimonio

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_VED_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_VED_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_VED_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_VED_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneVedovanzaPrecedente

    Comune getComuneVedovanzaPrecedente() {
        if (comuneVedovanzaPrecedente == null) {
            comuneVedovanzaPrecedente = new Comune()
        }
        return comuneVedovanzaPrecedente
    }

    void setComuneVedovanzaPrecedente(Comune comuneVedovanzaPrecedente) {
        this.comuneVedovanzaPrecedente = comuneVedovanzaPrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_VED_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_VED_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_VED_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_VED_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneAttoVedovanzaPrecedente

    Comune getComuneAttoVedovanzaPrecedente() {
        if (comuneAttoVedovanzaPrecedente == null) {
            comuneAttoVedovanzaPrecedente = new Comune()
        }
        return comuneAttoVedovanzaPrecedente
    }

    void setComuneAttoVedovanzaPrecedente(Comune comuneAttoVedovanzaPrecedente) {
        this.comuneAttoVedovanzaPrecedente = comuneAttoVedovanzaPrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_VED_PREC")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_VED_PREC")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_VED_PREC")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_VED_PREC")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_VED_PREC")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_VED_DIGITALE_PREC"))
    ])
    EstremiAtto attoVedovanzaPrecedente

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

    void setComuneAttoVedovanza(Comune comuneAttoVedovanza) {
        this.comuneAttoVedovanza = comuneAttoVedovanza
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

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_DIV_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_DIV_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_DIV_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_DIV_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneDivorzioPrecedente

    Comune getComuneDivorzioPrecedente() {
        if (comuneDivorzioPrecedente == null) {
            comuneDivorzioPrecedente = new Comune()
        }
        return comuneDivorzioPrecedente
    }

    void setComuneDivorzioPrecedente(Comune comuneDivorzioPrecedente) {
        this.comuneDivorzioPrecedente = comuneDivorzioPrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_DIV_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_DIV_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_DIV_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_DIV_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneAttoDivorzioPrecedente

    Comune getComuneAttoDivorzioPrecedente() {
        if (comuneAttoDivorzioPrecedente == null) {
            comuneAttoDivorzioPrecedente = new Comune()
        }
        return comuneAttoDivorzioPrecedente
    }

    void setComuneAttoDivorzioPrecedente(Comune comuneAttoDivorzioPrecedente) {
        this.comuneAttoDivorzioPrecedente = comuneAttoDivorzioPrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_DIV_PREC")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_DIV_PREC")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_DIV_PREC")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_DIV_PREC")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_DIV_PREC")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_DIV_DIGITALE_PREC"))
    ])
    EstremiAtto attoDivorzioPrecedente

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

    void setComuneAttoDivorzio(Comune comuneAttoDivorzio) {
        this.comuneAttoDivorzio = comuneAttoDivorzio
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
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_MOR_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_MOR_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_MOR_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_MOR_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneMortePrecedente

    Comune getComuneMortePrecedente() {
        if (comuneMortePrecedente == null) {
            comuneMortePrecedente = new Comune()
        }
        return comuneMortePrecedente
    }

    void setComuneMortePrecedente(Comune comuneMortePrecedente) {
        this.comuneMortePrecedente = comuneMortePrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_ATTO_MOR_PREC")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_ATTO_MOR_PREC", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_ATTO_MOR_PREC")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_MOR_PREC", updatable = false, insertable = false))
    ])
    private Comune comuneAttoMortePrecedente

    Comune getComuneAttoMortePrecedente() {
        if (comuneAttoMortePrecedente == null) {
            comuneAttoMortePrecedente = new Comune()
        }
        return comuneAttoMortePrecedente
    }

    void setComuneAttoMortePrecedente(Comune comuneAttoMortePrecedente) {
        this.comuneAttoMortePrecedente = comuneAttoMortePrecedente
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MOR_PREC")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MOR_PREC")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MOR_PREC")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MOR_PREC")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MOR_PREC")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MOR_DIGITALE_PREC"))
    ])
    EstremiAtto attoMortePrecedente

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MOR_TR_PREC")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MOR_TR_PREC")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MOR_TR_PREC")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MOR_TR_PREC")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MOR_TR_PREC")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MOR_TR_DIGITALE_PREC"))
    ])
    EstremiAtto attoMorteTrascrittoPrecedente

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

    void setComuneAttoMorte(Comune comuneAttoMorte) {
        this.comuneAttoMorte = comuneAttoMorte
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
            @AttributeOverride(name = "ufficio", column = @Column(name = "UFFICIO_MOR_TR")),
            @AttributeOverride(name = "anno", column = @Column(name = "ANNO_ATTO_MOR_TR")),
            @AttributeOverride(name = "atto", column = @Column(name = "ATTO_MOR_TR")),
            @AttributeOverride(name = "parte", column = @Column(name = "PARTE_MOR_TR")),
            @AttributeOverride(name = "serie", column = @Column(name = "SERIE_MOR_TR")),
            @AttributeOverride(name = "idAttoAnsc", column = @Column(name = "ATTO_MOR_TR_DIGITALE"))
    ])
    EstremiAtto attoMorteTrascritto

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_SOLO_CAMPI_VARIATI")
    Boolean flagSoloCampiVariati

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Nessun_dato_disponibile"), Etichette.getEtichetta("Data_Evento"), Etichette.getEtichetta("Descrizione"), Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Terminalista"),
                                              Etichette.getEtichetta("Dettaglio_Movimento"), Etichette.getEtichetta("Dettaglio_Pratica"), Etichette.getEtichetta("Numero"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Conteggio"),
                                              Etichette.getEtichetta("Comune_Evento"), Etichette.getEtichetta("Comune_Iscrizione_Aire"),
                                              Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"),
                                              Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Data_Nascita_Solo_Anno"), Etichette.getEtichetta("Comune_Nascita"), Etichette.getEtichetta("Comune_Atto_Nascita"),
                                              Etichette.getEtichetta("Atto_Nascita"), Etichette.getEtichetta("Atto_Nascita_Trascritto"),
                                              Etichette.getEtichetta("Stato_Civile"), Etichette.getEtichetta("Nazionalita"), Etichette.getEtichetta("Data_Nazionalita"), Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("CF_Calcolato"),
                                              Etichette.getEtichetta("Paternita"), Etichette.getEtichetta("Cognome_Padre"), Etichette.getEtichetta("Nome_Padre"), Etichette.getEtichetta("Matricola_Padre"),
                                              Etichette.getEtichetta("Maternita"), Etichette.getEtichetta("Cognome_Madre"), Etichette.getEtichetta("Nome_Madre"), Etichette.getEtichetta("Matricola_Madre"),
                                              Etichette.getEtichetta("Titolo_Studio"), Etichette.getEtichetta("Professione"), Etichette.getEtichetta("Attivita_Professionale"), Etichette.getEtichetta("Posizione_Professionale"), Etichette.getEtichetta("Pensionato"),
                                              Etichette.getEtichetta("Codice_Famiglia"), Etichette.getEtichetta("Cognome_Intestatario"), Etichette.getEtichetta("Nome_Intestatario"), Etichette.getEtichetta("Intestatario"), Etichette.getEtichetta("Rapporto_Parentela"),
                                              Etichette.getEtichetta("Indirizzo"), Etichette.getEtichetta("Via"), Etichette.getEtichetta("Civico"), Etichette.getEtichetta("Suffisso"), Etichette.getEtichetta("Interno"), Etichette.getEtichetta("Sub_Interno"),
                                              Etichette.getEtichetta("Scala"), Etichette.getEtichetta("Piano"),
                                              Etichette.getEtichetta("Metrico"), Etichette.getEtichetta("Progr_SNC"), Etichette.getEtichetta("Lettera"),
                                              Etichette.getEtichetta("Esponente"), Etichette.getEtichetta("Colore"), Etichette.getEtichetta("Corte"),
                                              Etichette.getEtichetta("Interno2"), Etichette.getEtichetta("Esponente_Interno2"), Etichette.getEtichetta("Secondario"),
                                              Etichette.getEtichetta("NUI"), Etichette.getEtichetta("NUI_Valore"),
                                              Etichette.getEtichetta("Residenza"),
                                              Etichette.getEtichetta("Via_AIRE"), Etichette.getEtichetta("Comune_AIRE"), Etichette.getEtichetta("Zipcode"), Etichette.getEtichetta("Provincia_Contea"), Etichette.getEtichetta("Presso"), Etichette.getEtichetta("Matricola_AIRE"),
                                              Etichette.getEtichetta("Cognome_Coniuge"), Etichette.getEtichetta("Nome_Coniuge"), Etichette.getEtichetta("Matricola_Coniuge"),
                                              Etichette.getEtichetta("Dati_Censimento"), Etichette.getEtichetta("Anno_Censimento"), Etichette.getEtichetta("Sezione"), Etichette.getEtichetta("Sez_Censimento"), Etichette.getEtichetta("Foglio"), Etichette.getEtichetta("Foglio_Censimento"),
                                              Etichette.getEtichetta("Edificio"), Etichette.getEtichetta("Edificio_Censimento"),
                                              Etichette.getEtichetta("Data_Matrimonio"), Etichette.getEtichetta("Data_Matrimonio_Solo_Anno"), Etichette.getEtichetta("Comune_Matrimonio"), Etichette.getEtichetta("Comune_Atto_Matrimonio"),
                                              Etichette.getEtichetta("Atto_Matrimonio"), Etichette.getEtichetta("Atto_Matrimonio_Trascritto"),
                                              Etichette.getEtichetta("Data_Vedovanza"), Etichette.getEtichetta("Comune_Vedovanza"), Etichette.getEtichetta("Comune_Atto_Vedovanza"), Etichette.getEtichetta("Atto_Vedovanza"),
                                              Etichette.getEtichetta("Data_Divorzio"), Etichette.getEtichetta("Data_Divorzio_Giudicato"), Etichette.getEtichetta("Data_Divorzio_Annotazione"),
                                              Etichette.getEtichetta("Comune_Divorzio"), Etichette.getEtichetta("Comune_Atto_Divorzio"), Etichette.getEtichetta("Atto_Divorzio"),
                                              Etichette.getEtichetta("Data_Morte"), Etichette.getEtichetta("Comune_Morte"), Etichette.getEtichetta("Comune_Atto_Morte"), Etichette.getEtichetta("Atto_Morte"), Etichette.getEtichetta("Atto_Morte_Trascritto"),
                                              Etichette.getEtichetta("Dettaglio_Provvedimento"), Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Data"), Etichette.getEtichetta("Ente"), Etichette.getEtichetta("Comune"),
                                              Etichette.getEtichetta("Motivazione"), Etichette.getEtichetta("Privacy"), Etichette.getEtichetta("Dettaglio_Trascrizione"), Etichette.getEtichetta("Atto_Trascritto")]
}
