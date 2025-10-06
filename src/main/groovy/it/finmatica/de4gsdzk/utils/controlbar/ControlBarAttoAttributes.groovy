package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarAttoAttributes {

	boolean annotazioniEnabled = true
	boolean anscEnabled = false

	static List<Map> etichetteCbAttoDesc = [Etichette.ansc_tooltip, Etichette.annotazioni_tooltip,
											Etichette.fascicolo_tooltip, Etichette.copia_conforme_tooltip,
											Etichette.comunicazioni_tooltip, Etichette.adempimenti_tooltip, Etichette.modello_istat_tooltip]

}
