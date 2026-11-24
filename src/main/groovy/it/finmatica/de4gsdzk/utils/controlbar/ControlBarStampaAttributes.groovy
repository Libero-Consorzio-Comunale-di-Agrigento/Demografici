package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarStampaAttributes extends ControlBarListaAttributes {

	boolean backFromListEnabled = false
	boolean selectStampaEnabled = false

	// Getters and setters per retrocompatibilità con vecchio metodo
	boolean getBackFromListStampaEnabled() {
		return super.backEnabled
	}

	void setBackFromListStampaEnabled(boolean backFromListStampaEnabled) {
		super.backEnabled = backFromListStampaEnabled
	}

	static final List<Map> etichetteCbStampaListDesc = [Etichette.getEtichetta("Ordina_per"), Etichette.getEtichetta("back_tooltip"), Etichette.getEtichetta("csv_export_tooltip"),
														Etichette.getEtichetta("xls_export_tooltip"), Etichette.getEtichetta("pdf_export_tooltip"), Etichette.getEtichetta("xml_export_tooltip")]

}
