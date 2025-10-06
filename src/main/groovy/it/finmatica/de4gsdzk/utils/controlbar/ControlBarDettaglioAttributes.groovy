package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarDettaglioAttributes extends ControlBarAttributes {

	// Getters and setters per retrocompatibilità con vecchio metodo
	boolean getSaveRecordEnabled() {
		return super.saveEnabled
	}

	void setSaveRecordEnabled(boolean saveRecordEnabled) {
		super.saveEnabled = saveRecordEnabled
	}

	boolean getBackFromRecordEnabled() {
		return super.backEnabled
	}

	void setBackFromRecordEnabled(boolean backFromRecordEnabled) {
		super.backEnabled = backFromRecordEnabled
	}

	boolean getPrintRecordEnabled() {
		return super.printEnabled
	}

	void setPrintRecordEnabled(boolean printRecordEnabled) {
		super.printEnabled = printRecordEnabled
	}

	boolean getDeleteRecordEnabled() {
		return super.deleteEnabled
	}

	void setDeleteRecordEnabled(boolean deleteRecordEnabled) {
		super.deleteEnabled = deleteRecordEnabled
	}

	boolean getPrintRecordPlusEnabled() {
		return super.printPlusEnabled
	}

	void setPrintRecordPlusEnabled(boolean printRecordPlusEnabled) {
		super.printPlusEnabled = printRecordPlusEnabled
	}
	static final List<Map> etichetteCbDettaglioDesc = [Etichette.back_tooltip, Etichette.salva_tooltip, Etichette.print_tooltip, Etichette.elimina_tooltip]

}
