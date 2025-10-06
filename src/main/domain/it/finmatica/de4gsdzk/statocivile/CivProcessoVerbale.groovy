package it.finmatica.de4gsdzk.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAttoPubPvu
import it.finmatica.de4gsdzk.ISoggettoAtto1
import it.finmatica.de4gsdzk.ISoggettoAtto2
import it.finmatica.de4gsdzk.anagrafe.AnaNazionalita
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Slf4j
@Entity
@Table(name = "CIVPVU_V")
class CivProcessoVerbale extends CivAttoBaseDomain implements ISoggettoAtto1, ISoggettoAtto2, IAttoPubPvu{

    @Column(name = "PARTE", nullable = true)
    Integer parte

    @Column(name = "SERIE", nullable = true)
    String serie

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

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_UCI_VERBALE", nullable = true)
    Date dataUnioneCivile

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_D3U", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloD3U

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
    Boolean senzaCognome1

    Boolean getSenzaCognome1() {
        return senzaCognome1
    }

    void setSenzaCognome1(Boolean val) {
        this.senzaCognome1 = val
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_M", nullable = true)
    Boolean senzaNome1

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

    @Column(name = "COD_FISCALE_M", nullable = true)
    private String codiceFiscale1

    String getCodiceFiscale1() {
        return codiceFiscale1
    }

    void setCodiceFiscale1(String codiceFiscale) {
        this.codiceFiscale1 = codiceFiscale?.toUpperCase()
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
        log.info ("Parametri stato civile non gestito su civpvu: " + (s?:"") )
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
    Boolean senzaCognome2

    Boolean getSenzaCognome2() {
        return senzaCognome2
    }

    void setSenzaCognome2(Boolean val) {
        this.senzaCognome2 = val
    }

    @Convert(converter=BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_F", nullable = true)
    Boolean senzaNome2

    Boolean getSenzaNome2() {
        return senzaNome2
    }

    void setSenzaNome2(Boolean val) {
        this.senzaNome2 = val
    }

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

    @Column(name = "COGNOME_2_LISTA", nullable = true, updatable = false, insertable = false)
    String cognome2Lista

    @Column(name = "NOME_2_LISTA", nullable = true, updatable = false, insertable = false)
    String nome2Lista

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_2_LISTA", nullable = true, updatable = false, insertable = false)
    ESesso sesso2Lista

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
    Integer codiceProvinciaNascita2

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

    Integer getTipoAtto(){
        return new Integer(ETipoAtto.PVU.valore)
    }

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.PVU
    }

    Boolean isUfficialeStatoCivile(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.PV1 )
        return val
    }

    Boolean isAutoritaGiudiziaria(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.PV2 )
        return val
    }

    Boolean isFuoriCasaComunale(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:"") == CivCategoriaTipoAtto.PV3 )
        return val
    }

    // Categoria ATL o senza categoria (atto generato con forms)
    Boolean isTestoLibero(){
        Boolean val = ( (this.tipoAttoDomain?.categoriaDomain?.codice?:CivCategoriaTipoAtto.ATL) == CivCategoriaTipoAtto.ATL )
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

    Boolean isUfficialeStatoCivileMandatory() {
        return false
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Ufficio, Etichette.Anno, Etichette.Tipo_Atto, Etichette.Provvisorio,
                                              Etichette.Numero_Atto, Etichette.Data_Pubblicazione,
                                              Etichette.Data_Nascita, Etichette.Codice_Fiscale, Etichette.Comune_Nascita,
                                              Etichette.Processo_Verbale, Etichette.Natura_Atto, Etichette.Codice_Fiscale, Etichette.Stato_Anagrafico, Etichette.Data_Unione_Civile,
                                              Etichette.Stato_Civile, Etichette.Senza_Cognome, Etichette.Senza_Nome, Etichette.Nazionalita, Etichette.Sesso,
                                              Etichette.Comune_Residenza, Etichette.Comune_Unione_Civile, Etichette.Ore, Etichette.Minuti,
                                              Etichette.Parte, Etichette.Serie, // per estremi atto di nascita
                                              Etichette.Cognome_Contraente_1, Etichette.Nome_Contraente_1, Etichette.Cognome_Contraente_2, Etichette.Nome_Contraente_2]

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
