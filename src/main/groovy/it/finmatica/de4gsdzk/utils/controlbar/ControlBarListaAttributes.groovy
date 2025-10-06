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

	static List<Map> etichetteCbDesc = [Etichette.filtro_ricerca_placeholder, Etichette.filtro_ricerca_tooltip, Etichette.ricerca_tooltip,
										Etichette.modifica_tooltip, Etichette.inserisci_tooltip, Etichette.elimina_tooltip, Etichette.seleziona_tooltip,
										Etichette.print_tooltip, Etichette.csv_export_tooltip, Etichette.xls_export_tooltip, Etichette.filtri_extra_tooltip,
										Etichette.Ordina_per]

}
