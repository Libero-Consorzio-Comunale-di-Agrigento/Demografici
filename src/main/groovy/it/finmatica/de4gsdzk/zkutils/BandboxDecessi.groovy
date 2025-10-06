package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.CivMorte
import it.finmatica.de4gsdzk.statocivile.CivMorteService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxDecessi extends CustomBandbox {

	public BandboxDecessi() {
		super()

        this.setStyle("text-transform:uppercase")
		
		attributoDaLeggere = "cognomeNomeRicerca"

		Executions.createComponents("/restrict/afc/bandboxDecessi.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

        paging.setPageSize(Paginazione.pageSize)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = CivMorte.etichetteDomain
		eList.addAll(etichetteBB)

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		errorTitle = getEtichetta(etichette, Etichette.Validazione)
		errorMsg = getEtichetta(etichette, Etichette.Dato_non_valido)
	}

	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		Map params = [activePage: paging.getActivePage(), pageSize: paging.getPageSize(),
					  stato: EStatoAtto.CONSOLIDATO, natura: ENaturaAtto.O,
					  cognomeNomeRicerca: filtro, searchEqual: searchEqual,
					  order: SortUtils.cognomeNomeDecedutoAsc]

		Page p = Holders.getApplicationContext().getBean(CivMorteService.class).list(params)
		listbox.setModel(new ListModelList<CivMorte>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
		label.value = getEtichetta(etichette, Etichette.Numero_record_trovati) + paging.totalSize
	}

}
