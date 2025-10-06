package it.finmatica.de4gsdzk.utils.controlbar

import it.finmatica.de4gsdzk.utils.Etichette

class ControlBarAnnotazioniAttributes extends ControlBarListaAttributes {

	boolean backFromRecordAnnotazione = false
	boolean selectTipoOrdinamentoEnabled = false
	boolean goToComunicazioniEnabled = false

	ControlBarAnnotazioniAttributes() {
		super()
		pagingAnnotazioneEnabled = false
	}

	boolean getBackFromListAnnotazioneEnabled() {
		return super.backEnabled
	}

	void setBackFromListAnnotazioneEnabled(boolean backFromListAnnotazioneEnabled) {
		super.backEnabled = backFromListAnnotazioneEnabled
	}

	boolean getBackFromRecordAnnotazioneEnabled() {
		return this.backFromRecordAnnotazione
	}

	void setBackFromRecordAnnotazioneEnabled(boolean backFromRecordAnnotazioneEnabled) {
		this.backFromRecordAnnotazione = backFromRecordAnnotazioneEnabled
	}

	boolean getPagingAnnotazioneEnabled() {
		return super.pagingEnabled
	}

	void setPagingAnnotazioneEnabled(boolean pagingAnnotazioneEnabled) {
		super.pagingEnabled = pagingAnnotazioneEnabled
	}

	boolean getSearchAnnotazioneEnabled() {
		return super.searchEnabled
	}

	void setSearchAnnotazioneEnabled(boolean searchAnnotazioneEnabled) {
		super.searchEnabled = searchAnnotazioneEnabled
	}

	boolean getAddAnnotazioneEnabled() {
		return super.addEnabled
	}

	void setAddAnnotazioneEnabled(boolean addAnnotazioneEnabled) {
		super.addEnabled = addAnnotazioneEnabled
	}

	boolean getAddPlusAnnotazioneEnabled() {
		return super.addPlusEnabled
	}

	void setAddPlusAnnotazioneEnabled(boolean addPlusAnnotazioneEnabled) {
		super.addPlusEnabled = addPlusAnnotazioneEnabled
	}

	boolean getModifyAnnotazioneEnabled() {
		return super.modifyEnabled
	}

	void setModifyAnnotazioneEnabled(boolean modifyAnnotazioneEnabled) {
		super.modifyEnabled = modifyAnnotazioneEnabled
	}

	boolean getDeleteAnnotazioneEnabled() {
		return super.deleteEnabled
	}

	void setDeleteAnnotazioneEnabled(boolean deleteAnnotazioneEnabled) {
		super.deleteEnabled = deleteAnnotazioneEnabled
	}

	boolean getSaveRecordAnnotazioneEnabled() {
		return super.saveEnabled
	}

	void setSaveRecordAnnotazioneEnabled(boolean saveRecordAnnotazioneEnabled) {
		super.saveEnabled = saveRecordAnnotazioneEnabled
	}

	String getAdditionalListaToolbarbutton() {
		return super.additionalToolbarbutton
	}

	void setAdditionalListaToolbarbutton(String additionalListaToolbarbutton) {
		super.additionalToolbarbutton = additionalListaToolbarbutton
	}

	String getAdditionalListaToolbarbutton2() {
		return super.additionalToolbarbutton2
	}

	void setAdditionalListaToolbarbutton2(String additionalListaToolbarbutton2) {
		super.additionalToolbarbutton2 = additionalListaToolbarbutton2
	}

	String getAdditionalListaToolbarbutton3() {
		return super.additionalToolbarbutton3
	}

	void setAdditionalListaToolbarbutton3(String additionalListaToolbarbutton3) {
		super.additionalToolbarbutton3 = additionalListaToolbarbutton3
	}
	static List<Map> etichetteCbAnnListDesc = [Etichette.filtro_ricerca_placeholder, Etichette.ricerca_tooltip, Etichette.filtro_ricerca_tooltip,
											   Etichette.inserisci_tooltip, Etichette.modifica_tooltip, Etichette.back_tooltip, Etichette.comunicazioni_tooltip,
											   Etichette.Ordina_per, Etichette.salva_tooltip, Etichette.elimina_tooltip,
											   Etichette.blocca_testo_tooltip, Etichette.stampa_etichetta_tooltip]

}
