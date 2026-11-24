package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.certificazione.CerTerminalista
import it.finmatica.de4gsdzk.certificazione.CerTerminalistaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxTerminalista extends CustomBandbox {

	BandboxTerminalista() {
		super()

		attributoDaLeggere = "cognomeNome"
		onChangePreventDefault = Boolean.TRUE

		Executions.createComponents("/restrict/afc/bandboxTerminalista.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = CerTerminalista.etichetteDomain
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

		PageRequest pr = new PageRequest(paging.activePage, paging.pageSize, new Sort(SortUtils.cognomeNomeAsc))
		Page<CerTerminalista> p = Holders.getApplicationContext().getBean(CerTerminalistaService.class).listAllByIdLikeOrCognomeNomeLike(b.toString(), pr)
		listbox.setModel(new ListModelList<CerTerminalista>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
		label.value = getEtichetta(etichette, Etichette.getEtichetta("Numero_record_trovati")) + paging.totalSize
	}

}
