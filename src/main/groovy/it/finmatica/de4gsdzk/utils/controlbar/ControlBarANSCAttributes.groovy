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
	static final List<Map> etichetteCbANSCDesc = [Etichette.getEtichetta("back_tooltip"), Etichette.getEtichetta("salva_tooltip"), Etichette.getEtichetta("firmatari_tooltip"),
												  Etichette.getEtichetta("fascicolo_tooltip"), Etichette.getEtichetta("invio_ansc_tooltip"), Etichette.getEtichetta("Inviato"),
												  Etichette.getEtichetta("inserisci_allegato_tooltip"), Etichette.getEtichetta("elimina_tooltip"),
												  Etichette.getEtichetta("scarica_allegato_tooltip"), Etichette.getEtichetta("scarica_allegato_ANSC_tooltip"), Etichette.getEtichetta("allegati_ansc_tooltip")]

}
