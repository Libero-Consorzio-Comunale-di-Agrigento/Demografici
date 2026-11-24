package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ETipoModelloIstat
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@MappedSuperclass
abstract class IstMscMsuBaseDomain extends IstBaseDomain {

    @Column(name = "ID_ATTO", nullable = false)
    String idAtto

    @Column(name = "UFFICIO", nullable = true)
    Integer ufficio

    @Column(name = "ANNO", nullable = true)
    Integer anno

    @Column(name = "ATTO", nullable = false)
    Integer atto

    @Column(name = "PARTE", nullable = false)
    Integer parte

    @Column(name = "SERIE", nullable = false)
    private String serie

    String getSerie() {
        return serie
    }

    void setSerie(String serie) {
        this.serie = serie?.toUpperCase()
    }

    @Column(name = "PROGR_QUESTIONARIO", nullable = true)
    Integer progressivo

    @Column(name = "COD_MODELLO", nullable = false)
    String codiceModelloIstat

    @Column(name = "ID_CIVANN")
    Long idAnnotazione

    @Column(name = "TIPO_PROCEDURA", nullable = false)
    Integer tipoProcedura

    abstract void setCodiceFiscale1(String s)
    abstract void setCodiceFiscale2(String s)

    abstract Date getDataMatUci()

    ////////////////////////////////////////////////////////////
    /////////////// TRIBUNALE O CORTE D'APPELLO ////////////////
    ////////////////////////////////////////////////////////////

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_TRIB")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_TRIB", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_TRIB")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_TRIB", updatable = false, insertable = false))
    ])
    private Comune comuneTribCda
    Comune getComuneTribCda() {
        if (comuneTribCda == null){
            comuneTribCda = new Comune()
        }
        return comuneTribCda
    }
    void setComuneTribCda(Comune c) {
        this.comuneTribCda = c
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_ISCR_RUOLO_TRIB", nullable = true)
    Date dataIscrizioneRuoloProcedimento

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_PROVVEDIMENTO_TRIB", nullable = true)
    Date dataProvvedimento

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_TRASCR_PROVV_TRIB", nullable = true)
    Date dataTrascrizioneProvvedimento

    @Column(name = "TIPO_PROVVEDIMENTO_TRIB", nullable = false)
    Integer tipoProvvedimentoTribCda

    Boolean isProvvedimento(){
        return (this.codiceModelloIstat?.toUpperCase() == ETipoModelloIstat.PROVV.name())
    }

    ////////////////////////////////////////////////////////////
    //////////////////// ACCORDO E CONFERMA ////////////////////
    ////////////////////////////////////////////////////////////

    @Column(name = "TIPO_ACCORDO", nullable = true)
    Integer tipoAccordo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_STIPULA_ACCORDO", nullable = true, updatable = false, insertable = false)
    Date dataAccordo

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_TRASCR_CONFERMA", nullable = true, updatable = false, insertable = false)
    Date dataConferma

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [ Etichette.getEtichetta("Tipo_procedura"), Etichette.getEtichetta("Data_iscrizione_procedimento"),
                                               Etichette.getEtichetta("Data_provvedimento"),  Etichette.getEtichetta("Data_trascrizione_provvedimento"),
                                               Etichette.getEtichetta("Comune_provvedimento_trib_cda"),  Etichette.getEtichetta("Tipo_provvedimento_trib_cda"),
                                               Etichette.getEtichetta("Causa_divorzio"),  Etichette.getEtichetta("Data_Separazione")]

}
