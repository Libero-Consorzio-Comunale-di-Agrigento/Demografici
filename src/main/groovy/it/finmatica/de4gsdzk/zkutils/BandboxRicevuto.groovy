package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.CivLuogoDecesso
import it.finmatica.de4gsdzk.statocivile.CivLuogoDecessoService
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxRicevuto extends CustomBandbox {

	public BandboxRicevuto() {
		super()

		onChangePreventDefault = Boolean.TRUE

		Executions.createComponents("/restrict/afc/bandboxRicevuto.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		java.lang.Iterable<Component> compList = this.queryAll("listbox listhead customlistheader");
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = CivLuogoDecesso.etichetteDomain
		eList.addAll(CustomBandbox.etichetteBB)

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		errorTitle = getEtichetta(etichette, Etichette.getEtichetta("Validazione"))
		errorMsg = getEtichetta(etichette, Etichette.getEtichetta("Dato_non_valido"))
	}
	
	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		StringBuilder b = new StringBuilder((filtro?:""))
		if (!(searchEqual)){
			b.insert(0,"%")
			b.append("%")
		}
		List<String> lista = Holders.getApplicationContext().getBean(CivLuogoDecessoService.class).listAllDistinctRicevutoDaByRicevutoDaLike(b.toString())
		listbox.setModel(new ListModelList<String>(lista))
		paging.setTotalSize(lista.size())
	}

}
