package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import it.finmatica.de4gsdzk.certificazione.error.FirmatariListRuntimeException
import it.finmatica.de4gsdzk.integrazioni.ad4.UtenteCustomService
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class OtpViewModel {
    Window   self

    Map<String, String> etichette = [:]

    List<CerTerminalista> listaFirmatari
    CerTerminalista firmatario
    String otp

    Boolean recuperaOtpEnabled

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CerTerminalistaService cerTerminalistaService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private UtenteCustomService utenteCustomService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map> eList = [Etichette.Firma, Etichette.Firmatario, Etichette.Otp, Etichette.Elabora,
                           Etichette.Seleziona, Etichette.Chiudi, Etichette.Nessun_dato_disponibile]
        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_firmatario, EtichetteMessaggi.Errore_Certificazioni_utente_non_firmatario, EtichetteMessaggi.Errore_Certificazioni_nessun_firmatario])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        recuperaOtpEnabled = arcParametroService.isRecuperoOtpProtocollazioneAttivo()

        caricaDati()
    }

    void caricaDati() {
        try {
            listaFirmatari = cerTerminalistaService.listAllFirmatariOrderByCognomeNome()
            String codUtente = utenteCustomService.loggedUserId
            CerTerminalista firmatarioUtente = null
            for (CerTerminalista m : listaFirmatari) {
                if (m.id == codUtente) {
                    firmatarioUtente = m
                    break
                }
            }
            if (firmatarioUtente == null) {
                Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Errore_Certificazioni_utente_non_firmatario),
                        getEtichetta(etichette, Etichette.Otp), Messagebox.OK, Messagebox.EXCLAMATION)
                firmatario = listaFirmatari.first()
            } else {
                firmatario = firmatarioUtente
            }
        } catch (FirmatariListRuntimeException ex) {
            Messagebox.show(getEtichetta(etichette, ex.getEtichetta()) ?: ex.getMessage(),
                    getEtichetta(etichette, Etichette.Otp), Messagebox.OK, Messagebox.ERROR)
        }
        BindUtils.postNotifyChange(null, null, this, "listaFirmatari")
        BindUtils.postNotifyChange(null, null, this, "firmatario")
    }

    @Command void onSeleziona() {
        if (firmatario && otp){
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [codUtentefirmatario:firmatario.id, otp:otp] )
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(etichette, Etichette.Nessun_dato_disponibile), getEtichetta(etichette, Etichette.Otp), Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onRecuperaOtp () {
        if (firmatario){
            statoCivileService.recuperaOtp(firmatario.id)
        } else {
            Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Compilare_firmatario), getEtichetta(etichette, Etichette.Otp), Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onChiudi () {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

}
