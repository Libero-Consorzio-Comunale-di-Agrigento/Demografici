package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.ErroreLunghezzaCampiRuntimeException
import it.finmatica.de4gsdzk.integrazioni.documentale.EModelloGdm
import it.finmatica.de4gsdzk.statocivile.embed.Comune
import it.finmatica.de4gsdzk.statocivile.embed.EstremiAtto
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.zkutils.ScanEvent
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.util.media.Media
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import java.nio.charset.StandardCharsets

@Slf4j
trait TraitGestioneIndividuo {

    Map<String, Boolean> minuscole = [:]
    List<ESesso> listaSesso
    List<AnaCittadinanza> listaNazionalita
    List<AnaStatoCivile> listaStatoCivile = []
    List<AnaTitoloStudio> listaTitoliStudio
    List<AnaProfessione> listaProfessioni = []
    List<AnaAttivita> listaAttivita
    List<AnaPosizioneProfessionale> listaPosizioniProfessionali
    List<AnaTipoProvvedimento> listaTipi
    List<AnaMotivoProvvedimento> listaMotivi
    List<AnaEnte> listaEnti
    List<EStatoConvivenza> statoConvivenzaList
    List<AnaTipoRecapito> listaTipiRecapito
    AnaRapportoParentela selectedRapportoParentela
    List<AnaRapportoParentela> rapportoParentelaMList
    List<AnaRapportoParentela> rapportoParentelaFList

    Date dataRiferimentoComuneAttoNascita
    Date dataRiferimentoComuneAttoMatrimonio
    Date dataRiferimentoComuneAttoVedovanza
    Date dataRiferimentoComuneAttoDivorzio
    Date dataRiferimentoComuneAttoInizioConvivenza
    Date dataRiferimentoComuneAttoFineConvivenza

    ETipoSiNo convivenzaDiFatto
    ETipoSiNo affidamentoUrneCinerarie
    ETipoSiNo provvedimento
    AnaDettaglioProvvedimento provvedimentoDivorzio

    Boolean ricercaSoggettoInANPROn = Boolean.TRUE

    AnaDocumento selectedDocumentoCDF
    AnaDocumento selectedDocumentoSoggetto

    abstract AnaCittadinanzaService getAnaCittadinanzaService()

    abstract AnaStatoCivileService getAnaStatoCivileService()

    abstract AnaTitoloStudioService getAnaTitoloStudioService()

    abstract AnaProfessioneService getAnaProfessioneService()

    abstract AnaAttivitaService getAnaAttivitaService()

    abstract AnaPosizioneProfessionaleService getAnaPosizioneProfessionaleService()

    abstract GsdService getGsdService()

    abstract ArcParametroService getArcParametroService()

    abstract AnaTipoProvvedimentoService getAnaTipoProvvedimentoService()

    abstract AnaMotivoProvvedimentoService getAnaMotivoProvvedimentoService()

    abstract AnaEnteService getAnaEnteService()

    abstract AnaRapportoParentelaService getAnaRapportoParentelaService()

    abstract AnaAnagrafeService getAnaAnagrafeService()

    abstract AnaDocumentoService getAnaDocumentoService()

    abstract AnaDocumentoAllegatoService getAnaDocumentoAllegatoService()

    abstract AnaTipoDocumentoService getAnaTipoDocumentoService()

    abstract AnaUrnaCinerariaService getAnaUrnaCinerariaService()

    abstract AnaTipoRecapitoService getAnaTipoRecapitoService()

    abstract AnaDettaglioProvvedimentoService getAnaDettaglioProvvedimentoService()

    abstract AnaConvivenzaDiFattoService getAnaConvivenzaDiFattoService()

    abstract CerTerminalistaService getCerTerminalistaService()

    abstract AnaAnagrafe getSoggetto()

    abstract AnaPratica getPratica()

    abstract String getMsgTitle()

    abstract String getEtichetta(Map<String, String> etichetta)

    abstract void refreshUi()

    abstract void caricaDettaglio(Object id)

    abstract Window getSelf()

    abstract void riempiComune(Comune comuneTarget, ArcComuneBaseDomain comuneSource)

    abstract void cancellaCampo(Object entita, String campo)

    abstract void aggiornaCase(Object entita, String p)

    abstract void onModificaDatiSoggetto(Event e)

    void initMinuscole() {
        minuscole = [cognome          : Boolean.FALSE, nome: Boolean.FALSE,
                     cognomePadre     : Boolean.FALSE, nomePadre: Boolean.FALSE,
                     cognomeMadre     : Boolean.FALSE, nomeMadre: Boolean.FALSE,
                     cognomeConiuge   : Boolean.FALSE, nomeConiuge: Boolean.FALSE,
                     cognomeConvivente: Boolean.FALSE, nomeConvivente: Boolean.FALSE]
        arcParametroService.checkMinuscoleOn(minuscole, true)
    }

    void caricaListaNazionalita() {
        listaNazionalita = [null]
        List<AnaCittadinanza> l = anaCittadinanzaService.listAll()
        if (l.size() > 0) {
            listaNazionalita.addAll(l)
        }
    }

    void caricaListaStatoCivile() {
        listaStatoCivile = [null]
        if (soggetto.sesso) {
            listaStatoCivile.addAll(anaStatoCivileService.listAllBySesso(soggetto.sesso))
        }
    }

    void caricaProfessioni() {
        listaProfessioni = [null]
        if (soggetto.sesso) {
            listaProfessioni.addAll(anaProfessioneService.findAllBySesso(soggetto.sesso))
        }
    }

    void initListeLookup(ETipoFamiglia tipoFamiglia) {
        listaSesso = [null] + ESesso.values().toList()
        listaTitoliStudio = [null] + anaTitoloStudioService.findAll()
        listaAttivita = [null] + anaAttivitaService.findAll()
        listaPosizioniProfessionali = [null] + anaPosizioneProfessionaleService.findAll()
        listaTipi = anaTipoProvvedimentoService.findAll()
        listaMotivi = anaMotivoProvvedimentoService.findAllByTipoDivorzioNotNull()
        listaEnti = anaEnteService.findAllByCodiceAnprNotNull()
        rapportoParentelaFList = [null] + anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.F, tipoFamiglia)
        rapportoParentelaMList = [null] + anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.M, tipoFamiglia)
        statoConvivenzaList = [null] + EStatoConvivenza.values().toList()
        listaTipiRecapito = anaTipoRecapitoService.findAll()
    }

    @Command
    void onCancellaCampo(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        cancellaCampo(soggetto, p)
        refreshUi()
    }

    @Command
    void onCancellaCampoProvvedimento(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        cancellaCampo(provvedimentoDivorzio, p)
        refreshUi()
    }

    @Command
    void onCancellaCampoCustom(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")

        if (p.contains("Madre")) {
            svuotaMatricola("M")
        } else if (p.contains("Padre")) {
            svuotaMatricola("P")
        } else if (p.contains("Coniuge")) {
            svuotaMatricola("CONI")
        } else if (p.contains("Convivente")) {
            svuotaMatricola("CONV")
            cancellaCampo(soggetto.convivenzaDiFatto, p)
            return
        } else { //nome e cognome
            onModificaDatiSoggetto(null)
        }

        cancellaCampo(soggetto, p)
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c) {
        switch (tca) {
            case ETipoComuneAtto.SOGG_NAS:
                riempiComune(soggetto.comuneNascita, c)
                break
            case ETipoComuneAtto.SOGG_ATTO_NAS:
                riempiComune(soggetto.comuneAttoNascita, c)
                break
            case ETipoComuneAtto.SOGG_MAT:
                riempiComune(soggetto.comuneMatrimonio, c)
                break
            case ETipoComuneAtto.SOGG_ATTO_MAT:
                riempiComune(soggetto.comuneAttoMatrimonio, c)
                break
            case ETipoComuneAtto.SOGG_VED:
                riempiComune(soggetto.comuneVedovanza, c)
                break
            case ETipoComuneAtto.SOGG_ATTO_VED:
                riempiComune(soggetto.comuneAttoVedovanza, c)
                break
            case ETipoComuneAtto.SOGG_DIV:
                riempiComune(soggetto.comuneDivorzio, c)
                break
            case ETipoComuneAtto.SOGG_ATTO_DIV:
                riempiComune(soggetto.comuneAttoDivorzio, c)
                break
            case ETipoComuneAtto.CONV_I:
                riempiComune(soggetto.convivenzaDiFatto.comuneInizio, c)
                break
            case ETipoComuneAtto.CONV_F:
                riempiComune(soggetto.convivenzaDiFatto.comuneFine, c)
                break
            case ETipoComuneAtto.PROVVEDIMENTO:
                riempiComune(provvedimentoDivorzio.comuneEnte, c)
                break
        }
        refreshUi()
    }

    @Command
    void onAggiornaCaseCustom(@ContextParam(ContextType.TRIGGER_EVENT) Event e, @BindingParam("sezione") String sezione) {
        String p = e?.target?.getAttribute("proprieta")
        if (sezione.equals("CONI")) {
            aggiornaCaseCustom(soggetto.coniuge, p)
        } else { // CONV
            aggiornaCase(soggetto.convivenzaDiFatto, p)
        }

    }

    @Command
    void onSelectComuneRecapito(@ContextParam(ContextType.TRIGGER_EVENT) Event event, @BindingParam("comune") Comune comune) {
        ArcComuneBaseDomain c = null
        if (event?.target?.selectedItem instanceof ArcComuneBaseDomain) {
            c = event.target.selectedItem
        }
        riempiComune(comune, c)
        refreshUi()
    }

    @Command
    void onSelectSesso() {
        soggetto.statoCivile = null
        caricaListaStatoCivile()
        onSessoChanged()
        caricaProfessioni()
        refreshUi()
    }

    void onSessoChanged() {
        // hook - no-op di default
    }

    @Command
    void onSelectStatoCivile() {
        refreshUi()
    }

    @Command
    void onCalcolaCf() {
        String cf = gsdService.calcolaCf(soggetto.cognome, soggetto.nome, soggetto.sesso, soggetto.dataNascita,
                soggetto.comuneNascita.codiceProvincia, soggetto.comuneNascita.codice)
        if ((cf ?: GsdService.ERRORE_CAMPI_CF) == GsdService.ERRORE_CAMPI_CF) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_campi_cf")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            soggetto.codiceFiscale = cf
            soggetto.cfCalcolato = true
        }
        refreshUi()
    }

    @Command
    void onAggiornaDataRiferimento(@BindingParam("campoRiferimento") String campoRiferimento) {
        switch (ETipoComuneAtto.valueOf(campoRiferimento)) {
            case ETipoComuneAtto.SOGG_DATA_NAS:
                dataRiferimentoComuneAttoNascita = DataUtils.getDataAttoRif(soggetto.dataNascita, soggetto.attoNascita.anno)
                onDataNascitaChanged()
                break
            case ETipoComuneAtto.SOGG_ATTO_NAS:
                dataRiferimentoComuneAttoNascita = DataUtils.getDataAttoRif(soggetto.dataNascita, soggetto.attoNascita.anno)
                break
            case ETipoComuneAtto.SOGG_ATTO_MAT:
                dataRiferimentoComuneAttoMatrimonio = DataUtils.getDataAttoRif(soggetto.dataMatrimonio, soggetto.attoMatrimonio.anno)
                break
            case ETipoComuneAtto.SOGG_ATTO_VED:
                dataRiferimentoComuneAttoVedovanza = DataUtils.getDataAttoRif(soggetto.dataVedovanza, soggetto.attoVedovanza.anno)
                break
            case ETipoComuneAtto.SOGG_ATTO_DIV:
                dataRiferimentoComuneAttoDivorzio = DataUtils.getDataAttoRif(soggetto.dataDivorzio, soggetto.attoDivorzio.anno)
                break
            case ETipoComuneAtto.SOGG_ATTO_CONV_I:
                dataRiferimentoComuneAttoInizioConvivenza = DataUtils.getDataAttoRif(soggetto.convivenzaDiFatto.dataInizio, soggetto.convivenzaDiFatto.annoPraticaInizio)
                break
            case ETipoComuneAtto.SOGG_ATTO_CONV_F:
                dataRiferimentoComuneAttoFineConvivenza = DataUtils.getDataAttoRif(soggetto.convivenzaDiFatto.dataFine, soggetto.convivenzaDiFatto.annoPraticaFine)
                break
        }
        refreshUi()
    }

    void onDataNascitaChanged() {
        // hook - no-op di default
    }

    @Command
    void svuotaMatricola(@BindingParam("sezione") String sezione) {
        switch (sezione) {
            case 'I':
                soggetto.id = null
                convivenzaDiFatto = ETipoSiNo.NO
                break
            case 'CONI':
                soggetto.coniuge.anagrafe = null
                break
            case 'P':
                soggetto.padre = null
                break
            case 'M':
                soggetto.madre = null
                break
            case 'CONV':
                soggetto?.convivenzaDiFatto?.convivente = null
                break
        }

        refreshUi()
    }


    @Command
    void onRicercaSoggetto(@BindingParam("sezione") String sezione) {
        switch (sezione) {
            case 'I':
                Map params = [cognome: soggetto.cognome?.toUpperCase(), nome: soggetto.nome?.toUpperCase(), sessoEnabled: Boolean.TRUE, archivioAnagrafe: archivioAnagrafe, tipoPratica: tipoPratica, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        caricaDettaglio(ana.matricola)
                        refreshUi()
                    }
                })
                w.doModal()

                break
            case 'CONI':
                Map params = [cognome: soggetto.coniuge?.cognome?.toUpperCase(), nome: soggetto.coniuge?.nome?.toUpperCase(), sessoEnabled: Boolean.TRUE, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        soggetto.coniuge.anagrafe = anaAnagrafeService.findById(ana.matricola as Integer)
                        soggetto.coniuge.nome = ana.nome
                        soggetto.coniuge.cognome = ana.cognome
                        refreshUi()
                    }
                })
                w.doModal()
                break
            case 'CONV':
                Map params = [cognome: soggetto.convivenzaDiFatto?.cognomeConvivente?.toUpperCase(), nome: soggetto.convivenzaDiFatto?.nomeConvivente?.toUpperCase(), sessoEnabled: Boolean.TRUE, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        soggetto.convivenzaDiFatto.convivente = anaAnagrafeService.findById(ana.matricola as Integer)
                        soggetto.convivenzaDiFatto.nomeConvivente = ana.nome
                        soggetto.convivenzaDiFatto.cognomeConvivente = ana.cognome
                        refreshUi()
                    }
                })
                w.doModal()
                break
            case 'P':
                Map params = [cognome: soggetto.cognomePadre?.toUpperCase(), nome: soggetto.nomePadre?.toUpperCase(), sessoEnabled: Boolean.TRUE, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        soggetto.padre = anaAnagrafeService.findById(ana.matricola as Integer)
                        soggetto.nomePadre = ana.nome
                        soggetto.cognomePadre = ana.cognome
                        refreshUi()
                    }
                })
                w.doModal()
                break
            case 'M':
                Map params = [cognome: soggetto.cognomeMadre?.toUpperCase(), nome: soggetto.nomeMadre?.toUpperCase(), sessoEnabled: Boolean.TRUE, flagInserimento: Boolean.TRUE]

                Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
                w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                    if (event.data instanceof AnaAnagrafeBaseDomain) {
                        AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain) event.data
                        soggetto.madre = anaAnagrafeService.findById(ana.matricola as Integer)
                        soggetto.nomeMadre = ana.nome
                        soggetto.cognomeMadre = ana.cognome
                        refreshUi()
                    }
                })
                w.doModal()

                break
        }

    }

    @Command
    void onCalcolaNumeroPraticaCdF(@BindingParam("tipoPratica") String tipoPratica) {
        if('F'.equals(tipoPratica)) {
            soggetto.convivenzaDiFatto.annoPraticaFine = soggetto.convivenzaDiFatto.annoPraticaFine ?: DataUtils.getAnnoCorrente()
            soggetto.convivenzaDiFatto.praticaFine = gsdService.getNumeroPraticaCdf(tipoPratica, soggetto.convivenzaDiFatto.annoPraticaFine)
        } else {
            soggetto.convivenzaDiFatto.annoPraticaInizio = soggetto.convivenzaDiFatto.annoPraticaInizio ?: DataUtils.getAnnoCorrente()
            soggetto.convivenzaDiFatto.praticaInizio = gsdService.getNumeroPraticaCdf(tipoPratica, soggetto.convivenzaDiFatto.annoPraticaInizio)
        }
        refreshUi()
    }

    void aggiornaCaseCustom(Object entita, String p) {
        if (p) {
            Boolean upper
            if (p.equals('nome')) {
                upper = (!(minuscole['nomeConiuge']))
            } else {
                upper = (!(minuscole['cognomeConiuge']))
            }

            if (upper) {
                entita."$p" = entita."$p"?.toUpperCase()
            }
            refreshUi()
        }
    }

    List<Map<String, String>> getEtichetteGestioneIndividuo() {
        List<Map<String, String>> eList = [
                Etichette.getEtichetta("Compilare_campi_cf"),
                Etichette.getEtichetta("Funzione_non_abilitata"),
                Etichette.getEtichetta("Seleziona_Documento_Errore"),
                Etichette.getEtichetta("Ask_Cancellazione_Documento"),
                Etichette.getEtichetta("Ask_Cancellazione_Allegato"),
                Etichette.getEtichetta("Ask_Cancellazione_Record"),
                Etichette.getEtichetta("Sezione_Convivenza_Di_Fatto_Pratica"),
                Etichette.getEtichetta("Sezione_Documenti_Pratica"),
                Etichette.getEtichetta("Sezione_Recapiti_Pratica"),
                Etichette.getEtichetta("Sezione_Urne_Cinerarie"),
                Etichette.getEtichetta("Errore_file_formato"),
                Etichette.getEtichetta("Minuscole"),
                Etichette.getEtichetta("Numero_record_trovati"),
                Etichette.getEtichetta("Nessun_dato_disponibile"),
                Etichette.getEtichetta("Nessuna_Urna_Cineraria_Presente"),
                Etichette.getEtichetta("Calcola_Numero_Pratica"),
                Etichette.getEtichetta("Errore_Lunghezza_Campo")
        ]
        eList.addAll(AnaAnagrafe.etichetteDomain)
        eList.addAll(AnaConvivenzaDiFatto.etichetteDomain)
        eList.addAll(AnaDocumento.etichetteDomain)
        eList.addAll(AnaRecapito.etichetteDomain)
        eList.addAll(AnaUrnaCineraria.etichetteDomain)
        eList.addAll(AnaDettaglioProvvedimento.etichetteDomain)
        eList.addAll(ESesso.values()*.getEtichettaDesc())
        eList.addAll(EStatoConvivenza.values()*.getEtichettaDesc())
        eList.addAll(ENaturaDocumento.values()*.getEtichettaDesc())
        eList.addAll([Etichette.getEtichetta("SI"), Etichette.getEtichetta("NO")])
        //Toolbar
        eList.addAll([Etichette.getEtichetta("inserisci_documento_tooltip"), Etichette.getEtichetta("modifica_tooltip"),
                      Etichette.getEtichetta("elimina_tooltip"), Etichette.getEtichetta("scarica_allegato_tooltip"),
                      Etichette.getEtichetta("scarica_allegati_tooltip"), Etichette.getEtichetta("elimina_allegato_tooltip"),
                      Etichette.getEtichetta("carica_documento_tooltip"), Etichette.getEtichetta("scansiona_documento_tooltip"),
                      Etichette.getEtichetta("inserisci_recapito_tooltip"), Etichette.getEtichetta("elimina_recapito_tooltip")])
        eList.addAll([Etichette.getEtichetta("Dati_Cdf_Differenti"), Etichette.getEtichetta("Codici_Cdf_Differenti")])

        return eList
    }

    // GESTIONE DOCUMENTI, CDF, RECAPITI E URNE

    List<AnaDocumento> getDocumentiCDF() {
        if (soggetto?.matricola) {
            return anaAnagrafeService.getDocumentiCDF(soggetto)
        }
        return []
    }

    List<AnaDocumento> getDocumentiSoggetto() {
        if (soggetto?.matricola) {
            return anaAnagrafeService.getDocumentiSoggetto(soggetto)
        }
        return []
    }

    @Command
    void onInserisciDocumento(@BindingParam("tipologia") String tipologia) {

        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneDocumento.zul", self, [id: null, tipologia: tipologia, matricola: soggetto.matricola])
        w.addEventListener(Events.ON_CLOSE, { event ->
            refreshUi()
        })
        w.doModal()

    }

    @Command
    void onModificaDocumento(@BindingParam("documento") AnaDocumento documento) {
        String tipologia = documento.tipoDocumento.flagConvivenzaDiFatto ? 'CDF' : 'SOGG'
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneDocumento.zul", self, [id: documento.id, tipologia: tipologia])
        w.addEventListener(Events.ON_CLOSE, { event ->
            if (documento.tipoDocumento.id == AnaTipoDocumento.PT) {
                soggetto.possessoPatente = anaAnagrafeService.refreshFlagPatente(soggetto.id)
            } else if (documento.tipoDocumento.id == AnaTipoDocumento.CC) {
                soggetto.possessoCartaCircolazione = anaAnagrafeService.refreshFlagCC(soggetto.id)
            }
            refreshUi()
        })
        w.doModal()

    }

    @Command
    void onEliminaDocumento(@BindingParam("documento") AnaDocumento documento) {

        Messagebox.show(documento.tipoDocumento.descrizione + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Documento")), " ", Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                { Event e ->
                    if (Messagebox.ON_OK.equals(e.getName())) {
                        anaDocumentoService.delete(documento)
                        if (documento.tipoDocumento.id.equals(AnaTipoDocumento.PT)) {
                            soggetto.possessoPatente = anaAnagrafeService.refreshFlagPatente(soggetto.id)
                        } else if (documento.tipoDocumento.id.equals(AnaTipoDocumento.CC)) {
                            soggetto.possessoCartaCircolazione = anaAnagrafeService.refreshFlagCC(soggetto.id)
                        }
                        refreshUi()
                    }
                } as EventListener
        )

        refreshUi()

    }


    @Command
    void onSelectConvivenza() {
        if (convivenzaDiFatto.equals(ETipoSiNo.SI) && soggetto.convivenzaDiFatto == null) {
            soggetto.convivenzaDiFatto = new AnaConvivenzaDiFatto()
        }

    }

    @Command
    void onSelectUrne() {
        if (affidamentoUrneCinerarie.equals(ETipoSiNo.SI) && soggetto.urneCinerarie == null) {
            soggetto.urneCinerarie = new ArrayList<>()
        }

    }

    @Command
    void onSelectProvvedimento() {
        if (provvedimento.equals(ETipoSiNo.SI) && provvedimentoDivorzio == null) {
            provvedimentoDivorzio = new AnaDettaglioProvvedimento(soggetto: soggetto, pratica: pratica, archivioAnagrafe: pratica.archivioAnagrafe.id,
                    tipoPratica: pratica.tipoPratica, annoPratica: pratica.anno, numeroPratica: pratica.numero)
        }

    }

    @Command
    void onScanAllegato(@ContextParam(ContextType.TRIGGER_EVENT) ScanEvent event, @BindingParam("tipologia") String tipologia) {
        if (event) {

            if (tipologia.equals('CDF')) {
                if (selectedDocumentoCDF) {
                    scanAllegato(event, selectedDocumentoCDF)
                } else {
                    throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Seleziona_Documento_Errore"))
                }
            } else { //standard
                if (selectedDocumentoSoggetto) {
                    scanAllegato(event, selectedDocumentoSoggetto)
                } else {
                    throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Seleziona_Documento_Errore"))
                }
            }

        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    private void scanAllegato(ScanEvent event, AnaDocumento documento) {
        String nomeAllegato = event.filename
        byte[] fileContent = event.inputStream.bytes
        Map<String, String> etichettaErrore = FileUtils.checkFile(fileContent, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (etichettaErrore) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(etichettaErrore))
            return
        }
        salvaAllegato(documento, nomeAllegato, fileContent)
    }

    @Command
    void onUploadAllegato(@ContextParam(ContextType.TRIGGER_EVENT) UploadEvent event, @BindingParam("tipologia") String tipologia) {
        if (tipologia.equals('CDF')) {
            if (selectedDocumentoCDF) {
                uploadAllegato(event, selectedDocumentoCDF)
            } else {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Seleziona_Documento_Errore"))
            }
        } else { //standard
            if (selectedDocumentoSoggetto) {
                uploadAllegato(event, selectedDocumentoSoggetto)
            } else {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Seleziona_Documento_Errore"))
            }
        }
    }

    private void uploadAllegato(UploadEvent event, AnaDocumento documento) {
        Media media = event.media
        byte[] fileContent = media.isBinary() ? media.byteData : media.stringData.getBytes(StandardCharsets.UTF_8.name())
        Map<String, String> etichettaErrore = FileUtils.checkFile(fileContent, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (etichettaErrore) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(etichettaErrore))
            return
        }

        salvaAllegato(documento, media.name, fileContent)

    }

    private void salvaAllegato(AnaDocumento documento, String nomeAllegato, byte[] contenutoAllegato) {
        AnaDocumentoAllegato allegato = anaDocumentoAllegatoService.create(documento, nomeAllegato)
        anaDocumentoAllegatoService.save(allegato)

        try {
            EModelloGdm modello = anaTipoDocumentoService.getModelloGdm(documento.tipoDocumento)

            anaDocumentoAllegatoService.saveAllegatoDocumentale(modello, allegato, contenutoAllegato)

        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)

            anaDocumentoAllegatoService.saveAllegatoLocale(allegato, contenutoAllegato)

            throw dre
        } catch (Exception ex) {
            log.error(ex.message, ex)

            anaDocumentoAllegatoService.delete(allegato)

            throw ex
        }

        refreshUi()
    }

    @Command
    void onDownloadAllegati(@BindingParam("tipologia") String tipologia) {
        if (tipologia.equals('CDF')) {
            if (selectedDocumentoCDF) {
                anaDocumentoService.downloadAllegati(selectedDocumentoCDF)
            } else {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Seleziona_Documento_Errore"))
            }
        } else { //standard
            if (selectedDocumentoSoggetto) {
                anaDocumentoService.downloadAllegati(selectedDocumentoSoggetto)
            } else {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Seleziona_Documento_Errore"))
            }
        }
    }

    @Command
    void onDownloadAllegato(@BindingParam("allegato") AnaDocumentoAllegato allegato) {
        anaDocumentoAllegatoService.downloadAllegato(allegato)
    }

    @Command
    void onEliminaAllegato(@BindingParam("allegato") AnaDocumentoAllegato allegato) {
        String tipologia = allegato.documento == selectedDocumentoSoggetto ? "SOGG" : "CDF"
        Messagebox.show(allegato.nome + ":\n" + getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Allegato")), " ", Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                { Event e ->
                    if (Messagebox.ON_OK.equals(e.getName())) {
                        anaDocumentoAllegatoService.delete(allegato)
                        if (tipologia.equals('CDF')) {
                            selectedDocumentoCDF?.allegati = anaDocumentoAllegatoService.listAllByDocumento(selectedDocumentoCDF)
                        } else {
                            selectedDocumentoSoggetto?.allegati = anaDocumentoAllegatoService.listAllByDocumento(selectedDocumentoSoggetto)
                        }
                        refreshUi()
                    }
                } as EventListener
        )
        refreshUi()
    }

    @Command
    void onInserisciRecapito() {
        AnaRecapito recapito = new AnaRecapito()
        recapito.anagrafe = soggetto
        soggetto.recapiti.add(recapito)
        refreshUi()
    }

    @Command
    void onEliminaRecapito(@BindingParam("recapito") AnaRecapito recapito) {
        soggetto.recapiti.remove(recapito)
        recapito.anagrafe = null
        refreshUi()
    }

    @Command
    void onChangeTipoRecapito(@BindingParam("recapito") AnaRecapito recapito) {
        if (!recapito.tipoRecapito.flagNumeroTelefonico) {
            recapito.numeroTelefonico = null
        }
        if (!recapito.tipoRecapito.flagIndirizzo) {
            recapito.indirizzo = null
        }
        if (!recapito.tipoRecapito.flagComune) {
            riempiComune(recapito.comuneRecapito, null)
        }
        refreshUi()
    }

    @Command
    void onInserisciUrna() {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneUrna.zul", self, [id: null, matricola: soggetto.matricola])
        w.addEventListener(Events.ON_CLOSE, { event ->
            soggetto.urneCinerarie = anaAnagrafeService.getUrneCinerarie(soggetto)
            refreshUi()
        })
        w.doModal()

    }

    @Command
    void onModificaUrna(@BindingParam("urna") AnaUrnaCineraria urna) {
        Window w = (Window) Executions.createComponents("/restrict/anagrafe/pratiche/gestioneUrna.zul", self, [id: urna.id])
        w.addEventListener(Events.ON_CLOSE, { event ->
            soggetto.urneCinerarie = anaAnagrafeService.getUrneCinerarie(soggetto)
            refreshUi()
        })
        w.doModal()

    }

    @Command
    void onEliminaUrna(@BindingParam("urna") AnaUrnaCineraria urna) {
        Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), " ", Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                { Event e ->
                    if (Messagebox.ON_OK.equals(e.getName())) {
                        anaUrnaCinerariaService.delete(urna)
                        soggetto.urneCinerarie = anaAnagrafeService.getUrneCinerarie(soggetto)
                        affidamentoUrneCinerarie = (soggetto.urneCinerarie && !soggetto.urneCinerarie.isEmpty()) ? ETipoSiNo.SI : ETipoSiNo.NO
                        refreshUi()
                    }
                } as EventListener
        )

    }

    // CONTROLLI OBBLIGATORIETA'
    void checkDatiObbligatoriIndividuo() {
        checkDatiIndividuo()
        checkDatiProvvedimento()
        checkConvivenzaDiFatto()
        checkRecapiti()
    }

    void salvaIndividuo() {
        salvaRecapiti()
        salvaCdF()
        salvaSoggetto()
        salvaProvvedimento()
        salvaDocumenti()
    }

    private void checkDatiIndividuo() {
        String sezione = "Individuo"
        if ((soggetto.cognome == null && !soggetto.senzaCognome) || (soggetto.nome == null && !soggetto.senzaNome) ||
                soggetto.sesso == null || soggetto.statoCivile == null || soggetto.nazionalita == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }

        checkCognomeNomeTroppoLunghiSoggetto(soggetto, "Cognome/Nome")
        checkCfTroppoLungoSoggetto(soggetto, "Codice Fiscale")
        checkCognomeNomeTroppoLunghiSoggetto(soggetto.madre, "Cognome/Nome Madre")
        checkCognomeNomeTroppoLunghiSoggetto(soggetto.padre, "Cognome/Nome Padre")

        sezione = "Nascita"
        if (soggetto.dataNascita == null || soggetto.comuneNascita.codice == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
        checkDatiAtto(soggetto.attoNascita, soggetto.comuneAttoNascita, ETipoAtto.NAS, "Atto di ${sezione}")
        checkDatiAtto(soggetto.attoNascitaTrascritto, null, ETipoAtto.NAS, "Atto di ${sezione} Trascritto", Boolean.TRUE)

        if (soggetto.statoCivile.hasConiugeContraente()) {
            sezione = soggetto.statoCivile.isUnioneCivile() ? "Unione_Civile" : "Matrimonio"
            if ((soggetto.coniuge.cognome == null && !soggetto.coniuge.senzaCognome) ||
                    (soggetto.coniuge.nome == null && !soggetto.coniuge.senzaNome) ||
                    soggetto.dataMatrimonio == null || soggetto.comuneMatrimonio.codice == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
            checkCognomeNomeTroppoLunghiSoggetto(soggetto.coniuge.anagrafe, "Cognome/Nome Coniuge")
            checkDatiAtto(soggetto.attoMatrimonio, soggetto.comuneAttoMatrimonio, ETipoAtto.MAT, "Atto di ${sezione}")
            checkDatiAtto(soggetto.attoMatrimonioTrascritto, null, ETipoAtto.MAT, "Atto di ${sezione} Trascritto", Boolean.TRUE)
        }

        if (soggetto.statoCivile.isVedovo()) {
            sezione = "Vedovanza"
            if (soggetto.dataVedovanza == null || soggetto.comuneVedovanza.codice == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
            checkDatiAtto(soggetto.attoVedovanza, soggetto.comuneAttoVedovanza, ETipoAtto.MOR, "Atto di ${sezione}")

        }

        if (soggetto.statoCivile.isDivorzioScioglimento()) {
            sezione = soggetto.statoCivile.isUnioneCivile() ? "Scioglimento" : "Divorzio"
            if (soggetto.dataDivorzio == null || soggetto.comuneDivorzio.codice == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
            checkDatiAtto(soggetto.attoDivorzio, soggetto.comuneAttoDivorzio, ETipoAtto.MAT, "Atto di ${sezione}")

        }

        sezione = "Altri Dati - Rapporto Parentela"
        if (soggetto.rapportoParentela == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
    }

    void checkCognomeNomeTroppoLunghiSoggetto(AnaAnagrafe soggetto, String campoSoggetto){
        if ( ( (soggetto?.cognome?.length()?:0) + (soggetto?.nome?.length()?:0) ) >= 100 ){
            throw new ErroreLunghezzaCampiRuntimeException(campoSoggetto)
        }
    }

    void checkCfTroppoLungoSoggetto(AnaAnagrafe soggetto, String campoSoggetto){
        if ( (soggetto.codiceFiscale?.length()?:0) > 16 ){
            throw new ErroreLunghezzaCampiRuntimeException(campoSoggetto)
        }
    }

    private void checkDatiAtto(EstremiAtto estremiAtto, Comune comune, ETipoAtto tipoAtto, String atto, Boolean assenzaComune = Boolean.FALSE) {

        DatiValidazioneEstremi dve = new DatiValidazioneEstremi(tipoAtto,
                estremiAtto,
                true,
                false)

        if (assenzaComune && ValidationUtils.estremiAttoFill(dve)) {
            ValidationUtils.validaEstremiAtto(dve, atto)
        } else {

            DatiValidazioneComune dvc = new DatiValidazioneComune(comune?.codice,
                    comune?.codiceProvincia,
                    true)

            //Controllo la presenza sia degli estremi che del comune o l'assenza di entrambi
            boolean campiFilled = ValidationUtils.validaEstremiAttoEComune(dve, dvc, atto)

            if (campiFilled) {
                ValidationUtils.validaEstremiAtto(dve, atto)
                ValidationUtils.validaEstremiAttoComune(dvc, atto)
            }

        }
    }

    void salvaProvvedimento() {
        if(provvedimento.equals(ETipoSiNo.SI)) {
            if(provvedimentoDivorzio.id == null) {
                provvedimentoDivorzio.id = gsdService.getIntegerIdFromSequence(provvedimentoDivorzio, provvedimentoDivorzio.getTableName())
            }

            anaDettaglioProvvedimentoService.saveOrUpdate(provvedimentoDivorzio)
        } else {
            provvedimentoDivorzio = null
        }
    }

    void checkDatiProvvedimento() {
        if(provvedimento.equals(ETipoSiNo.SI)) {
            String sezione = "Provvedimento Divorzio"
            if (provvedimentoDivorzio.tipo == null || provvedimentoDivorzio.motivo == null ||
                    provvedimentoDivorzio.numeroDecreto == null || provvedimentoDivorzio.dataDecreto == null ||
                    provvedimentoDivorzio.ente == null || provvedimentoDivorzio.comuneEnte.codice == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
        }

    }

    void salvaCdF() {
        if (convivenzaDiFatto.equals(ETipoSiNo.SI)) {
            if (soggetto.convivenzaDiFatto.id == null) {
                soggetto.convivenzaDiFatto.id = gsdService.getIntegerIdFromSequence(soggetto.convivenzaDiFatto, soggetto.convivenzaDiFatto.getTableName())
                soggetto.convivenzaDiFatto.matricola = soggetto.matricola
            }

            if (soggetto.convivenzaDiFatto?.convivente) { // il convivente è in anagrafe
                //Leggo da DB l'eventuale CdF
                soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto = anaConvivenzaDiFattoService.getCdF(soggetto.convivenzaDiFatto.convivente.id, soggetto.cognome, soggetto.nome)

                if (soggetto.convivenzaDiFatto.convivente?.convivenzaDiFatto) {
                    // il convivente possiede una CdF
                    //Nel caso in cui non ci fosse il soggetto associato lo associo
                    if (soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto.convivente == null) {
                        soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto.convivente = soggetto
                        anaConvivenzaDiFattoService.saveOrUpdate(soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto)
                    }
                    confrontaCdF(soggetto.convivenzaDiFatto, soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto)
                } else {
                    // il convivente NON possiede una CdF
                    if (soggetto.convivenzaDiFatto.codCdf == null) {
                        soggetto.convivenzaDiFatto.codCdf = gsdService.getCodCdf()
                        soggetto.convivenzaDiFatto.sequenza = 1
                    }
                    // creo CdF anche per convivente
                    soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto = new AnaConvivenzaDiFatto()
                    soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto.id = gsdService.getIntegerIdFromSequence(soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto, soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto.getTableName())
                    soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto.matricola = soggetto.convivenzaDiFatto.convivente.matricola
                    soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto.sequenza = 2
                    // inserisco il soggetto corrente come convivente
                    copiaCdf(soggetto.convivenzaDiFatto, soggetto, soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto)
                    //salvo la CdF appena creata
                    anaConvivenzaDiFattoService.saveOrUpdate(soggetto.convivenzaDiFatto.convivente.convivenzaDiFatto)
                    anaConvivenzaDiFattoService.saveOrUpdate(soggetto.convivenzaDiFatto)
                }

            } else {
                //Il convivente non è in anagrafe quindi mi genero solo il nuovo codice
                if (soggetto.convivenzaDiFatto.codCdf == null) {
                    soggetto.convivenzaDiFatto.codCdf = gsdService.getCodCdf()
                    soggetto.convivenzaDiFatto.sequenza = 1
                }
                anaConvivenzaDiFattoService.saveOrUpdate(soggetto.convivenzaDiFatto)
            }

        } else {
            soggetto.convivenzaDiFatto = null
        }
    }

    void checkConvivenzaDiFatto() {
        if (convivenzaDiFatto.equals(ETipoSiNo.SI)) {
            String sezione = "Convivenza di fatto"
            if ((soggetto.convivenzaDiFatto.cognomeConvivente == null && !soggetto.convivenzaDiFatto.senzaCognomeConvivente) ||
                    (soggetto.convivenzaDiFatto.nomeConvivente == null && !soggetto.convivenzaDiFatto.senzaNomeConvivente) ||
                    soggetto.convivenzaDiFatto.statoConvivenza == null || soggetto.convivenzaDiFatto.dataInizio == null ||
                    soggetto.convivenzaDiFatto.comuneInizio.codice == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
        }
    }

    void confrontaCdF(AnaConvivenzaDiFatto cdfSoggetto, AnaConvivenzaDiFatto cdfConvivente) {
        if (cdfSoggetto.codCdf) { //La Cdf possiede già un codice
            if (cdfSoggetto.codCdf != cdfConvivente.codCdf) {
                //Se diverso da quello della CdF del convivente -> errore e non faccio nulla
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Codici_Cdf_Differenti")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                anaConvivenzaDiFattoService.saveOrUpdate(cdfSoggetto)
                return
            }
        } else { //La CdF non possiede un codice e quindi le associo quello della CdF del convivente
            cdfSoggetto.codCdf = cdfConvivente.codCdf
        }
        if (cdfSoggetto.sequenza == null) {
            cdfSoggetto.sequenza = 2
        }
        //controllo se ci sono differenze tra i dati persistendi della CdF del convivente e quelli inseriti a maschera
        if (cdfDifferenti(cdfSoggetto, cdfConvivente)) {
            //Se sì -> chiedo se si vogliono aggiornare i dati persistenti del convivente
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Dati_Cdf_Differenti")), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    { Event ev ->
                        if (Messagebox.ON_YES.equals(ev.getName())) {
                            copiaCdf(cdfSoggetto, soggetto, cdfConvivente)
                            anaConvivenzaDiFattoService.saveOrUpdate(cdfConvivente)
                            anaConvivenzaDiFattoService.saveOrUpdate(cdfSoggetto)
                        }
                        if (Messagebox.ON_NO.equals(ev.getName())) {
                            log.info("Si è scelto di NON copiare la CdF")
                            anaConvivenzaDiFattoService.saveOrUpdate(cdfSoggetto)
                        }
                    } as EventListener)
        } else {
            anaConvivenzaDiFattoService.saveOrUpdate(cdfSoggetto)
        }

    }

    static void copiaCdf(AnaConvivenzaDiFatto cdfDaCopiare, AnaAnagrafe soggetto, AnaConvivenzaDiFatto cdf) {

        cdf.codCdf = cdfDaCopiare.codCdf

        cdf.convivente = soggetto
        cdf.cognomeConvivente = soggetto.cognome
        cdf.senzaCognomeConvivente = soggetto.senzaCognome
        cdf.nomeConvivente = soggetto.nome
        cdf.senzaNomeConvivente = soggetto.senzaNome

        cdf.statoConvivenza = cdfDaCopiare.statoConvivenza

        cdf.dataInizio = cdfDaCopiare.dataInizio
        cdf.comuneInizio = cdfDaCopiare.comuneInizio
        cdf.praticaInizio = cdfDaCopiare.praticaInizio
        cdf.annoPraticaInizio = cdfDaCopiare.annoPraticaInizio

        cdf.dataFine = cdfDaCopiare.dataFine
        cdf.comuneFine = cdfDaCopiare.comuneFine
        cdf.praticaFine = cdfDaCopiare.praticaFine
        cdf.annoPraticaFine = cdfDaCopiare.annoPraticaFine
    }

    static boolean cdfDifferenti(AnaConvivenzaDiFatto cdf1, AnaConvivenzaDiFatto cdf2) {
        return (cdf1.statoConvivenza != cdf2.statoConvivenza ||

                cdf1.dataInizio != cdf2.dataInizio ||
                cdf1.comuneInizio != cdf2.comuneInizio ||
                cdf1.praticaInizio != cdf2.praticaInizio ||
                cdf1.annoPraticaInizio != cdf2.annoPraticaInizio ||

                cdf1.dataFine != cdf2.dataFine ||
                cdf1.comuneFine != cdf2.comuneFine ||
                cdf1.praticaFine != cdf2.praticaFine ||
                cdf1.annoPraticaFine != cdf2.annoPraticaFine)
    }

    void salvaDocumenti() {
        if (soggetto.possessoCartaCircolazione) {
            gsdService.inserisciCC(soggetto.matricola)
        } else {
            gsdService.annullaCC(soggetto.matricola)
        }
        if (soggetto.possessoPatente) {
            gsdService.inserisciPatente(soggetto.matricola)
        } else {
            gsdService.annullaPatente(soggetto.matricola)
        }
    }

    void salvaRecapiti() {
        for (AnaRecapito r : soggetto.recapiti) {
            if (r.id == null) {
                r.id = gsdService.getIntegerIdFromSequence(r, r.getTableName())
            }
            r.terminalista = cerTerminalistaService.getTerminalistaUtente()
        }
    }

    void checkRecapiti() {
        String sezione = "Recapiti"
        for (AnaRecapito r : soggetto.recapiti) {
            if (r.tipoRecapito == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
            if ((r.tipoRecapito.flagNumeroTelefonico && r.numeroTelefonico == null) ||
                    (r.tipoRecapito.flagIndirizzo && r.indirizzo == null) ||
                    (r.tipoRecapito.flagComune && r.comuneRecapito.codice == null)) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), "${sezione} - ${r.tipoRecapito.descrizione}")
            }
        }
    }

    void salvaSoggetto() {
        soggetto.sequenzaParentela = soggetto.rapportoParentela.sequenza
        soggetto.codRp = soggetto.rapportoParentela.codiceRapportoParentela
        soggetto.codProf = soggetto.professione?.codice

        anaAnagrafeService.saveOrUpdate(soggetto)
    }


}