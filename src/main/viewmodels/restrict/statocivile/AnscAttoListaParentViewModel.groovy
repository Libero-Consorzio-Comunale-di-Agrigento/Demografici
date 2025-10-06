package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.IAnscComunicazione
import it.finmatica.de4gsdzk.IAttoAnsc
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.errors.FileNonValidoRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarANSCAttributes
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.util.media.Media
import org.zkoss.zhtml.Filedownload
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.event.UploadEvent
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitInvioComunicazioneAnsc

import javax.persistence.criteria.JoinType
import java.nio.charset.StandardCharsets

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AnscAttoListaParentViewModel extends RiferimentiAttoListaParentViewModel implements TraitInvioComunicazioneAnsc {

    List<AnscInfoStepInvio> lista
    AnscInfoStepInvio dettaglio

    Map<ETabComunicazioniAnsc, List<AnscInfoStepInvio>> tabLista = [(ETabComunicazioniAnsc.Allegati)   : [],
                                                                    (ETabComunicazioniAnsc.Obbligatori): [],
                                                                    (ETabComunicazioniAnsc.Aggiuntivi) : []]
    SelectedTabComunicazioneAnsc selectedTab = new SelectedTabComunicazioneAnsc(new IPredicate<ETabComunicazioniAnsc>() {
        @Override
        boolean test(ETabComunicazioniAnsc tab) {
            switch (tab) {
                case ETabComunicazioniAnsc.Allegati: return tabLista[ETabComunicazioniAnsc.Allegati].size() > 0
                case ETabComunicazioniAnsc.Obbligatori: return true
                case ETabComunicazioniAnsc.Aggiuntivi: return true
            }
        }
    })

    AnscCasoUsoBaseDomain casoUso

    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]
    final List<EMotivoRecupero> listaMotivoRecupero = [null] + Arrays.asList(EMotivoRecupero.values())
    ETipoSiNo selectedForzaIdAttoAnsc = ETipoSiNo.NO

    Boolean wPreviewFascicoloOpen = Boolean.FALSE
    Boolean wPreviewAllegatiOpen = Boolean.FALSE
    Boolean wPreviewFirmatariOpen = Boolean.FALSE

    LinkedHashMap<String, AnscInfoArchivioRifIdRifs > mappaServiziArchiviIdRif = [:]

    List<CivFirmatarioAtto> listaFirmatari = []
    AnscEndPointServizioArchivio servizioPooling

    Map allegatiCounters = [obbligatori   : 0,
                            nonObbligatori: 0]

    @WireVariable
    protected AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @WireVariable
    private AnscEndPointServizioAllegatoService anscEndPointServizioAllegatoService

    @WireVariable
    private AnscComunicazioneService anscComunicazioneService

    @WireVariable
    private AnscComunicazioneAllegatoService anscComunicazioneAllegatoService

    @WireVariable
    private AnscAllegatoService anscAllegatoService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private AnscCasoUsoService anscCasoUsoService

    @WireVariable
    private CivFascicoloAttoService civFascicoloAttoService

    @WireVariable
    private CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @WireVariable
    private AnscUtenteService anscUtenteService

    @WireVariable
    private CivFirmatarioAttoService civFirmatarioAttoService

    void doInitAllAtti(List<Map<String, String>> eList, Long pkAtto, ETipoAtto tipoAttoEnum, AnscCasoUsoBaseDomain casoUso, Map<String, ?> attoParams = null) {
        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarANSCAttributes.etichetteCbANSCDesc)

        eList.addAll(AnscEndPointServizioArchivio.etichetteDomain)
        eList.addAll(AnscComunicazione.etichetteDomain)
        eList.addAll(CivFascicoloAtto.etichetteDomain)
        eList.addAll(CivFirmatarioAtto.etichetteDomain)
        eList.addAll(CivAttoBaseDomain.etichetteDomain)
        eList.addAll(CivFascicoloAttoAllegato.etichetteDomain)

        // Aggiungo etichette tipo si no
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())

        eList.addAll(ETipoFirmaAnsc.values()*.getEtichettaDesc())

        eList.addAll([Etichette.Comunicazioni, Etichette.Allegati, Etichette.Allegato,
                      Etichette.ripetizione_invio_tooltip, Etichette.info_tooltip, Etichette.Inviato])
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_cdu, EtichetteMessaggi.Errore_ANSC_servizio_verifica_presa_visione,
                      EtichetteMessaggi.Ask_Cancellazione_Fascicolo, EtichetteMessaggi.Ask_tipo_file_ANSC, EtichetteMessaggi.Ask_Sbustamento_File,
                      EtichetteMessaggi.Warn_Cambio_Caso_Uso_Allegati, EtichetteMessaggi.Warn_Caso_Uso_non_implementato_ANSC])
        // Aggiungo etichette motivo recupero
        eList.addAll(Arrays.asList(EMotivoRecupero.values())*.etichettaDesc)
        // Aggiungo etichette forzatura id atto ansc
        eList.addAll([Etichette.Forza_Id_Atto_Ansc])

        // Aggiungo etichette invio ANSC
        eList.addAll(etichetteIcomANSCDefault)
        doInit(eList, pkAtto, tipoAttoEnum, attoParams) //carica anche atto e dati provenienza

        msgTitle = getEtichetta(Etichette.ANSC)
        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()

        caricaCasoUso(casoUso)

        caricaListaFirmatari(atto)

        caricaLista()

        selectedTab.initialize()
    }

    protected Map getAttoParams(){
        return [fetch:[[campo:'tipoAttoDomain.categoriaDomain', tipo: JoinType.LEFT]]]
    }

    Boolean getCasiUsoEnabled(){
        return TestoUtils.isVuoto(((IAttoAnsc)atto).getIdAttoAnsc())
    }

    void caricaCasoUso(AnscCasoUsoBaseDomain newCasoUso) {
        if (newCasoUso == null) {

            Long idUseCase = (atto as IAttoAnsc).idAnscUseCase
            String message = idUseCase ? String.format(getEtichetta(EtichetteMessaggi.Warn_Caso_Uso_non_implementato_ANSC), String.valueOf(idUseCase)) : String.format(getEtichetta(EtichetteMessaggi.Warn_Caso_Uso_non_implementato_ANSC), '')
            Messagebox.show(message, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)

        }

        this.casoUso = newCasoUso
    }

    void caricaListaFirmatari(CivAttoBaseDomain atto){
        listaFirmatari = civFirmatarioAttoService.listAllByIdAtto(atto?.idAtto, new Sort(SortUtils.sequenzaAsc))
        refreshUi()
    }

    void caricaLista(){
        if (casoUso) {
            Paginazione p = eseguiQuery(Boolean.TRUE)
            lista = p.lista
            updateTotalSize(p.count)

            updateTabLista()

            refreshUi()
        } else {
            lista = []
            updateTotalSize(0)

            updateTabLista()

            refreshUi()
        }
    }

    private void updateTabLista() {
        tabLista[ETabComunicazioniAnsc.Allegati].clear()
        tabLista[ETabComunicazioniAnsc.Obbligatori].clear()
        tabLista[ETabComunicazioniAnsc.Aggiuntivi].clear()
        lista.each {
            AnscInfoStepInvio step = (AnscInfoStepInvio) it
            switch (step.servizioCdu.servizio.tabComunicazione) {
                case ETabComunicazioniAnsc.Allegati:
                    tabLista[ETabComunicazioniAnsc.Allegati] << step
                    break
                case ETabComunicazioniAnsc.Obbligatori:
                    tabLista[ETabComunicazioniAnsc.Obbligatori] << step
                    break
                case ETabComunicazioniAnsc.Aggiuntivi:
                    tabLista[ETabComunicazioniAnsc.Aggiuntivi] << step
                    break
            }
        }
    }

    List<AnscInfoStepInvio> getProperLista(String tabComunicazione) {
        return tabLista[ETabComunicazioniAnsc.valueOf(tabComunicazione)]
    }

    List<AnscEndPointServizioArchivio> getListaServiziCdu() {
        return anscEndPointServizioArchivioService.listAllServiziAttoNonAllegatiByAndCasoUsoAndAtto(casoUso.id, atto)
    }

    // TODO: portare la business logic su servizio dividendo l'ottenimento degli allegati R001 dall'ottenimento degli altri servizi
    Paginazione eseguiQuery(Boolean usePaging){
        log.info ("usePaging: " + usePaging)

        List<AnscInfoStepInvio> l = []
        servizioPooling = null
        // Innanzitutto recupero l'elenco dei servizi da eseguire per cdu e tipo di atto,
        // quindi, per ciascun servizio, ricerco:
        // - gli eventuali documenti da allegare (obbligatori e non),
        // - gli eventuali documenti allegati al fascicolo (inviati e non ad ANSC)
        // - le comunicazioni inviate ad ANSC per servizio e per allegato
        ETipoArchivioAnsc tipoArchivioComunicazioneAtto = ((IAttoAnsc)atto).getTipoArchivioAnsc()

        List<AnscEndPointServizioArchivio> listaServiziCdu = getListaServiziCdu()
        int sequenza = 0
        for (AnscEndPointServizioArchivio servizioCdu : listaServiziCdu){
            AnscEndPointServizio se = servizioCdu.servizio
            if (se.flagAllegati) {
                String tipoDocumentoCdu = AnscUtils.getTipoDocumentoCdu(atto, datiProvenienza)
                List<AnscEndPointServizioAllegato> listaAllegatiXSrvECdu = anscEndPointServizioAllegatoService.listAllByServizioAndCasoUsoOrderBySequenza(se, casoUso.id, atto.getTipoAtto(), tipoDocumentoCdu)
                allegatiCounters.obbligatori = listaAllegatiXSrvECdu.count { it.flagObbligatorio }
                allegatiCounters.nonObbligatori = listaAllegatiXSrvECdu.count { !it.flagObbligatorio }
                // Allegati che è possibile fascicolare
                List<AnscInfoAllegatoCdu> listaInfoAllegatiFascicolabili = []
                // Allegati inseriti nel fascicolo
                List<AnscInfoAllegatoCdu> listaInfoAllegatiFas = []
                List<Long> idRifs = null
                // Comunicazioni inviate ad ANSC associate agli allegati fascicolati
                for (AnscEndPointServizioAllegato a: listaAllegatiXSrvECdu){
                    // Se nel fascicolo non esiste alcun allegato del tipo richiesto da ANSC
                    String statoAllegatoFascicolabile = AnscInfoAllegatoCdu.STATO_DA_FASCICOLARE
                    List<CivFascicoloAttoAllegato> listaAlleFas = (civFascicoloAttoAllegatoService.listAllByUkAttoAndTipoDocumentoFascicoloAndCheckHashOrdered(atto.idAtto, a.tipoDocumentoFascicolo, se.flagVerifica)?:[])
                    if (listaAlleFas.size() > 0) {
                        idRifs = listaAlleFas*.id
                        // Se ho già inserito nel fascicolo dell'atto un documento del tipo richiesto da ANSC
                        statoAllegatoFascicolabile = AnscInfoAllegatoCdu.STATO_FASCICOLATO
                        for (CivFascicoloAttoAllegato fal : listaAlleFas) {
                            List<AnscComunicazioneAllegato> listaComAlleFas = (anscComunicazioneService.listAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(ETipoArchivioAnsc.ALL, se, fal.id) ?: [])
                            listaInfoAllegatiFas.add(new AnscInfoAllegatoCdu(servizioCdu, AnscInfoAllegatoCdu.STATO_DA_INVIARE, fal.id,
                                    fal.fascicoloAtto.tipoDocumentoFascicolo.id, fal.fascicoloAtto.tipoDocumentoFascicolo.descrizione,
                                    fal.nome, a.flagObbligatorio, listaComAlleFas, fal.flagDaAttestareAnsc, fal.flagFirmatoAttestazioneAnsc))
                        }
                    }
                    // Per i servizi di verifica non mostro gli allegati da fascicolare perché già presenti nei servizi di upload
                    if (se.flagVerifica) {
                        continue
                    }
                    listaInfoAllegatiFascicolabili.add(new AnscInfoAllegatoCdu(servizioCdu, statoAllegatoFascicolabile, null,
                            a.tipoDocumentoFascicolo.id, a.tipoDocumentoFascicolo.descrizione, '', a.flagObbligatorio, [], false, false))
                }
                List<AnscInfoAllegatoCdu> listaAllegatiAll = listaInfoAllegatiFascicolabili + listaInfoAllegatiFas
                l.add(new AnscInfoStepInvio(AnscInfoStepInvio.TIPO_ALLEGATO, (se.flagObbligatorio?++sequenza:1), servizioCdu, listaAllegatiAll))
                AnscInfoArchivioRifIdRifs m = new AnscInfoArchivioRifIdRifs(ETipoArchivioAnsc.ALL, idRifs)
                mappaServiziArchiviIdRif[se.id] = m
            } else if (se.flagInvioMailFirma || se.flagAnnullaLinkFirma || se.flagPoolingPresaVisione) {
                if (se.flagPoolingPresaVisione){
                    servizioPooling = servizioCdu
                    continue
                }
                List<AnscInfoFirmatarioCdu> listaInfoFirmatari = []
                List<AnscInfoFirmatarioCdu> listaInfoFirmatariOld = []
                List<CivFirmatarioAtto> lFirmEL = civFirmatarioAttoService.listAllByIdAttoAndTipoFirma(atto?.idAtto, ETipoFirmaAnsc.EL, new Sort(SortUtils.sequenzaAsc))
                // Verifico se ci sono dei firmatari per i quali il servizio di firma è passato da digitale a cartaceo (es per problemi in fase di invio)
                List<CivFirmatarioAtto> lFirmCA = civFirmatarioAttoService.listAllByIdAttoAndTipoFirma(atto?.idAtto, ETipoFirmaAnsc.CA, new Sort(SortUtils.sequenzaAsc))
                if (lFirmCA.size() > 0) {
                    for (CivFirmatarioAtto fc:lFirmCA){
                        List<IAnscComunicazione> listaComServizioFirmatariOld = (anscComunicazioneService.listAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(ETipoArchivioAnsc.FIR, se, fc.id) ?: [])
                        if (listaComServizioFirmatariOld.size() > 0) {
                            listaInfoFirmatariOld.add(new AnscInfoFirmatarioCdu(servizioCdu, fc.id, fc.nominativo, fc.dataNascita, fc.indirizzoMail, fc.idAnscPresaVisione, listaComServizioFirmatariOld))
                        }
                    }
                    if (listaInfoFirmatariOld.size()>0){
                        l.add(new AnscInfoStepInvio(AnscInfoStepInvio.TIPO_FIRMATARIO, (se.flagObbligatorio?++sequenza:1), servizioCdu, listaInfoFirmatariOld))
                    }
                }
                if (lFirmEL.size() > 0) {
                    List<Long> idRifsFirm = lFirmEL*.id
                    for (CivFirmatarioAtto fi:lFirmEL){
                        // Comunicazioni inviate ad ANSC associate al servizio di firma elettronica dei firmatari
                        List<IAnscComunicazione> listaComServizioFirmatari = (anscComunicazioneService.listAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(ETipoArchivioAnsc.FIR, se, fi.id) ?: [])
                        listaInfoFirmatari.add(new AnscInfoFirmatarioCdu(servizioCdu, fi.id, fi.nominativo, fi.dataNascita, fi.indirizzoMail, fi.idAnscPresaVisione, listaComServizioFirmatari))
                    }
                    l.add(new AnscInfoStepInvio(AnscInfoStepInvio.TIPO_FIRMATARIO, (se.flagObbligatorio?++sequenza:1), servizioCdu, listaInfoFirmatari))
                    AnscInfoArchivioRifIdRifs m = null
                    if (se.flagInvioMailFirma){
                        m = new AnscInfoArchivioRifIdRifs(ETipoArchivioAnsc.FIR, idRifsFirm)
                    }
                    mappaServiziArchiviIdRif[se.id] = m
                }
            } else {
                // Comunicazioni inviate ad ANSC associate al servizio
                List<IAnscComunicazione> listaComServizioAtto = (anscComunicazioneService.listAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(tipoArchivioComunicazioneAtto, se, atto.id)?:[])
                List<AnscInfoServizioCdu> listaOggettiInvio = [new AnscInfoServizioCdu(servizioCdu, tipoArchivioComunicazioneAtto, atto.id, listaComServizioAtto)]
                l.add(new AnscInfoStepInvio(AnscInfoStepInvio.TIPO_BASE, (se.flagObbligatorio?++sequenza:1), servizioCdu, listaOggettiInvio))
                AnscInfoArchivioRifIdRifs m = new AnscInfoArchivioRifIdRifs(tipoArchivioComunicazioneAtto, [atto.id])
                mappaServiziArchiviIdRif[se.id] = m
            }
        }

        return new Paginazione(l, l.size())
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    boolean getLoadOnCloseData(){
        return true
    }

    private void caricaServizio(String id){
        if (id){
            for (AnscInfoStepInvio t : lista){
                if (t.servizioCdu.servizio.id == id){
                    dettaglio = t
                    refreshDettaglio()
                    break
                }
            }
        } else {
            resetDettaglio()
        }
    }

    @Command void onCaricaCasiUso(){
        ETipoAtto tipoAttoEnum = atto.getTipoAttoEnum()
        CivCategoriaTipoAtto categoriaDomain = atto.tipoAttoDomain?.categoriaDomain
        if ( getCasiUsoEnabled() && (atto instanceof IAttoAnsc)) {
            String uri = "/restrict/statocivile/anscCasiUsoSelect.zul"
            Window w = (Window) Executions.createComponents(uri, self.parent, [tipoAttoEnum: tipoAttoEnum, categoria: categoriaDomain, tipoAttoAnsc: atto.getTipoAttoAnsc()])
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data?.casoUso instanceof AnscCasoUsoBaseDomain) {
                    AnscCasoUsoBaseDomain newCasoUso = (AnscCasoUsoBaseDomain) event.data.casoUso
                    if (casoUso.id != newCasoUso.id) {
                        Messagebox.show(getEtichetta(EtichetteMessaggi.Warn_Cambio_Caso_Uso_Allegati), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    }
                    caricaCasoUso(newCasoUso)
                    caricaLista()
                }
            })
            w.doModal()
        }
    }

    @Command
    void onForzaIdAttoAnsc() {
        if (selectedForzaIdAttoAnsc == ETipoSiNo.SI) {
            String uri = "/restrict/statocivile/popupCollegaIdAnsc.zul"
            Window w = (Window) Executions.createComponents(uri, self.parent, [entitaAnsc: atto])
            w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { e ->
                caricaAtto(atto.getTipoAttoEnum(), atto.id, getAttoParams())
                caricaCasoUsoDaAtto()
                caricaLista()
            })
            w.addEventListener(Events.ON_CLOSE, { e ->
                selectedForzaIdAttoAnsc = ETipoSiNo.NO
                refreshUi()
            })
            w.doModal()
        }
    }

    void caricaCasoUsoDaAtto() {
        AnscCasoUsoBaseDomain casoUsoAtto = anscCasoUsoService.findByAtto(atto, datiProvenienza)
        caricaCasoUso(casoUsoAtto)
    }

    Boolean isInvioServizioDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc archivioRif, Long idRif){
        AnscEndPointServizio servizio = servizioCdu?.servizio
        if ( (idRif != null) && (archivioRif == ETipoArchivioAnsc.FIR) ){
            CivFirmatarioAtto fat = civFirmatarioAttoService.get(idRif)
            if ( (fat.tipoFirma?:"") != ETipoFirmaAnsc.EL){
                return Boolean.TRUE
            }
        }
        if (servizio && anscComunicazioneService.isUltimaComunicazioneByArchivioRifAndServizioAndIdRifNonInviataCausaHttpError(archivioRif, servizio, idRif)) {
            return Boolean.TRUE
        }
        if ( (idRif != null) && servizio && (!(servizio.flagRipetizione))){
            return anscComunicazioneService.esisteComunicazioneByArchivioRifAndServizioAndIdRifInList(archivioRif, servizio.id, [idRif])
        }
        if ( (idRif != null) && servizio && (servizio.flagRipetizione)){
            return anscComunicazioneService.esisteComunicazioneNonInviataByArchivioRifAndServizioAndIdRifInList(archivioRif, servizio.id, [idRif])
        }
        return Boolean.TRUE
    }

    void verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu,
                                                     Long idRif, Long idComunicazione, IRicercaNotificheAnsc r, IAnscPaginazione paginazione) {
        AnscEndPointServizio servizioPrec = servizioCdu?.servizioPrecedente
        ETipoArchivioAnsc taRifComPrec = null
        List<Long> idRifPrecs = null
        if (servizioPrec != null) {
            AnscInfoArchivioRifIdRifs m = mappaServiziArchiviIdRif.get(servizioPrec.id)
            if (m){
                taRifComPrec = m.getTipoArchivioRif()
                idRifPrecs = m.getIdRifs()
            }
        }
        Long idCasoUso = servizioCdu?.idCasoUso
        String tipoDocumentoCdu = AnscUtils.getTipoDocumentoCdu(atto, datiProvenienza)
        String msg = anscComunicazioneService.verificaSequenzaServizi(taRifComPrec, servizioPrec, idRifPrecs, servizioCdu?.servizio, idCasoUso, tipoDocumentoCdu, atto)
        if (msg){
            Messagebox.show(msg, msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
            recuperaCredenzialiEInviaComunicazione(ansUte, taRifCom, servizioCdu, idRif, idComunicazione, r, paginazione)
        }
    }

    void inviaComunicazione(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu, AnscCredenziali cre,
                            Long idRif, Long idComunicazione, IRicercaNotificheAnsc r, IAnscPaginazione paginazione, Boolean skip){
        AnscEndPointServizio servizio = servizioCdu?.servizio
        AnscEndPointServizio servizioPrec = servizioCdu?.servizioPrecedente
        ETipoArchivioAnsc taRifComPrec = null
        List<Long> idRifPrecs = null
        if (servizioPrec != null) {
            AnscInfoArchivioRifIdRifs m = mappaServiziArchiviIdRif.get(servizioPrec.id)
            if (m){
                taRifComPrec = m.getTipoArchivioRif()
                idRifPrecs = m.getIdRifs()
            }
        }
        Long idCasoUso = servizioCdu?.idCasoUso
        if (taRifCom && servizio && idRif && cre) {
            String tipoDocumentoCdu = AnscUtils.getTipoDocumentoCdu(atto, datiProvenienza)
            AnscInfoComunicazioneServizio com = anscComunicazioneService.inviaComunicazioneAtto(taRifComPrec, servizioPrec, idRifPrecs, taRifCom, servizio, idRif, idCasoUso, tipoDocumentoCdu, atto, idComunicazione, cre, skip)
            if ((com.getRetVal() ?: "") != "") {
                Messagebox.show(servizio.descrizioneEstesa + " :\n" + com.getRetVal(), msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else {
                if (servizio.flagDownloadAllegato) {
                    onDownloadAllegatoAnsc(com.getIdComunicazione(), servizio)
                } else if (servizio.flagPoolingPresaVisione) {
                    if (civFirmatarioAttoService.isFirmatarioELStatoVisionato(idRif)){
                        Messagebox.show("Presa visione effettuata", msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                    } else
                    if (civFirmatarioAttoService.isFirmatarioELDaVisionare(idRif)){
                        Messagebox.show("Documento ancora da visionare", msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                    } else
                    if (civFirmatarioAttoService.isFirmatarioELStatoAnnullato(idRif)){
                        Messagebox.show("Il link di presa visione risulta in stato annullato", msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                    }
                }
            }
            caricaAtto(atto.getTipoAttoEnum(), atto.id, getAttoParams())
            onPagina()
            caricaServizio(servizio.id)
            Events.sendEvent(CustomEvents.ON_REFRESH_DETAILS, self, null)
        }
    }

    @Command void onDownloadAllegatoAnsc(@BindingParam("idAllegatoAnsc") Long idAllegatoAnsc, @BindingParam("servizio") AnscEndPointServizio servizio) {
        if (servizio.flagDownloadAllegato) {
            AnscAllegato anscAllegato = anscAllegatoService.get(idAllegatoAnsc)
            if (anscAllegato) {
                Filedownload.save(anscAllegato.blobAllegato, null, anscAllegato.nomeFile)
            } else {
                Messagebox.show("Errore in recupero file allegato", msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        }
    }

    @Command void onDownloadAllegatoFascicolo(@BindingParam("idAllegato") Long idAllegato) {
        if (idAllegato != null) {
            CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.get(idAllegato)
            scaricaAllegatoFascicolo(fal, true)
        }
    }

    void scaricaAllegatoFascicolo(CivFascicoloAttoAllegato fal, boolean sbusta = false, boolean segnalaSbustamento = true){
        try{
            civFascicoloAttoAllegatoService.scaricaAllegato(fal, sbusta, segnalaSbustamento)
        } catch (FileNonValidoRuntimeException fre){
            Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.CANCEL] as Messagebox.Button[]
            String[] buttonsLabel = [getEtichetta(Etichette.SI), getEtichetta(Etichette.NO), getEtichetta(Etichette.Annulla)] as String[]
            Messagebox.show(fal.nome + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Sbustamento_File), getEtichetta(Etichette.Allegati), buttons, buttonsLabel , Messagebox.QUESTION, null,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (e.getName() == Messagebox.ON_YES){
                                scaricaAllegatoFascicolo(fal, true, false)
                            }
                            if (e.getName() == Messagebox.ON_NO){
                                scaricaAllegatoFascicolo(fal, false, false)
                            }
                        }
                    }
            )
        }
    }

    ////////////////////////////////////////// FIRMATARI ///////////////////////////////////////

    @Command void onPreviewFirmatari(){
        if (wPreviewFirmatariOpen){
            return
        }
        apriPreviewFirmatari()
    }

    void apriPreviewFirmatari(){
        if (atto?.id && (!(wPreviewFirmatariOpen)) ) {
            try{
                wPreviewFirmatariOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/firmatariANSCLista.zul", self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum(), casoUso: casoUso])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    onPagina()
                    caricaListaFirmatari(atto)
                    self.setVisible(true)
                    wPreviewFirmatariOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura form firmatari atto", ex)
                wPreviewFirmatariOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    ////////////////////////////////////////// FASCICOLO ///////////////////////////////////////

    @Command void onPreviewFascicolo(){
        if (wPreviewFascicoloOpen){
            return
        }
        apriPreviewFascicolo()
    }

    void apriPreviewFascicolo(){
        if (atto?.id && (!(wPreviewFascicoloOpen)) ) {
            try{
                wPreviewFascicoloOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/fascicoloAttoLista.zul", self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum(), casoUso: casoUso])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    onPagina()
                    self.setVisible(true)
                    wPreviewFascicoloOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura form fascicolo atto", ex)
                wPreviewFascicoloOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    protected void createAndAddToFascicolo(CivTipoDocumentoFascicolo tdf, String nomeFile, InputStream b, String idServizio){
        CivFascicoloAtto fa = civFascicoloAttoService.createWhereNotExists(atto, tdf)
        CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.create(fa, nomeFile, true)

        civFascicoloAttoAllegatoService.save(fal, Boolean.TRUE, b)

        onPagina()
        caricaServizio(idServizio)
    }

    @Command void onUploadAllegatoFascicolo(@ContextParam(ContextType.TRIGGER_EVENT)UploadEvent event, @BindingParam("idTipoDocumentoFascicolo") Long idTipoDocumentoFascicolo, @BindingParam("idServizio") String idServizio) {
        Media media = event.media
        byte[] _allegato = media.isBinary()?media.byteData:media.stringData.getBytes(StandardCharsets.UTF_8.name())
        String nomeFile = media.name
        Map<String, String> m = FileUtils.checkFile(_allegato, nomeFile, FileUtils.defaultAcceptableMimeTypesXComEFas)
        if (m){
            Messagebox.show(nomeFile + ":\n" + getEtichetta(m), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            CivTipoDocumentoFascicolo tdf = civTipoDocumentoFascicoloService.get(idTipoDocumentoFascicolo)
            if (tdf.tipoAllegatoANSC != null){
                String retVal = statoCivileService.verificaAllegatoAnsc(null, null, nomeFile)
                if ( (retVal?:"") != ""){
                    Messagebox.show(retVal + ".\n" + getEtichetta(EtichetteMessaggi.Ask_tipo_file_ANSC), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                            new org.zkoss.zk.ui.event.EventListener(){
                                void onEvent(Event evt){
                                    if (Messagebox.ON_OK == evt.getName()) {
                                        createAndAddToFascicolo(tdf, nomeFile, new ByteArrayInputStream(_allegato), idServizio)
                                    }
                                }
                            }
                    )
                } else {
                    createAndAddToFascicolo(tdf, nomeFile, new ByteArrayInputStream(_allegato), idServizio)
                }
            } else {
                Messagebox.show("Errore: non è stata definito il tipo di documento (valido ai fini dell'integrazione con ANSC) al quale associare il documento che si sta allegando")
            }
        }
    }

    Boolean isCancellazioneAllegatoDisabled(String idServizio, Long idAllegato){
        if (idServizio && idAllegato){
            return anscComunicazioneAllegatoService.existsComunicazioneByIdAllegatoAndInviatoANSC(idAllegato)
        }
        return Boolean.TRUE
    }

    protected void eliminaAllegatoFascicolo(CivFascicoloAttoAllegato fal, String idServizio){
        civFascicoloAttoAllegatoService.deleteAllegato(fal)
        onPagina()
        caricaServizio(idServizio)
    }

    @Command void onEliminaAllegatoFascicolo(@BindingParam("idAllegato") Long idAllegato, @BindingParam("idServizio") String idServizio) {
        CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.get(idAllegato)
        if (fal) {
            Messagebox.show(fal.nome + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Fascicolo), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener() {
                        void onEvent(Event e) {
                            if (Messagebox.ON_OK.equals(e.getName())) {
                                eliminaAllegatoFascicolo(fal, idServizio)
                            }
                        }
                    }
            )
        }
    }

    ///////////////////////////////// ALLEGATI ANSC ///////////////////////////////////

    @Command
    void onPreviewAllegati() {
        if (wPreviewAllegatiOpen) {
            return
        }
        apriPreviewAllegati()
    }

    void apriPreviewAllegati() {
        if (atto?.id && (!(wPreviewAllegatiOpen))) {
            try {
                wPreviewAllegatiOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/allegatiANSCLista.zul", self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum(), casoUso: casoUso])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    onPagina()
                    self.setVisible(true)
                    wPreviewAllegatiOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex) {
                log.error("Errore apertura form fascicolo atto", ex)
                wPreviewAllegatiOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    ///////////////////////////////// STORICO COMUNICAZIONI ///////////////////////////////////

    @Command void onOpenStoricoComunicazioni(@BindingParam("oggettoInvio") IAnscOggettoInvio oggettoInvio) {
        Window w = (Window) Executions.createComponents("/restrict/statocivile/anscComunicazioniOggettoLista.zul", self, [oggettoInvio: oggettoInvio])
        w.addEventListener(CustomEvents.ON_SKIP_CHECK, { event ->
            openStoricoComunicazioni(oggettoInvio)
        })
        w.addEventListener(CustomEvents.ON_SKIP_HTTP_ERROR, { event ->
            openStoricoComunicazioni(oggettoInvio)
        })
        w.doModal()
    }

    void openStoricoComunicazioni(IAnscOggettoInvio oggettoInvio){
        AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
        recuperaCredenzialiEInviaComunicazione(ansUte, oggettoInvio.tipoArchivioComunicazione, oggettoInvio.servizioCdu, oggettoInvio.idDomain, null, null, null, Boolean.TRUE)
    }

    ///////////////////////////////// VERIFICA PRESA VISIONE ///////////////////////////////////

    @Command void onEseguiServizioVerificaPresaVisione(@BindingParam("idDomain") Long idDomain){
        if (servizioPooling == null){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_ANSC_servizio_verifica_presa_visione), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } else {
            onEseguiServizio(servizioPooling, ETipoArchivioAnsc.FIR, idDomain)
        }
    }

    @Command
    void onCheckAttestazioneAnsc(@BindingParam("idAllegato") Long idAllegato, @BindingParam("flag") Boolean flag){
        CivFascicoloAttoAllegato fal = civFascicoloAttoAllegatoService.get(idAllegato)
        fal.flagDaAttestareAnsc = flag
        civFascicoloAttoAllegatoService.save(fal, Boolean.FALSE, null)
        refreshUi()
    }

}
