package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarFascicoloAttributes extends ControlBarListaAttributes {
	boolean uploadFascicoloEnabled = false
	boolean scansionaEnabled = false
	boolean importaDaProtocolloEnabled = false

	ControlBarFascicoloAttributes() {
		super()
		pagingEnabled = false
	}

	// Getters and setters per retrocompatibilita' con vecchio metodo
	boolean getBackFromListFascicoloEnabled() {
		return super.backEnabled
	}

	void setBackFromListFascicoloEnabled(boolean backFromListFascicoloEnabled) {
		super.backEnabled = backFromListFascicoloEnabled
	}

	boolean getPagingFascicoloEnabled() {
		return super.pagingEnabled
	}

	void setPagingFascicoloEnabled(boolean pagingFascicoloEnabled) {
		super.pagingEnabled = pagingFascicoloEnabled
	}

	String getAdditionalFascicoloSearchFilter() {
		return super.additionalSearchFilter
	}

	void setAdditionalFascicoloSearchFilter(String additionalFascicoloSearchFilter) {
		super.additionalSearchFilter = additionalFascicoloSearchFilter
	}

	boolean getDeleteFascicoloEnabled() {
		return super.deleteEnabled
	}

	void setDeleteFascicoloEnabled(boolean deleteFascicoloEnabled) {
		super.deleteEnabled = deleteFascicoloEnabled
	}


	static final List<Map> etichetteCbFascDesc = [Etichette.getEtichetta("back_tooltip"), Etichette.getEtichetta("carica_documento_tooltip"),
												  Etichette.getEtichetta("inserisci_tooltip"), Etichette.getEtichetta("elimina_tooltip"), Etichette.getEtichetta("Ordina_per")]

}
