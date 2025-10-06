package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.CivNotaFormula
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxCampiAnnotazione extends CustomBandbox {

	Integer tipoAtto
	String  campoDb

	BandboxCampiAnnotazione() {
		super()

		Executions.createComponents("/restrict/afc/bandboxCampiAnnotazione.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = []
		eList.addAll(CivNotaFormula.etichetteDomain)
		eList.addAll(etichetteBB)

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		errorTitle = getEtichetta(etichette, Etichette.Validazione)
		errorMsg = getEtichetta(etichette, Etichette.Dato_non_valido)
	}

	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		StringBuilder b = new StringBuilder((filtro?:""))
		if (!(searchEqual)){
			b.insert(0,"%")
			b.append("%")
		}
		List<String> lista = Holders.getApplicationContext().getBean(StatoCivileService.class).listVariabili(CivNotaFormula.class, tipoAtto, b.toString(), campoDb)
		listbox.setModel(new ListModelList<String>(lista))
		paging.setTotalSize(lista.size())
		label.value = getEtichetta(etichette, Etichette.Numero_record_trovati) + paging.totalSize
	}

}
