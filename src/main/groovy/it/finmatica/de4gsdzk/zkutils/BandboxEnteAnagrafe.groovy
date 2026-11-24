package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnte
import it.finmatica.de4gsdzk.anagrafe.pratiche.comunicazioni.AnaEnteService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxEnteAnagrafe extends CustomBandbox {

	BandboxEnteAnagrafe() {
		super()

		attributoDaLeggere = "descrizioneEstesa"

		Executions.createComponents("/restrict/afc/bandboxEnteAnagrafe.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = AnaEnte.etichetteDomain
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
		PageRequest pr = new PageRequest(paging.activePage, paging.pageSize, new Sort(SortUtils.idAsc))
		Page<AnaEnte> p = Holders.getApplicationContext().getBean(AnaEnteService.class).listAllByDescrizione(b.toString(), pr)
		Paginazione paginazione = new Paginazione(p?.getContent(), p?.getTotalElements())
		listbox.setModel(new ListModelList( (paginazione?.lista?:[]) ) )
		paging.setTotalSize( ( (int)(paginazione?.count?:0) ) )
		label.value = getEtichetta(etichette, Etichette.getEtichetta("Numero_record_trovati")) + paging.totalSize
	}

}
