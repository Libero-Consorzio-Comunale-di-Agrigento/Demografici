package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.ansc.AnscConsolato
import it.finmatica.de4gsdzk.ansc.AnscConsolatoService
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
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zul.ListModelList
import org.zkoss.zul.Toolbarbutton

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxConsolati extends CustomBandbox {

	@Wire("toolbarbutton")
	protected Toolbarbutton toolbarbutton

    BandboxConsolati() {
		super()

		this.setStyle("text-transform:uppercase")

		attributoDaLeggere = "descrizione"

		Executions.createComponents("/restrict/afc/bandboxConsolati.zul", this, null)
		
		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = [Etichette.Descrizione]
		eList.addAll(etichetteBB)

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		paging.setPageSize(Paginazione.pageSize)

		errorTitle = getEtichetta(etichette, Etichette.Validazione)
		errorMsg = getEtichetta(etichette, Etichette.Dato_non_valido)
	}
	
	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		StringBuilder b = new StringBuilder((filtro?:""))
		if (!(searchEqual)){
			b.insert(0,"%")
			b.append("%")
		}
		PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize(), new Sort(SortUtils.descrizioneAsc))
		Page p = (Holders.getApplicationContext().getBean(AnscConsolatoService.class).listAllByDescrizioneLike(b.toString(), pr))

		listbox.setModel(new ListModelList<AnscConsolato>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
		label.value = (getEtichetta(etichette, Etichette.Numero_record_trovati)?:"") + paging.totalSize
	}

	@Listen("onClick = toolbarbutton")
	public void onTbbClick () {
		paging.setActivePage(0)
		loadData(textbox.getValue())
	}

}
