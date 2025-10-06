package restrict.statocivile

import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.IEntitaAnsc
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAttoService
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.lang.NotImplementedException
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitInvioComunicazioneAnsc

@VariableResolver(DelegatingVariableResolver)
class PopupCollegaIdAnscViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitInvioComunicazioneAnsc {

    Window self

    IEntitaAnsc dettaglio
    String newIdAnsc

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @WireVariable
    AnscUtenteService anscUtenteService

    @WireVariable
    AnscComunicazioneService anscComunicazioneService

    @Init
    void init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("entitaAnsc") IEntitaAnsc entitaAnsc) {
        this.self = w

        this.dettaglio = entitaAnsc

        List<Map> eList = [Etichette.Salva, Etichette.Chiudi]
        eList.addAll(Etichette.Collega_Ansc)
        // Aggiungo etichette invio ANSC
        eList.addAll(etichetteIcomANSCDefault)
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        this.msgTitle = getEtichetta(Etichette.Collega_Ansc)

    }

    @Override
    void caricaDettaglio(Object id) {
        throw new NotImplementedException()
    }

    @Override
    void creaDettaglio(Map params) {
        throw new NotImplementedException()
    }

    @Command
    void onCancellaCampoPopup(@ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        cancellaCampo(this, p)
    }

    @Command
    void onSalva() {
        validaDati()

        effettuaConsultazioneEventoAndUpdateEntitaAnsc()
    }

    private void validaDati() {
        newIdAnsc = newIdAnsc?.trim()

        if (TestoUtils.isVuoto(newIdAnsc)) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_obbligatori)
        }

        Boolean existsAtto = civAttoService.existsIdAttoAnsc(newIdAnsc)
        if (existsAtto) {
            throw new De4gsdzkRuntimeException('Id ANSC già associato ad atto')
        }
        Boolean existsAnnotazione = civAnnotazioneAttoService.existsIdAttoAnsc(newIdAnsc)
        if (existsAnnotazione) {
            throw new De4gsdzkRuntimeException('Id ANSC già associato ad annotazione')
        }
    }

    private effettuaConsultazioneEventoAndUpdateEntitaAnsc() {
        ETipoArchivioAnsc tipoArchivioComunicazione = dettaglio.getTipoArchivioAnsc()
        Long idRif = dettaglio instanceof CivAttoBaseDomain ? ((CivAttoBaseDomain) dettaglio).getId() : ((CivAnnotazioneAtto) dettaglio).getId()

        AnscEndPointServizioArchivio servizioConsultazioneEvento = anscEndPointServizioArchivioService.getServizioConsultazioneEventoByArchivioAndCasoUsoNull(tipoArchivioComunicazione)
        verificaSequenzaServiziERecuperaCredenziali(tipoArchivioComunicazione, servizioConsultazioneEvento, idRif, null, null, null)
    }

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Override
    void verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu,
                                                     Long idRif, Long idComunicazione, IRicercaNotificheAnsc r, IAnscPaginazione paginazione) {
        AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
        recuperaCredenzialiEInviaComunicazione(ansUte, taRifCom, servizioCdu, idRif, idComunicazione, r, paginazione, Boolean.FALSE, Boolean.FALSE)
    }

    @Override
    Boolean isInvioServizioDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc archivioRif, Long idRifNot) {
        if (servizioCdu && archivioRif && idRifNot) {
            return Boolean.FALSE
        }
        return Boolean.TRUE
    }

    @Override
    void inviaComunicazione(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioArchivio, AnscCredenziali cre, Long idRif, Long idComunicazione, IRicercaNotificheAnsc r, IAnscPaginazione paginazione, Boolean skip) {
        AnscEndPointServizio servizio = servizioArchivio?.servizio
        if (taRifCom && servizio && idRif && cre) {

            CivAttoBaseDomain atto = null
            if (dettaglio instanceof CivAttoBaseDomain) {
                atto = (CivAttoBaseDomain) dettaglio
            }
            if (dettaglio instanceof CivAnnotazioneAtto) {
                CivAnnotazioneAtto annotazione = (CivAnnotazioneAtto) dettaglio
                atto = civAttoService.getAttoFromAnnotazione(annotazione.tipoAtto, annotazione.ufficio, annotazione.anno, annotazione.atto, annotazione.parte, annotazione.serie)
            }

            IRicercaEventoAnsc ricercaEvento = new IRicercaEventoAnsc() {
                @Override
                String getIdAnsc() {
                    return newIdAnsc
                }
            }

            AnscInfoComunicazioneServizio com = anscComunicazioneService.inviaComunicazioneGenericaSenzaCasoUso(taRifCom, servizio, idRif, atto, cre, ricercaEvento)
            if ((com.getRetVal() ?: "") != "") {
                Messagebox.show(servizio.descrizioneEstesa + " :\n" + com.getRetVal(), msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else {
                Events.postEvent(CustomEvents.ON_CLOSE_RELOAD, self, [:])
                onChiudi()
            }

        }

    }
}
