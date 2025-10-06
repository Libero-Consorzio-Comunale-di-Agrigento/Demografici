package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarANSCAttributes extends ControlBarListaAttributes {
	boolean goToFascicoloANSCEnabled = false
	boolean goToAllegatiANSCEnabled = true
	boolean goToFirmatariANSCEnabled = true
	boolean goToANSCEnabled = false
	boolean goToAllegatiANSCGrayed = true

	// Getters and setters per retrocompatibilita' con vecchio metodo
	boolean getBackFromListANSCEnabled() {
		return super.backEnabled
	}

	void setBackFromListANSCEnabled(boolean backFromListANSCEnabled) {
		super.backEnabled = backFromListANSCEnabled
	}

	boolean getSaveANSCEnabled() {
		return super.saveEnabled
	}

	void setSaveANSCEnabled(boolean saveANSCEnabled) {
		super.saveEnabled = saveANSCEnabled
	}
	static final List<Map> etichetteCbANSCDesc = [Etichette.back_tooltip, Etichette.salva_tooltip, Etichette.firmatari_tooltip,
												  Etichette.fascicolo_tooltip, Etichette.invio_ansc_tooltip, Etichette.Inviato,
												  Etichette.inserisci_allegato_tooltip, Etichette.elimina_tooltip,
												  Etichette.scarica_allegato_tooltip, Etichette.scarica_allegato_ANSC_tooltip, Etichette.allegati_ansc_tooltip]

}
