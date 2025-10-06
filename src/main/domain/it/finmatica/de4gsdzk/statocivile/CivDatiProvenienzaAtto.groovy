package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.ISoggettoCollegato
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.ansc.AnscConsolato
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula

import javax.persistence.*

@Entity
@Table(name = "CIVDPA_V")
class CivDatiProvenienzaAtto extends GsdBaseDomain implements ISoggettoCollegato, IRiferimentoAttoDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Column(name = "TIPO_ATTO")
    Integer tipoAtto

    @Column(name = "NOTA_RIF", nullable = true)
    private String notaRif

    String getNotaRif() {
        return notaRif
    }

    void setNotaRif(String val) {
        this.notaRif = val
    }

    @Column(name = "ANNO_NOTA_RIF", nullable = true)
    String annoNotaRif

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NOTA_RIF", nullable = true)
    Date dataNotaRif

    @Column(name = "PROTOCOLLO", nullable = true)
    String numeroProtocollo

    @Column(name = "ANNO_PROTOCOLLO", nullable = true)
    String annoProtocollo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROTOCOLLO", nullable = true)
    Date dataProtocollo

    @Column(name = "NEL_NAS", nullable = true)
    String nelLuogoNascita

    @Column(name = "LUOGO_NAS", nullable = true)
    String luogoNascita

    @Column(name = "NEL_MAT", nullable = true)
    String nelLuogoMatrimonio

    @Column(name = "LUOGO_MAT", nullable = true)
    String luogoMatrimonio

    @Column(name = "MINISTRO", nullable = true)
    String ministro

    // Non mappo QUALITA_2 perché abbiamo accorpato i 2 campi
    @Column(name = "QUALITA_1", nullable = true)
    String qualita

    @Column(name = "MINISTRO_ART", nullable = true)
    String celebrante

    @Column(name = "RITO", nullable = true)
    String rito

    @Column(name = "DOCUMENTO_TES", nullable = true)
    String documentoDecesso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DOCUMENTO_TES", nullable = true)
    Date dataDocumentoDecesso

    @Column(name = "RICEVUTO", nullable = true)
    String ricevuto

    @Column(name = "NEL_MOR", nullable = true)
    String nelLuogoMorte

    @Column(name = "LUOGO_MOR_1", nullable = true)
    String luogoMorte1

    @Column(name = "TIPO_DICHIARANTE", nullable = true)
    String tipoDichiarante

    @Column(name = "TIPO_COMPARENTE", nullable = true)
    String tipoComparente

    @Column(name = "TIPO_FIRMATARIO", nullable = true)
    String tipoFirmatario

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ADDETTO_DICHIARAZIONE_CNA", nullable = true)
    ETipoAddettoDichiarazione tipoAddettoDichiarazione

    // Per le TEP (nascite, matrimoni, unioni civili)
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICHIESTA_TRASCRIZIONE", nullable = true)
    ETipoRichiestaTrascrizione tipoRichiestaTrascrizione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_RICHIESTA_TRASCRIZIONE", nullable = true)
    Date dataRichiestaTrascrizione

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////// ATTO ORIGINALE /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ATTO_ORIG", nullable = true)
    Date dataAttoOriginale

    @Column(name = "ORE_ATTO_ORIG", nullable = true)
    String oraAttoOriginale

    @Column(name = "MINUTI_ATTO_ORIG", nullable = true)
    String minutoAttoOriginale

    @Column(name = "UFFICIO_ORIG", nullable = true)
    Integer ufficioAttoOriginale

    @Column(name = "ANNO_ORIG", nullable = true)
    Integer annoAttoOriginale

    @Column(name = "ATTO_ORIG", nullable = true)
    Integer attoAttoOriginale

    @Column(name = "PARTE_ORIG", nullable = true)
    Integer parteAttoOriginale

    @Column(name = "SERIE_ORIG", nullable = true)
    private String serieAttoOriginale

    String getSerieAttoOriginale() {
        return serieAttoOriginale
    }

    void setSerieAttoOriginale(String val) {
        this.serieAttoOriginale = val?.toUpperCase()
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_ATTO_ORIG")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ATTO_ORIG", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_ATTO_ORIG")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_ORIG", updatable = false, insertable = false))
    ])
    private Comune comuneAttoOriginale

    Comune getComuneAttoOriginale() {
        if (comuneAttoOriginale == null){
            comuneAttoOriginale = new Comune()
        }
        return comuneAttoOriginale
    }

    void setComuneAttoOriginale(Comune c) {
        this.comuneAttoOriginale = c
    }

    @Column(name = "AUTORITA_ATTO_ORIG", nullable = true)
    String autoritaAttoOriginale

    @Column(name = "ID_ATTO_ANSC_ORIG", nullable = true)
    String idAttoAnscAttoOriginale

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// PROVENIENZA //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    //Riutilizziamo il campo frazione per il dato che nella nuova analisi rappresenta l'ufficio di provenienza
    @Column(name = "FRAZIONE_PROV", nullable = true)
    String frazione

    @Column(name = "AUTORITA_PROV", nullable = true)
    String autorita

    @Column(name = "UFFICIALE_PROV", nullable = true)
    String ufficiale

    @Column(name = "QUALIFICA_PROV", nullable = true)
    String qualifica

    @Column(name = "COMUNE_PROV", nullable = true)
    private String comune

    String getComune() {
        return comune
    }

    void setComune(String comune) {
        this.comune = comune
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_PROV")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_PROV", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_PROV")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_PROV", updatable = false, insertable = false))
    ])
    private Comune comuneProvenienza

    Comune getComuneProvenienza() {
        if (comuneProvenienza == null){
            comuneProvenienza = new Comune()
        }
        return comuneProvenienza
    }

    void setComuneProvenienza(Comune comuneProvenienza) {
        this.comuneProvenienza = comuneProvenienza
    }

    @Column(name = "AUTORITA_PROV_EMAIL", nullable = true)
    String emailAutorita

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CONSOLATO_ANSC_PROV", nullable = true)
    AnscConsolato consolato

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// REDAZIONE ////////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIALE_UTENTE", nullable = true)
    String ufficialeUtente

    @Column(name = "QUALIFICA_UTENTE", nullable = true)
    String qualificaUtente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ATTO_UTENTE", nullable = true)
    Date dataAtto

    @Column(name = "ORE_ATTO_UTENTE", nullable = true)
    String oraAtto

    @Column(name = "MINUTI_ATTO_UTENTE", nullable = true)
    String minutoAtto

    ////////////////////////////////////////////////////////////////////////
    //////////////////// ANNOTAZIONI AUTOMATICHE ///////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "FORMULA_ANN_ATTO_NAS_1", nullable = true)
    String formulaDfaAnnotazioneNascita1

    @Column(name = "FORMULA_ANN_ATTO_NAS_2", nullable = true)
    String formulaDfaAnnotazioneNascita2

    @Column(name = "FORMULA_ANN_ATTO_MAT", nullable = true)
    String formulaDfaAnnotazioneMatrimonio

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// DICHIARANTE //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COGNOME_DIC", nullable = true)
    String cognomeDichiarante

    String getCognome(){
        return cognomeDichiarante
    }
    void setCognome(String s){
        this.cognomeDichiarante = s
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_DIC", nullable = true)
    Boolean senzaCognomeDichiarante

    @Column(name = "NOME_DIC", nullable = true)
    String nomeDichiarante

    String getNome(){
        return nomeDichiarante
    }
    void setNome(String s){
        this.nomeDichiarante = s
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_DIC", nullable = true)
    Boolean senzaNomeDichiarante

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_DIC", nullable = true)
    ESesso sessoDichiarante

    ESesso getSesso(){
        return sessoDichiarante
    }

    void setSesso(ESesso s){
        this.sessoDichiarante = s
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_DIC", nullable = false)
    Date dataNascitaDichiarante

    Date getDataNascita(){
        return dataNascitaDichiarante
    }

    void setDataNascita(Date d){
        this.dataNascitaDichiarante = d
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_NAS_DIC")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_NAS_DIC", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_NAS_DIC")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_DIC", updatable = false, insertable = false))
    ])
    private Comune comuneNascitaDichiarante

    Comune getComuneNascitaDichiarante() {
        if (comuneNascitaDichiarante == null){
            comuneNascitaDichiarante = new Comune()
        }
        return comuneNascitaDichiarante
    }

    void setComuneNascitaDichiarante(Comune c) {
        this.comuneNascitaDichiarante = c
    }

    Comune getComuneNascita(){
        return getComuneNascitaDichiarante()
    }

    void setComuneNascita(Comune c){
        setComuneNascitaDichiarante(c)
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES_DIC")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES_DIC", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES_DIC")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_DIC", updatable = false, insertable = false))
    ])
    private Comune comuneResidenzaDichiarante

    Comune getComuneResidenzaDichiarante() {
        if (comuneResidenzaDichiarante == null){
            comuneResidenzaDichiarante = new Comune()
        }
        return comuneResidenzaDichiarante
    }

    void setComuneResidenzaDichiarante(Comune c) {
        this.comuneResidenzaDichiarante = c
    }

    Comune getComuneResidenza(){
        return getComuneResidenzaDichiarante()
    }

    void setComuneResidenza(Comune c){
        setComuneResidenzaDichiarante(c)
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_DIC", nullable = true)
    AnaNazionalita nazionalitaDichiarante

    AnaNazionalita getNazionalita(){
        return nazionalitaDichiarante
    }

    void setNazionalita(AnaNazionalita n){
        this.nazionalitaDichiarante = n
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name = "COMPRENSIONE_DIC", nullable = true)
    CivTipoComprensione comprensioneDichiarante

    @Column(name = "MOTIVO_IMPEDIMENTO_DIC", nullable = true)
    String motivoImpedimentoDichiarante

    @Column(name = "NUMERO_DOCUMENTO_DIC", nullable = true)
    private String numeroDocumentoDichiarante

    String getNumeroDocumentoDichiarante() {
        return numeroDocumentoDichiarante
    }

    void setNumeroDocumentoDichiarante(String val) {
        this.numeroDocumentoDichiarante = (val?.toUpperCase())
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_DOCUMENTO_DIC", nullable = true)
    ETipoDocumentoRiconoscimento tipoDocumentoDichiarante

    @Convert(converter=EnumToIntConverter.class)
    @Column(name = "ENTE_DOCUMENTO_DIC", nullable = true)
    ETipoEnteEmittente enteDocumentoDichiarante

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_SCADENZA_DOCUMENTO_DIC")
    Date dataScadenzaDocumentoDichiarante

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EMISSIONE_DOCUMENTO_DIC")
    Date dataEmissioneDocumentoDichiarante

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_PRIVATO_DIC", nullable = true)
    Boolean flagRichiestaDaPrivatoDichiarante

    boolean isRichiestaDaPrivatoDichiarante() {
        return flagRichiestaDaPrivatoDichiarante ?: false
    }

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// AVVOCATI ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "AVVOCATO_SPOSO", nullable = true)
    private String avvocato1

    String getAvvocato1() {
        return avvocato1
    }

    void setAvvocato1(String s) {
        this.avvocato1 = s
    }

    @Column(name = "AVVOCATO_SPOSO_COGNOME", nullable = true)
    String cognomeAvvocato1

    @Column(name = "AVVOCATO_SPOSO_NOME", nullable = true)
    String nomeAvvocato1

    @Column(name = "SEDE_AVVOCATO_SPOSO", nullable = true)
    String sedeAvvocato1

    @Column(name = "FORO_AVVOCATO_SPOSO", nullable = true)
    String foroAvvocato1

    @Column(name = "AVVOCATO_SPOSA", nullable = true)
    private String avvocato2

    String getAvvocato2() {
        return avvocato2
    }

    void setAvvocato2(String s) {
        this.avvocato2 = s
    }

    @Column(name = "AVVOCATO_SPOSA_COGNOME", nullable = true)
    String cognomeAvvocato2

    @Column(name = "AVVOCATO_SPOSA_NOME", nullable = true)
    String nomeAvvocato2

    @Column(name = "SEDE_AVVOCATO_SPOSA", nullable = true)
    String sedeAvvocato2

    @Column(name = "FORO_AVVOCATO_SPOSA", nullable = true)
    String foroAvvocato2

    @Column(name = "RICEZIONE_ATTO_AVVOCATI", nullable = true)
    Integer ricezioneAttoAvvocati

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////// TIPO DIVORZIO /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_DIVORZIO", nullable = true)
    ETipoDivorzio tipoDivorzio

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_DIVORZIO_ALTRO", nullable = true)
    ETipoDivorzioAltro tipoDivorzioAltro

    Boolean isDivorzio(){
        return ([ETipoDivorzio.C, ETipoDivorzio.S].contains(tipoDivorzio))
    }

    Boolean isMancataConfermaAccordo(ETipoAtto tipoAttoEnum){
        if (tipoAttoEnum?.equals(ETipoAtto.UCI)){
            return (tipoDivorzioAltro == ETipoDivorzioAltro.M)
        } else {
            return ((tipoDivorzio == ETipoDivorzio.A) && (tipoDivorzioAltro == ETipoDivorzioAltro.M))
        }
    }

    Boolean isModificaCondizioneSeparazione(){
        return ( (tipoDivorzio == ETipoDivorzio.A) && (tipoDivorzioAltro == ETipoDivorzioAltro.C) )
    }

    Boolean isModificaCondizioneDivorzio(){
        return ( (tipoDivorzio == ETipoDivorzio.A) && (tipoDivorzioAltro == ETipoDivorzioAltro.D) )
    }

    Boolean isModificaCondizioniSeparazioneODivorzio(){
        return (isModificaCondizioneSeparazione() || isModificaCondizioneDivorzio())
    }

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////////// ACCORDO //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "ACCORDO_UFFICIO", nullable = true)
    Integer ufficioAccordo

    @Column(name = "ACCORDO_ANNO", nullable = true)
    Integer annoAccordo

    @Column(name = "ACCORDO_ATTO", nullable = false)
    Integer attoAccordo

    @Column(name = "ACCORDO_PARTE", nullable = true)
    Integer parteAccordo

    @Column(name = "ACCORDO_SERIE", nullable = true)
    private String serieAccordo

    String getSerieAccordo() {
        return serieAccordo
    }

    void setSerieAccordo(String val) {
        this.serieAccordo = val?.toUpperCase()
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_ACCORDO_DATA", nullable = true)
    Date dataAccordo

    @Column(name = "ACCORDO_NUMERO", nullable = true)
    String numeroAccordo

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "ACCORDO_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ACCORDO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "ACCORDO_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ACCORDO", updatable = false, insertable = false))
    ])
    private Comune comuneAccordo

    Comune getComuneAccordo() {
        if (comuneAccordo == null){
            comuneAccordo = new Comune()
        }
        return comuneAccordo
    }

    void setComuneAccordo(Comune c) {
        this.comuneAccordo = c
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "ACCORDO_TIPO", nullable = true)
    ETipoAccordo tipoAccordo

    // campo dismesso per https://github.com/italia/ansc/issues/377
    @Column(name = "ACCORDO_ENTE", nullable = true)
    String enteAccordo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_CONFERMA_DATA", nullable = true)
    Date dataConferma // dataConfermaAccordo

    @Column(name = "ACCORDO_ID_ATTO_ANSC", nullable = true)
    String idAttoAnscAccordo

    @Column(name = "ACCORDO_PROT_AVV_1", nullable = true)
    String protocolloAvvocato1Accordo

    @Column(name = "ACCORDO_PROT_AVV_2", nullable = true)
    String protocolloAvvocato2Accordo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_ACCORDO_DATA_COM_AVV_1", nullable = true)
    Date dataComunicazioneAvvocato1Accordo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_ACCORDO_DATA_COM_AVV_2", nullable = true)
    Date dataComunicazioneAvvocato2Accordo

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// SENTENZA //////////////////////////////
    ////////////////////////////////////////////////////////////////////////
    // Per morti e cittadinanze
    @Column(name = "SENTENZA_NUMERO", nullable = true)
    String numeroSentenza

    @Column(name = "SENTENZA_TRIBUNALE", nullable = true)
    String tribunaleSentenza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_SENTENZA_DATA", nullable = true)
    Date dataSentenza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_SENTENZA_DATA_NOTIFICA", nullable = true)
    Date dataNotificaSentenza

    ////////////////////////////////////////////////////////////////////////
    ////// Blocco campi per FCC - PDV estesi alle medesime categorie ///////
    ////// dei matrimoni a dispetto dei pedici /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "LUOGO_UCI", nullable = true)
    String luogoPvuUci

    @Column(name = "INDIRIZZO_UCI", nullable = true)
    String indirizzo

    @Column(name = "CIVICO_UCI", nullable = true)
    String civico

    @Column(name = "SEGRETARIO_UTENTE", nullable = true)
    String segretario

    @Column(name = "IMPOSSIBILITATO_UCI", nullable = true)
    String impossibilitato

    @Column(name = "CERTIFICATO_UCI", nullable = true)
    String certificato

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CERTIFICATO_UCI", nullable = true)
    Date dataCertificato

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "CERTIFICATO_UCI_COD_COM")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_CERTIFICATO_UCI", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "CERTIFICATO_UCI_COD_PRO")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_CERTIFICATO_UCI", updatable = false, insertable = false))
    ])
    private Comune comuneCertificato

    Comune getComuneCertificato() {
        if (comuneCertificato == null) {
            comuneCertificato = new Comune()
        }
        return comuneCertificato
    }

    void setComuneCertificato(Comune c) {
        this.comuneCertificato = c
    }

    @Column(name = "CERTIFICATO_UCI_ESTREMI_DOC", nullable = true)
    String estremiCertificato

    ////////////////////////////////////////////////////////////////////////
    //// Fine Blocco campi per FCC - PDV estesi alle medesime categorie ////
    //// dei matrimoni a dispetto dei pedici ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////// GIURAMENTO //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "GIURAMENTO_UFFICIO", nullable = true)
    Integer ufficioGiuramento

    @Column(name = "GIURAMENTO_ANNO", nullable = true)
    Integer annoGiuramento

    @Column(name = "GIURAMENTO_ATTO", nullable = true)
    Integer attoGiuramento

    @Column(name = "GIURAMENTO_ID_ATTO_ANSC", nullable = true)
    String idAttoAnscGiuramento

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "GIURAMENTO_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_GIURAMENTO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "GIURAMENTO_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_GIURAMENTO", updatable = false, insertable = false))
    ])
    private Comune comuneGiuramento

    Comune getComuneGiuramento() {
        if (comuneGiuramento == null){
            comuneGiuramento = new Comune()
        }
        return comuneGiuramento
    }

    void setComuneGiuramento(Comune c) {
        this.comuneGiuramento = c
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////// ATTO NOTARILE ///////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Enumerated(EnumType.STRING)
    @Formula("""CASE WHEN ATTO_NOTARILE_ENTE IS NOT NULL OR ATTO_NOTARILE_COD_PRO IS NOT NULL OR ATTO_NOTARILE_COD_COM IS NOT NULL
                OR DES_COM_ATTO_NOTARILE IS NOT NULL OR SIGLA_PRO_ATTO_NOTARILE IS NOT NULL OR ATTO_NOTARILE_ESTREMI_DOC IS NOT NULL
                OR D_ATTO_NOTARILE_DATA_DOC IS NOT NULL THEN 'SI' ELSE 'NO' END""")
    ETipoSiNo attoNotarile

    @Column(name = "ATTO_NOTARILE_ENTE", nullable = true)
    String nomeEnteNotarile

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "ATTO_NOTARILE_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ATTO_NOTARILE", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "ATTO_NOTARILE_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_NOTARILE", updatable = false, insertable = false))
    ])
    private Comune comuneAttoNotarile

    Comune getComuneAttoNotarile() {
        if (comuneAttoNotarile == null){
            comuneAttoNotarile = new Comune()
        }
        return comuneAttoNotarile
    }

    void setComuneAttoNotarile(Comune c) {
        this.comuneAttoNotarile = c
    }

    @Column(name = "ATTO_NOTARILE_ESTREMI_DOC", nullable = true)
    String estremiAttoNotarile

    @Temporal(TemporalType.DATE)
    @Column(name = "D_ATTO_NOTARILE_DATA_DOC", nullable = true)
    Date dataAttoNotarile

    ////////////////////////////////////////////////////////////////////////
    ///////////////////// ATTO RICONOSCIMENTO PRENATALE ////////////////////
    ////////////////////////////////////////////////////////////////////////

    // 1 = MATERNO O UNICO, 2 = PATERNO SU ATTO DIVERSO

    @Column(name = "RICONOSCIMENTO_PRE_ANNO_1", nullable = true)
    Integer annoAttoRiconoscimento1

    @Column(name = "RICONOSCIMENTO_PRE_ATTO_1", nullable = true)
    Integer numeroAttoRiconoscimento1

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "RICONOSCIMENTO_PRE_COD_COM_1")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ATTO_RIC_PRE_1", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "RICONOSCIMENTO_PRE_COD_PRO_1")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_RIC_PRE_1", updatable = false, insertable = false))
    ])
    private Comune comuneAttoRiconoscimento1

    Comune getComuneAttoRiconoscimento1() {
        if (comuneAttoRiconoscimento1 == null){
            comuneAttoRiconoscimento1 = new Comune()
        }
        return comuneAttoRiconoscimento1
    }

    void setComuneAttoRiconoscimento1(Comune c) {
        this.comuneAttoRiconoscimento1 = c
    }

    @Column(name = "RICONOSCIMENTO_PRE_PARTE_1", nullable = true)
    Integer parteAttoRiconoscimento1

    @Column(name = "RICONOSCIMENTO_PRE_SERIE_1", nullable = true)
    private String serieAttoRiconoscimento1

    String getSerieAttoRiconoscimento1(){
        return serieAttoRiconoscimento1
    }

    void setSerieAttoRiconoscimento1(String s){
        this.serieAttoRiconoscimento1 = s?.toUpperCase()
    }

    @Column(name = "RICONOSCIMENTO_PRE_UFFICIO_1", nullable = true)
    Integer ufficioAttoRiconoscimento1

    @Temporal(TemporalType.DATE)
    @Column( name = "D_RICONOSCIMENTO_PRE_DATA_1", nullable = true)
    Date dataAttoRiconoscimento1

    @Column(name = "RICONOSCIM_PRE_ID_ATTO_ANSC_1", nullable = true)
    String idAttoAnscRiconoscimento1

    ////////////////////////////////////////////////////////////////////////

    @Column(name = "RICONOSCIMENTO_PRE_ANNO_2", nullable = true)
    Integer annoAttoRiconoscimento2

    @Column(name = "RICONOSCIMENTO_PRE_ATTO_2", nullable = true)
    Integer numeroAttoRiconoscimento2

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "RICONOSCIMENTO_PRE_COD_COM_2")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ATTO_RIC_PRE_2", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "RICONOSCIMENTO_PRE_COD_PRO_2")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_RIC_PRE_2", updatable = false, insertable = false))
    ])
    private Comune comuneAttoRiconoscimento2

    Comune getComuneAttoRiconoscimento2() {
        if (comuneAttoRiconoscimento2 == null){
            comuneAttoRiconoscimento2 = new Comune()
        }
        return comuneAttoRiconoscimento2
    }

    void setComuneAttoRiconoscimento2(Comune c) {
        this.comuneAttoRiconoscimento2 = c
    }

    @Column(name = "RICONOSCIMENTO_PRE_PARTE_2", nullable = true)
    Integer parteAttoRiconoscimento2

    @Column(name = "RICONOSCIMENTO_PRE_SERIE_2", nullable = true)
    private String serieAttoRiconoscimento2

    String getSerieAttoRiconoscimento2(){
        return serieAttoRiconoscimento2
    }

    void setSerieAttoRiconoscimento2(String s){
        this.serieAttoRiconoscimento2 = s?.toUpperCase()
    }

    @Column(name = "RICONOSCIMENTO_PRE_UFFICIO_2", nullable = true)
    Integer ufficioAttoRiconoscimento2

    @Temporal(TemporalType.DATE)
    @Column( name = "D_RICONOSCIMENTO_PRE_DATA_2", nullable = true)
    Date dataAttoRiconoscimento2

    @Column(name = "RICONOSCIM_PRE_ID_ATTO_ANSC_2", nullable = true)
    String idAttoAnscRiconoscimento2

    ////////////////////////////////////////////////////////////////////////
    //////////////////// SENTENZA RICONOSCIMENTO ///////////////////////////
    ////////////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////// ATTO DI ASSENSO ///////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "ATTO_ASSENSO_ANNO", nullable = true)
    Integer annoAttoAssenso

    @Column(name = "ATTO_ASSENSO_ATTO", nullable = true)
    Integer numeroAttoAssenso

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "ATTO_ASSENSO_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ATTO_ASSENSO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "ATTO_ASSENSO_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ATTO_ASSENSO", updatable = false, insertable = false))
    ])
    private Comune comuneAttoAssenso

    Comune getComuneAttoAssenso() {
        if (comuneAttoAssenso == null){
            comuneAttoAssenso = new Comune()
        }
        return comuneAttoAssenso
    }

    void seCcomuneAttoAssenso(Comune c) {
        this.comuneAttoAssenso = c
    }

    @Column(name = "ATTO_ASSENSO_PARTE", nullable = true)
    Integer parteAttoAssenso

    @Column(name = "ATTO_ASSENSO_SERIE", nullable = true)
    private String serieAttoAssenso

    String getSerieAttoAssenso(){
        return serieAttoAssenso
    }

    void setSerieAttoAssenso(String s){
        this.serieAttoAssenso = s?.toUpperCase()
    }

    @Column(name = "ATTO_ASSENSO_UFFICIO", nullable = true)
    Integer ufficioAttoAssenso

    @Temporal(TemporalType.DATE)
    @Column( name = "D_ATTO_ASSENSO_DATA", nullable = true)
    Date dataAttoAssenso

    @Column(name = "ATTO_ASSENSO_ID_ATTO_ANSC", nullable = true)
    String idAttoAnscAssenso

    ////////////////////////////////////////////////////////////////////////
    ///////////////////// PROVVEDIMENTO SEPARAZIONE ////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "SEPARAZIONE_ENTE", nullable = true)
    String enteSeparazione

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "SEPARAZIONE_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_SEPARAZIONE", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "SEPARAZIONE_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_SEPARAZIONE", updatable = false, insertable = false))
    ])
    private Comune comuneAttoSeparazione

    Comune getComuneAttoSeparazione() {
        if (comuneAttoSeparazione == null){
            comuneAttoSeparazione = new Comune()
        }
        return comuneAttoSeparazione
    }

    void setComuneAttoSeparazione(Comune c) {
        this.comuneAttoSeparazione = c
    }

    @Temporal(TemporalType.DATE)
    @Column( name = "D_SEPARAZIONE_DATA_DOC", nullable = true)
    Date dataAttoSeparazione

    @Column(name = "SEPARAZIONE_ESTREMI_DOC", nullable = true)
    String estremiSeparazione

    @Enumerated(EnumType.STRING)
    @Column(name = "SEPARAZIONE_TIPO_PROVV", nullable = true)
    ETipoProvvedimentoSeparazione tipoProvvedimentoSeparazione

    // refs #72274
    Boolean isSepDaProvvedimentoSeparazioneUAL(){
        return ([ETipoDivorzio.A].contains(tipoDivorzio) &&
                [ETipoDivorzioAltro.C, ETipoDivorzioAltro.D].contains(tipoDivorzioAltro) &&
                (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.PR))
    }    
    Boolean isSepDaProvvedimentoSeparazioneUAC(){
        return ([ETipoDivorzio.C, ETipoDivorzio.S].contains(tipoDivorzio) && (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.PR))
    }
    Boolean isSepDaProvvedimentoSeparazioneRCN(){
        return (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.PR)
    }
    // refs #72274
    Boolean isSepDaAccordoSeparazioneUAL(){
        return ([ETipoDivorzio.A].contains(tipoDivorzio) &&
                [ETipoDivorzioAltro.C, ETipoDivorzioAltro.D].contains(tipoDivorzioAltro) &&
                (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.AC))
    }
    Boolean isSepDaAccordoSeparazioneUAC(){
        return ([ETipoDivorzio.C, ETipoDivorzio.S].contains(tipoDivorzio) && (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.AC))
    }
    Boolean isSepDaAccordoSeparazioneRCN(){
        return (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.AC)
    }
    // refs #72274
    Boolean isSepDaNegoziazioneAssistitaUAL(){
        return ([ETipoDivorzio.A].contains(tipoDivorzio) &&
                [ETipoDivorzioAltro.C, ETipoDivorzioAltro.D].contains(tipoDivorzioAltro) &&
                (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.NA))
    }
    Boolean isSepDaNegoziazioneAssistitaUAC(){
        return ([ETipoDivorzio.C, ETipoDivorzio.S].contains(tipoDivorzio) && (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.NA))
    }
    Boolean isSepDaNegoziazioneAssistitaRCN(){
        return (tipoProvvedimentoSeparazione == ETipoProvvedimentoSeparazione.NA)
    }
    // refs #72274
    Boolean isSepDaAccordoSeparazioneODaNegoziazioneAssistitaUAC(){
        return (isSepDaAccordoSeparazioneUAC() || isSepDaNegoziazioneAssistitaUAC())
    }
    Boolean isSepDaAccordoSeparazioneODaNegoziazioneAssistitaUAL(){
        return (isSepDaAccordoSeparazioneUAL() || isSepDaNegoziazioneAssistitaUAL())
    }
    Boolean isSepDaAccordoSeparazioneODaNegoziazioneAssistitaRCN(){
        return (isSepDaAccordoSeparazioneRCN() || isSepDaNegoziazioneAssistitaRCN())
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////// CONFERMA ACCORDO SEPARAZIONE ////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "SEPARAZIONE_CONF_UFFICIO", nullable = true)
    Integer ufficioConfermaAccordoSeparazione

    @Column(name = "SEPARAZIONE_CONF_ANNO", nullable = true)
    Integer annoConfermaAccordoSeparazione

    @Column(name = "SEPARAZIONE_CONF_ATTO", nullable = false)
    Integer attoConfermaAccordoSeparazione

    @Column(name = "SEPARAZIONE_CONF_PARTE", nullable = true)
    Integer parteConfermaAccordoSeparazione

    @Column(name = "SEPARAZIONE_CONF_SERIE", nullable = true)
    private String serieConfermaAccordoSeparazione

    String getSerieConfermaAccordoSeparazione() {
        return serieConfermaAccordoSeparazione
    }

    void setSerieConfermaAccordoSeparazione(String val) {
        this.serieConfermaAccordoSeparazione = val?.toUpperCase()
    }

    @Temporal(TemporalType.DATE)
    @Column( name = "D_SEPARAZIONE_CONF_DATA", nullable = true)
    Date dataConfermaAccordoSeparazione

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "SEPARAZIONE_CONF_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_SEPARAZIONE_CONF", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "SEPARAZIONE_CONF_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_SEPARAZIONE_CONF", updatable = false, insertable = false))
    ])
    private Comune comuneConfermaAccordoSeparazione

    Comune getComuneConfermaAccordoSeparazione() {
        if (comuneConfermaAccordoSeparazione == null){
            comuneConfermaAccordoSeparazione = new Comune()
        }
        return comuneConfermaAccordoSeparazione
    }

    void setComuneConfermaAccordoSeparazione(Comune c) {
        this.comuneConfermaAccordoSeparazione = c
    }

    @Column(name = "SEPARAZIONE_CONF_ID_ATTO_ANSC", nullable = true)
    String idAttoAnscConfermaAccordoSeparazione

    ////////////////////////////////////////////////////////////////////////
    ////////////// IMPEDIMENTO - GENERICO - SOLO UCI ///////////////////////
    ////////////////////////////////////////////////////////////////////////

    //https://github.com/italia/ansc/issues/219
    //Per le UCI non sussiste l'impedimento dell'età.

    @Enumerated(EnumType.STRING)
    @Column(name = "IMPEDIMENTO_UCI", nullable = true)
    EImpedimentoGenericoUnioneCivile impedimentoGenericoUci

    ////////////////////////////////////////////////////////////////////////
    ///////////////// IMPEDIMENTO - DIFETTO ETA ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "IMPEDIMENTO_ETA_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_IMPEDIMENTO_ETA", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "IMPEDIMENTO_ETA_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_IMPEDIMENTO_ETA", updatable = false, insertable = false))
    ])
    private Comune comuneAttoImpedimentoEta

    Comune getComuneAttoImpedimentoEta() {
        if (comuneAttoImpedimentoEta == null){
            comuneAttoImpedimentoEta = new Comune()
        }
        return comuneAttoImpedimentoEta
    }

    void setComuneAttoImpedimentoEta(Comune c) {
        this.comuneAttoImpedimentoEta = c
    }

    @Temporal(TemporalType.DATE)
    @Column( name = "D_IMPEDIMENTO_ETA_DATA_DOC", nullable = true)
    Date dataAttoImpedimentoEta

    @Column(name = "IMPEDIMENTO_ETA_ESTREMI_DOC", nullable = true)
    String estremiDocumentoImpedimentoEta

    @Column(name = "IMPEDIMENTO_ETA_ENTE", nullable = true)
    String enteImpedimentoEta

    ////////////////////////////////////////////////////////////////////////
    /////////////////// IMPEDIMENTO - PARENTELA ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "IMPEDIMENTO_PAR_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_IMPEDIMENTO_PAR", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "IMPEDIMENTO_PAR_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_IMPEDIMENTO_PAR", updatable = false, insertable = false))
    ])
    private Comune comuneAttoImpedimentoParentela

    Comune getComuneAttoImpedimentoParentela() {
        if (comuneAttoImpedimentoParentela == null){
            comuneAttoImpedimentoParentela = new Comune()
        }
        return comuneAttoImpedimentoParentela
    }

    void setComuneAttoImpedimentoParentela(Comune c) {
        this.comuneAttoImpedimentoParentela = c
    }

    @Temporal(TemporalType.DATE)
    @Column( name = "D_IMPEDIMENTO_PAR_DATA_DOC", nullable = true)
    Date dataAttoImpedimentoParentela

    @Column(name = "IMPEDIMENTO_PAR_ESTREMI_DOC", nullable = true)
    String estremiDocumentoImpedimentoParentela

    @Column(name = "IMPEDIMENTO_PAR_ENTE", nullable = true)
    String enteImpedimentoParentela

    ////////////////////////////////////////////////////////////////////////
    //////////////// IMPEDIMENTO - DIVIETO TEMPORANEO //////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "IMPEDIMENTO_TMP_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_IMPEDIMENTO_TMP", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "IMPEDIMENTO_TMP_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_IMPEDIMENTO_TMP", updatable = false, insertable = false))
    ])
    private Comune comuneAttoDivietoTemporaneo

    Comune getComuneAttoDivietoTemporaneo() {
        if (comuneAttoDivietoTemporaneo == null){
            comuneAttoDivietoTemporaneo = new Comune()
        }
        return comuneAttoDivietoTemporaneo
    }

    void setComuneAttoDivietoTemporaneo(Comune c) {
        this.comuneAttoDivietoTemporaneo = c
    }

    @Temporal(TemporalType.DATE)
    @Column( name = "D_IMPEDIMENTO_TMP_DATA_DOC", nullable = true)
    Date dataAttoDivietoTemporaneo

    @Column(name = "IMPEDIMENTO_TMP_ESTREMI_DOC", nullable = true)
    String estremiDocumentoDivietoTemporaneo

    @Column(name = "IMPEDIMENTO_TMP_ENTE", nullable = true)
    String enteDivietoTemporaneo

    ////////////////////////////////////////////////////////////////////////
    ///////////////////// RICHIESTA COSTITUZIONE UCI ///////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COSTITUZIONE_UCI_COD_COM_1")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_COSTITUZIONE_UCI_1", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COSTITUZIONE_UCI_COD_PRO_1")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_COSTITUZIONE_UCI_1", updatable = false, insertable = false))
    ])
    private Comune comuneRichiestaCostituzione1

    Comune getComuneRichiestaCostituzione1() {
        if (comuneRichiestaCostituzione1 == null){
            comuneRichiestaCostituzione1 = new Comune()
        }
        return comuneRichiestaCostituzione1
    }

    void setComuneRichiestaCostituzione1(Comune c) {
        this.comuneRichiestaCostituzione1 = c
    }

    @Temporal(TemporalType.DATE)
    @Column( name = "D_COSTITUZIONE_UCI_DATA_1", nullable = true)
    Date dataRichiestaCostituzione1

    @Temporal(TemporalType.DATE)
    @Column( name = "D_COSTITUZIONE_UCI_DATA_2", nullable = true)
    Date dataRichiestaCostituzione2

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COSTITUZIONE_UCI_COD_COM_2")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_COSTITUZIONE_UCI_2", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COSTITUZIONE_UCI_COD_PRO_2")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_COSTITUZIONE_UCI_2", updatable = false, insertable = false))
    ])
    private Comune comuneRichiestaCostituzione2

    Comune getComuneRichiestaCostituzione2() {
        if (comuneRichiestaCostituzione2 == null){
            comuneRichiestaCostituzione2 = new Comune()
        }
        return comuneRichiestaCostituzione2
    }

    void setComuneRichiestaCostituzione2(Comune c) {
        this.comuneRichiestaCostituzione2 = c
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////// ENTE STRANIERO/ESTERO ///////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "ENTE_STRANIERO", nullable = true)
    String autoritaEnteStraniero

    @Column(name = "ENTE_STRANIERO_TIPO_ATTO", nullable = true)
    String tipoAttoEnteStraniero

    @Temporal(TemporalType.DATE)
    @Column(name = "D_ENTE_STRANIERO_DATA_ATTO", nullable = true)
    Date dataAttoEnteStraniero

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "ENTE_STRANIERO_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ENTE_STRANIERO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "ENTE_STRANIERO_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ENTE_STRANIERO", updatable = false, insertable = false))
    ])
    private Comune comuneEnteStraniero

    Comune getComuneEnteStraniero() {
        if (comuneEnteStraniero == null){
            comuneEnteStraniero = new Comune()
        }
        return comuneEnteStraniero
    }

    void setComuneEnteStraniero(Comune comuneEnteStraniero) {
        this.comuneEnteStraniero = comuneEnteStraniero
    }

    @Column(name = "ENTE_STRANIERO_ESTREMI_ATTO ", nullable = true)
    String estremiAttoEnteStraniero

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// SENTENZA DIVORZIO ESTERO //////////////
    ////////////////////////////////////////////////////////////////////////
    // Per i divorzi esteri
    @Temporal(TemporalType.DATE)
    @Column(name = "D_SENTENZA_DATA_PUBBLICAZIONE", nullable = true)
    Date dataPubblicazioneSentenza

    @Temporal(TemporalType.DATE)
    @Column(name = "D_SENTENZA_DATA_DECORRENZA", nullable = true)
    Date dataDecorrenzaSentenza

    ////////////////////////////////////////////////////////////////////////
    //////////////////////// AUTORITA GIUDIZIARIA //////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_GIUDIZIO_PENDENTE", nullable = true)
    Boolean flagGiudizioPendente

    @Temporal(TemporalType.DATE)
    @Column(name = "D_AUTORITA_GIUD_DATA_DOC", nullable = true)
    Date dataAttoAutoritaGiudiziaria

    @Temporal(TemporalType.DATE)
    @Column(name = "D_AUTORITA_GIUD_DATA_DEPOSITO", nullable = true)
    Date dataDepositoAutoritaGiudiziaria

    @Temporal(TemporalType.DATE)
    @Column(name = "D_AUTORITA_GIUD_DATA_COM_AVV", nullable = true)
    Date dataComunicazioneAvvocatiAutoritaGiudiziaria

    // campo non più in uso nel caso della negoziazione assistita: https://github.com/italia/ansc/issues/377
    // resta come campo di appoggio per altri tipi di divorzio (es autorità giudiziale in accordo divorzio)
    @Column(name = "AUTORITA_GIUD_ENTE", nullable = true)
    String enteAutoritaGiudiziaria

    @Enumerated(EnumType.STRING)
    @Column(name = "AUTORITA_GIUD_TIPO_PROVV", nullable = true)
    ETipoProvvedimentoAutoritaGiudiziaria tipoProvvedimentoAutoritaGiudiziaria

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "AUTORITA_GIUD_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_AUTORITA_GIUDIZIARIA", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "AUTORITA_GIUD_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_AUTORITA_GIUDIZIARIA", updatable = false, insertable = false))
    ])
    private Comune comuneAutoritaGiudiziaria

    Comune getComuneAutoritaGiudiziaria() {
        if (comuneAutoritaGiudiziaria == null){
            comuneAutoritaGiudiziaria = new Comune()
        }
        return comuneAutoritaGiudiziaria
    }

    void setComuneAutoritaGiudiziaria(Comune c) {
        this.comuneAutoritaGiudiziaria = c
    }

    // campo dismesso: https://github.com/italia/ansc/issues/377
    @Column(name = "AUTORITA_GIUD_ESTREMI_DOC", nullable = true)
    String estremiAttoAutoritaGiudiziaria

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////// PUBBLICO IMPIEGO ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_PUBBLICO_IMPIEGO_DATA_DOC", nullable = true)
    Date dataDocumentoPubblicoImpiego

    @Column(name = "PUBBLICO_IMPIEGO_ESTREMI_DOC", nullable = true)
    String estremiDocumentoPubblicoImpiego

    @Column(name = "PUBBLICO_IMPIEGO_ENTE", nullable = true)
    String entePubblicoImpiego

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "PUBBLICO_IMPIEGO_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_PUBBLICO_IMPIEGO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "PUBBLICO_IMPIEGO_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_PUBBLICO_IMPIEGO", updatable = false, insertable = false))
    ])
    private Comune comunePubblicoImpiego

    Comune getComunePubblicoImpiego() {
        if (comunePubblicoImpiego == null){
            comunePubblicoImpiego = new Comune()
        }
        return comunePubblicoImpiego
    }

    void setComunePubblicoImpiego(Comune c) {
        this.comunePubblicoImpiego = c
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "PUBBLICO_IMPIEGO_TEMPO", nullable = true)
    ETempisticaAssunzionePubblicoImpiego tempisticaAssunzionePubblicoImpiego

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// OPPOSIZIONE  /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Enumerated(EnumType.STRING)
    @Column(name = "FINE_OPPOSIZIONE_TIPO_DOC", nullable = true)
    ETipoDocumentoFineOpposizione tipoDocumentoFineOpposizione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_FINE_OPPOSIZIONE_DATA_DOC", nullable = true)
    Date dataDocumentoFineOpposizione

    @Column(name = "FINE_OPPOSIZIONE_ENTE", nullable = true)
    String enteFineOpposizione

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "FINE_OPPOSIZIONE_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_FINE_OPPOSIZIONE", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "FINE_OPPOSIZIONE_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_FINE_OPPOSIZIONE", updatable = false, insertable = false))
    ])
    private Comune comuneFineOpposizione

    Comune getComuneFineOpposizione() {
        if (comuneFineOpposizione == null){
            comuneFineOpposizione = new Comune()
        }
        return comuneFineOpposizione
    }

    void setComuneFineOpposizione(Comune c) {
        this.comuneFineOpposizione = c
    }

    @Column(name = "FINE_OPPOSIZIONE_ESTREMI_DOC", nullable = true)
    String estremiDocumentoFineOpposizione

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////// DATI ACCERTAMENTO  ///////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Temporal(TemporalType.DATE)
    @Column(name = "D_ACCERTAMENTO_DATA_DOC", nullable = true)
    Date dataDocumentoAccertamento

    @Column(name = "ACCERTAMENTO_ENTE", nullable = true)
    String enteAccertamento

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "ACCERTAMENTO_COD_COM")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ACCERTAMENTO", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "ACCERTAMENTO_COD_PRO")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ACCERTAMENTO", updatable = false, insertable = false))
    ])
    private Comune comuneAccertamento

    Comune getComuneAccertamento() {
        if (comuneAccertamento == null){
            comuneAccertamento = new Comune()
        }
        return comuneAccertamento
    }

    void setComuneAccertamento(Comune c) {
        this.comuneAccertamento = c
    }

    @Column(name = "ACCERTAMENTO_ESTREMI_DOC", nullable = true)
    String estremiDocumentoAccertamento

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////// GENERICHE  //////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_CASA_COMUNALE", nullable = true)
    Boolean flagCasaComunale

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_RITO_CATTOLICO", nullable = true, updatable = false, insertable = false)
    Boolean flagRitoCattolico

    // per le nascite
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ACCERTAMENTO", nullable = true)
    ETipoAccertamentoNascita tipoAccertamento

    // per le morti
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_TRASMISSIONE", nullable = true, updatable = false, insertable = false)
    ETipoTrasmissioneMorte tipoTrasmissione

    @Enumerated(EnumType.STRING)
    @Column(name = "DICHIARAZIONE_GIUDIZIALE", nullable = true)
    ETipoSiNo dichiarazioneGiudiziale

    @Enumerated(EnumType.STRING)
    @Column(name = "PRESENTAZIONE_DOCUMENTI", nullable = true)
    ETipoPresentazioneDocumentiAnsc presentazioneDocumentiAnsc

    @Column(name = "DATI_PROCURA", nullable = true)
    String datiProcura

    @Column(name = "DATI_ASSEGNO_DIVORZIO", nullable = true)
    String datiAssegnoDivorzio

    // ES nelle cittadinanze (residenza biennale)
    @Column(name = "DATI_RESIDENZA", nullable = true)
    String datiResidenza

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_EX_ART19", nullable = true)
    Boolean flagExArt19

    @Lob
    @Column(name = "TESTO_RIASSUNTO", nullable = true)
    String testoRiassunto

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_STRANIERI_NON_RESIDENTI", nullable = true)
    Boolean flagStranieriNonResidenti

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_IN_VIAGGIO", nullable = true)
    Boolean flagInViaggio

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_LUOGO_IN_VIAGGIO", nullable = true)
    ETipoLuogoNascita tipoLuogoNascita


    Boolean isAttoOriginalePrimaB(){
        Boolean val = ( ( (this.parteAttoOriginale?.intValue()?:0) == 1 ) && ((this.serieAttoOriginale?:"") == CivTipoAtto.SERIE_B) )
        return val
    }

    Boolean isRichiedentePadre(){
        Boolean val = tipoDichiarante?.contains(ETipoDichiaranteNascita.PD.name())
        return val
    }

    Boolean isRichiedenteMadre(){
        Boolean val = tipoDichiarante?.contains(ETipoDichiaranteNascita.MD.name())
        return val
    }

    Boolean isRichiedenteInteressato(){
        Boolean val = tipoDichiarante?.contains(ETipoDichiaranteNascita.IN.name())
        return val
    }

    Boolean isComparenteInterprete(){
        Boolean val = tipoComparente?.contains(ETipoDichiaranteNascita.IT.name())
        return val
    }

    Boolean isComparenteSanitario(){
        Boolean val = tipoComparente?.contains(ETipoDichiaranteNascita.OS.name())
        return val
    }

    Boolean isComparenteProcuratorePadre(){
        Boolean val = tipoComparente?.equals(ETipoDichiaranteNascita.PP.name()) || tipoComparente?.equals(ETipoDichiaranteNascita.PPMD.name())
        return val
    }

    Boolean isComparenteProcuratoreMadre(){
        Boolean val = tipoComparente?.equals(ETipoDichiaranteNascita.PM.name()) || tipoComparente?.equals(ETipoDichiaranteNascita.PMPD.name())
        return val
    }

    Boolean isComparenteProcuratore(){
        Boolean val = ( isComparenteProcuratorePadre() || isComparenteProcuratoreMadre() )
        return val
    }

    Boolean isPresenteComparenteDecesso(){
        Boolean val = (tipoComparente != null)
        return val
    }

    Boolean isDichiaranteRiconoscimentoPadre(){
        Boolean val = tipoDichiarante?.equals(ETipoDichiaranteNascita.PD.name()) || tipoDichiarante?.equals(ETipoDichiaranteNascita.EN.name())
        return val
    }

    Boolean isStranieriNonResidenti() {
        return flagStranieriNonResidenti == Boolean.TRUE
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Converter
    static class EnumToIntConverter implements AttributeConverter<ETipoEnteEmittente, Integer> {
        @Override Integer convertToDatabaseColumn(ETipoEnteEmittente ee) {
            return (ee ? ee.valore : null)
        }
        @Override ETipoEnteEmittente convertToEntityAttribute(Integer value) {
            ETipoEnteEmittente ret = null
            for (ETipoEnteEmittente ee : ETipoEnteEmittente.values()) {
                if (ee.valore == value) {
                    ret = ee
                    break
                }
            }
            return ret
        }

    }

    static final List<Map> etichetteDomain = [Etichette.Da, Etichette.In, Etichette.Descrizione, Etichette.Ufficio, Etichette.Qualifica,
                                              Etichette.Sede_parto, Etichette.Luogo_decesso, Etichette.Nota_Rif_Anno, Etichette.Consolato,
                                              Etichette.In_data, Etichette.Numero_Protocollo_Anno, Etichette.Motivo_Impedimento, Etichette.Luogo,
                                              Etichette.Condizioni_dichiarante, Etichette.Luogo, Etichette.Segretario_comunale, Etichette.Firmato,
                                              Etichette.Notificato_in_data, Etichette.Ufficiale_Stato_Civile, Etichette.Provenienza, Etichette.Tipo_richiesta,
                                              Etichette.Richiesta_da_privato_cittadino,
                                              Etichette.Dati_Richiedente, Etichette.Registrato_da, Etichette.Nome_Ente, Etichette.Comune_Atto, Etichette.Comune_Provenienza,
                                              Etichette.Atto_Notarile, Etichette.Dati_Atto_Notarile, Etichette.Estremi_Atto_Notarile, Etichette.Tipo_provvedimento,
                                              Etichette.Ente_Straniero, Etichette.Comune_Ente_Straniero, Etichette.Comune_Ente, Etichette.Estremi_Atto_Straniero, Etichette.Descrizione_Atto_Straniero,
                                              Etichette.Sentenza, Etichette.Data_Pubblicazione, Etichette.Data_Decorrenza,
                                              Etichette.Dati_Decreto_Attestazione, Etichette.Dati_residenza_biennale, Etichette.Dati_assegno_mantenimento, Etichette.Dati_accertamento,
                                              Etichette.Data_deposito, Etichette.Data_Comunicazione, Etichette.Data_comunicazione_avv, Etichette.Foro,
                                              Etichette.Autorita_giudiziale, Etichette.Dichiarazione_giudiziale, Etichette.Protocollo,
                                              Etichette.Atto_da_trascrivere, Etichette.Atto_da_trascrivere_sentenza_tribunale, Etichette.Autorita_mittente, Etichette.Data_Atto, Etichette.Data_Formazione, Etichette.Ricezione_Atto,
                                              Etichette.Estremi_Atto, Etichette.Ente, Etichette.Luogo_Celebrazione, Etichette.Indirizzo, Etichette.Civico, Etichette.Entrambi,
                                              Etichette.Giudizio_pendente, Etichette.Autorita_giudiziale, Etichette.Autorita_Giudiziaria, Etichette.Tempistica_assunzione, Etichette.Numero,
                                              Etichette.Tipo_separazione, Etichette.Tipo, Etichette.Rilasciato_da, Etichette.Data_Richiesta, Etichette.Dati_Richiesta,
                                              Etichette.Data_Rilascio, Etichette.Data_Scadenza, Etichette.Estremi_documento, Etichette.Estremi_delega,
                                              Etichette.Comune_delegante, Etichette.Riassunto_dichiarazione, Etichette.Testo_Riassunto_placeholder, Etichette.Estremi_Certificazione, Etichette.Durante_viaggio, Etichette.Tipo_Luogo_Nascita]

}
