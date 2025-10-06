package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxComuni extends CustomBandbox {

	Date dataRiferimento
	List<String> idNotIn

	BandboxComuni() {
		super()

        this.setStyle("text-transform:uppercase")
		
		attributoDaLeggere = "descrizioneComune"

		Executions.createComponents("/restrict/afc/bandboxComuni.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

        paging.setPageSize(Paginazione.pageSize)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = ArcComuneBaseDomain.etichetteDomain
		eList.addAll(etichetteBB)
		eList.addAll([EtichetteMessaggi.Errore_Comune])

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		errorTitle = getEtichetta(etichette, Etichette.Validazione)
		errorMsg = getEtichetta(etichette, EtichetteMessaggi.Errore_Comune)
	}

	void setDataRiferimento(Date d){
		dataRiferimento = d
		Iterable<Component> compListheader = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compListheader){
			if (c.visibilityHandler){
				if (c.visibilityHandler == 'ST'){
					c.visible = (d != null)
				}
				if (c.visibilityHandler == 'AR'){
					c.visible = (d == null)
				}
			}
		}
	}

	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		RicercaComune r = new RicercaComune(dataRiferimento, filtro?.toUpperCase(), searchEqual, idNotIn)
		PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize(), new Sort(SortUtils.descrizioneComuneAsc) )
		Page p = Holders.getApplicationContext().getBean(ArcComuneBaseService.class).list(r, pr)
		listbox.setModel(new ListModelList<ArcComuneBaseDomain>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
	}

}
