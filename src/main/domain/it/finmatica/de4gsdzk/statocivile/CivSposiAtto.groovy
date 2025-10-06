package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IEstremiAttoMatrimonioDomain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggetto1Domain
import it.finmatica.de4gsdzk.IEstremiAttoNascitaSoggetto2Domain
import it.finmatica.de4gsdzk.IRiferimentoAttoDomain
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.AnnotazioneUtils
import it.finmatica.de4gsdzk.utils.ETipoSN

import javax.persistence.*

@Entity
@Table(name = "CIVSPO_V", uniqueConstraints = @UniqueConstraint(columnNames=["TIPO_ATTO", "UFFICIO", "ANNO", "PARTE", "SERIE", "ATTO"]))
class CivSposiAtto implements IEstremiAttoNascitaSoggetto1Domain, IEstremiAttoNascitaSoggetto2Domain, IEstremiAttoMatrimonioDomain, IRiferimentoAttoDomain{

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

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// SPOSO //////////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIO_NAS_M", nullable = true)
    private Integer ufficioAttoNascita1

    Integer getUfficioAttoNascita1() {
        return ufficioAttoNascita1
    }

    void setUfficioAttoNascita1(Integer ufficioAttoNascita1) {
        this.ufficioAttoNascita1 = ufficioAttoNascita1
    }

    @Column(name = "ANNO_ATTO_NAS_M", nullable = true)
    private Integer annoAttoNascita1

    Integer getAnnoAttoNascita1() {
        return annoAttoNascita1
    }

    void setAnnoAttoNascita1(Integer annoAttoNascita1) {
        this.annoAttoNascita1 = annoAttoNascita1
    }

    @Column(name = "ATTO_NAS_M", nullable = false)
    private Integer attoAttoNascita1

    Integer getAttoAttoNascita1() {
        return attoAttoNascita1
    }

    void setAttoAttoNascita1(Integer attoAttoNascita1) {
        this.attoAttoNascita1 = attoAttoNascita1
    }

    @Column(name = "PARTE_NAS_M", nullable = true)
    private String parteAttoNascita1String

    String getParteAttoNascita1String() {
        return parteAttoNascita1String
    }

    void setParteAttoNascita1String(String s) {
        this.parteAttoNascita1String = s
    }

    Integer getParteAttoNascita1(){
        return AnnotazioneUtils.fromStringToIntegerParte(parteAttoNascita1String)
    }

    @Column(name = "SERIE_NAS_M", nullable = true)
    private String serieAttoNascita1

    String getSerieAttoNascita1(){
        return serieAttoNascita1
    }

    void setSerieAttoNascita1(String serieAttoNascita1) {
        this.serieAttoNascita1 = serieAttoNascita1?.toUpperCase()
    }

    @Column(name = "COD_COM_ATTO_NAS_M", nullable = true)
    private Integer codiceComuneAttoNascita1

    Integer getCodiceComuneAttoNascita1() {
        return codiceComuneAttoNascita1
    }

    void setCodiceComuneAttoNascita1(Integer codiceComuneAttoNascita1) {
        this.codiceComuneAttoNascita1 = codiceComuneAttoNascita1
    }

    @Column(name = "COM_ATTO_NAS_M", nullable = true)
    private String descrizioneComuneAttoNascita1

    String getDescrizioneComuneAttoNascita1() {
        return descrizioneComuneAttoNascita1
    }

    void setDescrizioneComuneAttoNascita1(String descrizioneComuneAttoNascita1) {
        this.descrizioneComuneAttoNascita1 = descrizioneComuneAttoNascita1
    }

    @Column(name = "COD_PRO_ATTO_NAS_M", nullable = true)
    private Integer codiceProvinciaAttoNascita1

    Integer getCodiceProvinciaAttoNascita1() {
        return codiceProvinciaAttoNascita1
    }

    void setCodiceProvinciaAttoNascita1(Integer codiceProvinciaAttoNascita1) {
        this.codiceProvinciaAttoNascita1 = codiceProvinciaAttoNascita1
    }

    @Column(name = "SIGLA_PRO_ATTO_NAS_M", nullable = true, updatable = false, insertable = false)
    private String siglaProvinciaAttoNascita1

    String getSiglaProvinciaAttoNascita1() {
        return siglaProvinciaAttoNascita1
    }

    void setSiglaProvinciaAttoNascita1(String siglaProvinciaAttoNascita1) {
        this.siglaProvinciaAttoNascita1 = siglaProvinciaAttoNascita1
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_COMUNE_UTENTE_M", nullable = true, updatable = false, insertable = false)
    private ETipoSN comuneAttoNascita1UtenteDb

    Boolean getComuneAttoNascita1Utente() {
        return (comuneAttoNascita1UtenteDb == ETipoSN.S)
    }

    @Column(name = "ID_ATTO_ANSC_NAS_M", nullable = true)
    private String idAttoAnscNascita1

    String getIdAttoAnscNascita1() {
        return idAttoAnscNascita1
    }

    void setIdAttoAnscNascita1(String s) {
        this.idAttoAnscNascita1 = s
    }

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// SPOSA //////////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIO_NAS_F", nullable = true)
    private Integer ufficioAttoNascita2

    Integer getUfficioAttoNascita2() {
        return ufficioAttoNascita2
    }

    void setUfficioAttoNascita2(Integer ufficioAttoNascita2) {
        this.ufficioAttoNascita2 = ufficioAttoNascita2
    }

    @Column(name = "ANNO_ATTO_NAS_F", nullable = true)
    private Integer annoAttoNascita2

    Integer getAnnoAttoNascita2() {
        return annoAttoNascita2
    }

    void setAnnoAttoNascita2(Integer i) {
        this.annoAttoNascita2 = i
    }

    @Column(name = "ATTO_NAS_F", nullable = false)
    private Integer attoAttoNascita2

    Integer getAttoAttoNascita2() {
        return attoAttoNascita2
    }

    void setAttoAttoNascita2(Integer i) {
        this.attoAttoNascita2 = i
    }

    @Column(name = "PARTE_NAS_F", nullable = true)
    private String parteAttoNascita2String

    String getParteAttoNascita2String() {
        return parteAttoNascita2String
    }

    void setParteAttoNascita2String(String s) {
        this.parteAttoNascita2String = s
    }

    Integer getParteAttoNascita2(){
        return AnnotazioneUtils.fromStringToIntegerParte(parteAttoNascita2String)
    }

    @Column(name = "SERIE_NAS_F", nullable = true)
    private String serieAttoNascita2

    String getSerieAttoNascita2(){
        return serieAttoNascita2
    }

    void setSerieAttoNascita2(String serieAttoNascita2) {
        this.serieAttoNascita2 = serieAttoNascita2?.toUpperCase()
    }

    @Column(name = "COD_COM_ATTO_NAS_F", nullable = true)
    private Integer codiceComuneAttoNascita2

    Integer getCodiceComuneAttoNascita2() {
        return codiceComuneAttoNascita2
    }

    void setCodiceComuneAttoNascita2(Integer i) {
        this.codiceComuneAttoNascita2 = i
    }

    @Column(name = "COM_ATTO_NAS_F", nullable = true)
    private String descrizioneComuneAttoNascita2

    String getDescrizioneComuneAttoNascita2() {
        return descrizioneComuneAttoNascita2
    }

    void setDescrizioneComuneAttoNascita2(String s) {
        this.descrizioneComuneAttoNascita2 = s
    }

    @Column(name = "COD_PRO_ATTO_NAS_F", nullable = true)
    private Integer codiceProvinciaAttoNascita2

    Integer getCodiceProvinciaAttoNascita2() {
        return codiceProvinciaAttoNascita2
    }

    void setCodiceProvinciaAttoNascita2(Integer i) {
        this.codiceProvinciaAttoNascita2 = i
    }

    @Column(name = "SIGLA_PRO_ATTO_NAS_F", nullable = true, updatable = false, insertable = false)
    private String siglaProvinciaAttoNascita2

    String getSiglaProvinciaAttoNascita2() {
        return siglaProvinciaAttoNascita2
    }

    void setSiglaProvinciaAttoNascita2(String s) {
        this.siglaProvinciaAttoNascita2 = s
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_COMUNE_UTENTE_F", nullable = true, updatable = false, insertable = false)
    private ETipoSN comuneAttoNascita2UtenteDb

    Boolean getComuneAttoNascita2Utente() {
        return (comuneAttoNascita2UtenteDb == ETipoSN.S)
    }

    @Column(name = "ID_ATTO_ANSC_NAS_F", nullable = true)
    private String idAttoAnscNascita2

    String getIdAttoAnscNascita2() {
        return idAttoAnscNascita2
    }

    void setIdAttoAnscNascita2(String s) {
        this.idAttoAnscNascita2 = s
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// MATRIMONIO ////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIO_MAT", nullable = true)
    private Integer ufficioAttoMatrimonio

    Integer getUfficioAttoMatrimonio() {
        return ufficioAttoMatrimonio
    }

    void setUfficioAttoMatrimonio(Integer ufficioAttoMatrimonio) {
        this.ufficioAttoMatrimonio = ufficioAttoMatrimonio
    }

    @Column(name = "ANNO_ATTO_MAT", nullable = true)
    private Integer annoAttoMatrimonio

    Integer getAnnoAttoMatrimonio() {
        return annoAttoMatrimonio
    }

    void setAnnoAttoMatrimonio(Integer annoAttoMatrimonio) {
        this.annoAttoMatrimonio = annoAttoMatrimonio
    }

    @Column(name = "ATTO_MAT", nullable = false)
    private Integer attoAttoMatrimonio

    Integer getAttoAttoMatrimonio() {
        return attoAttoMatrimonio
    }

    void setAttoAttoMatrimonio(Integer attoAttoMatrimonio) {
        this.attoAttoMatrimonio = attoAttoMatrimonio
    }

    @Column(name = "PARTE_MAT", nullable = true)
    private String parteAttoMatrimonioString

    String getParteAttoMatrimonioString() {
        return parteAttoMatrimonioString
    }

    void setParteAttoMatrimonioString(String s) {
        this.parteAttoMatrimonioString = s
    }

    Integer getParteAttoMatrimonio(){
        return AnnotazioneUtils.fromStringToIntegerParte(parteAttoMatrimonioString)
    }

    @Column(name = "SERIE_MAT", nullable = true)
    private String serieAttoMatrimonio

    String getSerieAttoMatrimonio() {
        return serieAttoMatrimonio
    }

    void setSerieAttoMatrimonio(String serieAttoMatrimonio) {
        this.serieAttoMatrimonio = serieAttoMatrimonio?.toUpperCase()
    }

    @Column(name = "COD_COM_ATTO_MAT", nullable = true)
    private Integer codiceComuneAttoMatrimonio

    Integer getCodiceComuneAttoMatrimonio() {
        return codiceComuneAttoMatrimonio
    }

    void setCodiceComuneAttoMatrimonio(Integer i) {
        this.codiceComuneAttoMatrimonio = i
    }

    @Column(name = "DES_COM_ATTO_MAT", nullable = true, updatable = false, insertable = false)
    private String descrizioneComuneAttoMatrimonio

    String getDescrizioneComuneAttoMatrimonio() {
        return descrizioneComuneAttoMatrimonio
    }

    void setDescrizioneComuneAttoMatrimonio(String s) {
        this.descrizioneComuneAttoMatrimonio = s
    }

    @Column(name = "COD_PRO_ATTO_MAT", nullable = true)
    private Integer codiceProvinciaAttoMatrimonio

    Integer getCodiceProvinciaAttoMatrimonio() {
        return codiceProvinciaAttoMatrimonio
    }

    void setCodiceProvinciaAttoMatrimonio(Integer i) {
        this.codiceProvinciaAttoMatrimonio = i
    }

    @Column(name = "SIGLA_PRO_ATTO_MAT", nullable = true, updatable = false, insertable = false)
    private String siglaProvinciaAttoMatrimonio

    String getSiglaProvinciaAttoMatrimonio() {
        return siglaProvinciaAttoMatrimonio
    }

    void setSiglaProvinciaAttoMatrimonio(String s) {
        this.siglaProvinciaAttoMatrimonio = s
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "FLAG_COMUNE_UTENTE_MAT", nullable = true, updatable = false, insertable = false)
    ETipoSN comuneAttoMatrimonioUtenteDb

    Boolean getComuneAttoMatrimonioUtente() {
        return (comuneAttoMatrimonioUtenteDb == ETipoSN.S)
    }

    @Temporal(TemporalType.DATE)
    @Column( name = "D_DATA_ATTO_MAT", nullable = true)
    Date dataAttoMatrimonio

    @Column(name = "ID_ATTO_ANSC_MAT", nullable = true)
    private String idAttoAnscMatrimonio

    String getIdAttoAnscMatrimonio() {
        return idAttoAnscMatrimonio
    }

    void setIdAttoAnscMatrimonio(String s) {
        this.idAttoAnscMatrimonio = s
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_MAT")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_MAT", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_MAT")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_MAT", updatable = false, insertable = false))
    ])
    private Comune comuneMatrimonio

    Comune getComuneMatrimonio() {
        if (comuneMatrimonio == null){
            comuneMatrimonio = new Comune()
        }
        return comuneMatrimonio
    }

    void setComuneMatrimonio(Comune c) {
        this.comuneMatrimonio = c
    }

    @Temporal(TemporalType.DATE)
    @Column( name = "D_DATA_MAT", nullable = true)
    Date dataMatrimonio

    @Column(name = "OFFICIANTE_MAT", nullable = true)
    String officiante

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

}