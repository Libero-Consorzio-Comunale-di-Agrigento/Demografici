package it.finmatica.de4gsdzk.statocivile.baseDomain

import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivTipoComprensione
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula
import org.hibernate.annotations.Type

import javax.persistence.*

@MappedSuperclass
abstract class CivMatrimonioBaseDomain extends CivAttoBaseDomain implements IAttoAnsc, ISoggettoAtto1, ISoggettoAtto2, IAttoMatUci, ICertificabile, ISoggettoAttoAnsc1, ISoggettoAttoAnsc2 {

    public static final int tipoAttoAnnotazioneSuAttoNascitaAltroComune = 7
    public static final int tipoAttoAnnotazioneSuAttoMatrimonioAltroComune = 9

    @Column(name = "PARTE", nullable = false)
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

    @Enumerated(EnumType.STRING)
    @Column(name = "CONVENZIONI", nullable = true)
    private ETipoSiNo convenzioniDb

    void setConvenzioni(Boolean val) {
        this.convenzioniDb = (val ? ETipoSiNo.SI : null)
    }

    Boolean getConvenzioni() {
        return (convenzioniDb == ETipoSiNo.SI)
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_CONVENZIONI", nullable = true)
    Date dataConvenzioni

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_GG_IMPRECISATO", nullable = true)
    Boolean giornoMatrimonioImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MM_IMPRECISATO", nullable = true)
    Boolean meseMatrimonioImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_AA_IMPRECISATO", nullable = true)
    Boolean annoMatrimonioImprecisato

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
        this.certificabileDb = ((val == ETipoSiNo.SI) ? ETipoSN.S : ETipoSN.N)
    }

    @Column(name = "NOTE", nullable = true)
    String note

    @Formula("CASE WHEN COALESCE(FLAG_DIVORZIO, 'N') = 'N' THEN 0 ELSE 1 END")
    @Type(type = "numeric_boolean")
    Boolean divorzio

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_D3", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloD3

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_SC", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloSC

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_SDSU", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloSDSU

    @Enumerated(EnumType.STRING)
    @Column(name = "RICONOSCIMENTO_FIGLI", nullable = true)
    ETipoSiNo riconoscimentoFigli

    @Enumerated(EnumType.STRING)
    @Column(name = "DIFETTO_ETA", nullable = true)
    ETipoDifettoEta difettoEta

    @Enumerated(EnumType.STRING)
    @Column(name = "IMPEDIMENTO_MAT", nullable = true)
    ETipoImpedimentoParentelaMatrimonio impedimentoParentelaMatrimonio

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_DIVIETO_TEMPORANEO", nullable = true)
    Boolean flagDivietoTemporaneo

    @Column(name = "NUMERO_FIGLI", nullable = true)
    Integer numeroFigli

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_FIRMATO_USC_ANSC", nullable = true, updatable = false, insertable = false)
    Boolean flagFirmatoUscAnsc

    @Column(name = "ID_USECASE_ANSC", nullable = true)
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

    ETipoArchivioAnsc getTipoArchivioAnsc() {
        return ETipoArchivioAnsc.MAT
    }

    ETipoAttoAnsc getTipoAttoAnsc() {
        if (isRiconciliazione()) {
            return ETipoAttoAnsc.Matr_Riconc
        } else if (divorzio) {
            return ETipoAttoAnsc.Sep_Div
        } else
        // refs #70519
        if (isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita() || [ENaturaAtto.T, ENaturaAtto.D].contains(natura)) {
            return ETipoAttoAnsc.Trascr_Matr
        } else {
            return ETipoAttoAnsc.Matr
        }
    }

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// SPOSO /////////////////////////////////
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

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_M", nullable = true)
    private Boolean senzaCognome1

    Boolean getSenzaCognome1() {
        return senzaCognome1
    }

    void setSenzaCognome1(Boolean val) {
        this.senzaCognome1 = val
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_M", nullable = true)
    private Boolean senzaNome1

    Boolean getSenzaNome1() {
        return senzaNome1
    }

    void setSenzaNome1(Boolean val) {
        this.senzaNome1 = val
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

    @Column(name = "COGNOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String cognome1Lista

    @Column(name = "NOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String nome1Lista

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVENTO_LISTA", nullable = true, updatable = false, insertable = false)
    Date dataEventoLista

    @Column(name = "ANNI_M", nullable = true)
    Integer anni1

    ESesso getSesso1() {
        return ESesso.M
    }

    void setSesso1(ESesso s) {
        log.info("Parametri sesso non gestito su civmat: " + (s?.name() ?: ""))
    }

    String getCodiceSesso1Lista() {
        return (getSesso1()?.name())
    }

    EStatoCivile getStatoCivile1() {
        return null
    }

    void setStatoCivile1(EStatoCivile s) {
        log.info("Parametri stato civile non gestito su civmat: " + (s ?: ""))
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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA_M", nullable = true)
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

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO_M", nullable = true)
    private Boolean cfCalcolato1

    Boolean getCfCalcolato1() {
        return cfCalcolato1
    }

    void setCfCalcolato1(Boolean val) {
        this.cfCalcolato1 = val
    }

    @ManyToOne(fetch = FetchType.LAZY)
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

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ASSISTENZA_DIFETTO_ETA_M", nullable = true)
    ETipoAssistenzaMinore tipoAssistenzaMinore1

    ////////////////////////////////////////////////////////////////////////
    //////////////////////////////// SPOSA /////////////////////////////////
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

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_F", nullable = true)
    private Boolean senzaCognome2

    Boolean getSenzaCognome2() {
        return senzaCognome2
    }

    void setSenzaCognome2(Boolean val) {
        this.senzaCognome2 = val
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_F", nullable = true)
    private Boolean senzaNome2

    Boolean getSenzaNome2() {
        return senzaNome2
    }

    void setSenzaNome2(Boolean val) {
        this.senzaNome2 = val
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
        log.info("Parametri sesso non gestito su civmat: " + (s?.name() ?: ""))
    }

    String getCodiceSesso2Lista() {
        return (getSesso2()?.name())
    }

    @Column(name = "COGNOME_2_LISTA", nullable = true, updatable = false, insertable = false)
    String cognome2Lista

    @Column(name = "NOME_2_LISTA", nullable = true, updatable = false, insertable = false)
    String nome2Lista

    @Column(name = "ANNI_F", nullable = true)
    Integer anni2

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA_F", nullable = true)
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

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO_F", nullable = true)
    private Boolean cfCalcolato2

    Boolean getCfCalcolato2() {
        return cfCalcolato2
    }

    void setCfCalcolato2(Boolean val) {
        this.cfCalcolato2 = val
    }

    @ManyToOne(fetch = FetchType.LAZY)
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

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ASSISTENZA_DIFETTO_ETA_F", nullable = true)
    ETipoAssistenzaMinore tipoAssistenzaMinore2

    ////////////////////////////////////////////////////////////////////////
    /////////////////////////////// GENERALI ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    Integer getTipoAtto() {
        return new Integer(ETipoAtto.MAT.valore)
    }

    ETipoAtto getTipoAttoEnum() {
        return ETipoAtto.MAT
    }

    Boolean isSecondaA() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "") == CivTipoAtto.SERIE_A))
        return val
    }

    Boolean isSecondaB() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "") == CivTipoAtto.SERIE_B))
        return val
    }

    Boolean isSecondaC() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "") == CivTipoAtto.SERIE_C))
        return val
    }

    // Categoria ATL o senza categoria (atto generato con forms)
    Boolean isTestoLibero() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: CivCategoriaTipoAtto.ATL) == CivCategoriaTipoAtto.ATL))
        return val
    }

    Boolean isTrascrizioneEsteroDaPrivato() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.TEP))
        return val
    }

    Boolean isTrascrizioneEsteroDaAutorita() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.TEA))
        return val
    }

    Boolean isConsolatoMandatory() {
        return isTrascrizioneEsteroDaAutorita()
    }

    Boolean isEnteStranieroEnabled() {
        return (isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita()) || isDivorzioEstero()
    }

    Boolean isTrascrizioneEstero() {
        return isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita()
    }

    Boolean isDatiRichiedenteEnabled() {
        return isTrascrizioneEsteroDaPrivato() || isDivorzioEstero()
    }

    Boolean isAutoritaMittenteEnabled() {
        return isTrascrizioneEsteroDaAutorita() || isDivorzioEstero()
    }

    Boolean isCivileXDelega() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.CPD))
        return val
    }

    Boolean isTrascrizioneMatrimonioCivile() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.TMC))
        return val
    }

    Boolean isTrascrizioneMatrimonioCivileSuDelega() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.TMD))
        return val
    }

    Boolean isAvvocati() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.AVV))
        return val
    }

    Boolean isAvvocatiAltro() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.AAL))
        return val
    }

    Boolean isUfficialeAccordo() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.UAC))
        return val
    }

    Boolean isUfficialeConferma() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.UCO))
        return val
    }

    Boolean isUfficialeAltro() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.UAL))
        return val
    }

    Boolean isTribunale() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.TRI))
        return val
    }

    Boolean isDivorzioEstero() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.EST))
        return val
    }

    Boolean isRiconciliazione() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.RCN))
        return val
    }

    Boolean isFuoriCasaComunale() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.FCC))
        return val
    }

    Boolean isPericoloVita() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.PDV))
        return val
    }

    //////////////////////////////////////////////////////////////////
    ////////////////////////////// ZUL ///////////////////////////////
    //////////////////////////////////////////////////////////////////

    Boolean isTestimoniVisibile() {
        return (isPartePrima() || isCivileXDelega() || isTrascrizioneMatrimonioCivile() || isTrascrizioneMatrimonioCivileSuDelega()
                || isFuoriCasaComunale() || isPericoloVita())
    }

    Boolean isTestimoniMandatory() {
        // Obbligatori per un sottoinsieme di categorie per le quali sono visibili
        if (isTestimoniVisibile()) {
            return (!(isTrascrizioneMatrimonioCivile() || isTrascrizioneMatrimonioCivileSuDelega()))
        }
        return Boolean.FALSE
    }

    //DICHIARANTE-COMPARENTE-FIRMATARIO nei matrimoni
    // Nelle 2A vedo solo il dichiarante
    Boolean isDichMatUciVisibile() {
        return (isPartePrima() || isSecondaA() || isCivileXDelega() || isTestoLibero() || isFuoriCasaComunale() || isPericoloVita())
    }

    Boolean isCompMatUciVisibile() {
        return (isPartePrima() || isCivileXDelega() || isTestoLibero() || isFuoriCasaComunale() || isPericoloVita())
    }

    Boolean isFirmMatUciVisibile() {
        return (isPartePrima() || isCivileXDelega() || isTestoLibero() || isFuoriCasaComunale() || isPericoloVita())
    }

    //DICHIARANTE-COMPARENTE-FIRMATARIO nei divorzi
    Boolean isDichDivScioVisibile() {
        return (isUfficialeAccordo() || isUfficialeConferma() || isUfficialeAltro())
    }

    Boolean isCompDivScioVisibile() {
        return (isUfficialeAccordo() || isUfficialeConferma() || isUfficialeAltro())
    }

    Boolean isFirmDivScioVisibile() {
        return (isUfficialeAccordo() || isUfficialeConferma() || isUfficialeAltro())
    }

    Boolean isEstremiAttoMatUciMandatory() {
        return (isUfficialeAccordo() || isRiconciliazione() || isAvvocati())
    }

    Boolean isDifettoEtaParentelaDivietoTempVisibile() {
        return (isPartePrima() || isSecondaA() || isCivileXDelega() || isFuoriCasaComunale() || isPericoloVita())
    }

    Boolean isRiconoscimentoFigliVisibile() {
        return (!(isSecondaA() || isSecondaB()))
    }

    Boolean isStranieriNonResidentiVisible() {
        return isPartePrima()
    }

    String getNominativo1() {
        return ((this.cognome1 ?: "") + ((this.cognome1 && this.nome1) ? " " : "") + (this.nome1 ?: ""))
    }

    String getNominativo2() {
        return ((this.cognome2 ?: "") + ((this.cognome2 && this.nome2) ? " " : "") + (this.nome2 ?: ""))
    }

    Boolean isDataOraMatrimonioMandatory() {
        return isPartePrima() || isSecondaA() || isCivileXDelega() || isFuoriCasaComunale() || isPericoloVita() || isTrascrizioneEsteroDaAutorita() || isTrascrizioneEsteroDaPrivato()
    }

    Boolean isUfficialeStatoCivileMandatory() {
        return isCivileXDelega() || isFuoriCasaComunale() || isPericoloVita()
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static List<Map> etichetteDomain = [Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Provvisorio"),
                                        Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Data_Atto"),
                                        Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Comune_Nascita"), Etichette.getEtichetta("Anni"),
                                        Etichette.getEtichetta("Atto_Matrimonio"), Etichette.getEtichetta("Atto_Divorzio"), Etichette.getEtichetta("Natura_Atto"), Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Stato_Anagrafico"),
                                        Etichette.getEtichetta("Stato_Civile"), Etichette.getEtichetta("Senza_Cognome"), Etichette.getEtichetta("Senza_Nome"), Etichette.getEtichetta("Nazionalita"),
                                        Etichette.getEtichetta("Comune_Residenza"), Etichette.getEtichetta("Comune_Matrimonio"), Etichette.getEtichetta("Data_Matrimonio"), Etichette.getEtichetta("Ore"), Etichette.getEtichetta("Minuti"),
                                        Etichette.getEtichetta("Cognome_Sposo"), Etichette.getEtichetta("Nome_Sposo"), Etichette.getEtichetta("Cognome_Sposa"), Etichette.getEtichetta("Nome_Sposa"),
                                        Etichette.getEtichetta("Note"), Etichette.getEtichetta("Convenzioni"), Etichette.getEtichetta("Data_Convenzioni"), Etichette.getEtichetta("Data_Conferma"), Etichette.getEtichetta("Data_Accordo"),
                                        Etichette.getEtichetta("Data_Convezione"), Etichette.getEtichetta("Data_Trascrizione"), Etichette.getEtichetta("Legge_Convenzioni"), Etichette.getEtichetta("Data_Riconciliazione"), Etichette.getEtichetta("Certificazione_atto"),
                                        Etichette.getEtichetta("Residenza_Sposo"), Etichette.getEtichetta("Residenza_Sposa"), Etichette.getEtichetta("Elenco_Matrimoni"), Etichette.getEtichetta("Luogo_Matrimonio"),
                                        Etichette.getEtichetta("Comprensione_sposo"), Etichette.getEtichetta("Comprensione_sposa"), Etichette.getEtichetta("Motivo_Impedimento"), Etichette.getEtichetta("Divieto_temporaneo"),
                                        Etichette.getEtichetta("Assistenza_minore_sposo"), Etichette.getEtichetta("Assistenza_minore_sposa")]

    @PrePersist
    void beforeInsert() {
        this.cognomeNome1 = (cognome1 ?: "") + ((cognome1 || nome1) ? "/" : "") + (nome1 ?: "")
        this.cognomeNome2 = (cognome2 ?: "") + ((cognome2 || nome2) ? "/" : "") + (nome2 ?: "")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNome1 = (cognome1 ?: "") + ((cognome1 || nome1) ? "/" : "") + (nome1 ?: "")
        this.cognomeNome2 = (cognome2 ?: "") + ((cognome2 || nome2) ? "/" : "") + (nome2 ?: "")
    }
}
