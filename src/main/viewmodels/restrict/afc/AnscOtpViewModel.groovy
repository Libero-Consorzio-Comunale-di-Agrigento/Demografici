package restrict.afc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.ansc.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractResizedViewModel

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnscOtpViewModel extends AbstractResizedViewModel{

    Window self

    AnscEndPointServizio servizio

    String anscOtp
    String urlOTP

    Boolean recuperaOtpEnabled

    String utenteFirmaRemota
    String pwdFirmaRemota
    String otpFirmaRemota

    String msgTitle = ""

    Map<String, String> etichette = [:]

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private AnscParametroService anscParametroService

    @WireVariable
    private AnscUtenteService anscUtenteService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("servizio") AnscEndPointServizio servizio) {
        self = w

        this.servizio = servizio

        List<Map<String, String>> eList = [Etichette.Chiudi, Etichette.Otp, Etichette.Elabora, Etichette.Recupera_Otp_Ansc]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_firmatario, EtichetteMessaggi.Compilare_Codice_OTP, EtichetteMessaggi.Ask_salvataggio_otp_ANSC,
                      EtichetteMessaggi.Compilare_campi_obbligatori, EtichetteMessaggi.Errore_ANSC_abilitazione_utente])
        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        recuperaOtpEnabled = Boolean.FALSE //((anscParametroService.get(ArcParametro.?)?.valore?:'N') == ETipoSN.S.name())

        msgTitle = getEtichetta(etichette, Etichette.Otp)

        // Parametro che attiva il pulsante per l'apertura della finestra di acquisizione dell'otp nella webapp ANSC
        urlOTP = (anscParametroService.get(AnscParametro.URL_OTP)?.valore?:"")
        AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
        if (ansUte){
            this.anscOtp = ansUte.anscOtp
        } else {
            Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Errore_ANSC_abilitazione_utente), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            chiudi()
        }
        self.addEventListener(CustomEvents.ON_SAVE_SETTINGS, new org.zkoss.zk.ui.event.EventListener() {
            void onEvent(Event event) {
                if (event.data.idUtente && event.data.consenso && event.data.servizio){
                    String idAnsUte = event.data.idUtente
                    ETipoSiNo anscConsensoMemo = event.data.consenso
                    AnscEndPointServizio srv = event.data.servizio

                    AnscUtente ute = anscUtenteService.get(idAnsUte)
                    ute.anscConsensoMemo = anscConsensoMemo
                    ute.anscOtp = (anscConsensoMemo.equals(ETipoSiNo.SI)?event.data.anscOtp:"")
                    ute.anscDataOtp = new Date()
                    AnscUtente ansUteSaved = anscUtenteService.save(ute)

                    eseguiServizio(ansUteSaved, event.data.anscOtp, srv)
                }
            }
        })

    }

    @Command onSeleziona(){
        if (anscOtp) {
            AnscUtente ansUte = anscUtenteService.getAnscUtenteCorrente()
            if (ansUte){
                Boolean otpScaduto = Boolean.TRUE
                if (ansUte.anscDataOtp != null){
                    String val = anscParametroService.get(AnscParametro.DURATA_OTP)?.valore
                    int anscOtpValidita = (val?Integer.parseInt(val):AnscUtils.OTP_DURATION)
                    Date dateLimit = DataUtils.addMinutes(ansUte.anscDataOtp, anscOtpValidita)
                    otpScaduto = (dateLimit?.compareTo(new Date()) < 0)
                }
                if ( (ansUte.anscConsensoMemo == null) || otpScaduto || ( (ansUte.anscConsensoMemo == ETipoSiNo.SI) && (ansUte.anscOtp != anscOtp) ) && (!(servizio.flagOtpFirma)) ){
                    Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Ask_salvataggio_otp_ANSC), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                            new org.zkoss.zk.ui.event.EventListener() {
                                void onEvent(Event e) {
                                    if (Messagebox.ON_YES.equals(e.getName())){
                                        Events.postEvent(CustomEvents.ON_SAVE_SETTINGS, self, [idUtente:ansUte.id, consenso:ETipoSiNo.SI, anscOtp:anscOtp, servizio:servizio])
                                    }
                                    if (Messagebox.ON_NO.equals(e.getName())){
                                        Events.postEvent(CustomEvents.ON_SAVE_SETTINGS, self, [idUtente:ansUte.id, consenso:ETipoSiNo.NO, anscOtp:anscOtp, servizio:servizio])
                                    }
                                }
                            }
                    )
                } else{
                    eseguiServizio(ansUte, anscOtp, servizio)
                }
            } else {
                Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Errore_ANSC_abilitazione_utente), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                chiudi()
            }
        } else {
            Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Compilare_Codice_OTP), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void eseguiServizio(AnscUtente ansUte, String otpUte, AnscEndPointServizio srv){
        if (srv.flagOtpFirma) {
            if (utenteFirmaRemota && pwdFirmaRemota && otpFirmaRemota) {
                AnscCredenziali cre = new AnscCredenziali(ansUte, otpUte, utenteFirmaRemota, pwdFirmaRemota, otpFirmaRemota)
                Events.sendEvent(CustomEvents.ON_SEND_ANSC_SERVICE, self, [credenziali: cre])
                chiudi()
            } else {
                Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Compilare_campi_obbligatori), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            AnscCredenziali cre = new AnscCredenziali(ansUte, otpUte)
            Events.sendEvent(CustomEvents.ON_SEND_ANSC_SERVICE, self, [credenziali: cre])
            chiudi()
        }
    }

    @Command void onChiudi () {
        chiudi()
        Events.sendEvent(CustomEvents.ON_CLOSE_RELOAD, self, [:])
    }

    void chiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }
}
