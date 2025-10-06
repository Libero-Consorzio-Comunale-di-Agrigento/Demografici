package it.finmatica.de4gsdzk.ansc

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import groovy.json.JsonOutput
import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.competenze.CompetenzeRuntimeException
import it.finmatica.de4gsdzk.errors.AnscClientUnmanagedStatusException
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.EmptyReportException
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.json.JSONObject
import org.json.XML
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

import javax.net.ssl.SSLHandshakeException

@Slf4j
@Transactional
@Service
class AnscComunicazioneService {

    private final StatoCivileService statoCivileService

    private final CompetenzaService competenzaService

    private final CivAttoService civAttoService

    private final CivTestoLiberoService civTestoLiberoService

    private final AnscJsonService anscJsonService

    private final AnscParametroService anscParametroService

    private final LogsService logsService

    private final CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService

    private final CivFirmatarioAttoService civFirmatarioAttoService

    private final AnscEndPointServizioAllegatoService anscEndPointServizioAllegatoService

    private final AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    private final AnscNotificaService anscNotificaService

    private final CivAnnotazioneAttoService civAnnotazioneAttoService

    private final AnscCodificaErroreService anscCodificaErroreService

    private final AnscComunicazioneRepository anscComunicazioneRepository

    private final AnscComunicazioneAttoRepository anscComunicazioneAttoRepository

    private final AnscComunicazioneAnnotazioneRepository anscComunicazioneAnnotazioneRepository

    private final AnscComunicazioneFirmatarioRepository anscComunicazioneFirmatarioRepository

    private final AnscComunicazioneAllegatoRepository anscComunicazioneAllegatoRepository

    AnscComunicazioneService(AnscComunicazioneRepository anscComunicazioneRepository, AnscComunicazioneAttoRepository anscComunicazioneAttoRepository,
                             AnscComunicazioneAnnotazioneRepository anscComunicazioneAnnotazioneRepository, AnscComunicazioneFirmatarioRepository anscComunicazioneFirmatarioRepository,
                             AnscComunicazioneAllegatoRepository anscComunicazioneAllegatoRepository, CivTestoLiberoService civTestoLiberoService,
                             StatoCivileService statoCivileService, CompetenzaService competenzaService, CivAttoService civAttoService,
                             LogsService logsService, AnscParametroService anscParametroService, CivAnnotazioneAttoService civAnnotazioneAttoService,
                             CivFascicoloAttoAllegatoService civFascicoloAttoAllegatoService, CivFirmatarioAttoService civFirmatarioAttoService,
                             AnscEndPointServizioAllegatoService anscEndPointServizioAllegatoService,
                             AnscEndPointServizioArchivioService anscEndPointServizioArchivioService, AnscCodificaErroreService anscCodificaErroreService,
                             AnscJsonService anscJsonService, AnscNotificaService anscNotificaService) {
        this.anscComunicazioneRepository = anscComunicazioneRepository
        this.anscComunicazioneAttoRepository = anscComunicazioneAttoRepository
        this.anscComunicazioneAnnotazioneRepository = anscComunicazioneAnnotazioneRepository
        this.anscComunicazioneFirmatarioRepository = anscComunicazioneFirmatarioRepository
        this.anscComunicazioneAllegatoRepository = anscComunicazioneAllegatoRepository
        this.statoCivileService = statoCivileService
        this.competenzaService = competenzaService
        this.civTestoLiberoService = civTestoLiberoService
        this.civAttoService = civAttoService
        this.logsService = logsService
        this.civAnnotazioneAttoService = civAnnotazioneAttoService
        this.civFascicoloAttoAllegatoService = civFascicoloAttoAllegatoService
        this.civFirmatarioAttoService = civFirmatarioAttoService
        this.anscEndPointServizioAllegatoService = anscEndPointServizioAllegatoService
        this.anscEndPointServizioArchivioService = anscEndPointServizioArchivioService
        this.anscCodificaErroreService = anscCodificaErroreService
        this.anscParametroService = anscParametroService
        this.anscJsonService = anscJsonService
        this.anscNotificaService = anscNotificaService
    }

    AnscComunicazione get (Long id){
        return anscComunicazioneRepository.findById(id)
    }

    AnscComunicazione create(Long idRif, ETipoArchivioAnsc archivioRif, AnscEndPointServizio servizio){
        return new AnscComunicazione(idRif: idRif, servizio: servizio, archivioRif: archivioRif)
    }

    Boolean esisteComunicazioneByArchivioRifAndServizioAndIdRifInList(ETipoArchivioAnsc archivioRif, String idEpServizio, List<Long> idRifs){
        return anscComunicazioneRepository.esisteComunicazioneByArchivioRifAndServizioAndIdRifInList(archivioRif, idEpServizio, idRifs)
    }

    Boolean esisteComunicazioneNonInviataByArchivioRifAndServizioAndIdRifInList(ETipoArchivioAnsc archivioRif, String idEpServizio, List<Long> idRifs){
        return anscComunicazioneRepository.esisteComunicazioneByInviatoAndArchivioRifAndServizioAndIdRifInListAndHttpErrorFalse(Boolean.FALSE, archivioRif, idEpServizio, idRifs)
    }

    Boolean esisteComunicazioneInviataByArchivioRifAndServizioAndIdRifInList(ETipoArchivioAnsc archivioRif, String idEpServizio, List<Long> idRifs){
        return anscComunicazioneRepository.esisteComunicazioneByInviatoAndArchivioRifAndServizioAndIdRifInListAndHttpErrorFalse(Boolean.TRUE, archivioRif, idEpServizio, idRifs)
    }

    List<IAnscComunicazione> listAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(ETipoArchivioAnsc tipoArchivio, AnscEndPointServizio servizio, Long idRif) {
        if (tipoArchivio.equals(ETipoArchivioAnsc.ANN)){
            return anscComunicazioneAnnotazioneRepository.findAllByServizioAndIdAnnotazioneOrderByDataInvio(servizio, idRif)
        } else
        if (tipoArchivio.equals(ETipoArchivioAnsc.ALL)) {
            return anscComunicazioneAllegatoRepository.findAllByServizioAndIdAllegatoOrderByDataInvio(servizio, idRif)
        } else
        if (tipoArchivio.equals(ETipoArchivioAnsc.FIR)) {
            return anscComunicazioneFirmatarioRepository.findAllByServizioAndIdFirmatarioOrderByDataInvio(servizio, idRif)
        } else {
            return anscComunicazioneAttoRepository.findAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(tipoArchivio, servizio, idRif)
        }
    }

    Boolean isUltimaComunicazioneByArchivioRifAndServizioAndIdRifNonInviataCausaHttpError(ETipoArchivioAnsc archivioRif, AnscEndPointServizio servizio, Long idRif) {
        List<IAnscComunicazione> list = listAllByArchivioRifAndServizioAndIdRifOrderByDataInvio(archivioRif, servizio, idRif)
        if (list.isEmpty()) {
            return Boolean.FALSE
        }
        AnscComunicazione lastComunicazione = list.first().comunicazione
        return !lastComunicazione.inviato && lastComunicazione.httpError
    }

    void bloccaSeRipetizioneNonAmmessa(ETipoArchivioAnsc tipoArchivio, AnscEndPointServizio epServizio, Long idRif){
        if (!(epServizio.flagRipetizione)){
            if (esisteComunicazioneInviataByArchivioRifAndServizioAndIdRifInList(tipoArchivio, epServizio.id, [idRif])) {
                throw new AnscRuntimeException("Il servizio selezionato è già stato gestito.\nNon è consentito effettuare nuove elaborazioni")
            }
        }
    }

    String verificaSequenzaServizi(ETipoArchivioAnsc taComPrec, AnscEndPointServizio epServizioPrec, List<Long> idRifPrecs,
                                   AnscEndPointServizio epServizio,
                                   Long idCdu, String tipoDocumentoCdu, CivAttoBaseDomain atto, Boolean skip=Boolean.FALSE){
        String errMsg = ""
        // Se non ho dipendenza da altro servizio o voglio forzare l 'invio
        if ( (epServizioPrec == null) || (taComPrec == null) || skip){
            return errMsg
        }

        String errMsgServizio = "Impossibile procedere: il servizio ${epServizioPrec.descrizioneEstesa} non è stato eseguito/completato!"
        if (epServizioPrec.flagAllegati) {
            List<AnscEndPointServizioAllegato> listaAllegatiXSrvECdu = anscEndPointServizioAllegatoService.listAllByServizioAndCasoUsoOrderBySequenza(epServizioPrec, idCdu, atto.getTipoAtto(), tipoDocumentoCdu)
            for (AnscEndPointServizioAllegato a: listaAllegatiXSrvECdu){
                if (a.flagObbligatorio){
                    List<CivFascicoloAttoAllegato> listaAlleFas = (civFascicoloAttoAllegatoService.listAllByUkAttoAndTipoDocumentoFascicoloAndCheckHashOrdered(atto.idAtto, a.tipoDocumentoFascicolo, epServizioPrec.flagVerifica)?:[])
                    if (listaAlleFas.isEmpty()) {
                        errMsg = errMsgServizio
                        break
                    }
                    List<Integer> listaIdTipiAllegatoAnscGestiti = []
                    List<CivFascicoloAttoAllegato> listaAllegatiNonInviati = []
                    for (CivFascicoloAttoAllegato alle : listaAlleFas) {
                        if (esisteComunicazioneInviataByArchivioRifAndServizioAndIdRifInList(ETipoArchivioAnsc.ALL, epServizioPrec.id, [alle.id]) ) {
                            listaIdTipiAllegatoAnscGestiti.add(alle.fascicoloAtto.tipoDocumentoFascicolo.tipoAllegatoANSC.id)
                        } else {
                            // se c'è un allegato non inviato o inviato con errore, lo salvo in una lista di appoggio
                            // per verificare se c'è un allegato dello stesso tipo per lo stesso servizio inviato con successo
                            listaAllegatiNonInviati.add(alle)
                        }
                    }
                    int countAlleVerificati = 0
                    for (CivFascicoloAttoAllegato alle : listaAllegatiNonInviati) {
                        if (listaIdTipiAllegatoAnscGestiti.contains(alle.fascicoloAtto.tipoDocumentoFascicolo.tipoAllegatoANSC.id)){
                            countAlleVerificati++
                        }
                    }
                    if (countAlleVerificati != listaAllegatiNonInviati.size()){
                        errMsg = errMsgServizio
                    }
                }
            }
        } else {
            if ( (epServizio.flagOtpFirma && epServizioPrec.flagInvioMailFirma) || epServizio.flagFirmaCartacea ){
                Boolean b = civFirmatarioAttoService.existsFirmatarioELNonGestito(atto.idAtto)
                if (b){
                    errMsg = "Impossibile procedere: non è stata eseguita/completata la presa visione online del documento da parte di tutti i soggetti che hanno scelto la firma digitale!"
                }
            }
            if  ( (idRifPrecs != null) && (!(idRifPrecs.isEmpty())) && (!(esisteComunicazioneInviataByArchivioRifAndServizioAndIdRifInList(taComPrec, epServizioPrec.id, idRifPrecs))) ) {
                errMsg = errMsgServizio
            }
        }
        return errMsg
    }

    private void validaDati(ETipoArchivioAnsc taCom, AnscEndPointServizio servizio, AnscCredenziali cre){
        if (taCom == null) {
            throw new CampoMandatoryRuntimeException("- Indicare l'archivio di riferimento")
        }
        if (servizio == null){
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_servizio_ANSC)
        }
        String sub = cre.getAnscUtente()?.codiceFiscale
        if (TestoUtils.isVuoto(sub)){
            throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_abilitazione_utente)
        }
        String anscOtp = cre.anscOtp
        if (TestoUtils.isVuoto(anscOtp)){
            throw new CampoMandatoryRuntimeException("- compilare otp ANSC")
        }
    }

    private void validaComunicazioneAnnotazione (ETipoArchivioAnsc taComPrec, AnscEndPointServizio epServizioPrec, List<Long> idRifPrecs,
                                                 ETipoArchivioAnsc taCom, AnscEndPointServizio epServizio, Long idRif,
                                                 Long idCdu, String tipoDocumentoCdu, CivAttoBaseDomain atto,
                                                 AnscCredenziali cre, Boolean skipControlli=Boolean.FALSE) {
        validaDati(taCom, epServizio, cre)

        if (!([ETipoArchivioAnsc.ANN].contains(taCom))){
            throw new AnscRuntimeException("Errore in fase di invio. Archivio non ammesso per il tipo di comunicazione selezionato")
        }

        if (idRif == null){
            throw new CampoMandatoryRuntimeException("- identificativo riferimento mancante")
        }

        if (idCdu == null){
            throw new CampoMandatoryRuntimeException("- non è stato indicato il caso d'uso specifico")
        }
        // refs #67881
        if ( (atto instanceof IEntitaAnsc) && (!(atto.getFlagFirmatoUscAnsc())) ){
            throw new AnscRuntimeException("Errore in fase di invio. L'atto non risulta firmato dall'Ufficiale di Stato civile")
        }

        String msg = verificaSequenzaServizi(taComPrec, epServizioPrec, idRifPrecs, epServizio, idCdu, tipoDocumentoCdu, null, skipControlli)
        if (msg) {
            throw new AnscRuntimeException(msg)
        }

        bloccaSeRipetizioneNonAmmessa(taCom, epServizio, idRif)

        CivAnnotazioneAtto aa = civAnnotazioneAttoService.get(idRif)
        if ( (aa instanceof IEntitaAnsc) && ( (aa.getIdAttoAnsc()?:"") != "" ) && (aa.getIdAnscUseCase() != idCdu) ) {
            throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_modifica_cdu)
        }
        civAnnotazioneAttoService.updateIdAnscUseCase(idRif, idCdu)

        if ( (aa instanceof IEntitaAnsc) && ( aa.getNumeroUnico() == null) ) {
            Integer annoAnnotazione = DataUtils.getAnnoCorrente()
            Long numeroUnico = statoCivileService.getNumeroUnico(annoAnnotazione)
            civAnnotazioneAttoService.updateAnnoAnnotazioneAndNumeroUnico(idRif, annoAnnotazione, numeroUnico)
        }
    }

    private void validaComunicazioneNotifica(ETipoArchivioAnsc taCom, AnscEndPointServizio epServizio, Long idRif,
                                             AnscCredenziali cre, IRicercaNotificheAnsc ricerca) {

        validaDati(taCom, epServizio, cre)

        if (!([ETipoArchivioAnsc.NOT].contains(taCom))){
            throw new AnscRuntimeException("Errore in fase di invio. Archivio non ammesso per il tipo di comunicazione selezionato")
        }

        if ( epServizio.flagNotificaRicerca && ( (ricerca?.getDal() == null) || (ricerca?.getAl() == null) ) ){
            throw new CampoMandatoryRuntimeException("- Indicare da quale data a quale data effettuare la ricerca")
        }
        if ( (epServizio.flagNotificaConferma || epServizio.flagNotificaRifiuto) && (idRif == null) ){
            throw new CampoMandatoryRuntimeException("- identificativo riferimento mancante")
        }
        if ( (epServizio.flagNotificaConferma || epServizio.flagNotificaRifiuto) ){
            AnscNotifica n = anscNotificaService.get(idRif)
            if (n == null){
                throw new AnscRuntimeException("Errore in fase di conferma. Non è stato possibile confermare la notifica selezionata")
            }
            if (n.getStato() == EStatoFlussoNotifica.AP){
                throw new AnscRuntimeException("Operazione non consentita. La notifica è già stata approvata")
            }
            if (n.getStato() == EStatoFlussoNotifica.RI){
                throw new AnscRuntimeException("Operazione non consentita. La notifica è già stata rifiutata")
            }
        }
    }

    private void validaComunicazioneAtto(ETipoArchivioAnsc taComPrec, AnscEndPointServizio epServizioPrec, List<Long> idRifPrecs,
                                         ETipoArchivioAnsc taCom, AnscEndPointServizio epServizio, Long idRif,
                                         Long idCdu, String tipoDocumentoCdu, CivAttoBaseDomain atto,
                                         AnscCredenziali cre, Boolean skipControlli=Boolean.FALSE) {

        validaDati(taCom, epServizio, cre)

        List<ETipoArchivioAnsc> lTipiArchiviAtto = [ETipoArchivioAnsc.NAS,
                                                    ETipoArchivioAnsc.MAT,
                                                    ETipoArchivioAnsc.MOR,
                                                    ETipoArchivioAnsc.UCI,
                                                    ETipoArchivioAnsc.CIT,
                                                    ETipoArchivioAnsc.ALL,
                                                    ETipoArchivioAnsc.CER,
                                                    ETipoArchivioAnsc.FIR]

        if (!(lTipiArchiviAtto.contains(taCom))){
            throw new AnscRuntimeException("Errore in fase di invio. Archivio non ammesso per il tipo di comunicazione selezionato")
        }

        if (idRif == null){
            throw new CampoMandatoryRuntimeException("- identificativo riferimento mancante")
        }

        if (idCdu == null){
            throw new CampoMandatoryRuntimeException("- non è stato indicato il caso d'uso specifico")
        }

        if (taCom == ETipoArchivioAnsc.ALL){
            String retVal = statoCivileService.verificaAllegatoAnsc(taCom, idRif, null)
            if ( (retVal?:"") != ""){
                throw new AnscRuntimeException(retVal)
            }
        } else {
            if (!epServizio.isCertificazione()) {
                CivTestoLibero tli = civTestoLiberoService.getByUkAtto(atto.idAtto)
                if ((tli == null) || TestoUtils.isVuoto(tli?.testo)) {
                    throw new EmptyReportException(EtichetteMessaggi.Errore_testo_atto)
                }
            }
        }

        if (epServizio.flagInvioMailFirma || epServizio.flagAnnullaLinkFirma || epServizio.flagPoolingPresaVisione){
            Boolean b = civFirmatarioAttoService.isFirmatarioELNonValido(idRif)
            if (b){
                throw new AnscRuntimeException("Errore in fase di invio.\nIndirizzo e-mail NON indicato o servizio incompatibile con il tipo di firma indicato per il firmatario selezionato")
            }
        }

        if (epServizio.flagAnnullaLinkFirma || epServizio.flagPoolingPresaVisione){
            Boolean b = civFirmatarioAttoService.isFirmatarioELNonGestito(idRif)
            if (b){
                throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_Annullamento_link)
            }
        }

        /*
        if (epServizio.flagAnnullaLinkFirma){
            Boolean b = civFirmatarioAttoService.isFirmatarioStatoAnnullato(idRif)
            if (b){
                throw new AnscRuntimeException("La richiesta di annullamento presa visione per il firmatario selezionato risulta già effettuata")
            }
        }
        */

        if (epServizio.flagOtpFirma){
            Boolean b = civFirmatarioAttoService.existsFirmatarioELNonGestito(atto.idAtto)
            if (b){
                throw new AnscRuntimeException("Impossibile procedere: non è stata eseguita/completata la presa visione online del documento da parte di tutti i soggetti che hanno scelto la firma digitale!")
            }
        }

        if (epServizio.flagAttestazione){
            Boolean b = civAttoService.hasAllegatiInviatiAnsc(atto.getTipoAttoEnum(), atto.id)
            if (!b){
                throw new AnscRuntimeException("Non risultano allegati per i quali occorre effettuare l'attestazione di conformità.\nE' possibile procedere con l'invio del servizio di firma dell'ufficiale di stato civile")
            }
        }

        String msg = verificaSequenzaServizi(taComPrec, epServizioPrec, idRifPrecs, epServizio, idCdu, tipoDocumentoCdu, atto, skipControlli)
        if (msg) {
            throw new AnscRuntimeException(msg)
        }

        bloccaSeRipetizioneNonAmmessa(taCom, epServizio, idRif)

        if (epServizio.flagValidazione && (atto instanceof IAttoAnsc) && atto.flagFirmatoUscAnsc ){
            throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_invio_atto_firmato)
        }

        if ( (atto == null) || ( (atto instanceof IAttoAnsc) && ( (atto.getIdAttoAnsc()?:"") != "" ) && (atto.getIdAnscUseCase() != idCdu) ) ) {
            throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_modifica_cdu)
        }
        civAttoService.updateIdAnscUseCase(atto.getTipoAttoEnum(), atto.id, idCdu)

        EMotivoRecupero mrOld = civAttoService.getMotivoRecuperoAnsc(atto.getTipoAttoEnum(), atto.id)
        EMotivoRecupero mrNew = ((IAttoAnsc)atto).motivoRecuperoAnsc
        if (mrOld != mrNew){
            if (((IEntitaAnsc)atto).flagFirmatoUscAnsc){
                throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_invio_atto_firmato)
            } else {
                civAttoService.updateMotivoRecuperoAnsc(atto.getTipoAttoEnum(), atto.id, mrNew)
            }
        }
    }

    synchronized AnscInfoComunicazioneServizio inviaComunicazioneAnnotazione(ETipoArchivioAnsc taComPrec, AnscEndPointServizio epServizioPrec, List<Long> idRifPrecs,
                                                                ETipoArchivioAnsc taCom, AnscEndPointServizio epServizio, Long idRifAnn,
                                                                Long idCdu, String tipoDocumentoCdu, CivAttoBaseDomain atto, Long idCom, AnscCredenziali cre,
                                                                Boolean skipControlli=Boolean.FALSE, Boolean fullResponse=Boolean.FALSE) {
        if ( (atto == null) || ( (atto instanceof IAttoAnsc) && TestoUtils.isVuoto(atto.getIdAttoAnsc()) ) ) {
            throw new AnscRuntimeException("Operazione non consentita. L'atto cui l'annotazione fa riferimento non risulta inviato ad ANSC")
        }

        validaComunicazioneAnnotazione(taComPrec, epServizioPrec, idRifPrecs, taCom, epServizio, idRifAnn, idCdu, tipoDocumentoCdu, atto, cre, skipControlli)

        Integer tipoAtto = (epServizio.flagAnnotazioni?atto.getTipoAtto():null)
        AnscInfoComunicazioneServizio retCom = buildJsonAndSend(taCom, epServizio, idRifAnn, idCdu, tipoAtto, atto.id, "", idCom, cre, null, null, null, fullResponse)

        if (TestoUtils.isVuoto(retCom.getRetVal())) {
            if (epServizio.flagBeforeConsultazioneEvento){
                List<AnscEndPointServizioArchivio> listaServiziEveCons = anscEndPointServizioArchivioService.listAllByArchivioAndCasoUsoAndFlagConsultazioneEventoIsTrueOrderBySequenza(taCom, idCdu)
                for (AnscEndPointServizioArchivio sec : listaServiziEveCons) {

                    validaComunicazioneAnnotazione(null, null, null, sec.archivio, sec.servizio, idRifAnn, idCdu, tipoDocumentoCdu, atto, cre, skipControlli)
                    Integer tipoAttoConsEv = (epServizio.flagAnnotazioni?atto.getTipoAtto():null)
                    AnscInfoComunicazioneServizio retConsEve = buildJsonAndSend(sec.archivio, sec.servizio, idRifAnn, idCdu, tipoAttoConsEv, atto.id, "", null, cre, null, null, null, fullResponse)

                    if ((retConsEve.getRetVal() ?: "") != "") {
                        log.warn("Errore in consultazione evento per annotazione " + idRifAnn + " : " + retConsEve.getRetVal())
                        // non sollevo eccezione per non rischiare di bloccare la firma USC
                    }
                }
            }
        }

        return retCom
    }

    synchronized AnscInfoComunicazioneServizio inviaComunicazioneNotifica(ETipoArchivioAnsc taCom, AnscEndPointServizio epServizio, Long idRifNot,
                                                                          Long idCom, AnscCredenziali cre, IRicercaNotificheAnsc ricerca=null, IAnscPaginazione paginazione=null,
                                                                          Boolean skipControlli=Boolean.FALSE, Boolean fullResponse=Boolean.FALSE){
        if (skipControlli){
            log.warn("Controllo di sequenza servizi non presente")
        }
        // Nel caso delle notifiche devo creare una nuova comunicazione per ogni invio
        if (idCom != null){
            throw new AnscRuntimeException("Impossibile procedere con la gestione della notifica")
        }

        if (epServizio.flagAfterConsultazioneSoggetto){
            AnscEndPointServizioArchivio ssc = anscEndPointServizioArchivioService.getServizioArchivioNotificaConsultazioneSoggetto()
            if (ssc?.servizio == null) {
                throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_servizio_notifica)
            }
            validaComunicazioneNotifica(taCom, ssc.servizio, idRifNot, cre, ricerca)
            AnscInfoComunicazioneServizio retConsSogg = buildJsonAndSend(taCom, ssc.servizio, idRifNot, null, null, null, "", null, cre, ricerca, paginazione, null, fullResponse)

            if ((retConsSogg.getRetVal() ?: "") != "") {
                log.warn("Errore in consultazione soggetto per notifica " + idRifNot + " : " + retConsSogg.getRetVal())
                // non sollevo eccezione per non rischiare di bloccare la validazione
            }
        }

        validaComunicazioneNotifica(taCom, epServizio, idRifNot, cre, ricerca)

        AnscInfoComunicazioneServizio com = buildJsonAndSend(taCom, epServizio, idRifNot, null, null, null, "", null, cre, ricerca, paginazione, null, fullResponse)

        return com
    }

    synchronized AnscInfoComunicazioneServizio inviaComunicazioneAtto(ETipoArchivioAnsc taComPrec, AnscEndPointServizio epServizioPrec, List<Long> idRifPrecs,
                                                         ETipoArchivioAnsc taCom, AnscEndPointServizio epServizio, Long idRif,
                                                         Long idCdu, String tipoDocumentoCdu, CivAttoBaseDomain atto, Long idCom, AnscCredenziali cre,
                                                         Boolean skipControlli=Boolean.FALSE, Boolean fullResponse=Boolean.FALSE) {
        if (epServizio.flagAfterConsultazioneSoggetto){
            boolean lanciaConsultazione = ( ( (atto instanceof ISoggettoAttoAnsc1) && (atto.idSoggettoAnsc1 == null) ) || ( (atto instanceof ISoggettoAttoAnsc2) && (atto.idSoggettoAnsc2 == null) ) )
            if (lanciaConsultazione){
                List<AnscEndPointServizioArchivio> listaServiziSoggCons = anscEndPointServizioArchivioService.listAllByArchivioAndCasoUsoAndFlagConsultazioneSoggettoIsTrueOrderBySequenza(taCom, idCdu)
                for (AnscEndPointServizioArchivio ssc : listaServiziSoggCons) {

                    validaComunicazioneAtto(null, null, null, ssc.archivio, ssc.servizio, idRif, idCdu, tipoDocumentoCdu, atto, cre, skipControlli)
                    AnscInfoComunicazioneServizio retConsSogg = buildJsonAndSend(ssc.archivio, ssc.servizio, idRif, idCdu, atto.tipoAtto, atto.id, atto.idAtto, null, cre)

                    if ((retConsSogg.getRetVal() ?: "") != "") {
                        log.warn("Errore in consultazione soggetto per id_atto " + atto.idAtto + " : " + retConsSogg.getRetVal())
                        // non sollevo eccezione per non rischiare di bloccare la validazione
                        // throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_Consultazione_soggetto)
                    }
                }
            }
        }

        validaComunicazioneAtto(taComPrec, epServizioPrec, idRifPrecs, taCom, epServizio, idRif, idCdu, tipoDocumentoCdu, atto, cre, skipControlli)
        AnscInfoComunicazioneServizio retCom = buildJsonAndSend(taCom, epServizio, idRif, idCdu, atto.tipoAtto, atto.id, atto.idAtto, idCom, cre, null, null, null, fullResponse)

        if (TestoUtils.isVuoto(retCom.getRetVal())) {
            if (epServizio.flagBeforeConsultazioneEvento){
                List<AnscEndPointServizioArchivio> listaServiziEveCons = anscEndPointServizioArchivioService.listAllByArchivioAndCasoUsoAndFlagConsultazioneEventoIsTrueOrderBySequenza(taCom, idCdu)
                for (AnscEndPointServizioArchivio sec : listaServiziEveCons) {

                    validaComunicazioneAtto(null, null, null, sec.archivio, sec.servizio, idRif, idCdu, tipoDocumentoCdu, atto, cre, skipControlli)
                    AnscInfoComunicazioneServizio retConsEve = buildJsonAndSend(sec.archivio, sec.servizio, idRif, idCdu, atto.tipoAtto, atto.id, atto.idAtto, null, cre)

                    if ((retConsEve.getRetVal() ?: "") != "") {
                        log.warn("Errore in consultazione evento per id_atto " + atto.idAtto + " : " + retConsEve.getRetVal())
                        // non sollevo eccezione per non rischiare di bloccare la firma USC
                    }
                }
            }
            if (epServizio.flagBeforeConsultazionePresaVisione) {
                List<AnscEndPointServizioArchivio> listaServiziConsPv = anscEndPointServizioArchivioService.listAllByArchivioAndCasoUsoAndFlagPoolingPresaVisioneIsTrue(atto.getTipoArchivioAnsc(), idCdu)
                if (listaServiziConsPv.size() == 1){
                    AnscEndPointServizioArchivio scpv = listaServiziConsPv.get(0)
                    validaComunicazioneAtto(null, null, null, taCom, scpv.servizio, idRif, idCdu, tipoDocumentoCdu, atto, cre, skipControlli)
                    AnscInfoComunicazioneServizio retConsPv = buildJsonAndSend(taCom, scpv.servizio, idRif, idCdu, atto.tipoAtto, atto.id, atto.idAtto, null, cre)

                    if ((retConsPv.getRetVal() ?: "") != "") {
                        log.warn("Errore in consultazione stato presa visione per id_atto " + atto.idAtto + " : " + retConsPv.getRetVal())
                        // non sollevo eccezione per non bloccare l'invio/annullamento link
                    }
                }
            }
        }
        return retCom
    }

    synchronized AnscInfoComunicazioneServizio inviaComunicazioneGenericaSenzaCasoUso(ETipoArchivioAnsc taCom, AnscEndPointServizio epServizio, Long idRif,
                                                                                      CivAttoBaseDomain atto, AnscCredenziali cre, IRicercaEventoAnsc ricercaEvento, Boolean fullResponse = Boolean.FALSE) {

        String idAtto = epServizio.flagAnnotazioni ? '' : atto.idAtto
        AnscInfoComunicazioneServizio retCom = buildJsonAndSend(taCom, epServizio, idRif, null, atto.tipoAtto, atto.id, idAtto, null, cre, null, null, ricercaEvento, fullResponse)

        return retCom
    }

    /*
    skipControlli: consente di saltare il controllo sulla sequenzialità dei servizi
    fullResponse: consente di avere come valore di ritorno tutto il json restituito dall'invocazione del servizio ANSC
    */
    private AnscInfoComunicazioneServizio buildJsonAndSend(ETipoArchivioAnsc taCom, AnscEndPointServizio epServizio, Long idRif, Long idCdu,
                                                           Integer tipoAtto, Long pkAtto, String idAtto, Long idCom, AnscCredenziali cre,
                                                           IRicercaNotificheAnsc ricerca = null, IAnscPaginazione paginazione = null, IRicercaEventoAnsc ricercaEvento = null, Boolean fullResponse = Boolean.FALSE) {

        Long idComunicazione = (idCom != null)?idCom:statoCivileService.getIdFromSequence(null, "ANSCIU")

        LinkedHashMap<String, ?> jwsPayloadClaims
        if (epServizio.flagOtpFirma){
            jwsPayloadClaims = anscJsonService.buildJwsPayloadClaims(epServizio.id, tipoAtto, 0, null, idRif, idCdu, pkAtto, idComunicazione, cre, ricerca, paginazione, ricercaEvento)
        } else {
            jwsPayloadClaims = anscJsonService.buildJwsPayloadClaims(epServizio.id, tipoAtto, 0, null, idRif, idCdu, pkAtto, idComunicazione, null, ricerca, paginazione, ricercaEvento)
        }

        String sede = anscParametroService.get(AnscParametro.SEDE)?.valore
        String postazione = anscParametroService.get(AnscParametro.POSTAZIONE)?.valore
        if ( (sede == null) || (postazione == null)){
            throw new AnscRuntimeException("Configurazione ANSC incompleta")
        }
        LinkedHashMap<String, String> jwtPayloadClaims = ["sub": cre.getAnscUtente()?.codiceFiscale, "otp": cre.getAnscOtp(), "sede": sede, "postazione": postazione]

        LinkedHashMap<String, String> tokenMap = anscJsonService.generateTokens(jwtPayloadClaims, epServizio.flagJwsEnabled, jwsPayloadClaims)

        Gson gson = new GsonBuilder().serializeNulls().disableHtmlEscaping().create()
        String jwsPayloadClaimsString = gson.toJson(jwsPayloadClaims)

        String logOperazione = "zk - Id operazione: " + String.valueOf(idComunicazione) + " - " + cre.getAnscUtente()?.codiceFiscale
        String descrizioneServizio = epServizio.id + (epServizio.descrizione?" : " + epServizio.descrizione:"")
        if (descrizioneServizio.length()>60){
            descrizioneServizio = epServizio.descrizioneEstesa.substring(0, 59)
        }
        logsService.save(ETipoLog.ANSC, new LogAnsc(servizio: descrizioneServizio, operazione: logOperazione, note: "request", clob: jwsPayloadClaimsString, idAtto: idAtto, noteAssistenza: cre.anscOtp))
        logsService.save(ETipoLog.ANSC, new LogAnsc(servizio: descrizioneServizio, operazione: logOperazione, note: "prettyRequest", clob: JsonOutput.prettyPrint(JsonOutput.toJson(jwsPayloadClaims)), idAtto: idAtto, noteAssistenza: cre.anscOtp))

        String tokenJwt = tokenMap.get(AnscUtils.HEADER_JWT_TYPE)
        logsService.save(ETipoLog.ANSC, new LogAnsc(servizio: descrizioneServizio, operazione: logOperazione, note: "tokenJWT", clob: tokenJwt, idAtto: idAtto) )

        String tokenJws = tokenMap.get(AnscUtils.HEADER_JWS_TYPE)
        logsService.save(ETipoLog.ANSC, new LogAnsc(servizio: descrizioneServizio, operazione: logOperazione, note: "tokenJWS", clob: tokenJws, idAtto: idAtto) )

        String tokenJwsFull = tokenMap.get(AnscUtils.HEADER_JWS_FULL_TYPE)
        logsService.save(ETipoLog.ANSC, new LogAnsc(servizio: descrizioneServizio, operazione: logOperazione, note: "tokenJWSFull", clob: tokenJwsFull, idAtto: idAtto) )

        String responseXml = anscParametroService.get(AnscParametro.RESPONSE_XML)?.valore
        AnscClient anscClient = new AnscClient(jwsPayloadClaimsString)
        AnscResponse response
        try {
            response = anscClient.getResponse(epServizio?.indirizzoURL, responseXml, tokenJwt, tokenJws)
        } catch (SocketException ex){
            log.error(ex.message)
            throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_Down)
        } catch (SSLHandshakeException sslEx){
            log.error(sslEx.message)
            throw new AnscRuntimeException(EtichetteMessaggi.Errore_ANSC_Down)
        } catch (AnscClientUnmanagedStatusException ex) {
            log.error(ex.message)
            response = createUnmanagedStatusFakeResponse(ex)
        }

        logsService.save(ETipoLog.ANSC, new LogAnsc(servizio: descrizioneServizio, operazione: logOperazione, note: "jsonResponse", clob: response.stringResponse, idAtto: idAtto))

        if (responseXml) {
            logsService.save(ETipoLog.ANSC, new LogAnsc(servizio: descrizioneServizio, operazione: logOperazione, note: "xmlResponse", clob: response.xmlResponse, idAtto: idAtto))
        } else {
            logsService.save(ETipoLog.ANSC, new LogAnsc(servizio: descrizioneServizio, operazione: logOperazione, note: "prettyResponse", clob: JsonOutput.prettyPrint(response.stringResponse), idAtto: idAtto))
        }
        String retVal = statoCivileService.gestisciAnscResponse(epServizio.id, idComunicazione, taCom.name(), idRif, response.xmlResponse, cre.getAnscUtente()?.id, idAtto)
        // Errori della response da girare all'utente
        AnscInfoComunicazioneServizio infoComunicazioneServizio = new AnscInfoComunicazioneServizio(retVal, idComunicazione, response.stringResponse)
        String codiceErrore = infoComunicazioneServizio.getCodiceErrore()
        if (codiceErrore){
            AnscCodificaErrore ce = anscCodificaErroreService.getByIdAndFlagGestitoIsNull(codiceErrore)
            if (ce?.flagOtpUser && ce?.descrizione) {
                throw new AnscRuntimeException(ce)
            }
        }

        if (fullResponse){
            return infoComunicazioneServizio
        } else {
            return new AnscInfoComunicazioneServizio(retVal, idComunicazione)
        }
    }

    private AnscResponse createUnmanagedStatusFakeResponse(AnscClientUnmanagedStatusException ex) {
        Map fakeResponse = [
                root: [
                        fakeResponse   : true,
                        type           : 'unmanagedStatus',
                        testataRisposta: [
                                idEsito: 1
                        ],
                        errors         : [
                                severity: 'H',
                                text    : ex.message,
                                code    : ex.statusCode
                        ]
                ]
        ]
        String jsonResponse = JsonOutput.toJson(fakeResponse)
        JSONObject jsonObject = new JSONObject(jsonResponse)
        String xmlResponse = XML.toString(jsonObject)
        return new AnscResponse(jsonResponse, xmlResponse)
    }

    AnscComunicazione save(AnscComunicazione obj) {
        if (obj.id == null){
            obj.id = statoCivileService.getIdFromSequence(obj)
        }
        return anscComunicazioneRepository.save(obj)
    }

}
