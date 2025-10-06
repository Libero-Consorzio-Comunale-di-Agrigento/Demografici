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

	static final List<Map> etichetteCbStampaListDesc = [Etichette.Ordina_per, Etichette.back_tooltip, Etichette.csv_export_tooltip,
														Etichette.xls_export_tooltip, Etichette.pdf_export_tooltip, Etichette.xml_export_tooltip]

}
