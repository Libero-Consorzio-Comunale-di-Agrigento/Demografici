package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarComunicazioniAttributes extends ControlBarListaAttributes {
	boolean generaTestoComunicazioneEnabled = false
	boolean protocollaComunicazioneEnabled = false
	boolean sendAlboComunicazioneEnabled = false
	boolean goToFascicoloEnabled = false

	ControlBarComunicazioniAttributes() {
		super()
		pagingEnabled = false
		addEnabled = false
	}

	// Getters and setters per retrocompatibilità con vecchio metodo
	boolean getBackFromListComunicazioneEnabled() {
		return super.backEnabled
	}

	void setBackFromListComunicazioneEnabled(boolean backFromListComunicazioneEnabled) {
		super.backEnabled = backFromListComunicazioneEnabled
	}

	boolean getPagingComunicazioneEnabled() {
		return super.pagingEnabled
	}

	void setPagingComunicazioneEnabled(boolean pagingComunicazioneEnabled) {
		super.pagingEnabled = pagingComunicazioneEnabled
	}

	boolean getAddComunicazioneEnabled() {
		return super.addEnabled
	}

	void setAddComunicazioneEnabled(boolean addComunicazioneEnabled) {
		super.addEnabled = addComunicazioneEnabled
	}

	static final List<Map> etichetteCbComListDesc = [Etichette.back_tooltip, Etichette.inserisci_tooltip, Etichette.genera_testo_tooltip, Etichette.elimina_tooltip,
													 Etichette.invio_fascicolo_tooltip, Etichette.protocolla_tooltip, Etichette.invio_albo_tooltip,
													 Etichette.info_tooltip, Etichette.inserisci_destinatario_tooltip, Etichette.invia_pec_tooltip,
													 Etichette.inserisci_allegato_tooltip, Etichette.scarica_allegato_tooltip,
													 Etichette.Ordina_per, Etichette.salva_tooltip, Etichette.allega_copia_conforme_tooltip, Etichette.fascicolo_tooltip]
}
