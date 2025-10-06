package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "CIVUCI_V")
class CivUnioneCivile extends CivAttoBaseDomain implements IAttoAnsc, ISoggettoAtto1, ISoggettoAtto2, IAttoMatUci, ICertificabile, ISoggettoAttoAnsc1, ISoggettoAttoAnsc2 {

    public static final int tipoAttoAnnotazioneSuAttoNascitaAltroComune = -7
    public static final int tipoAttoAnnotazioneSuAttoUnioneCivileAltroComune = -9

    @Column(name = "PARTE", nullable = false)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MAT", nullable = true)
    private Date dataMatrimonio

    Date getDataMatrimonio() {
        return dataMatrimonio
    }

    void setDataMatrimonio(Date d) {
        this.dataMatrimonio = d
    }

    @Column(name = "ORE", nullable = true)
    String oraMatrimonio

    @Column(name = "MINUTI", nullable = true)
    String minutoMatrimonio

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_GG_IMPRECISATO", nullable = true)
    Boolean giornoMatrimonioImprecisato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MM_IMPRECISATO", nullable = true)
    Boolean meseMatrimonioImprecisato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_AA_IMPRECISATO", nullable = true)
    Boolean annoMatrimonioImprecisato

    @Column(name = "COD_COM_MAT", nullable = true)
    private Integer codiceComuneMatrimonio

    Integer getCodiceComuneMatrimonio() {
        return codiceComuneMatrimonio
    }

    void setCodiceComuneMatrimonio(Integer i) {
        this.codiceComuneMatrimonio = i
    }

    @Column(name = "DES_COM_MAT", nullable = true, updatable = false, insertable = false)
    private String descrizioneComuneMatrimonio

    String getDescrizioneComuneMatrimonio(){
        return descrizioneComuneMatrimonio
    }

    void setDescrizioneComuneMatrimonio(String s){
        this.descrizioneComuneMatrimonio = s
    }

    @Column(name = "COD_PRO_MAT", nullable = false)
    private Integer codiceProvinciaMatrimonio

    Integer getCodiceProvinciaMatrimonio() {
        return codiceProvinciaMatrimonio
    }

    void setCodiceProvinciaMatrimonio(Integer i) {
        this.codiceProvinciaMatrimonio = i
    }

    @Column(name = "SIGLA_PRO_MAT", nullable = true, updatable = false, insertable = false)
    private String siglaProvinciaMatrimonio

    String getSiglaProvinciaMatrimonio(){
        return siglaProvinciaMatrimonio
    }

    void setSiglaProvinciaMatrimonio(String s){
        this.siglaProvinciaMatrimonio = s
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "CONVENZIONI", nullable = true)
    private ETipoSiNo convenzioniDb

    void setConvenzioni(Boolean val){
        this.convenzioniDb = (val?ETipoSiNo.SI: null)
    }

    Boolean getConvenzioni() {
        return (convenzioniDb == ETipoSiNo.SI)
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CONVENZIONI", nullable = true)
    Date dataConvenzioni

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_CERTIFICABILE", nullable = true)
    private ETipoSN certificabileDb

    @Enumerated(EnumType.STRING)
    @Formula("CASE WHEN FLAG_CERTIFICABILE IS NULL THEN NULL WHEN FLAG_CERTIFICABILE = 'N' THEN 'NO' ELSE 'SI' END")
    private ETipoSiNo certificabile

    ETipoSiNo getCertificabile() {
        return this.certificabile
    }

    void setCertificabile(ETipoSiNo val) {
        this.certificabile = val
        this.certificabileDb = ((val == ETipoSiNo.SI)?ETipoSN.S:ETipoSN.N)
    }

    @Column(name = "NOTE", nullable = true)
    String note

    @Formula("CASE WHEN COALESCE(FLAG_DIVORZIO, 'N') = 'N' THEN 0 ELSE 1 END")
    @Type(type="numeric_boolean")
    Boolean divorzio

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_D3U", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloD3U

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_SDSU", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloSDSU

    /*
    //campo dismesso perché non previsto per le uci
    // https://github.com/italia/ansc/issues/219
    @Enumerated(EnumType.STRING)
    @Column(name = "DIFETTO_ETA", nullable = true)
    ETipoDifettoEta difettoEta

    //campo dismesso perché non previsto per le uci
    // https://github.com/italia/ansc/issues/219
    @Enumerated(EnumType.STRING)
    @Column(name = "IMPEDIMENTO_MAT", nullable = true)
    ETipoImpedimentoParentelaMatrimonio impedimentoParentelaMatrimonio
    */

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_FIRMATO_USC_ANSC", nullable = true, updatable = false, insertable = false)
    Boolean flagFirmatoUscAnsc

    @Column(name = "ID_USECASE_ANSC", nullable=true)
    Long idAnscUseCase

    @Column(name = "NUMERO_UNICO", nullable = true)
    Long numeroUnico

    @Column(name = "ID_ATTO_ANSC", nullable = true)
    String idAttoAnsc

    @Column(name = "ID_SOGGETTO_ANSC_M", nullable = true)
    Long idSoggettoAnsc1

    @Column(name = "ID_SOGGETTO_ANSC_F", nullable = true)
    Long idSoggettoAnsc2

    @Enumerated(EnumType.STRING)
    @Column(name = "MOTIVO_RECUPERO_ANSC")
    EMotivoRecupero motivoRecuperoAnsc

    @Enumerated(EnumType.STRING)
    @Formula("""CASE WHEN MOTIVO_RECUPERO_ANSC IS NOT NULL THEN 'SI' ELSE 'NO' END""")
    ETipoSiNo motivoRecuperoAnscValorizzato

    ETipoArchivioAnsc getTipoArchivioAnsc(){
        return ETipoArchivioAnsc.UCI
    }

    ETipoAttoAnsc getTipoAttoAnsc(){
        if (divorzio){
            return ETipoAttoAnsc.Sciogl_UnCiv
        } else
        // refs #70519
        if (isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita() || isTrascrizioneAltroComune() || [ENaturaAtto.T, ENaturaAtto.D].contains(natura) ){
            return ETipoAttoAnsc.Trascr_UnCiv
        } else {
            return ETipoAttoAnsc.UnCiv
        }
    }

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// CONTRAENTE 1 /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COGNOME_M", nullable = true)
    private String cognome1

    String getCognome1() {
        return cognome1
    }

    void setCognome1(String s) {
        this.cognome1 = s
    }

    @Column(name = "NOME_M", nullable = true)
    private String nome1

    String getNome1() {
        return nome1
    }

    void setNome1(String s) {
        this.nome1 = s
    }

    @Column(name = "COGNOME_NOME_M", nullable = true)
    private String cognomeNome1

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_M", nullable = true)
    private Boolean senzaCognome1

    Boolean getSenzaCognome1() {
        return senzaCognome1
    }

    void setSenzaCognome1(Boolean val) {
        this.senzaCognome1 = val
    }

    @Column(name = "COGNOME_AGG_M", nullable = true)
    String cognomeComune1

    @Enumerated(EnumType.STRING)
    @Column(name = "CAMBIO_COGNOME_M", nullable = true)
    ETipoCambioCognome cambioCognome1

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_M", nullable = true)
    private Boolean senzaNome1

    Boolean getSenzaNome1() {
        return senzaNome1
    }

    void setSenzaNome1(Boolean val) {
        this.senzaNome1 = val
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_M", nullable = true)
    private AnaNazionalita nazionalita1

    AnaNazionalita getNazionalita1() {
        return nazionalita1
    }

    void setNazionalita1(AnaNazionalita n) {
        this.nazionalita1 = n
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_M", nullable = true)
    private Date dataNascita1

    Date getDataNascita1() {
        return dataNascita1
    }

    void setDataNascita1(Date d) {
        this.dataNascita1 = d
    }

    @Column(name = "ANNI_M", nullable = true)
    Integer anni1

    @Column(name = "COD_FISCALE_M", nullable = true)
    private String codiceFiscale1

    String getCodiceFiscale1() {
        return codiceFiscale1
    }

    void setCodiceFiscale1(String val) {
        this.codiceFiscale1 = val?.toUpperCase()
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO_M", nullable = true)
    private Boolean cfCalcolato1

    Boolean getCfCalcolato1() {
        return cfCalcolato1
    }

    void setCfCalcolato1(Boolean val) {
        this.cfCalcolato1 = val
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_M")
    private ESesso sesso1

    ESesso getSesso1() {
        return sesso1
    }

    void setSesso1(ESesso s) {
        this.sesso1 = s
    }

    @Column(name = "COGNOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String cognome1Lista

    @Column(name = "NOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String nome1Lista

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_1_LISTA", nullable = true, updatable = false, insertable = false)
    ESesso sesso1Lista

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVENTO_LISTA", nullable = true, updatable = false, insertable = false)
    Date dataEventoLista

    String getStatoCivile1() {
        return null
    }

    void setStatoCivile1(String s) {
        log.info ("Parametri stato civile non gestito su civuci: " + (s?:"") )
    }

    @Column(name = "COD_COM_NAS_M", nullable = true)
    private Integer codiceComuneNascita1

    Integer getCodiceComuneNascita1() {
        return codiceComuneNascita1
    }

    void setCodiceComuneNascita1(Integer i) {
        this.codiceComuneNascita1 = i
    }

    @Column(name = "DES_COM_NAS_M", nullable = true, updatable = false, insertable = false)
    private String descrizioneComuneNascita1

    String getDescrizioneComuneNascita1() {
        return descrizioneComuneNascita1
    }

    void setDescrizioneComuneNascita1(String s) {
        this.descrizioneComuneNascita1 = s
    }

    @Column(name = "COD_PRO_NAS_M", nullable = true)
    private Integer codiceProvinciaNascita1

    Integer getCodiceProvinciaNascita1() {
        return codiceProvinciaNascita1
    }

    void setCodiceProvinciaNascita1(Integer i) {
        this.codiceProvinciaNascita1 = i
    }

    @Column(name = "SIGLA_PRO_NAS_M", nullable = true, updatable = false, insertable = false)
    private String siglaProvinciaNascita1

    String getSiglaProvinciaNascita1() {
        return siglaProvinciaNascita1
    }

    void setSiglaProvinciaNascita1(String s) {
        this.siglaProvinciaNascita1 = s
    }

    @Column(name = "COD_COM_RES_M", nullable = true)
    private Integer codiceComuneResidenza1

    Integer getCodiceComuneResidenza1() {
        return codiceComuneResidenza1
    }

    void setCodiceComuneResidenza1(Integer i) {
        this.codiceComuneResidenza1 = i
    }

    @Column(name = "DES_COM_RES_M", nullable = true, updatable = false, insertable = false)
    private String descrizioneComuneResidenza1

    String getDescrizioneComuneResidenza1() {
        return descrizioneComuneResidenza1
    }

    void setDescrizioneComuneResidenza1(String s) {
        this.descrizioneComuneResidenza1 = s
    }

    @Column(name = "COD_PRO_RES_M", nullable = true)
    private Integer codiceProvinciaResidenza1

    Integer getCodiceProvinciaResidenza1() {
        return codiceProvinciaResidenza1
    }

    void setCodiceProvinciaResidenza1(Integer i) {
        this.codiceProvinciaResidenza1 = i
    }

    @Column(name = "SIGLA_PRO_RES_M", nullable = true, updatable = false, insertable = false)
    private String siglaProvinciaResidenza1

    String getSiglaProvinciaResidenza1() {
        return siglaProvinciaResidenza1
    }

    void setSiglaProvinciaResidenza1(String s) {
        this.siglaProvinciaResidenza1 = s
    }

    String getCodiceSesso1Lista(){
        return (this.sesso1Lista?.name())
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name = "COMPRENSIONE_M", nullable = true)
    private CivTipoComprensione comprensione1

    CivTipoComprensione getComprensione1() {
        return comprensione1
    }

    void setComprensione1(CivTipoComprensione c) {
        this.comprensione1 = c
    }

    @Column(name = "MOTIVO_IMPEDIMENTO_M", nullable = true)
    private String motivoImpedimento1

    String getMotivoImpedimento1() {
        return motivoImpedimento1
    }

    void setMotivoImpedimento1(String m) {
        this.motivoImpedimento1 = m
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////// CONTRAENTE 2 ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COGNOME_F", nullable = true)
    private String cognome2

    String getCognome2() {
        return cognome2
    }

    void setCognome2(String s) {
        this.cognome2 = s
    }

    @Column(name = "NOME_F", nullable = true)
    private String nome2

    String getNome2() {
        return nome2
    }

    void setNome2(String s) {
        this.nome2 = s
    }

    @Column(name = "COGNOME_NOME_F", nullable = true)
    private String cognomeNome2

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_F", nullable = true)
    private Boolean senzaCognome2

    Boolean getSenzaCognome2() {
        return senzaCognome2
    }

    void setSenzaCognome2(Boolean val) {
        this.senzaCognome2 = val
    }

    @Column(name = "COGNOME_AGG_F", nullable = true)
    String cognomeComune2

    @Enumerated(EnumType.STRING)
    @Column(name = "CAMBIO_COGNOME_F", nullable = true)
    ETipoCambioCognome cambioCognome2

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_F", nullable = true)
    private Boolean senzaNome2

    Boolean getSenzaNome2() {
        return senzaNome2
    }

    void setSenzaNome2(Boolean val) {
        this.senzaNome2 = val
    }

    @Column(name = "COGNOME_2_LISTA", nullable = true, updatable = false, insertable = false)
    String cognome2Lista

    @Column(name = "NOME_2_LISTA", nullable = true, updatable = false, insertable = false)
    String nome2Lista

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_2_LISTA", nullable = true, updatable = false, insertable = false)
    ESesso sesso2Lista

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_F", nullable = true)
    private AnaNazionalita nazionalita2

    AnaNazionalita getNazionalita2() {
        return nazionalita2
    }

    void setNazionalita2(AnaNazionalita n) {
        this.nazionalita2 = n
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_F", nullable = true)
    private Date dataNascita2

    Date getDataNascita2() {
        return dataNascita2
    }

    void setDataNascita2(Date d) {
        this.dataNascita2 = d
    }

    @Column(name = "ANNI_F", nullable = true)
    Integer anni2

    @Column(name = "COD_FISCALE_F", nullable = true)
    private String codiceFiscale2

    String getCodiceFiscale2() {
        return codiceFiscale2
    }

    void setCodiceFiscale2(String codiceFiscale) {
        this.codiceFiscale2 = codiceFiscale?.toUpperCase()
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO_F", nullable = true)
    private Boolean cfCalcolato2

    Boolean getCfCalcolato2() {
        return cfCalcolato2
    }

    void setCfCalcolato2(Boolean val) {
        this.cfCalcolato2 = val
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_F")
    private ESesso sesso2

    ESesso getSesso2() {
        return sesso2
    }

    void setSesso2(ESesso s) {
        this.sesso2 = s
    }

    @Column(name = "COD_COM_NAS_F", nullable = true)
    private Integer codiceComuneNascita2

    Integer getCodiceComuneNascita2() {
        return codiceComuneNascita2
    }

    void setCodiceComuneNascita2(Integer i) {
        this.codiceComuneNascita2 = i
    }

    @Column(name = "DES_COM_NAS_F", nullable = true, updatable = false, insertable = false)
    private String descrizioneComuneNascita2

    String getDescrizioneComuneNascita2() {
        return descrizioneComuneNascita2
    }

    void setDescrizioneComuneNascita2(String s) {
        this.descrizioneComuneNascita2 = s
    }

    @Column(name = "COD_PRO_NAS_F", nullable = true)
    private Integer codiceProvinciaNascita2

    Integer getCodiceProvinciaNascita2() {
        return codiceProvinciaNascita2
    }

    void setCodiceProvinciaNascita2(Integer i) {
        this.codiceProvinciaNascita2 = i
    }

    @Column(name = "SIGLA_PRO_NAS_F", nullable = true, updatable = false, insertable = false)
    private String siglaProvinciaNascita2

    String getSiglaProvinciaNascita2() {
        return siglaProvinciaNascita2
    }

    void setSiglaProvinciaNascita2(String s) {
        this.siglaProvinciaNascita2 = s
    }

    @Column(name = "COD_COM_RES_F", nullable = true)
    private Integer codiceComuneResidenza2

    Integer getCodiceComuneResidenza2() {
        return codiceComuneResidenza2
    }

    void setCodiceComuneResidenza2(Integer i) {
        this.codiceComuneResidenza2 = i
    }

    @Column(name = "DES_COM_RES_F", nullable = true, updatable = false, insertable = false)
    private String descrizioneComuneResidenza2

    String getDescrizioneComuneResidenza2() {
        return descrizioneComuneResidenza2
    }

    void setDescrizioneComuneResidenza2(String s) {
        this.descrizioneComuneResidenza2 = s
    }

    @Column(name = "COD_PRO_RES_F", nullable = true)
    private Integer codiceProvinciaResidenza2

    Integer getCodiceProvinciaResidenza2() {
        return codiceProvinciaResidenza2
    }

    void setCodiceProvinciaResidenza2(Integer i) {
        this.codiceProvinciaResidenza2 = i
    }

    @Column(name = "SIGLA_PRO_RES_F", nullable = true, updatable = false, insertable = false)
    private String siglaProvinciaResidenza2

    String getSiglaProvinciaResidenza2() {
        return siglaProvinciaResidenza2
    }

    void setSiglaProvinciaResidenza2(String s) {
        this.siglaProvinciaResidenza2 = s
    }

    String getCodiceSesso2Lista(){
        return (this.sesso2Lista?.name())
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name = "COMPRENSIONE_F", nullable = true)
    private CivTipoComprensione comprensione2

    CivTipoComprensione getComprensione2() {
        return comprensione2
    }

    void setComprensione2(CivTipoComprensione c) {
        this.comprensione2 = c
    }

    @Column(name = "MOTIVO_IMPEDIMENTO_F", nullable = true)
    private String motivoImpedimento2

    String getMotivoImpedimento2() {
        return motivoImpedimento2
    }

    void setMotivoImpedimento2(String m) {
        this.motivoImpedimento2 = m
    }

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// GENERALI ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    Integer getTipoAtto(){
        return new Integer(ETipoAtto.UCI.valore)
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.UCI
    }

    // Categoria ATL o senza categoria (atto generato con forms)
    Boolean isTestoLibero(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:CivCategoriaTipoAtto.ATL) == CivCategoriaTipoAtto.ATL )
        return val
    }

    Boolean isTrascrizioneEsteroDaPrivato(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.TEP) )
        return val
    }

    Boolean isTrascrizioneEsteroDaAutorita(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.TEA) )
        return val
    }

    Boolean isConsolatoMandatory(){
        return isTrascrizioneEsteroDaAutorita()
    }

    Boolean isEnteStranieroEnabled(){
        return ( isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita() )
    }

    Boolean isDatiRichiedenteEnabled() {
        return isTrascrizioneEsteroDaPrivato()
    }

    Boolean isAutoritaMittenteEnabled() {
        return isTrascrizioneEsteroDaAutorita()
    }

    Boolean isUnioneCivileConiugi(){
        Boolean val = ( isPartePrima() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.UCN) )
        return val
    }

    Boolean isAvvocati(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.AVV) )
        return val
    }

    Boolean isAvvocatiAltro(){
        // FIXME: verificare se esiste anche negli scioglimenti (oltre che nei divorzi)
        Boolean val = Boolean.FALSE
        return val
    }

    Boolean isUfficialeAccordo(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.UAC) )
        return val
    }

    Boolean isUfficialeConferma(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.UCO) )
        return val
    }

    Boolean isUfficialeAltro(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.UAL) )
        return val
    }

    Boolean isVolontaScioglimento(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.DVS) )
        return val
    }

    Boolean isFuoriCasaComunale(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.FCC ) )
        return val
    }

    Boolean isPericoloVita(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.PDV ) )
        return val
    }

    Boolean isCivileXDelega(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.UPD ) )
        return val
    }

    Boolean isTrascrizioneAltroComune(){
        Boolean val = ( isParteSeconda() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.T2 ) )
        return val
    }

    Boolean isUnioneCivile(){
        Boolean val = ( isPartePrima() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.O1 ) )
        return val
    }

    //////////////////////////////////////////////////////////////////
    ////////////////////////////// ZUL ///////////////////////////////
    //////////////////////////////////////////////////////////////////

    Boolean isTestimoniVisibile(){
        return ( !(isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita() || isUnioneCivileConiugi() ) )
    }

    Boolean isTestimoniMandatory(){
        // Obbligatori per un sottoinsieme di categorie per le quali sono visibili
        if (isTestimoniVisibile()){
            return ( !( isTrascrizioneAltroComune() || isTestoLibero() ) )
        }
        return Boolean.FALSE
    }

    //DICHIARANTE-COMPARENTE-FIRMATARIO nelle unioni civili
    Boolean isDichMatUciVisibile(){
        return ( isPartePrima() || isCivileXDelega() || isFuoriCasaComunale() || isPericoloVita() || isTestoLibero() )
    }

    Boolean isCompMatUciVisibile(){
        return ( isPartePrima() || isCivileXDelega() || isFuoriCasaComunale() || isPericoloVita() || isTestoLibero() )
    }

    Boolean isFirmMatUciVisibile(){
        return ( isPartePrima() || isCivileXDelega() || isFuoriCasaComunale() || isPericoloVita() || isTestoLibero() )
    }

    //DICHIARANTE-COMPARENTE-FIRMATARIO negli scioglimenti
    Boolean isDichDivScioVisibile(){
        return ( isUfficialeAccordo() || isUfficialeConferma() || isUfficialeAltro() || isVolontaScioglimento())
    }

    Boolean isCompDivScioVisibile(){
        return ( isUfficialeAccordo() || isUfficialeConferma() || isUfficialeAltro() || isVolontaScioglimento())
    }

    Boolean isFirmDivScioVisibile(){
        return ( isUfficialeAccordo() || isUfficialeConferma() || isUfficialeAltro() || isVolontaScioglimento())
    }

    Boolean isRichiestaCostituzioneVisibile(){
        return (isPartePrima() || isFuoriCasaComunale() || isPericoloVita() || isCivileXDelega() )
    }

    Boolean isEstremiAttoMatUciMandatory(){
        return ( isUfficialeAccordo() || isUfficialeConferma() )
    }

    Boolean isImpedimentoGenericoVisibile(){
        return (isPartePrima() || isFuoriCasaComunale() || isPericoloVita() || isCivileXDelega() )
    }

    String getNominativo1(){
        return ( (this.cognome1?:"") + ((this.cognome1 && this.nome1)?" ":"") + (this.nome1?:"") )
    }

    String getNominativo2(){
        return ( (this.cognome2?:"") + ((this.cognome2 && this.nome2)?" ":"") + (this.nome2?:"") )
    }

    Boolean isDataOraMatrimonioMandatory() {
        return isUnioneCivile() || isCivileXDelega() || isFuoriCasaComunale() || isPericoloVita() || isTrascrizioneEsteroDaAutorita() || isTrascrizioneEsteroDaPrivato()
    }

    Boolean isUfficialeStatoCivileMandatory() {
        return isCivileXDelega() || isFuoriCasaComunale() || isPericoloVita()
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Ufficio, Etichette.Anno, Etichette.Tipo_Atto, Etichette.Provvisorio,
                                              Etichette.Numero_Atto, Etichette.Parte, Etichette.Data_Atto,
                                              Etichette.Data_Nascita, Etichette.Codice_Fiscale, Etichette.Comune_Nascita, Etichette.Anni,
                                              Etichette.Atto_Unione_Civile, Etichette.Atto_Scioglimento, Etichette.Natura_Atto, Etichette.Codice_Fiscale, Etichette.Stato_Anagrafico,
                                              Etichette.Stato_Civile, Etichette.Senza_Cognome, Etichette.Senza_Nome, Etichette.Nazionalita, Etichette.Sesso,
                                              Etichette.Comune_Residenza, Etichette.Comune_Unione_Civile, Etichette.Data_Unione_Civile, Etichette.Ore, Etichette.Minuti,
                                              Etichette.Cognome_Contraente_1, Etichette.Nome_Contraente_1, Etichette.Cognome_Contraente_2, Etichette.Nome_Contraente_2,
                                              Etichette.Note, Etichette.Convenzioni, Etichette.Data_Convenzioni, Etichette.Data_Conferma, Etichette.Data_Accordo, Etichette.Data_Convezione, Etichette.Data_Trascrizione,
                                              Etichette.Cognome_comune, Etichette.Cambio_cognome, Etichette.Legge_Convenzioni, Etichette.Certificazione_atto, Etichette.Serie, // per estremi atto di nascita
                                              Etichette.Residenza_Contraente, Etichette.Elenco_Unioni_Civili,
                                              Etichette.Comprensione_contraente_1, Etichette.Comprensione_contraente_2, Etichette.Motivo_Impedimento, Etichette.Divieto_temporaneo]

    @PrePersist
    void beforeInsert() {
        this.cognomeNome1 = (cognome1?:"") + ((cognome1 || nome1)?"/":"") + (nome1?:"")
        this.cognomeNome2 = (cognome2?:"") + ((cognome2 || nome2)?"/":"") + (nome2?:"")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNome1 = (cognome1?:"") + ((cognome1 || nome1)?"/":"") + (nome1?:"")
        this.cognomeNome2 = (cognome2?:"") + ((cognome2 || nome2)?"/":"") + (nome2?:"")
    }
}
