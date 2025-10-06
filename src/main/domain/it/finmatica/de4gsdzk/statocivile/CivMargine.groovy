package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.GsdBaseDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggetto1Domain
import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.ansc.AnscConsolato
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.*

import javax.persistence.*

@Entity
@Table(name = "CIVMAR_V")
class CivMargine extends GsdBaseDomain implements IEstremiAttoNascitaSoggetto1Domain, IRiferimentoAttoDomain{

    @Id
    @Column(name = "ID")
    Long id

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "TIPO_ATTO", nullable = false)
    Integer tipoAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

    @Enumerated(EnumType.STRING)
    @Column(name = "DESTRA_SINISTRA", nullable = true)
    ETipoMargineLaterale tipoMargineLaterale

    @Enumerated(EnumType.STRING)
    @Column(name = "ALTO_BASSO", nullable = true)
    ETipoMargineIntestazione tipoMargineIntestazione

    @Column(name = "COMUNE_TRAS_1", nullable = true)
    String descrizioneComuneTras1

    @Column(name = "ANNO_TRAS_1", nullable = true)
    String annoTras1

    @Column(name = "ATTO_TRAS_1", nullable = true)
    Integer attoTras1

    @Column(name = "PARTE_TRAS_1", nullable = true)
    String parteTras1

    @Column(name = "SERIE_TRAS_1", nullable = true)
    String serieTras1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_COMUNICAZIONE_1", nullable = false)
    Date dataComunicazione1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FIRMA_1", nullable = false)
    Date dataFirma1

    @Column(name = "COMUNE_TRAS_2", nullable = true)
    String descrizioneComuneTras2

    @Column(name = "ANNO_TRAS_2", nullable = true)
    String annoTras2

    @Column(name = "ATTO_TRAS_2", nullable = true)
    Integer attoTras2

    @Column(name = "PARTE_TRAS_2", nullable = true)
    String parteTras2

    @Column(name = "SERIE_TRAS_2", nullable = true)
    String serieTras2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_COMUNICAZIONE_2", nullable = false)
    Date dataComunicazione2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_FIRMA_2", nullable = false)
    Date dataFirma2

    //Pubblicazioni

    @Enumerated(EnumType.STRING)
    @Column(name = "DOCUMENTI_PRESENTATI_MAT", nullable = true)
    EDocumentoMatrimonio documentoPresentatoMatrimonio

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DA_DATA_AFF_1", nullable = true)
    Date dataAffissioneDa1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_A_DATA_AFF_1", nullable = true)
    Date dataAffissioneA1

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_AFF_1")),
            @AttributeOverride(name="descrizione", column = @Column(name = "COMUNE_AFF_1")),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_AFF_1")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_AFF_1", updatable = false, insertable = false))
    ])
    private Comune comuneAffissione1

    Comune getComuneAffissione1() {
        if (comuneAffissione1 == null){
            comuneAffissione1 = new Comune()
        }
        return comuneAffissione1
    }

    void setComuneAffissione1(Comune c) {
        this.comuneAffissione1 = c
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CONSOLATO_ANSC_AFF_1", nullable = true)
    AnscConsolato consolatoAffisione1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DA_DATA_AFF_2", nullable = true)
    Date dataAffissioneDa2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_A_DATA_AFF_2", nullable = true)
    Date dataAffissioneA2

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_AFF_2")),
            @AttributeOverride(name="descrizione", column = @Column(name = "COMUNE_AFF_2")),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_AFF_2")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_AFF_2", updatable = false, insertable = false))
    ])
    private Comune comuneAffissione2

    Comune getComuneAffissione2() {
        if (comuneAffissione2 == null){
            comuneAffissione2 = new Comune()
        }
        return comuneAffissione2
    }

    void setComuneAffissione2(Comune c) {
        this.comuneAffissione2 = c
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CONSOLATO_ANSC_AFF_2", nullable = true)
    AnscConsolato consolatoAffisione2

    @Column(name = "GIORNI_AFF_2", nullable = true)
    String giorniAffissione

    @Column(name = "SCELTA_CONV", nullable = true)
    Integer sceltaConvenzioni

    @Column(name = "LEGGE_CONV", nullable = true)
    String leggeConvenzioni

    @Column(name = "ARTICOLO", nullable = true)
    Integer articoloCertificato

    @Column(name = "LEGGE", nullable = true)
    String leggeCertificato

    Boolean isMargineDestro(){
        Boolean val = (this.tipoMargineLaterale == ETipoMargineLaterale.D)
        return val
    }

    Boolean isMargineSinistro(){
        Boolean val = (this.tipoMargineLaterale == ETipoMargineLaterale.S)
        return val
    }

    @Column(name = "UFFICIO_NAS", nullable = true)
    String ufficioAttoNascitaString

    @Column(name = "ANNO_NAS", nullable = true)
    String annoAttoNascitaString

    @Column(name = "ATTO_NAS", nullable = false)
    Integer attoAttoNascita

    @Column(name = "PARTE_NAS", nullable = true)
    String parteAttoNascitaString

    @Column(name = "SERIE_NAS", nullable = true)
    private String serieAttoNascita

    String getSerieAttoNascita() {
        return serieAttoNascita
    }

    void setSerieAttoNascita(String serieAttoNascita) {
        this.serieAttoNascita = serieAttoNascita?.toUpperCase()
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ATTO_NAS", nullable = true)
    Date dataAttoNascita

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = true)
    Date dataFirmaAttoNascita

    @Column(name = "COD_COM_ATTO_NAS", nullable = true)
    Integer codiceComuneAttoNascita

    @Column(name = "COMUNE_NAS", nullable = true)
    String descrizioneComuneAttoNascita

    @Column(name = "COD_PRO_ATTO_NAS", nullable = true)
    Integer codiceProvinciaAttoNascita

    @Column(name = "SIGLA_PRO_NAS", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaAttoNascita

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_COMUNE_UTENTE_NAS", nullable = true, updatable = false, insertable = false)
    ETipoSN comuneAttoNascitaUtenteDb

    Boolean getComuneAttoNascita1Utente() {
        return (comuneAttoNascitaUtenteDb == ETipoSN.S)
    }

    //Ad uso delle formule del margine
    @Column(name = "MINISTRO_1", nullable = true)
    String ministro1

    //Ad uso delle formule del margine
    @Column(name = "MINISTRO_2", nullable = true)
    String ministro2

    //Ad uso delle formule del margine (libretto)
    @Column(name = "NUMERO_LIB", nullable = true)
    String numeroLibretto

    //Ad uso delle formule del margine (libretto)
    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_LIB", nullable = true)
    Date dataLibretto

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "STAMPA_TR1", nullable = true)
    Boolean stampaFormulaMargineTr1

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "STAMPA_TR2", nullable = true)
    Boolean stampaFormulaMargineTr2

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "STAMPA_NAS", nullable = true)
    Boolean stampaFormulaNascita

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "STAMPA_MIN", nullable = true)
    Boolean stampaFormulaMinistro

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "STAMPA_SEN", nullable = true)
    Boolean stampaFormulaSentenza

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "STAMPA_LIB", nullable = true)
    Boolean stampaFormulaLibretto

    @Column(name = "ID_ATTO_ANSC_NAS", nullable = true)
    private String idAttoAnscNascita1

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////// ANNOTAZIONI /////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    // SOGGETTO 1
    // Ufficio atto
    Integer getUfficioAttoNascita1(){
        return AnnotazioneUtils.fromStringToIntegerUfficio(ufficioAttoNascitaString)
    }
    void setUfficioAttoNascita1(Integer ufficioAttoNascita1) {
        this.ufficioAttoNascitaString = ufficioAttoNascita1?.toString()
    }
    // Anno atto
    Integer getAnnoAttoNascita1(){
        return AnnotazioneUtils.fromStringToIntegerAnno(annoAttoNascitaString)
    }
    void setAnnoAttoNascita1(Integer annoAttoNascita1) {
        this.annoAttoNascitaString = annoAttoNascita1?.toString()
    }
    // Numero atto
    Integer getAttoAttoNascita1(){
        return attoAttoNascita
    }
    void setAttoAttoNascita1(Integer attoAttoNascita1) {
        this.attoAttoNascita = attoAttoNascita1
    }
    // Parte atto
    Integer getParteAttoNascita1(){
        return AnnotazioneUtils.fromStringToIntegerParte(parteAttoNascitaString)
    }
    String getParteAttoNascita1String() {
        return parteAttoNascitaString
    }

    void setParteAttoNascita1String(String parteAttoNascita1String) {
        this.parteAttoNascitaString = parteAttoNascita1String
    }
    // Serie atto
    String getSerieAttoNascita1(){
        return serieAttoNascita
    }
    void setSerieAttoNascita1(String serieAttoNascita1) {
        this.setSerieAttoNascita(serieAttoNascita1)
    }
    // Codice comune
    Integer getCodiceComuneAttoNascita1(){
        return codiceComuneAttoNascita
    }
    void setCodiceComuneAttoNascita1(Integer codiceComuneAttoNascita1) {
        this.codiceComuneAttoNascita = codiceComuneAttoNascita1
    }
    // Descrizione comune
    String getDescrizioneComuneAttoNascita1(){
        return descrizioneComuneAttoNascita
    }
    void setDescrizioneComuneAttoNascita1(String descrizioneComuneAttoNascita1) {
        this.descrizioneComuneAttoNascita = descrizioneComuneAttoNascita1
    }
    // Codice provincia
    Integer getCodiceProvinciaAttoNascita1(){
        return codiceProvinciaAttoNascita
    }
    void setCodiceProvinciaAttoNascita1(Integer codiceProvinciaAttoNascita1) {
        this.codiceProvinciaAttoNascita = codiceProvinciaAttoNascita1
    }
    // Sigla provincia
    String getSiglaProvinciaAttoNascita1() {
        return siglaProvinciaAttoNascita
    }
    void setSiglaProvinciaAttoNascita1(String siglaProvinciaAttoNascita1) {
        this.siglaProvinciaAttoNascita = siglaProvinciaAttoNascita1
    }

    String getIdAttoAnscNascita1() {
        return idAttoAnscNascita1
    }
    void setIdAttoAnscNascita1(String s) {
        this.idAttoAnscNascita1 = s
    }

    /////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI /////////////////////////////
    /////////////////////////////////////////////////////////////////////////


    static final String tipoMagineDS = "DS"

    static final String tipoMagineAB = "AB"

    static final String S = "S"
    static final String S1 = "S1"
    static final String INV = "INV"
    static final String INV1 = "INV1"
    static final String N = "N"

    static final List<Map> etichetteDomain = [Etichette.Margine, Etichette.Affissione_nel_Comune_di, Etichette.Rilasciato_Libretto_famiglia,
                                              Etichette.Dal, Etichette.Al]

}
