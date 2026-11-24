package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarAttoAttributes {

	boolean annotazioniEnabled = true
	boolean caratteriSpecialiEnabled = false
	boolean anscEnabled = false


	static List<Map> etichetteCbAttoDesc = [Etichette.getEtichetta("ansc_tooltip"), Etichette.getEtichetta("annotazioni_tooltip"), Etichette.getEtichetta("caratteri_speciali_tooltip"),
											Etichette.getEtichetta("fascicolo_tooltip"), Etichette.getEtichetta("copia_conforme_tooltip"),
											Etichette.getEtichetta("comunicazioni_tooltip"), Etichette.getEtichetta("adempimenti_tooltip"), Etichette.getEtichetta("modello_istat_tooltip")]

}
