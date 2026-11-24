package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarListaAttributes extends ControlBarAttributes {

	ControlBarListaAttributes() {
		super()
		backEnabled = false
	}

	// Getters and setters per retrocompatibilità con vecchio metodo
	String getAdditionalListaToolbarbutton() {
		return additionalToolbarbutton
	}

	void setAdditionalListaToolbarbutton(String additionalListaToolbarbutton) {
		this.additionalToolbarbutton = additionalListaToolbarbutton
	}

	static List<Map> etichetteCbDesc = [Etichette.getEtichetta("filtro_ricerca_placeholder"), Etichette.getEtichetta("filtro_ricerca_tooltip"), Etichette.getEtichetta("ricerca_tooltip"),
										Etichette.getEtichetta("modifica_tooltip"), Etichette.getEtichetta("inserisci_tooltip"), Etichette.getEtichetta("elimina_tooltip"), Etichette.getEtichetta("seleziona_tooltip"),
										Etichette.getEtichetta("print_tooltip"), Etichette.getEtichetta("csv_export_tooltip"), Etichette.getEtichetta("xls_export_tooltip"), Etichette.getEtichetta("filtri_extra_tooltip"),
										Etichette.getEtichetta("Ordina_per")]

}
