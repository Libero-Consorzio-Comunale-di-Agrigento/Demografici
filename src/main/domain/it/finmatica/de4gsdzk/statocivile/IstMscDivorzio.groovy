package it.finmatica.de4gsdzk.statocivile

import it.finmatica.de4gsdzk.IstMscMsuBaseDomain
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ISTMSC_V")
class IstMscDivorzio extends IstMscMsuBaseDomain{

    static final String M6SD  = "6SD"
    static final String M12SD = "12SD"

    @Column(name = "CAUSA_SCIOGLIMENTO", nullable = true)
    Integer causaScioglimento

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_SENTENZA", nullable = true)
    Date dataSentenzaSeparazione

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_STIPULA_SEP", nullable = true)
    Date dataStipulaSeparazione // rinominato in data 02/01/2024

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_REG_SEP", nullable = true)
    Date dataRegistrazioneSeparazione // rinominato in data 02/01/2024

    @Column(name = "SOSTENTAMENTO_CN", nullable = true)
    Integer sostentamentoConiuge

    @Column(name = "ABITAZIONE_ASSEGNATA", nullable = true)
    Integer assegnazioneAbitazione

    @Column(name = "CHI_SOSTENTAMENTO_CN", nullable = true)
    Integer sostentamentoConiugeChi

    @Column(name = "IMPORTO_MENSILE_CN", nullable = true)
    Integer importoMensileConiuge

    @Column(name = "IMPORTO_UNICO_CN", nullable = true)
    Integer importoUnicoConiuge

    @Column(name = "PRESENZA_FG", nullable = true)
    Integer presenzaFigli

    @Column(name = "PRESENZA_FG_MIN", nullable = true)
    Integer presenzaFigliMinori

    @Column(name = "PRESENZA_FG_MAG", nullable = true)
    Integer presenzaFigliMaggiorenni

    @Column(name = "NUMERO_FG", nullable = true)
    Integer numeroFigli

    @Column(name = "NUMERO_FG_MIN", nullable = true)
    Integer numeroFigliMinori

    @Column(name = "NUMERO_FG_MAG", nullable = true)
    Integer numeroFigliMaggiorenni

    @Column(name = "MANTENIMENTO_FG", nullable = true)
    Integer mantenimentoFigli

    @Column(name = "MANTENIMENTO_FG_MAG", nullable = true)
    Integer mantenimentoFigliMaggiorenni

    @Column(name = "CHI_SOSTENTAMENTO_FG", nullable = true)
    Integer sostentamentoFigliChi

    @Column(name = "IMPORTO_MENSILE_FG", nullable = true)
    Integer importoMensileFigli

    @Column(name = "COGNOME_FG_1", nullable = true)
    private String cognomeFiglio1

    String getCognomeFiglio1() {
        return cognomeFiglio1
    }

    void setCognomeFiglio1(String c) {
        this.cognomeFiglio1 = c?.toUpperCase()
    }

    @Column(name = "COGNOME_FG_2", nullable = true)
    private String cognomeFiglio2

    String getCognomeFiglio2() {
        return cognomeFiglio2
    }

    void setCognomeFiglio2(String c) {
        this.cognomeFiglio2 = c?.toUpperCase()
    }

    @Column(name = "COGNOME_FG_3", nullable = true)
    private String cognomeFiglio3

    String getCognomeFiglio3() {
        return cognomeFiglio3
    }

    void setCognomeFiglio3(String c) {
        this.cognomeFiglio3 = c?.toUpperCase()
    }

    @Column(name = "COGNOME_FG_4", nullable = true)
    private String cognomeFiglio4

    String getCognomeFiglio4() {
        return cognomeFiglio4
    }

    void setCognomeFiglio4(String c) {
        this.cognomeFiglio4 = c?.toUpperCase()
    }

    @Column(name = "NOME_FG_1", nullable = true)
    private String nomeFiglio1

    String getNomeFiglio1() {
        return nomeFiglio1
    }

    void setNomeFiglio1(String c) {
        this.nomeFiglio1 = c?.toUpperCase()
    }

    @Column(name = "NOME_FG_2", nullable = true)
    private String nomeFiglio2

    String getNomeFiglio2() {
        return nomeFiglio2
    }

    void setNomeFiglio2(String c) {
        this.nomeFiglio2 = c?.toUpperCase()
    }

    @Column(name = "NOME_FG_3", nullable = true)
    private String nomeFiglio3

    String getNomeFiglio3() {
        return nomeFiglio3
    }

    void setNomeFiglio3(String c) {
        this.nomeFiglio3 = c?.toUpperCase()
    }

    @Column(name = "NOME_FG_4", nullable = true)
    private String nomeFiglio4

    String getNomeFiglio4() {
        return nomeFiglio4
    }

    void setNomeFiglio4(String c) {
        this.nomeFiglio4 = c?.toUpperCase()
    }

    @Column (name = "SESSO_FG_1", nullable = true)
    String sessoFiglio1

    @Column (name = "SESSO_FG_2", nullable = true)
    String sessoFiglio2

    @Column (name = "SESSO_FG_3", nullable = true)
    String sessoFiglio3

    @Column (name = "SESSO_FG_4", nullable = true)
    String sessoFiglio4

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_FG_1", nullable = true)
    Date dataNascitaFiglio1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_FG_2", nullable = true)
    Date dataNascitaFiglio2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_FG_3", nullable = true)
    Date dataNascitaFiglio3

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_FG_4", nullable = true)
    Date dataNascitaFiglio4

    @Column(name = "ETA_FG_1", nullable = true)
    Integer etaFiglio1

    @Column(name = "ETA_FG_2", nullable = true)
    Integer etaFiglio2

    @Column(name = "ETA_FG_3", nullable = true)
    Integer etaFiglio3

    @Column(name = "ETA_FG_4", nullable = true)
    Integer etaFiglio4

    @Column(name = "COD_FISCALE_FG_1", nullable = true)
    private String codiceFiscaleFiglio1

    String getCodiceFiscaleFiglio1() {
        return codiceFiscaleFiglio1
    }

    void setCodiceFiscaleFiglio1(String c) {
        this.codiceFiscaleFiglio1 = c?.toUpperCase()
    }

    @Column(name = "COD_FISCALE_FG_2", nullable = true)
    private String codiceFiscaleFiglio2

    String getCodiceFiscaleFiglio2() {
        return codiceFiscaleFiglio2
    }

    void setCodiceFiscaleFiglio2(String c) {
        this.codiceFiscaleFiglio2 = c?.toUpperCase()
    }

    @Column(name = "COD_FISCALE_FG_3", nullable = true)
    private String codiceFiscaleFiglio3

    String getCodiceFiscaleFiglio3() {
        return codiceFiscaleFiglio3
    }

    void setCodiceFiscaleFiglio3(String c) {
        this.codiceFiscaleFiglio3 = c?.toUpperCase()
    }

    @Column(name = "COD_FISCALE_FG_4", nullable = true)
    private String codiceFiscaleFiglio4

    String getCodiceFiscaleFiglio4() {
        return codiceFiscaleFiglio4
    }

    void setCodiceFiscaleFiglio4(String c) {
        this.codiceFiscaleFiglio4 = c?.toUpperCase()
    }

    @Column(name = "PERNOTTAMENTI_FG_1", nullable = true)
    Integer pernottamentiFiglio1

    @Column(name = "PERNOTTAMENTI_FG_2", nullable = true)
    Integer pernottamentiFiglio2

    @Column(name = "PERNOTTAMENTI_FG_3", nullable = true)
    Integer pernottamentiFiglio3

    @Column(name = "PERNOTTAMENTI_FG_4", nullable = true)
    Integer pernottamentiFiglio4

    @Column(name = "AFFIDAMENTO_FG_1", nullable = true)
    Integer affidamentoFiglio1

    @Column(name = "AFFIDAMENTO_FG_2", nullable = true)
    Integer affidamentoFiglio2

    @Column(name = "AFFIDAMENTO_FG_3", nullable = true)
    Integer affidamentoFiglio3

    @Column(name = "AFFIDAMENTO_FG_4", nullable = true)
    Integer affidamentoFiglio4

    @Column(name = "CAPITOLO_SPESA_1", nullable = true)
    Integer capitoloSpesa1

    @Column(name = "CAPITOLO_SPESA_2", nullable = true)
    Integer capitoloSpesa2

    @Column(name = "CAPITOLO_SPESA_3", nullable = true)
    Integer capitoloSpesa3

    @Column(name = "CAPITOLO_SPESA_4", nullable = true)
    Integer capitoloSpesa4

    @Column(name = "CAPITOLO_SPESA_5", nullable = true)
    Integer capitoloSpesa5

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SOGGETTO 1 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COD_FISCALE_M", nullable = true)
    private String codiceFiscale1

    String getCodiceFiscale1() {
        return codiceFiscale1
    }

    void setCodiceFiscale1(String val) {
        this.codiceFiscale1 = (val?.toUpperCase())
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES_M")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES_M", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES_M")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_M", updatable = false, insertable = false))
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

    @Column(name = "STATO_CIVILE_M", nullable = true)
    Integer statoCivile1

    @Column(name = "NAZIONALITA_ITA_M", nullable = false)
    Integer nazionalitaItaliana1

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAZIONALITA_M", nullable = true)
    Date dataNazionalita1

    @Column(name = "TITOLO_STUDIO_M", nullable = true)
    Integer titoloStudio1

    @Column(name = "POSIZIONE_PROF_M", nullable = true)
    Integer posizioneProfessionale1

    @Column(name = "CONDIZIONE_PROF_M", nullable = true)
    Integer condizioneProfessionale1

    @Column(name = "COGNOME_AVV_M", nullable = true)
    String cognomeAvvocato1

    @Column(name = "NOME_AVV_M", nullable = true)
    String nomeAvvocato1

    @Column(name = "NUMERO_ALBO_AVV_M", nullable = true)
    String numeroAlboAvvocato1

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_ALBO_AVV_M")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ALBO_AVV_M", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_ALBO_AVV_M")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ALBO_AVV_M", updatable = false, insertable = false))
    ])
    private Comune comuneAlboAvvocato1
    Comune getComuneAlboAvvocato1() {
        if (comuneAlboAvvocato1 == null){
            comuneAlboAvvocato1 = new Comune()
        }
        return comuneAlboAvvocato1
    }
    void setComuneAlboAvvocato1(Comune c) {
        this.comuneAlboAvvocato1 = c
    }

    @Column(name = "COD_FISCALE_AVV_M", nullable = true)
    private String codiceFiscaleAvvocato1

    String getCodiceFiscaleAvvocato1() {
        return codiceFiscaleAvvocato1
    }

    void setCodiceFiscaleAvvocato1(String val) {
        this.codiceFiscaleAvvocato1 = (val?.toUpperCase())
    }

    ////////////////////////////////////////////////////////////////////////
    ///////////////////////////// SOGGETTO 2 ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COD_FISCALE_F", nullable = true)
    private String codiceFiscale2

    String getCodiceFiscale2() {
        return codiceFiscale2
    }

    void setCodiceFiscale2(String val) {
        this.codiceFiscale2 = (val?.toUpperCase())
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_RES_F")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_RES_F", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_RES_F")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_F", updatable = false, insertable = false))
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

    @Column(name = "STATO_CIVILE_F", nullable = true)
    Integer statoCivile2

    @Column(name = "NAZIONALITA_ITA_F", nullable = false)
    Integer nazionalitaItaliana2

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAZIONALITA_F", nullable = true)
    Date dataNazionalita2

    @Column(name = "TITOLO_STUDIO_F", nullable = true)
    Integer titoloStudio2

    @Column(name = "POSIZIONE_PROF_F", nullable = true)
    Integer posizioneProfessionale2

    @Column(name = "CONDIZIONE_PROF_F", nullable = true)
    Integer condizioneProfessionale2

    @Column(name = "COGNOME_AVV_F", nullable = true)
    String cognomeAvvocato2

    @Column(name = "NOME_AVV_F", nullable = true)
    String nomeAvvocato2

    @Column(name = "COD_FISCALE_AVV_F", nullable = true)
    private String codiceFiscaleAvvocato2

    String getCodiceFiscaleAvvocato2() {
        return codiceFiscaleAvvocato2
    }

    void setCodiceFiscaleAvvocato2(String val) {
        this.codiceFiscaleAvvocato2 = (val?.toUpperCase())
    }

    @Column(name = "NUMERO_ALBO_AVV_F", nullable = true)
    String numeroAlboAvvocato2

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_ALBO_AVV_F")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_ALBO_AVV_F", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_ALBO_AVV_F")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_ALBO_AVV_F", updatable = false, insertable = false))
    ])
    private Comune comuneAlboAvvocato2
    Comune getComuneAlboAvvocato2() {
        if (comuneAlboAvvocato2 == null){
            comuneAlboAvvocato2 = new Comune()
        }
        return comuneAlboAvvocato2
    }
    void setComuneAlboAvvocato2(Comune c) {
        this.comuneAlboAvvocato2 = c
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////// ATTO E DATI DI MATRIMONIO ///////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "UFFICIO_MAT", nullable = true)
    Integer ufficioMatrimonio

    @Column(name = "ANNO_MAT", nullable = true)
    Integer annoMatrimonio

    @Column(name = "ATTO_MAT", nullable = false)
    Integer attoMatrimonio

    @Column(name = "PARTE_MAT", nullable = true)
    Integer parteMatrimonio

    @Column(name = "SERIE_MAT", nullable = true)
    private String serieMatrimonio

    String getSerieMatrimonio() {
        return serieMatrimonio
    }

    void setSerieMatrimonio(String s) {
        this.serieMatrimonio = s?.toUpperCase()
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MAT", nullable = true)
    Date dataMatUci // in modo da usare lo stesso template zk

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name="codice", column = @Column(name = "COD_COM_MAT")),
            @AttributeOverride(name="descrizione", column = @Column(name = "DES_COM_MAT", updatable = false, insertable = false)),
            @AttributeOverride(name="codiceProvincia", column = @Column(name = "COD_PRO_MAT")),
            @AttributeOverride(name="siglaProvincia", column = @Column(name = "SIGLA_PRO_MAT", updatable = false, insertable = false))
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

    @Column(name = "RITO_MAT", nullable = true)
    Integer rito

    @Column(name = "REGIME_PATRIMONIALE_MAT", nullable = true)
    Integer regimePatrimoniale

    ETipoAtto getTipoAttoEnum(){
        return ETipoAtto.MAT
    }

    Boolean is6sd(){
        return (this.codiceModelloIstat?.toUpperCase() == M6SD)
    }

    Boolean is12sd(){
        return (this.codiceModelloIstat?.toUpperCase() == M12SD)
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Data_Registrazione"), Etichette.getEtichetta("Data_Atto"), Etichette.getEtichetta("Data_Trascrizione"),

                                              Etichette.getEtichetta("Avvocato_Marito"), Etichette.getEtichetta("Avvocato_Moglie"), Etichette.getEtichetta("Importo"),
                                              Etichette.getEtichetta("Tipo_accordo_extragiudiziale"), Etichette.getEtichetta("Albo_Iscrizione"), Etichette.getEtichetta("Numero_Figli"),
                                              Etichette.getEtichetta("Causa_separazione"), Etichette.getEtichetta("Causa_divorzio"), Etichette.getEtichetta("Data_Separazione"),
                                              Etichette.getEtichetta("Data_Stipula"), Etichette.getEtichetta("Data_stipula_accordo"), Etichette.getEtichetta("Data_trascrizione_accordo"),
                                              Etichette.getEtichetta("Mantenimento"), Etichette.getEtichetta("Tipo_Affidamento"), Etichette.getEtichetta("Presenza_Figli"),
                                              Etichette.getEtichetta("Mantenimento_Maggiorenni"), Etichette.getEtichetta("Sostentamento_coniuge"), Etichette.getEtichetta("Chi_obbligato"),
                                              Etichette.getEtichetta("Mensile"), Etichette.getEtichetta("Una_Tantum"), Etichette.getEtichetta("Assegnazione_abitazione"), Etichette.getEtichetta("Numero_Pernotti"),
                                              Etichette.getEtichetta("Figli_Minorenni"), Etichette.getEtichetta("Figli_Maggiorenni"), Etichette.getEtichetta("Figli_Maggiorenni_A_Carico")]

}
