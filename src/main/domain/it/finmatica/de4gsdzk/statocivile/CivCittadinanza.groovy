package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoAnsc
import it.finmatica.de4gsdzk.ISoggettoAtto1
import it.finmatica.de4gsdzk.ISoggettoAttoAnsc1
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "CIVCIT_V")
class CivCittadinanza extends CivAttoBaseDomain implements IAttoAnsc, ISoggettoAtto1, ISoggettoAttoAnsc1 {

    public static final int tipoAttoAnnotazioneSuAttoNascitaAltroComune = 6

    //Sono colonne di appoggio: le cittadinanze non hanno nè parte nè serie
    @Column(name = "PARTE", nullable = true, updatable = false, insertable = false)
    Integer parte

    //Sono colonne di appoggio: le cittadinanze non hanno nè parte nè serie
    @Column(name = "SERIE", nullable = true, updatable = false, insertable = false)
    String serie

    @Column(name = "COGNOME", nullable = true)
    String cognome

    String getCognome1() {
        return cognome
    }

    void setCognome1(String s) {
        this.cognome = s
    }

    @Column(name = "NOME", nullable = true)
    String nome

    String getNome1() {
        return nome
    }

    void setNome1(String s) {
        this.nome = s
    }

    @Column(name = "COGNOME_NOME", nullable = true)
    private String cognomeNome

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME", nullable = true)
    Boolean senzaCognome

    Boolean getSenzaCognome1() {
        return senzaCognome
    }

    void setSenzaCognome1(Boolean val) {
        senzaCognome = val
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME", nullable = true)
    Boolean senzaNome

    Boolean getSenzaNome1() {
        return senzaNome
    }

    void setSenzaNome1(Boolean val) {
        senzaNome = val
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = true)
    Date dataNascita

    Date getDataNascita1() {
        return dataNascita
    }

    void setDataNascita1(Date d) {
        this.dataNascita = d
    }

    @Column(name = "COGNOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String cognome1Lista

    @Column(name = "NOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String nome1Lista

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_1_LISTA", nullable = true, updatable = false, insertable = false)
    ESesso sesso1Lista

    String getCodiceSesso1Lista(){
        return (this.sesso1Lista?.name())
    }

    String getExtra1Lista(){
        return null
    }

    Date getExtra2Lista(){
        return this.dataEventoLista
    }

    String getExtra3Lista(){
        return this.tipoAttoDomain?.getDescrizioneEstesa()
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVENTO_LISTA", nullable = true, updatable = false, insertable = false)
    Date dataEventoLista

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_GG_IMPRECISATO_NAS", nullable = true)
    Boolean giornoNascitaImprecisato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MM_IMPRECISATO_NAS", nullable = true)
    Boolean meseNascitaImprecisato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_AA_IMPRECISATO_NAS", nullable = true)
    Boolean annoNascitaImprecisato

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = true)
    ESesso sesso

    ESesso getSesso1() {
        return sesso
    }

    void setSesso1(ESesso s) {
        this.sesso = s
    }

    @Column(name = "COD_FISCALE", nullable = true)
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String val) {
        this.codiceFiscale = (val?.toUpperCase())
    }

    String getCodiceFiscale1() {
        return getCodiceFiscale()
    }

    void setCodiceFiscale1(String c) {
        setCodiceFiscale(c)
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO", nullable = true)
    private Boolean cfCalcolato

    Boolean getCfCalcolato1() {
        return cfCalcolato
    }

    void setCfCalcolato1(Boolean val) {
        this.cfCalcolato = val
    }

    @Column(name = "NOTE", nullable = true)
    String note

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA", nullable = true)
    private AnaNazionalita nazionalita1

    AnaNazionalita getNazionalita1() {
        return nazionalita1
    }

    void setNazionalita1(AnaNazionalita n) {
        this.nazionalita1 = n
    }

    String getStatoCivile1() {
        return null
    }

    void setStatoCivile1(String s) {
        log.info ("Parametro stato civile non gestito su civcit: " + (s?:"") )
    }

    // 04/06/2024 in uso solo per 52111: Acquisto alla nascita per iure soli
    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ACCERTAMENTO", nullable = true)
    Date dataAccertamento

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_RICHIESTA", nullable = true)
    Date dataRichiesta

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CIT", nullable = true)
    Date dataGiuramento

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_GG_IMPRECISATO", nullable = true)
    Boolean giornoGiuramentoImprecisato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MM_IMPRECISATO", nullable = true)
    Boolean meseGiuramentoImprecisato

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_AA_IMPRECISATO", nullable = true)
    Boolean annoGiuramentoImprecisato

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_DECORRENZA", nullable = true)
    Date dataDecorrenza

    @Column(name = "COD_COM_NAS", nullable = true)
    Integer codiceComuneNascita

    Integer getCodiceComuneNascita1() {
        return codiceComuneNascita
    }

    void setCodiceComuneNascita1(Integer i) {
        this.codiceComuneNascita = i
    }

    @Column(name = "DES_COM_NAS", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneNascita

    String getDescrizioneComuneNascita1() {
        return descrizioneComuneNascita
    }

    void setDescrizioneComuneNascita1(String s) {
        this.descrizioneComuneNascita = s
    }

    @Column(name = "COD_PRO_NAS", nullable = false)
    Integer codiceProvinciaNascita

    Integer getCodiceProvinciaNascita1() {
        return codiceProvinciaNascita
    }

    void setCodiceProvinciaNascita1(Integer i) {
        this.codiceProvinciaNascita = i
    }

    @Column(name = "SIGLA_PRO_NAS", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaNascita

    String getSiglaProvinciaNascita1() {
        return siglaProvinciaNascita
    }

    void setSiglaProvinciaNascita1(String s) {
        this.siglaProvinciaNascita = s
    }

    @Column(name = "COD_COM_RES", nullable = true)
    Integer codiceComuneResidenza

    Integer getCodiceComuneResidenza1() {
        return codiceComuneResidenza
    }

    void setCodiceComuneResidenza1(Integer i) {
        this.codiceComuneResidenza = i
    }

    @Column(name = "DES_COM_RES", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneResidenza

    String getDescrizioneComuneResidenza1() {
        return descrizioneComuneResidenza
    }

    void setDescrizioneComuneResidenza1(String s) {
        this.descrizioneComuneResidenza = s
    }

    @Column(name = "COD_PRO_RES", nullable = false)
    Integer codiceProvinciaResidenza

    Integer getCodiceProvinciaResidenza1() {
        return codiceProvinciaResidenza
    }

    void setCodiceProvinciaResidenza1(Integer i) {
        this.codiceProvinciaResidenza = i
    }

    @Column(name = "SIGLA_PRO_RES", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaResidenza

    String getSiglaProvinciaResidenza1() {
        return siglaProvinciaResidenza
    }

    void setSiglaProvinciaResidenza1(String s) {
        this.siglaProvinciaResidenza = s
    }

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="ID_CIVDMC", nullable = true)
    CivMotivoRichiesta motivoCittadinanza

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICONOSCIMENTO", nullable=true)
    ETipoRiconoscimentoCittadinanza tipoRiconoscimento

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICHIESTA", nullable=true)
    ETipoRichiesta tipoRichiesta

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_TRASMISSIONE_CITTADINANZA", nullable=true)
    ETipoTrasmissioneCittadinanza tipoTrasmissioneCittadinanza

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_FIRMATO_USC_ANSC", nullable = true, updatable = false, insertable = false)
    Boolean flagFirmatoUscAnsc

    @Column(name = "ID_USECASE_ANSC", nullable=true)
    Long idAnscUseCase

    @Column(name = "NUMERO_UNICO", nullable = true)
    Long numeroUnico

    @Column(name = "ID_ATTO_ANSC", nullable = true)
    String idAttoAnsc

    @Column(name = "ID_SOGGETTO_ANSC", nullable = true)
    Long idSoggettoAnsc1

    @Enumerated(EnumType.STRING)
    @Column(name = "MOTIVO_RECUPERO_ANSC")
    EMotivoRecupero motivoRecuperoAnsc

    @Enumerated(EnumType.STRING)
    @Formula("""CASE WHEN MOTIVO_RECUPERO_ANSC IS NOT NULL THEN 'SI' ELSE 'NO' END""")
    ETipoSiNo motivoRecuperoAnscValorizzato

    ETipoArchivioAnsc getTipoArchivioAnsc(){
        return ETipoArchivioAnsc.CIT
    }

    ETipoAttoAnsc getTipoAttoAnsc(){
        if (isGiuramento()){
            return ETipoAttoAnsc.Citt
        } else
        // refs #70519
        if ( isTrascrizione() || [ENaturaAtto.D].contains(natura) ){
            return ETipoAttoAnsc.Trascr_Citt
        } else {
            return ETipoAttoAnsc.Citt
        }
    }

    Boolean isDichiarazione(){
        return tipoRichiesta?.equals(ETipoRichiesta.DIC)
    }

    Boolean isTrascrizione(){
        return tipoRichiesta?.equals(ETipoRichiesta.TRA)
    }

    Boolean isTrascrizioneEsteroDaPrivato(){
        // Casisitica non prevista per le cittadinanze
        return Boolean.FALSE
    }

    Boolean isTrascrizioneEsteroDaAutorita(){
        //Inserita per gestire al momento usecase 52111 (ius soli), 52153 e 52154
        //condizione dinamica diversamente dalle altre tipologie di atti
        return ( isTrascrizione() && (this.motivoCittadinanza?.flagEnteEstero || this.motivoCittadinanza?.flagAutorita) )
    }

    Boolean isConsolatoMandatory(){
        return Boolean.FALSE
    }

    Boolean isEnteStranieroEnabled(){
        //condizione dinamica diversamente dalle altre tipologie di atti
        //Inserita per uniformità con gli altri atti e per gestire lo usecase 52111 (ius soli)
        return ( isTrascrizione() && this.motivoCittadinanza?.flagEnteEstero )
    }

    Boolean isDatiRichiedenteEnabled() {
        return isTrascrizioneEsteroDaPrivato()
    }

    Boolean isAutoritaMittenteEnabled() {
        return isTrascrizioneEsteroDaAutorita()
    }

    Integer getTipoAtto(){
        return new Integer(ETipoAtto.CIT.valore)
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.CIT
    }

    Boolean isUfficialeStatoCivileMandatory() {
        return false
    }

    // Categoria ATL o senza categoria (atto generato con forms)
    Boolean isTestoLibero(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:CivCategoriaTipoAtto.ATL) == CivCategoriaTipoAtto.ATL )
        return val
    }

    Boolean isGiuramento(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.GIU )
        return val
    }

    Boolean isAcquisto(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.DAQ )
        return val
    }

    Boolean isPerdita(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.DPE )
        return val
    }

    Boolean isRichiestaDiciottenne(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.R18 )
        return val
    }

    Boolean isAttestazioneSindacoDiciottenne(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.AS1 )
        return val
    }

    Boolean isAttestazioneSindacoMinore(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.ASM )
        return val
    }

    Boolean isDicCompFirmCitVisibile(){
        //condizione dinamica diversamente dalle altre tipologie di atti
        return ( isGiuramento() ||
                (isAcquisto() && isDichiarazione() ) ||
                (isAcquisto() && isTrascrizione() && this.motivoCittadinanza?.flagCambioGeneralita && !(this.motivoCittadinanza?.flagConsolato) ) )
    }

    Boolean isComprensioneDichiaranteVisibile(){
        return isDicCompFirmCitVisibile()
    }

    Boolean isDataProvvedimentoSindacoMandatory() {
        return this.motivoCittadinanza?.flagMinore && this.motivoCittadinanza?.flagRiconoscimento
    }

    Boolean isDatiDecretoAttestazioneVisible() {
        return !this.motivoCittadinanza?.flagMinore
    }

    Boolean isDataAttoEstremiAttoNascitaVisible() {
        return Boolean.FALSE
    }

    String getNominativo(){
        return ( (this.cognome?:"") + ((this.cognome && this.nome)?" ":"") + (this.nome?:"") )
    }

    Boolean isEstremiGiuramentoMandatory() {
        return this.motivoCittadinanza?.flagEstremiGiuramento ?: Boolean.FALSE
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Ufficio, Etichette.Anno, Etichette.Tipo_Atto, Etichette.Provvisorio,
                                              Etichette.Numero_Atto, Etichette.Atto_Cittadinanza, Etichette.Natura_Atto,
                                              Etichette.Cognome, Etichette.Nome, Etichette.Data_Nascita, Etichette.Data,
                                              Etichette.Senza_Cognome, Etichette.Senza_Nome, Etichette.Data_Giuramento,
                                              Etichette.Data_Decorrenza, Etichette.Data_Accertamento,
                                              Etichette.Sesso, Etichette.Data_Cittadinanza, Etichette.Ore, Etichette.Minuti, Etichette.Comune_Nascita,
                                              Etichette.Codice_Fiscale, Etichette.Nazionalita, Etichette.Comune_Residenza,
                                              Etichette.Stato_Civile, Etichette.Stato_Anagrafico, Etichette.Data_Richiesta,
                                              Etichette.Parte, Etichette.Serie, // per estremi atto di nascita
                                              Etichette.Note, Etichette.Certificazione_atto, Etichette.Cognome_Nome, Etichette.Tipo_riconoscimento,
                                              Etichette.Grado_parentela, Etichette.Rapporto_Parentela, Etichette.Elenco_Cittadinanze]

    @PrePersist
    void beforeInsert() {
        this.cognomeNome = (cognome?:"") + ((cognome || nome)?"/":"") + (nome?:"")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNome = (cognome?:"") + ((cognome || nome)?"/":"") + (nome?:"")
    }
}
