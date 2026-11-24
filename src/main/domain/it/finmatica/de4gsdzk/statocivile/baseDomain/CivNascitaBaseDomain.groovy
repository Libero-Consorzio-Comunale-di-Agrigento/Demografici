package it.finmatica.de4gsdzk.statocivile.baseDomain

import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.anagrafe.AnaCittadinanza
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivMotivoRichiesta
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.utils.*
import org.hibernate.annotations.Formula

import javax.persistence.*

@MappedSuperclass
abstract class CivNascitaBaseDomain extends CivAttoBaseDomain implements IAttoAnsc, ISoggettoAtto1, ISoggettoAtto1Genitori, ICertificabile, ISoggettoAttoAnsc1 {

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

    @Column(name = "SECONDO_NOME", nullable = true)
    String secondoNome

    @Column(name = "TERZO_NOME", nullable = true)
    String terzoNome

    @Enumerated(EnumType.STRING)
    @Column(name = "SESSO", nullable = true)
    ESesso sesso

    ESesso getSesso1() {
        return sesso
    }

    void setSesso1(ESesso s) {
        this.sesso = s
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_FILIAZIONE")
    ETipoFiliazione tipoFiliazione

    // Consenso ad essere nominato/a
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_CONSENSO", nullable = true)
    ETipoConsenso tipoConsenso

    // Tipo di atto di riconoscimento materno/unico e/o paterno nelle dichiarazioni di nascita
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICONOSCIMENTO", nullable = true)
    ETipoRiconoscimentoPrenatale tipoRiconoscimento

    // Consenso dell'altro genitore in sede di riconoscimento
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_CONSENSO_RICONOSCIMENTO", nullable = true)
    ETipoConsensoRiconoscimento tipoConsensoRiconoscimento

    //Tipo di assenso del figlio nei riconoscimenti
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_ASSENSO", nullable = true)
    ETipoAssenso tipoAssenso

    //Scelta del cognome del figlio nei riconoscimenti
    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_SCELTA_COGNOME", nullable = true)
    ETipoSceltaCognome tipoSceltaCognome

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_MANCATO_CONSENSO", nullable = true)
    ETipoMancatoConsensoMadre tipoMancatoConsensoMadre

    @Column(name = "MOTIVO_RITARDO", nullable = true)
    String motivoRitardo

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

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "CF_CALCOLATO", nullable = true)
    private Boolean cfCalcolato

    Boolean getCfCalcolato1() {
        return cfCalcolato
    }

    void setCfCalcolato1(Boolean val) {
        this.cfCalcolato = val
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS", nullable = false)
    Date dataNascita

    Date getDataNascita1() {
        return dataNascita
    }

    void setDataNascita1(Date d) {
        this.dataNascita = d
    }

    @Column(name = "ORE", nullable = true)
    String oraNascita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_HH_IMPRECISATO", nullable = true)
    Boolean oraNascitaImprecisata

    @Column(name = "MINUTI", nullable = true)
    String minutoNascita

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MI_IMPRECISATO", nullable = true)
    Boolean minutoNascitaImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_GG_IMPRECISATO", nullable = true)
    Boolean giornoNascitaImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MM_IMPRECISATO", nullable = true)
    Boolean meseNascitaImprecisato

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_AA_IMPRECISATO", nullable = true)
    Boolean annoNascitaImprecisato

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
        return this.cognomeNomePadre
    }

    String getExtra2Lista() {
        return this.cognomeNomeMadre
    }

    String getExtra3Lista() {
        return null
    }

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_EVENTO_LISTA", nullable = true, updatable = false, insertable = false)
    Date dataEventoLista

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA", nullable = true)
    AnaCittadinanza nazionalita

    AnaCittadinanza getNazionalita1() {
        return nazionalita
    }

    void setNazionalita1(AnaCittadinanza n) {
        this.nazionalita = n
    }

    Boolean isNazionalitaMandatory() {
        return isAdozione() || isRiconoscimentoPostNascita()
    }

    @Enumerated(EnumType.STRING)
    @Column(name = "PARTO_PLURIMO", nullable = true)
    private ETipoSiNo partoPlurimoDb

    void setPartoPlurimo(Boolean val) {
        this.partoPlurimoDb = (val ? ETipoSiNo.SI : null)
    }

    Boolean getPartoPlurimo() {
        return (partoPlurimoDb == ETipoSiNo.SI)
    }

    @Column(name = "PARTO_PLURIMO_NUM_GEMELLO", nullable = true)
    Integer numeroGemello

    @Column(name = "PARTO_PLURIMO_TOT_GEMELLI", nullable = true)
    Integer totaleGemelli

    @Enumerated(EnumType.STRING)
    @Column(name = "NATO_MORTO", nullable = true)
    private ETipoSiNo natoMortoDb

    EStatoNascita getNatoMorto() {
        EStatoNascita val
        switch (this.natoMortoDb) {
            case ETipoSiNo.SI:
                val = EStatoNascita.Nato_morto
                break
            case ETipoSiNo.NO:
                val = EStatoNascita.Vivo_morto
                break
            default:
                val = EStatoNascita.Nato_vivo
                break
        }
        return val
    }

    void setNatoMorto(EStatoNascita val) {
        switch (val) {
            case EStatoNascita.Nato_morto:
                natoMortoDb = ETipoSiNo.SI
                break
            case EStatoNascita.Vivo_morto:
                natoMortoDb = ETipoSiNo.NO
                break
            default:
                natoMortoDb = null
                break
        }
    }

    @Column(name = "COD_COM_NAS", nullable = true)
    Integer codiceComuneNascita

    Integer getCodiceComuneNascita1() {
        return codiceComuneNascita
    }

    void setCodiceComuneNascita1(Integer i) {
        this.codiceComuneNascita = i
    }

    Boolean isComuneNascitaMandatory() {
        return isAdozione() || isRiconoscimentoPostNascita()
    }

    @Column(name = "DES_COM_NAS", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneNascita

    String getDescrizioneComuneNascita1() {
        return descrizioneComuneNascita
    }

    void setDescrizioneComuneNascita1(String s) {
        this.descrizioneComuneNascita = s
    }

    @Column(name = "COD_PRO_NAS", nullable = true)
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

    @Column(name = "COD_PRO_RES", nullable = true)
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

    @Enumerated(EnumType.STRING)
    @Column(name = "TIPO_RICHIESTA", nullable = true)
    ETipoRichiesta tipoRichiesta

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_CIVDMC", nullable = true)
    CivMotivoRichiesta motivoNascita

    @Column(name = "NOTE", nullable = true)
    String note

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_MODELLO_P4", nullable = true, updatable = false, insertable = false)
    Boolean hasModelloP4

    EStatoCivile getStatoCivile1() {
        return null
    }

    void setStatoCivile1(EStatoCivile s) {
        log.info("Parametri stato civile non gestito su civnas: " + (s ?: ""))
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

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_PD", nullable = true)
    Date dataNascitaPadre

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS_PD")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS_PD", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS_PD")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_PD", updatable = false, insertable = false))
    ])
    private Comune comuneNascitaPadre

    Comune getComuneNascitaPadre() {
        if (comuneNascitaPadre == null) {
            comuneNascitaPadre = new Comune()
        }
        return comuneNascitaPadre
    }

    void setComuneNascitaPadre(Comune c) {
        this.comuneNascitaPadre = c
    }

    @Column(name = "COD_COM_RES_PD", nullable = true)
    Integer codiceComuneResidenzaPadre

    @Column(name = "DES_COM_RES_PD", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneResidenzaPadre

    @Column(name = "COD_PRO_RES_PD", nullable = true)
    Integer codiceProvinciaResidenzaPadre

    @Column(name = "SIGLA_PRO_RES_PD", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaResidenzaPadre

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA_PD", nullable = true)
    AnaCittadinanza nazionalitaPadre

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

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_NAS_MD", nullable = true)
    Date dataNascitaMadre

    @Embedded
    @AttributeOverrides([
            @AttributeOverride(name = "codice", column = @Column(name = "COD_COM_NAS_MD")),
            @AttributeOverride(name = "descrizione", column = @Column(name = "DES_COM_NAS_MD", updatable = false, insertable = false)),
            @AttributeOverride(name = "codiceProvincia", column = @Column(name = "COD_PRO_NAS_MD")),
            @AttributeOverride(name = "siglaProvincia", column = @Column(name = "SIGLA_PRO_NAS_MD", updatable = false, insertable = false))
    ])
    private Comune comuneNascitaMadre

    Comune getComuneNascitaMadre() {
        if (comuneNascitaMadre == null) {
            comuneNascitaMadre = new Comune()
        }
        return comuneNascitaMadre
    }

    void setComuneNascitaMadre(Comune c) {
        this.comuneNascitaMadre = c
    }

    @Column(name = "COD_COM_RES_MD", nullable = true)
    Integer codiceComuneResidenzaMadre

    @Column(name = "DES_COM_RES_MD", nullable = true, updatable = false, insertable = false)
    String descrizioneComuneResidenzaMadre

    @Column(name = "COD_PRO_RES_MD", nullable = true)
    Integer codiceProvinciaResidenzaMadre

    @Column(name = "SIGLA_PRO_RES_MD", nullable = true, updatable = false, insertable = false)
    String siglaProvinciaResidenzaMadre

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "NAZIONALITA_MD", nullable = true)
    AnaCittadinanza nazionalitaMadre

    @Column(name = "MATERNITA", nullable = true)
    private String cognomeNomeMadre

    @Column(name = "CONCEPITO_DA_MESI", nullable = true)
    Integer mesiDalConcepimento

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

    @Column(name = "NUOVO_NOME", nullable = true)
    String nuovoNome

    @Column(name = "NUOVO_COGNOME", nullable = true)
    String nuovoCognome

    @Convert(converter = BooleanToStringConverter.class)
    @Column(name = "FLAG_FIGLIO_DI_IGNOTI", nullable = true)
    Boolean flagFiglioDiIgnoti

    ETipoArchivioAnsc getTipoArchivioAnsc() {
        return ETipoArchivioAnsc.NAS
    }

    ETipoAttoAnsc getTipoAttoAnsc() {
        if (isRiconoscimento()) {
            return ETipoAttoAnsc.Rico
        } else
        // refs #70519
        if (isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita() || isCentroNascita() || isOmessaDichiarazioneNascita() || [ENaturaAtto.T, ENaturaAtto.D].contains(natura)) {
            return ETipoAttoAnsc.Trascr
        } else {
            return ETipoAttoAnsc.Dic_Nasc
        }
    }

    Integer getTipoAtto() {
        return new Integer(ETipoAtto.NAS.valore)
    }

    ETipoAtto getTipoAttoEnum() {
        return ETipoAtto.NAS
    }

    Boolean isUfficialeStatoCivileMandatory() {
        return false
    }

    Boolean isSenzaSerie() {
        Boolean val = ((this.parte != null) && ((this.serie ?: "") == ""))
        return val
    }

    Boolean isPrimaA() {
        Boolean val = (isPartePrima() && ((this.serie ?: "") == CivTipoAtto.SERIE_A))
        return val
    }

    Boolean isSecondaA() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "") == CivTipoAtto.SERIE_A))
        return val
    }

    Boolean isPrimaB() {
        Boolean val = (isPartePrima() && ((this.serie ?: "") == CivTipoAtto.SERIE_B))
        return val
    }

    Boolean isSecondaB() {
        Boolean val = (isParteSeconda() && ((this.serie ?: "") == CivTipoAtto.SERIE_B))
        return val
    }

    Boolean isCentroNascita() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.CNA))
        return val
    }

    Boolean isTrascrizioneEsteroDaPrivato() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.TEP))
        return val
    }

    Boolean isTrascrizioneEsteroDaAutorita() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.TEA))
        return val
    }

    Boolean isConsolatoMandatory() {
        return isTrascrizioneEsteroDaAutorita()
    }

    Boolean isEnteStranieroEnabled() {
        return (isTrascrizioneEsteroDaPrivato() || isTrascrizioneEsteroDaAutorita() || isOmessaDichiarazioneNascita())
    }

    Boolean isDatiRichiedenteEnabled() {
        return isTrascrizioneEsteroDaPrivato()
    }

    Boolean isAutoritaMittenteEnabled() {
        return isTrascrizioneEsteroDaAutorita()
    }

    Boolean isRiconoscimentoPrenatale() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.RPN))
        return val
    }

    Boolean isRiconoscimentoPostNascita() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.RIC))
        return val
    }

    Boolean isRiconoscimento() {
        return (isRiconoscimentoPrenatale() || isRiconoscimentoPostNascita())
    }

    Boolean isCambioGeneralita() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.CGE))
        return val
    }

    Boolean isAdozione() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.ADO))
        return val
    }

    Boolean isOmessaDichiarazioneNascita() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: "") == CivCategoriaTipoAtto.ODN))
        return val
    }

    // Categoria ATL o senza categoria (atto generato con forms)
    Boolean isTestoLibero() {
        Boolean val = (isSecondaB() && ((this.tipoAttoDomain?.categoriaDomain?.codice ?: CivCategoriaTipoAtto.ATL) == CivCategoriaTipoAtto.ATL))
        return val
    }

    Boolean isDicCompFirmNasVisibile() {
        return (isPrimaA() || isPrimaB() || isSecondaA() || isCentroNascita() || isTestoLibero())
    }

    Boolean isDicCompFirmRicVisibile() {
        return isRiconoscimento()
    }

    Boolean isTipoAccertamentoVisibile() {
        return (isPrimaA() || isPrimaB() || isSecondaA())
    }

    Boolean isDataAttoEstremiAttoNascitaVisible() {
        isRiconoscimentoPostNascita() || isAdozioneEstremiAttoNascitaVisible()
    }

    Boolean isAdozioneEstremiAttoNascitaVisible() {
        return this.isAdozione() && this.motivoNascita?.flagEstremiAttoNascita
    }

    Boolean isAdozioneAutoritaMittenteVisible() {
        return isAdozione() && (motivoNascita?.flagAutorita)
    }

    String getNomeCompleto() {
        return ((this.nome ?: "") + (this.secondoNome ? (", " + this.secondoNome) : "") + (this.terzoNome ? (", " + this.terzoNome) : ""))
    }

    String getNominativo() {
        return ((this.cognome ?: "") + ((this.cognome && this.nome) ? " " : "") + (this.nome ?: ""))
    }

    Boolean isSedePartoMandatory() {
        return isPartePrima()
    }

    Boolean isMadreMandatory() {
        return this.motivoNascita?.flagMadre ?: Boolean.FALSE
    }

    Boolean isPadreMandatory() {
        return this.motivoNascita?.flagPadre ?: Boolean.FALSE
    }

    Boolean isNazionalitaPadreMadreMandatory() {
        return this.motivoNascita?.flagNazionalitaPadreMadreMandatory ?: Boolean.FALSE
    }

    Boolean isAdozioneEstremiAttoNascitaMandatory() {
        return this.motivoNascita?.flagEstremiAttoNascita ?: Boolean.FALSE
    }

    Boolean isCambioGeneralitaTrascrizioneMandatory() {
        return this.motivoNascita?.flagCambioGeneralitaMandatory ?: Boolean.FALSE
    }

    Boolean isTipoRichiestaTrascrizioneMandatory() {
        return this.motivoNascita?.flagTipoRichiestaTrascrizioneMandatory ?: Boolean.FALSE
    }

    Boolean isTipoConsensoEnabled() {
        return this.tipoFiliazione == ETipoFiliazione.C &&
                (this.tipoRiconoscimento ?: ETipoRiconoscimentoPrenatale.MD) == ETipoRiconoscimentoPrenatale.MD
    }

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Ufficio"), Etichette.getEtichetta("Anno"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Provvisorio"),
                                              Etichette.getEtichetta("Numero_Atto"), Etichette.getEtichetta("Parte"), Etichette.getEtichetta("Serie"), Etichette.getEtichetta("Atto_Nascita"), Etichette.getEtichetta("Natura_Atto"),
                                              Etichette.getEtichetta("Tipo_Filiazione"), Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Secondo_Nome"), Etichette.getEtichetta("Terzo_Nome"),
                                              Etichette.getEtichetta("Senza_Cognome"), Etichette.getEtichetta("Senza_Nome"), Etichette.getEtichetta("Stato_nato_nascita"), Etichette.getEtichetta("Parto_plurimo"),
                                              Etichette.getEtichetta("Sesso"), Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Ore"), Etichette.getEtichetta("Minuti"), Etichette.getEtichetta("Comune_Nascita"),
                                              Etichette.getEtichetta("Codice_Fiscale"), Etichette.getEtichetta("Nazionalita"), Etichette.getEtichetta("Comune_Residenza"), Etichette.getEtichetta("Motivo_ritardo"),
                                              Etichette.getEtichetta("Cognome_Padre"), Etichette.getEtichetta("Nome_Padre"), Etichette.getEtichetta("Stato_Civile"), Etichette.getEtichetta("Stato_Anagrafico"),
                                              Etichette.getEtichetta("Cognome_Madre"), Etichette.getEtichetta("Nome_Madre"), Etichette.getEtichetta("Note"), Etichette.getEtichetta("Certificazione_atto"),
                                              Etichette.getEtichetta("Elenco_Nascite"), Etichette.getEtichetta("Paternita"), Etichette.getEtichetta("Maternita"), Etichette.getEtichetta("Concepito_da_Mesi"),
                                              Etichette.getEtichetta("Motivo_mancato_consenso_madre")]

    @PrePersist
    void beforeInsert() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
        this.cognomeNomePadre = (cognomePadre ?: "") + ((cognomePadre || nomePadre) ? "/" : "") + (nomePadre ?: "")
        this.cognomeNomeMadre = (cognomeMadre ?: "") + ((cognomeMadre || nomeMadre) ? "/" : "") + (nomeMadre ?: "")
    }

    @PreUpdate
    void beforeUpdate() {
        this.cognomeNome = (cognome ?: "") + ((cognome || nome) ? "/" : "") + (nome ?: "")
        this.cognomeNomePadre = (cognomePadre ?: "") + ((cognomePadre || nomePadre) ? "/" : "") + (nomePadre ?: "")
        this.cognomeNomeMadre = (cognomeMadre ?: "") + ((cognomeMadre || nomeMadre) ? "/" : "") + (nomeMadre ?: "")
    }

}
