package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.elettorale.EleElezioneService
import it.finmatica.de4gsdzk.elettorale.EleElezione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxElezioni extends CustomBandbox {

    BandboxElezioni() {
		super()

		setReadonly(true)
		attributoDaLeggere = "identificativo"

		Executions.createComponents("/restrict/afc/bandboxElezioni.zul", this, null)
		
		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		paging.setPageSize(Integer.MAX_VALUE)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = EleElezione.etichetteDomain
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

		PageRequest pr = new PageRequest(paging.activePage, paging.pageSize, new Sort(new Sort.Order(Sort.Direction.DESC, "data")))
        Page<EleElezione> p = Holders.getApplicationContext().getBean(EleElezioneService.class).findAll(pr)
        Paginazione paginazione = new Paginazione(p?.getContent(), p?.getTotalElements())

		listbox.setModel(new ListModelList( (paginazione?.lista?:[]) ) )
		paging.setTotalSize( ( (int)(paginazione?.count?:0) ) )
	}

}
