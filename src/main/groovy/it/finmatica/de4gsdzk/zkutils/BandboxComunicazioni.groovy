package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneService
import it.finmatica.de4gsdzk.utils.ETipoComunicazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxComunicazioni extends CustomBandbox {

	Integer tipoAtto

	ETipoComunicazione tipoComunicazione

	BandboxComunicazioni() {
		super()

		attributoDaLeggere = "descrizioneEstesa"

		Executions.createComponents("/restrict/afc/bandboxComunicazioni.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = []
		eList.addAll(CivComunicazione.etichetteDomain)
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

		Map params = [tipoAtto: tipoAtto, tipoComunicazione: tipoComunicazione, filtro: b.toString(), searchEqual: searchEqual,
					  order: SortUtils.idAsc]

		Page<CivComunicazione> p = Holders.getApplicationContext().getBean(CivComunicazioneService.class).list(params)
		listbox.setModel(new ListModelList<CivComunicazione>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
		label.value = getEtichetta(etichette, Etichette.getEtichetta("Numero_record_trovati")) + paging.totalSize
	}

}
