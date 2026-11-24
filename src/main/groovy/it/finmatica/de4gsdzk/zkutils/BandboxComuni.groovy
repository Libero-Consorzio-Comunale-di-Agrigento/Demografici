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
import org.zkoss.zk.ui.event.CheckEvent
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zul.Checkbox
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxComuni extends CustomBandbox {

	Date dataRiferimento
	List<String> idNotIn
    Boolean escludiSoppressi

	@Wire
	Checkbox chkEscludiSoppressi

	void setEscludiSoppressi(Boolean value) {
		escludiSoppressi = value
		if (chkEscludiSoppressi != null) {
			chkEscludiSoppressi.checked = (value == true)
		}
	}

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
		eList.addAll([Etichette.getEtichetta("Errore_Comune")])

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		errorTitle = getEtichetta(etichette, Etichette.getEtichetta("Validazione"))
		errorMsg = getEtichetta(etichette, Etichette.getEtichetta("Errore_Comune"))
		chkEscludiSoppressi.label = getEtichetta(etichette, Etichette.getEtichetta("Escludi_Soppressi"))
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
		chkEscludiSoppressi.visible = (d == null)
	}

	@Listen("onCheck = #chkEscludiSoppressi")
	void onCheckEscludiSoppressi(CheckEvent e) {
		escludiSoppressi = e.checked
		loadData(getValue())
	}

	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		RicercaComune r = new RicercaComune(dataRiferimento, filtro?.toUpperCase(), searchEqual, idNotIn, escludiSoppressi)
		PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize(), new Sort(SortUtils.descrizioneComuneAsc) )
		Page p = Holders.getApplicationContext().getBean(ArcComuneBaseService.class).list(r, pr)
		listbox.setModel(new ListModelList<ArcComuneBaseDomain>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
	}

}
