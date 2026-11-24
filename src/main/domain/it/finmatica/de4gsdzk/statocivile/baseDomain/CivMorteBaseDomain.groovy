package it.finmatica.de4gsdzk.statocivile.baseDomain

import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula

import javax.persistence.*

@MappedSuperclass
abstract class CivMorteBaseDomain extends CivAttoBaseDomain implements IAttoAnsc, ISoggettoAtto1, ISoggettoAtto1Genitori, ICertificabile, ISoggettoAttoAnsc1 {

    public static final int tipoAttoAnnotazioneSuAttoNascitaAltroComune = 8

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

    @Formula("CONCAT(COALESCE(COGNOME, ''), CONCAT(CASE WHEN COGNOME IS NOT NULL AND NOME IS NOT NULL THEN ' ' ELSE '' END, COALESCE(NOME, '')))")
    String cognomeNomeRicerca

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME", nullable = true)
    Boolean senzaCognome

    Boolean getSenzaCognome1() {
        return getSenzaCognome()
    }

    void setSenzaCognome1(Boolean val) {
        setSenzaCognome(val)
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME", nullable = true)
    Boolean senzaNome

    Boolean getSenzaNome1() {
        return getSenzaNome()
    }

    void setSenzaNome1(Boolean val) {
        setSenzaNome(val)
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO")
    ESesso sesso

    ESesso getSesso1() {
        return sesso
    }

    void setSesso1(ESesso s) {
        this.sesso = s
    }

    @Column(name = "COGNOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String cognome1Lista

    @Column(name = "NOME_1_LISTA", nullable = true, updatable = false, insertable = false)
    String nome1Lista

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_1_LISTA", nullable = true, updatable = false, insertable = false)
    ESesso sesso1Lista

    String getCodiceSesso1Lista() {
        return (this.sesso1Lista?.name())
    }

    String getExtra1Lista() {
        return this.descrizioneStatoCivile
    }

    Date getExtra2Lista() {
        return this.dataEventoLista
    }

    String getExtra3Lista() {
        return (comuneMorte?.descrizione ? comuneMorte.descrizione + (comuneMorte?.siglaProvincia ? " (" + comuneMorte?.siglaProvincia + ")" : "") : "")
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVENTO_LISTA", nullable = true, updatable = false, insertable = false)
    Date dataEventoLista

    @Column(name = "ANNI", nullable = true)
    Integer anni

    @Column(name = "COD_FISCALE", nullable = true)
    private String codiceFiscale

    String getCodiceFiscale() {
        return codiceFiscale
    }

    void setCodiceFiscale(String codiceFiscale) {
        this.codiceFiscale = codiceFiscale?.toUpperCase()
    }

    String getCodiceFiscale1() {
        return getCodiceFiscale()
    }

    void setCodiceFiscale1(String c) {
        setCodiceFiscale(c)
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO", nullable = true)
    private Boolean cfCalcolato

    Boolean getCfCalcolato1() {
        return cfCalcolato
    }

    void setCfCalcolato1(Boolean val) {
        this.cfCalcolato = val
    }

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA", nullable = true)
    AnaCittadinanza nazionalita

    AnaCittadinanza getNazionalita1() {
        return nazionalita
    }

    void setNazionalita1(AnaCittadinanza n) {
        this.nazionalita = n
    }

    @Column(name = "STATO_CIVILE", nullable = true)
    String statoCivile

    EStatoCivile getStatoCivile1() {
        return new EStatoCivile.EnumStatoCivileToStringConverter().convertToEntityAttribute(statoCivile)
    }

    void setStatoCivile1(EStatoCivile s) {
        this.statoCivile = s?.id
    }

    @Column(name = "DES_STATO_CIVILE", nullable = true, updatable = false, insertable = false)
    String descrizioneStatoCivile

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_MOR", nullable = true)
    Date dataMorte

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_GG_IMPRECISATO", nullable = true)
    Boolean giornoMorteImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MM_IMPRECISATO", nullable = true)
    Boolean meseMorteImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_AA_IMPRECISATO", nullable = true)
    Boolean annoMorteImprecisato

    @Column(name = "ORE", nullable = true)
    String oraMorte

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_HH_IMPRECISATO", nullable = true)
    Boolean oraMorteImprecisata

    @Column(name = "MINUTI", nullable = true)
    String minutoMorte

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MI_IMPRECISATO", nullable = true)
    Boolean minutoMorteImprecisato

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = true)
    Date dataNascita

    Date getDataNascita1() {
        return dataNascita
    }

    void setDataNascita1(Date d) {
        this.dataNascita = d
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_GG_IMPRECISATO_NAS", nullable = true)
    Boolean giornoNascitaImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MM_IMPRECISATO_NAS", nullable = true)
    Boolean meseNascitaImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_AA_IMPRECISATO_NAS", nullable = true)
    Boolean annoNascitaImprecisato

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

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_MOR")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_MOR", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_MOR")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_MOR", updatable = false, insertable = false))
    ])
    private Comune comuneMorte

    Comune getComuneMorte() {
        if (comuneMorte == null) {
            comuneMorte = new Comune()
        }
        return comuneMorte
    }

    void setComuneMorte(Comune c) {
        this.comuneMorte = c
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MORTE_VIOLENTA", nullable = true)
    private Boolean flagMorteViolenta

    @Enumerated(EnumType.STRING)
    @Formula("CASE WHEN FLAG_MORTE_VIOLENTA = 'S' THEN 'SI' ELSE 'NO' END")
    private ETipoSiNo morteViolenta

    ETipoSiNo getMorteViolenta() {
        return morteViolenta
    }

    void setMorteViolenta(ETipoSiNo val) {
        this.morteViolenta = val
        this.flagMorteViolenta = ((val == ETipoSiNo.SI) ? Boolean.TRUE : null)
    }

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

    // Caso rinvenimento cadavere
    @Column(name = "DES_EVENTO_MOR", nullable = true)
    String descrizioneEventoMorte

    @Column(name = "DES_DATA_MOR", nullable = true)
    String descrizioneDataMorte

    @Column(name = "DES_ORE_MINUTI_MOR", nullable = true)
    String descrizioneOrarioMorte

    @Enumerated(EnumType.STRING)
    @Formula("CASE WHEN DES_EVENTO_MOR IS NOT NULL OR DES_DATA_MOR IS NOT NULL OR DES_ORE_MINUTI_MOR IS NOT NULL THEN 'NO' ELSE 'SI' END")
    private ETipoSiNo estremiDecessoNoti

    ETipoSiNo getEstremiDecessoNoti() {
        return estremiDecessoNoti
    }

    void setEstremiDecessoNoti(ETipoSiNo estremiDecessoNoti) {
        this.estremiDecessoNoti = estremiDecessoNoti
    }

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_D4", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloD4

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_D4BIS", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloD4Bis

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_FIRMATO_USC_ANSC", nullable = true, updatable = false, insertable = false)
    Boolean flagFirmatoUscAnsc

    @Column(name = "ID_USECASE_ANSC", nullable = true)
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

    ETipoArchivioAnsc getTipoArchivioAnsc() {
        return ETipoArchivioAnsc.MOR
    }

    ETipoAttoAnsc getTipoAttoAnsc() {
        // refs #70519
        if (isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita() || [ENaturaAtto.T, ENaturaAtto.D].contains(natura)) {
            return ETipoAttoAnsc.Trascr_Morte
        } else {
            return ETipoAttoAnsc.Morte
        }
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// PADRE ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COGNOME_PD", nullable = true)
    String cognomePadre

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_PD", nullable = true)
    Boolean senzaCognomePadre

    @Column(name = "NOME_PD", nullable = true)
    String nomePadre

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_PD", nullable = true)
    Boolean senzaNomePadre

    @Column(name = "PATERNITA", nullable = true)
    private String cognomeNomePadre

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// MADRE ///////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    @Column(name = "COGNOME_MD", nullable = true)
    String cognomeMadre

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_MD", nullable = true)
    Boolean senzaCognomeMadre

    @Column(name = "NOME_MD", nullable = true)
    String nomeMadre

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_MD", nullable = true)
    Boolean senzaNomeMadre

    @Column(name = "MATERNITA", nullable = true)
    private String cognomeNomeMadre

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// CONIUGE /////////////////////////////
    ////////////////////////////////////////////////////////////////////////


    @Column(name = "COGNOME_CN", nullable = true)
    String cognomeConiuge

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_COGNOME_CN", nullable = true)
    Boolean senzaCognomeConiuge

    @Column(name = "NOME_CN", nullable = true)
    String nomeConiuge

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "SENZA_NOME_CN", nullable = true)
    Boolean senzaNomeConiuge

    @Column(name = "COGNOME_NOME_CN", nullable = true)
    private String cognomeNomeConiuge

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO_CN", nullable = true)
    ESesso sessoConiuge

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_CN", nullable = true)
    Date dataNascitaConiuge

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA_CN", nullable = true)
    AnaCittadinanza nazionalitaConiuge

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS_CN")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS_CN", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS_CN")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_CN", updatable = false, insertable = false))
    ])
    private Comune comuneNascitaConiuge

    Comune getComuneNascitaConiuge() {
        if (comuneNascitaConiuge == null) {
            comuneNascitaConiuge = new Comune()
        }
        return comuneNascitaConiuge
    }

    void setComuneNascitaConiuge(Comune c) {
        this.comuneNascitaConiuge = c
    }

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_RES_CN")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_RES_CN", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_RES_CN")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_RES_CN", updatable = false, insertable = false))
    ])
    private Comune comuneResidenzaConiuge

    Comune getComuneResidenzaConiuge() {
        if (comuneResidenzaConiuge == null) {
            comuneResidenzaConiuge = new Comune()
        }
        return comuneResidenzaConiuge
    }

    void setComuneResidenzaConiuge(Comune c) {
        this.comuneResidenzaConiuge = c
    }

    //////////////////////////////////////////////////////////////////////////

    Integer getTipoAtto() {
        return new Integer(ETipoAtto.MOR.valore)
    }

    ETipoAtto getTipoAttoEnum() {
        return ETipoAtto.MOR
    }

    Boolean isUfficialeStatoCivileMandatory() {
        return false
    }

    Boolean isSecondaA() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "") == CivTipoAtto.SERIE_A))
        return val
    }

    Boolean isSecondaB() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "") == CivTipoAtto.SERIE_B))
        return val
    }

    Boolean isSecondaBBis() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "").toUpperCase().contains(CivTipoAtto.SERIE_BIS)))
        return val
    }

    Boolean isSecondaC() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "") == CivTipoAtto.SERIE_C))
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
        return (isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita())
    }

    Boolean isDatiRichiedenteEnabled() {
        return isTrascrizioneEsteroDaPrivato()
    }

    Boolean isAutoritaMittenteEnabled() {
        return isTrascrizioneEsteroDaAutorita()
    }

    Boolean isMortePresunta() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.MPR))
        return val
    }

    Boolean isCadutoInGuerra() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.CIG))
        return val
    }

    Boolean isSecondaCEx2BBis() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.BIS))
        return val
    }

    // Categoria ATL o senza categoria (atto generato con forms)
    Boolean isTestoLibero() {
        Boolean val = (isSecondaC() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: CivCategoriaTipoAtto.ATL) == CivCategoriaTipoAtto.ATL))
        return val
    }

    // Categoria ATL
    Boolean isATL() {
        Boolean val = (isSecondaC() && (this.tipoAttoDomain != null) && (this.tipoAttoDomain.categoriaDomain != null) && (this.tipoAttoDomain?.categoriaDomain?.codice == CivCategoriaTipoAtto.ATL))
        return val
    }

    Boolean isCompFirmMorVisibile() {
        return (isPartePrima() || isSecondaA())
    }

    Boolean isComprensioneDichiaranteVisibile() {
        return isCompFirmMorVisibile()
    }

    String getNominativo() {
        return ((this.cognome ?: "") + ((this.cognome && this.nome) ? " " : "") + (this.nome ?: ""))
    }

    Boolean isConiugato() {
        //#65832
        (this.statoCivile.equals(EStatoCivile.CN.id) || this.statoCivile.equals(EStatoCivile.UC.id) ||
                this.statoCivile.equals(EStatoCivile.VE.id) || this.statoCivile.equals(EStatoCivile.VU.id) ||
                this.statoCivile.equals(EStatoCivile.DV.id) || this.statoCivile.equals(EStatoCivile.GU.id))
    }

    Boolean isConiugeMandatory() {
        (this.statoCivile.equals(EStatoCivile.CN.id) || this.statoCivile.equals(EStatoCivile.UC.id) ||
                this.statoCivile.equals(EStatoCivile.VE.id) || this.statoCivile.equals(EStatoCivile.VU.id))
    }

    Boolean isEstremiDecessoDecisionVisible() {
        return isPartePrima() || isParteSeconda()
    }

    Boolean isDataAttoEstremiAttoNascitaVisible() {
        return Boolean.FALSE
    }

    //////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI///////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Provvisorio"),
                                              Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Atto_Morte"), Etichette.getEtichetta("Natura_Atto"),
                                              Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Anni"),
                                              Etichette.getEtichetta("Senza_Cognome"), Etichette.getEtichetta("Senza_Nome"), Etichette.getEtichetta("Comune_Decesso"),
                                              Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Data_Decesso"), Etichette.getEtichetta("Ore"), Etichette.getEtichetta("Minuti"), Etichette.getEtichetta("Comune_Nascita"),
                                              Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Nazionalita"), Etichette.getEtichetta("Comune_Residenza"),
                                              Etichette.getEtichetta("Cognome_Padre"), Etichette.getEtichetta("Nome_Padre"), Etichette.getEtichetta("Stato_Civile"), Etichette.getEtichetta("Stato_Anagrafico"),
                                              Etichette.getEtichetta("Cognome_Madre"), Etichette.getEtichetta("Nome_Madre"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Certificazione_atto"),
                                              Etichette.getEtichetta("Elenco_Morti"), Etichette.getEtichetta("Circostanze"), Etichette.getEtichetta("Data_ritrovamento"), Etichette.getEtichetta("Ore_ritrovamento"),
                                              Etichette.getEtichetta("Estremi_decesso_noti"), Etichette.getEtichetta("Morte_violenta"), Etichette.getEtichetta("Nota_ritrovamento_cadavere")]

    @PrePersist
    void beforeInsert() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
        this.cognomeNomePadre = (cognomePadre ?: "") + ((cognomePadre || nomePadre) ? "/" : "") + (nomePadre ?: "")
        this.cognomeNomeMadre = (cognomeMadre ?: "") + ((cognomeMadre || nomeMadre) ? "/" : "") + (nomeMadre ?: "")
        this.cognomeNomeConiuge = (cognomeConiuge ?: "") + ((cognomeConiuge || nomeConiuge) ? "/" : "") + (nomeConiuge ?: "")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
        this.cognomeNomePadre = (cognomePadre ?: "") + ((cognomePadre || nomePadre) ? "/" : "") + (nomePadre ?: "")
        this.cognomeNomeMadre = (cognomeMadre ?: "") + ((cognomeMadre || nomeMadre) ? "/" : "") + (nomeMadre ?: "")
        this.cognomeNomeConiuge = (cognomeConiuge ?: "") + ((cognomeConiuge || nomeConiuge) ? "/" : "") + (nomeConiuge ?: "")
    }
}
