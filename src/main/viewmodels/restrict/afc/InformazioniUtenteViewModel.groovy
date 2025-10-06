package restrict.afc

import groovy.util.logging.Slf4j
import it.finmatica.ad4.utility.UtenteService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.MessaggioUtils
import org.springframework.security.core.Authentication
import org.springframework.security.core.context.SecurityContextHolder
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zk.ui.util.Clients
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractPopupViewModel

import static it.finmatica.de4gsdzk.utils.ErorrUtils.decodeSqlExceptionMessage
import static it.finmatica.de4gsdzk.utils.ErorrUtils.getSQLException

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class InformazioniUtenteViewModel extends AbstractPopupViewModel {

	String nominativo
	String cognomeNome
	String codiceUtente

	String ruoloAccesso

	List<Map> listaPreferenze

	String vecchiaPassword
	String nuovaPassword
	String confermaPassword
	boolean passwordVerificata

	@WireVariable
	private UtenteService utenteService

	@Init init(@ContextParam(ContextType.COMPONENT) Window w) {
		self 		= w

		List<Map> eList = [Etichette.Informazioni, Etichette.Preferenze, Etichette.Cambio_Password, Etichette.Codice, Etichette.Valore, Etichette.Chiudi,
						   Etichette.Nuova_Password, Etichette.Password_Corrente, Etichette.Nuova_Password, Etichette.Conferma_Password,
						   Etichette.Password_Coincidono_tooltip, Etichette.Password_Diverse_tooltip, EtichetteMessaggi.Info_Cambio_Password]
		doInitEtichette(eList)

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication()

		nominativo  = authentication.getName()
		cognomeNome = authentication.principal.nominativoSoggetto?:""
		codiceUtente= authentication.principal.id

		ruoloAccesso = authentication.principal.authorities.join(',')

		listaPreferenze = []
	}

	@Command
	void onNuovaPasswordChanging(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
		String value = event.data

		Clients.evalJavaScript("meterUpdate('" + value + "');")

		updatePasswordVerificata(value, confermaPassword)

		refreshUi()
	}

	@Command
	void onConfermaPasswordChanging(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
		String value = event.data

		updatePasswordVerificata(nuovaPassword, value)

		refreshUi()
	}

	private void updatePasswordVerificata(String nuova, String conferma) {
		passwordVerificata = nuova.length() > 0 && nuova == conferma
	}

	@Command
	onCambiaPassword() {
		try {
			utenteService.updatePassword(vecchiaPassword, nuovaPassword, confermaPassword)
		} catch (Exception e) {
            MessaggioUtils.showMsgBox(getEtichetta(Etichette.Cambio_Password), MessaggioUtils.E, decodeSqlExceptionMessage(e.message, getSQLException(e), etichette))
            return
		}
		MessaggioUtils.showMsgBox(getEtichetta(Etichette.Cambio_Password), MessaggioUtils.I, getEtichetta(EtichetteMessaggi.Info_Cambio_Password))
	}

}
