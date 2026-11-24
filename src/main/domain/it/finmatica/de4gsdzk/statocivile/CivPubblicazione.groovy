package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoPubPvu
import it.finmatica.de4gsdzk.ISoggettoAtto1
import it.finmatica.de4gsdzk.ISoggettoAtto2
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.EStatoCivile
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "CIVPUB_V", uniqueConstraints = @UniqueConstraint(columnNames=["UFFICIO", "ANNO", "PARTE", "SERIE", "ATTO"]))
class CivPubblicazione extends CivAttoBaseDomain implements ISoggettoAtto1, ISoggettoAtto2, IAttoPubPvu{

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

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PUB", nullable = true)
    Date dataPubblicazione

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

    String getDescrizioneComuneMatrimonio() {
        return descrizioneComuneMatrimonio
    }

    void setDescrizioneComuneMatrimonio(String s) {
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

    String getSiglaProvinciaMatrimonio() {
        return siglaProvinciaMatrimonio
    }

    void setSiglaProvinciaMatrimonio(String s) {
        this.siglaProvinciaMatrimonio = s
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_D3", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloD3

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// LUI /////////////////////////////////
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

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_M", nullable = true)
    private Boolean senzaNome1

    Boolean getSenzaNome1() {
        return senzaNome1
    }

    void setSenzaNome1(Boolean val) {
        this.senzaNome1 = val
    }

    @Column(name = "COGNOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String cognome1Lista

    @Column(name = "NOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String nome1Lista

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVENTO_LISTA", nullable = true, updatable = false, insertable = false)
    Date dataEventoLista

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_M", nullable = true)
    private AnaCittadinanza nazionalita1

    AnaCittadinanza getNazionalita1() {
        return nazionalita1
    }

    void setNazionalita1(AnaCittadinanza n) {
        this.nazionalita1 = n
    }

    @Column(name = "COD_FISCALE_M", nullable = true)
    private String codiceFiscale1

    String getCodiceFiscale1() {
        return codiceFiscale1
    }

    void setCodiceFiscale1(String val) {
        this.codiceFiscale1 = (val?.toUpperCase())
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

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_M", nullable = true)
    private Date dataNascita1

    Date getDataNascita1() {
        return dataNascita1
    }

    void setDataNascita1(Date d) {
        this.dataNascita1 = d
    }

    ESesso getSesso1() {
        return ESesso.M
    }

    void setSesso1(ESesso s) {
        log.info ("Parametri sesso non gestito su civpub: " + (s?.name()?:"") )
    }

    String getCodiceSesso1Lista(){
        return (getSesso1()?.name())
    }

    EStatoCivile getStatoCivile1() {
        return null
    }

    void setStatoCivile1(EStatoCivile s) {
        log.info ("Parametri stato civile non gestito su civpub: " + (s?:"") )
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

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// LEI /////////////////////////////////
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

    @ManyToOne(fetch=FetchType.LAZY)
    @JoinColumn(name="NAZIONALITA_F", nullable = true)
    private AnaCittadinanza nazionalita2

    AnaCittadinanza getNazionalita2() {
        return nazionalita2
    }

    void setNazionalita2(AnaCittadinanza n) {
        this.nazionalita2 = n
    }

    @Column(name = "COD_FISCALE_F", nullable = true)
    private String codiceFiscale2

    String getCodiceFiscale2() {
        return codiceFiscale2
    }

    void setCodiceFiscale2(String val) {
        this.codiceFiscale2 = (val?.toUpperCase())
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

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_F", nullable = true)
    private Date dataNascita2

    Date getDataNascita2() {
        return dataNascita2
    }

    void setDataNascita2(Date d) {
        this.dataNascita2 = d
    }

    ESesso getSesso2() {
        return ESesso.F
    }

    void setSesso2(ESesso s) {
        log.info ("Parametri sesso non gestito su civpub: " + (s?.name()?:"") )
    }

    String getCodiceSesso2Lista(){
        return (getSesso2()?.name())
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

    Integer getTipoAtto(){
        return new Integer(ETipoAtto.PUB.valore)
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.PUB
    }

    Boolean isSecondaA(){
        Boolean val = ( isParteSeconda() && ((this.serie?:"") == CivTipoAtto.SERIE_A) )
        return val
    }

    Boolean isSecondaB(){
        Boolean val = ( isParteSeconda() && ((this.serie?:"") == CivTipoAtto.SERIE_B) )
        return val
    }

    // Categoria ATL o senza categoria (atto generato con forms)
    Boolean isTestoLibero(){
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice?:CivCategoriaTipoAtto.ATL) == CivCategoriaTipoAtto.ATL) )
        return val
    }

    String getNominativo1(){
        return ( (this.cognome1?:"") + ((this.cognome1 && this.nome1)?" ":"") + (this.nome1?:"") )
    }

    String getNominativo2(){
        return ( (this.cognome2?:"") + ((this.cognome2 && this.nome2)?" ":"") + (this.nome2?:"") )
    }

    Boolean hasMargine(){
        return Boolean.FALSE
    }

    @Override
    String getIdAttoAnsc() {
        return null
    }

    @Override
    Long getNumeroUnico() {
        return null
    }

    Boolean isUfficialeStatoCivileMandatory() {
        return false
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static List<Map> etichetteDomain = [ Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Provvisorio"),
                                         Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Data_Pubblicazione"),
                                         Etichette.getEtichetta("Data_Nascita"),Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Comune_Nascita"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"),
                                         Etichette.getEtichetta("Verbale_Pubblicazione"), Etichette.getEtichetta("Natura_Atto"),Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Stato_Anagrafico"),
                                         Etichette.getEtichetta("Stato_Civile"), Etichette.getEtichetta("Senza_Cognome"), Etichette.getEtichetta("Senza_Nome"), Etichette.getEtichetta("Nazionalita"),
                                         Etichette.getEtichetta("Comune_Residenza"), Etichette.getEtichetta("Comune_Matrimonio"), Etichette.getEtichetta("Data_Matrimonio"), Etichette.getEtichetta("Ore"), Etichette.getEtichetta("Minuti"),
                                         Etichette.getEtichetta("Cognome_Sposo"), Etichette.getEtichetta("Nome_Sposo"), Etichette.getEtichetta("Cognome_Sposa"), Etichette.getEtichetta("Nome_Sposa")]

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
