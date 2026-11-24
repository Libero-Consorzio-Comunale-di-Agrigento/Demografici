package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.certificazione.CerCertificatoEmessoRepository
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxEnteRichiedente extends CustomBandbox {

	BandboxEnteRichiedente() {
		super()

		onChangePreventDefault = Boolean.TRUE

		Executions.createComponents("/restrict/certificazione/emissione/bandboxEnteRichiedente.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		List<Map> eList = [Etichette.getEtichetta("Denominazione")]
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
		PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize())
		Page<String> p = Holders.getApplicationContext().getBean(CerCertificatoEmessoRepository.class).listEntiRichiedenti(b.toString(), pr)
		listbox.setModel(new ListModelList<String>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
	}

}