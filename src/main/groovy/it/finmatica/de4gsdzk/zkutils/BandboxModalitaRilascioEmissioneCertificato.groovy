package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerModalitaRilascio
import it.finmatica.de4gsdzk.certificazione.CerModalitaRilascioService
import it.finmatica.de4gsdzk.certificazione.generazione.ETipoGenerazioneCertificato
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
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichettaEnum

class BandboxModalitaRilascioEmissioneCertificato extends CustomBandbox {

	String labelMotivoEsenzioneBollo
	CerCategoriaTipoCertificato categoriaTipoCertificato

	BandboxModalitaRilascioEmissioneCertificato() {
		super()

		attributoDaLeggere = "descrizione"

		Executions.createComponents("/restrict/afc/bandboxModalitaRilascioEmissioneCertificato.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c : compList) {
			c.bbParent = this
		}

		List<Map> eList = CerModalitaRilascio.etichetteDomain
		eList.addAll(ETipoGenerazioneCertificato.values()*.getEtichettaDesc())
		eList.addAll(etichetteBB)

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		paging.setPageSize(Paginazione.pageSize)

		errorTitle = getEtichetta(etichette, Etichette.Validazione)
		errorMsg = getEtichetta(etichette, Etichette.Dato_non_valido)

		labelMotivoEsenzioneBollo = String.format(getEtichetta(etichette, Etichette.Uso), "${getEtichettaEnum(etichette, ETipoGenerazioneCertificato.ANPR)}/${getEtichettaEnum(etichette, ETipoGenerazioneCertificato.ANSC)}")
	}

	void setCategoriaTipoCertificato(CerCategoriaTipoCertificato c) {
		categoriaTipoCertificato = c
	}

	protected void loadData(String filtro, Boolean searchEqual = Boolean.FALSE) {
		StringBuilder b = new StringBuilder((filtro ?: ""))
		if (!(searchEqual)) {
			b.insert(0, "%")
			b.append("%")
		}
		PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize(), new Sort(SortUtils.modalitaRilascioAsc))

		Page p = loadPage(b, pr)

		listbox.setModel(new ListModelList<CerModalitaRilascio>(p.getContent()))
		paging.setTotalSize((int) p.getTotalElements())
		label.value = (getEtichetta(etichette, Etichette.Numero_record_trovati) ?: "") + paging.totalSize
	}

	protected Page loadPage(StringBuilder b, PageRequest pr) {
		CerModalitaRilascioService cerModalitaRilascioService = Holders.getApplicationContext().getBean(CerModalitaRilascioService.class)
		return cerModalitaRilascioService.listAllNonDismessiByCategoriaTipoCertificatoAndDescrizioneEstesaLike(categoriaTipoCertificato, b.toString(), pr)
	}
}
