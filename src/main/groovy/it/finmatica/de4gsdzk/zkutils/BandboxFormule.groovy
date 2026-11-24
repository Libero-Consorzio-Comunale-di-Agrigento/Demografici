package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazioneService
import it.finmatica.de4gsdzk.utils.ETipoAnnotazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxFormule extends CustomBandbox {

	Integer tipoAtto

	List<ETipoAnnotazione> listaTipoAnnotazione

	BandboxFormule() {
		super()

		attributoDaLeggere = "descrizioneEstesa"

		Executions.createComponents("/restrict/afc/bandboxFormule.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		paging.setPageSize(Paginazione.pageSize)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = CivFormulaAnnotazione.etichetteDomain
		eList.addAll(CivAnnotazioneAtto.etichetteDomain)
		eList.addAll(etichetteBB)

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
		Map params = [tipoAtto: tipoAtto, tipiAnnotazione:listaTipoAnnotazione, filtroEsteso: b.toString(),
					  order: SortUtils.formulaAsc]

		Page p = Holders.getApplicationContext().getBean(CivFormulaAnnotazioneService.class).list(params)
		listbox.setModel(new ListModelList<CivFormulaAnnotazione>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
		label.value = getEtichetta(etichette, Etichette.getEtichetta("Numero_record_trovati")) + paging.totalSize
	}

}
