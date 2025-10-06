package restrict

import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.errors.AnscRuntimeException
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.Executions
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

trait TraitInvioComunicazioneAnsc {

    abstract Window getSelf()

    abstract Map<String, String> getEtichette()

    abstract Boolean isInvioServizioDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc archivioRif, Long idRif)

    abstract void verificaSequenzaServiziERecuperaCredenziali(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu, Long idRif, Long idComunicazione, IRicercaNotificheAnsc r, IAnscPaginazione paginazione)

    abstract void inviaComunicazione(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu, AnscCredenziali cre, Long idRif, Long idComunicazione, IRicercaNotificheAnsc r, IAnscPaginazione paginazione, Boolean skip)

    Boolean isInvioServizioBaseDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc taRifCom, Long idRifDomain){
        return isInvioServizioDisabled(servizioCdu, taRifCom, idRifDomain)
    }

    Boolean isInvioServizioAllegatoDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc taRifCom, Long idAllegato){
        return isInvioServizioDisabled(servizioCdu, taRifCom, idAllegato)
    }

    Boolean isInvioServizioFirmatarioDisabled(AnscEndPointServizioArchivio servizioCdu, ETipoArchivioAnsc taRifCom, Long idFirmatario){
        return isInvioServizioDisabled(servizioCdu, taRifCom, idFirmatario)
    }

    Boolean isRipetiInvioDisabled(IAnscOggettoInvio oggettoInvio) {
        if (!oggettoInvio.ultimaComunicazione) {
            return Boolean.TRUE
        }
        return oggettoInvio.ultimaComunicazione.comunicazione.inviato ||
                (!oggettoInvio.ultimaComunicazione.comunicazione.inviato && oggettoInvio.ultimaComunicazione.comunicazione.httpError)
    }

    void recuperaCredenzialiEInviaComunicazione(AnscUtente ansUte, ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu, Long idRif,
                                                Long idComunicazione = null, IRicercaNotificheAnsc r = null, IAnscPaginazione paginazione = null, Boolean skip = Boolean.FALSE, Boolean force = Boolean.FALSE) {
        if (ansUte && servizioCdu?.servizio){
            Boolean otpValido = Boolean.FALSE
            if (ansUte.anscDataOtp != null){
                Date dateLimit = DataUtils.addMinutes(ansUte.anscDataOtp, AnscUtils.OTP_DURATION)
                otpValido = (dateLimit?.compareTo(new Date()) > 0)
            }
            // per il servizio di firma occorre inserire anche le credenziali di firma
            if ( (!(force)) && ansUte.anscOtp && otpValido && (!(servizioCdu.servizio.flagOtpFirma)) ) {
                AnscCredenziali cre = new AnscCredenziali(ansUte, ansUte.anscOtp)
                tentaInvio(taRifCom, servizioCdu, cre, idRif, idComunicazione, r, paginazione, skip)
            } else {
                Window w = (Window) Executions.createComponents("/restrict/afc/anscOtp.zul", self, [servizio:servizioCdu.servizio])
                w.addEventListener(CustomEvents.ON_SEND_ANSC_SERVICE, { event ->
                    if (event.data.credenziali instanceof AnscCredenziali) {
                        AnscCredenziali cre = (AnscCredenziali) event.data.credenziali
                        tentaInvio(taRifCom, servizioCdu, cre, idRif, idComunicazione, r, paginazione, skip)
                    }
                })
                w.doModal()
            }
        } else {
            if (!(ansUte)) {
                Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Errore_ANSC_abilitazione_utente), getEtichetta(etichette, Etichette.ANSC), Messagebox.OK, Messagebox.EXCLAMATION)
            }
            if (!(servizioCdu?.servizio)) {
                Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Compilare_servizio_ANSC), getEtichetta(etichette, Etichette.ANSC), Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    void tentaInvio(ETipoArchivioAnsc taRifCom, AnscEndPointServizioArchivio servizioCdu, AnscCredenziali cre, Long idRif,
                    Long idComunicazione = null, IRicercaNotificheAnsc r = null, IAnscPaginazione paginazione = null, Boolean skip = Boolean.FALSE) {
        try {
            inviaComunicazione(taRifCom, servizioCdu, cre, idRif, idComunicazione, r, paginazione, skip)
        } catch (AnscRuntimeException arex){
            if (arex.codificaErrore?.flagOtpUser && (!(arex.codificaErrore?.flagGestito)) ){
                recuperaCredenzialiEInviaComunicazione(cre.getAnscUtente(), taRifCom, servizioCdu, idRif, idComunicazione, r, paginazione, skip, Boolean.TRUE)
                Messagebox.show(arex.getMessage(), getEtichetta(etichette, Etichette.ANSC), Messagebox.OK, Messagebox.ERROR)
            } else {
                throw arex
            }
        }
    }

    @Command void onEseguiServizio(@BindingParam("servizioCdu") AnscEndPointServizioArchivio servizioCdu,
                                   @BindingParam("tipoArchivioComunicazione") ETipoArchivioAnsc tipoArchivioComunicazione,
                                   @BindingParam("idDomain") Long idDomain){
        verificaSequenzaServiziERecuperaCredenziali(tipoArchivioComunicazione, servizioCdu, idDomain, null, null, null)
    }

    @Command void onRipetiComunicazione(@BindingParam("comunicazione") AnscComunicazione comunicazione, @BindingParam("servizioCdu") AnscEndPointServizioArchivio servizioCdu){
        if (!(comunicazione.inviato)){
            verificaSequenzaServiziERecuperaCredenziali(comunicazione.archivioRif, servizioCdu, comunicazione.idRif, comunicazione.id, null, null)
        }
    }

    List<Map> etichetteIcomANSCDefault = [Etichette.ANSC, Etichette.Servizi_allegati, Etichette.Servizi_obbligatori, Etichette.Servizi_aggiuntivi,
                                          EtichetteMessaggi.Errore_ANSC_abilitazione_utente, EtichetteMessaggi.Compilare_servizio_ANSC]

}