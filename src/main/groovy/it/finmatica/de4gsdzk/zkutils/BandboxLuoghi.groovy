package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.ETipoAtto
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

class BandboxLuoghi extends CustomBandbox {

	protected ETipoAtto tipoAttoEnum

	BandboxLuoghi() {
		super()

		attributoDaLeggere = "descrizione"

		Executions.createComponents("/restrict/afc/bandboxLuoghi.zul", this, null)
		
		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		paging.setPageSize(Integer.MAX_VALUE)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = CivLuogoNascita.etichetteDomain
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
		Paginazione paginazione = null
		switch (this.tipoAttoEnum) {
			case ETipoAtto.NAS:
				Page<CivLuogoNascita> p = Holders.getApplicationContext().getBean(CivLuogoNascitaService.class).listAllByDescrizioneLike(b.toString(), pr)
				paginazione = new Paginazione(p?.getContent(), p?.getTotalElements())
				break
			case ETipoAtto.MAT:
				Page<CivLuogoMatrimonio> p = Holders.getApplicationContext().getBean(CivLuogoMatrimonioService.class).listAllByDescrizioneLike(b.toString(), pr)
				paginazione = new Paginazione(p?.getContent(), p?.getTotalElements())
				break
			case ETipoAtto.MOR:
				Page<CivLuogoDecesso> p = Holders.getApplicationContext().getBean(CivLuogoDecessoService.class).listAllByDescrizioneLike(b.toString(), pr)
				paginazione = new Paginazione(p?.getContent(), p?.getTotalElements())
				break
		}
		listbox.setModel(new ListModelList( (paginazione?.lista?:[]) ) )
		paging.setTotalSize( ( (int)(paginazione?.count?:0) ) )
	}

}
