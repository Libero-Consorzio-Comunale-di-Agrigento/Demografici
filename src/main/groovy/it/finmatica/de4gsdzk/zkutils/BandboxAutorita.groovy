package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxAutorita extends CustomBandbox {

	Integer tipoAtto
	Integer parte
	String serie
	String categoria
	Boolean showLuogo = Boolean.TRUE

	BandboxAutorita() {
		super()

		onChangePreventDefault = Boolean.TRUE

		Executions.createComponents("/restrict/afc/bandboxAutorita.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}
		setupVisibilyListHeaders()

		List<Map> eList = [Etichette.Descrizione, Etichette.Luogo]
		eList.addAll(etichetteBB)

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		errorTitle = getEtichetta(etichette, Etichette.Validazione)
		errorMsg = getEtichetta(etichette, Etichette.Dato_non_valido)
	}

	private void setupVisibilyListHeaders() {
		Iterable<Component> compListheader = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c : compListheader) {
			if (c.visibilityHandler) {
				if (c.visibilityHandler == 'LU') {
					c.visible = showLuogo == Boolean.TRUE
				}
			}
		}
	}

	void setShowLuogo(Boolean b) {
		showLuogo = b != null ? b : Boolean.TRUE
		setupVisibilyListHeaders()
	}

	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		StringBuilder b = new StringBuilder((filtro?:""))
		if (!(searchEqual)){
			b.insert(0,"%")
			b.append("%")
		}
		Map params = [parte: parte, serie: serie, categoria: categoria, filtro: b.toString()]
		List<Map<String, String>> lista = Holders.getApplicationContext().getBean(StatoCivileService.class).listAutorita(tipoAtto, params)
		listbox.setModel(new ListModelList<Map<String, String>>(lista))
		paging.setTotalSize(lista.size())
	}

}
