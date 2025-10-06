package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IstMscMsuBaseDomain
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ISTMSU_V")
class IstMsuScioglimento extends IstMscMsuBaseDomain{

    static final String M6SU  = "6SU"
    static final String M12SU = "12SU"

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SOGGETTO 1 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COD_FISCALE_1", nullable = true)
    private String codiceFiscale1

    String getCodiceFiscale1() {
        return codiceFiscale1
    }

    void setCodiceFiscale1(String val) {
        this.codiceFiscale1 = (val?.toUpperCase())
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES_1")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES_1", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES_1")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_1", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza1
    Comune getComuneResidenza1() {
        if (comuneResidenza1 == null){
            comuneResidenza1 = new Comune()
        }
        return comuneResidenza1
    }
    void setComuneResidenza1(Comune c) {
        this.comuneResidenza1 = c
    }

    @Column(name = "STATO_CIVILE_1", nullable = true)
    Integer statoCivile1

    @Column(name = "NAZIONALITA_ITA_1", nullable = false)
    Integer nazionalitaItaliana1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAZIONALITA_1", nullable = true)
    Date dataNazionalita1

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SOGGETTO 2 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COD_FISCALE_2", nullable = true)
    private String codiceFiscale2

    String getCodiceFiscale2() {
        return codiceFiscale2
    }

    void setCodiceFiscale2(String val) {
        this.codiceFiscale2 = (val?.toUpperCase())
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES_2")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES_2", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES_2")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_2", updatable = false, insertable = false))
    ])
    private Comune comuneResidenza2
    Comune getComuneResidenza2() {
        if (comuneResidenza2 == null){
            comuneResidenza2 = new Comune()
        }
        return comuneResidenza2
    }
    void setComuneResidenza2(Comune c) {
        this.comuneResidenza2 = c
    }

    @Column(name = "STATO_CIVILE_2", nullable = true)
    Integer statoCivile2

    @Column(name = "NAZIONALITA_ITA_2", nullable = false)
    Integer nazionalitaItaliana2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAZIONALITA_2", nullable = true)
    Date dataNazionalita2

    ////////////////////////////////////////////////////////////////////////
    //////////////////////// ATTO E DATI DI UNIONE /////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIO_UCI", nullable = true)
    Integer ufficioUnioneCivile

    @Column(name = "ANNO_UCI", nullable = true)
    Integer annoUnioneCivile

    @Column(name = "ATTO_UCI", nullable = false)
    Integer attoUnioneCivile

    @Column(name = "PARTE_UCI", nullable = true)
    Integer parteUnioneCivile

    @Column(name = "SERIE_UCI", nullable = true)
    private String serieUnioneCivile

    String getSerieUnioneCivile() {
        return serieUnioneCivile
    }

    void setSerieUnioneCivile(String s) {
        this.serieUnioneCivile = s?.toUpperCase()
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_UCI", nullable = true)
    Date dataMatUci // in modo da usare lo stesso template zk

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_UCI")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_UCI", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_UCI")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_UCI", updatable = false, insertable = false))
    ])
    private Comune comuneMatUci // in modo da usare lo stesso template zk
    Comune getComuneMatUci() {
        if (comuneMatUci == null){
            comuneMatUci = new Comune()
        }
        return comuneMatUci
    }
    void setComuneMatUci(Comune c) {
        this.comuneMatUci = c
    }

    @Column(name = "REGIME_PATRIMONIALE_UCI", nullable = true)
    Integer regimePatrimoniale

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.UCI
    }

    Boolean is6su(){
        return (this.codiceModelloIstat?.toUpperCase() == M6SU)
    }

    Boolean is12su(){
        return (this.codiceModelloIstat?.toUpperCase() == M12SU)
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.Data_stipula_accordo, Etichette.Data_trascrizione_accordo, Etichette.Tipo_accordo_extragiudiziale]

}
