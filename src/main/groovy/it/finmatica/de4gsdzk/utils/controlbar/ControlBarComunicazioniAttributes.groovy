package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarComunicazioniAttributes extends ControlBarListaAttributes {
	boolean generaTestoComunicazioneEnabled = false
	boolean protocollaComunicazioneEnabled = false
	boolean sendAlboComunicazioneEnabled = false
	boolean goToFascicoloEnabled = false
	boolean goToAllegatiEnabled = false

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

	static final List<Map> etichetteCbComListDesc = [Etichette.getEtichetta("back_tooltip"), Etichette.getEtichetta("inserisci_tooltip"), Etichette.getEtichetta("genera_testo_tooltip"), Etichette.getEtichetta("elimina_tooltip"),
													 Etichette.getEtichetta("invio_fascicolo_tooltip"),Etichette.getEtichetta("invio_fascicolo_tooltip_pratica"), Etichette.getEtichetta("protocolla_tooltip"), Etichette.getEtichetta("invio_albo_tooltip"),
													 Etichette.getEtichetta("info_tooltip"), Etichette.getEtichetta("inserisci_destinatario_tooltip"), Etichette.getEtichetta("invia_pec_tooltip"),
													 Etichette.getEtichetta("inserisci_allegato_tooltip"), Etichette.getEtichetta("scarica_allegato_tooltip"), Etichette.getEtichetta("allegati_tooltip"),
													 Etichette.getEtichetta("Ordina_per"), Etichette.getEtichetta("salva_tooltip"), Etichette.getEtichetta("allega_copia_conforme_tooltip"), Etichette.getEtichetta("allega_modello_apr4_tooltip"), Etichette.getEtichetta("fascicolo_tooltip")]
}
