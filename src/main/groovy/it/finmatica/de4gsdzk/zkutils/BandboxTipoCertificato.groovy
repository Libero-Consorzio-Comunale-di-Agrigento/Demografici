package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.certificazione.CerAnagrafeFiltro
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificatoService
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

class BandboxTipoCertificato extends CustomBandbox {
	List<CerAnagrafeFiltro> anagrafeFiltroList
	CerCategoriaTipoCertificato categoriaTipoCertificato

	BandboxTipoCertificato() {
		super()

		attributoDaLeggere = "descrizione"

		Executions.createComponents("/restrict/afc/bandboxTipoCertificato.zul", this, null)
		
		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		List<Map> eList = CerTipoCertificato.etichetteDomain
		eList.addAll(etichetteBB)

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		paging.setPageSize(Paginazione.pageSize)

		errorTitle = getEtichetta(etichette, Etichette.getEtichetta("Validazione"))
		errorMsg = getEtichetta(etichette, Etichette.getEtichetta("Dato_non_valido"))
	}

	void setCategoriaTipoCertificato(CerCategoriaTipoCertificato c) {
		svuotaRisultati()
		categoriaTipoCertificato = c
	}

	void setAnagrafeFiltroList(List<CerAnagrafeFiltro> anagrafeFiltroList) {
		svuotaRisultati()
		this.anagrafeFiltroList = anagrafeFiltroList
	}


	private void svuotaRisultati() {
		listbox?.setModel(new ListModelList<CerTipoCertificato>([]))
		paging?.setTotalSize(0)
		paging?.setActivePage(0)
		label?.setValue("")
	}

	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		StringBuilder b = new StringBuilder((filtro?:""))
		if (!(searchEqual)){
			b.insert(0,"%")
			b.append("%")
		}
		Page p = getPage(b)

		listbox.setModel(new ListModelList<CerTipoCertificato>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
		label.value = (getEtichetta(etichette, Etichette.getEtichetta("Numero_record_trovati"))?:"") + paging.totalSize
	}

	private getPage(StringBuilder b) {
		CerTipoCertificatoService cerTipoCertificatoService = Holders.getApplicationContext().getBean(CerTipoCertificatoService.class)

		// Bandbox utilizzata in certificatoEmessoLista.zul
		if (categoriaTipoCertificato == null && anagrafeFiltroList == null) {
			PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize(), new Sort(SortUtils.descrizioneAsc))
			return cerTipoCertificatoService.listAllByDescrizioneEstesaLike(b.toString(), pr)
		}

		if (categoriaTipoCertificato == null || anagrafeFiltroList == null) {
			throw new IllegalStateException("Impossibile effettuare ricerca su certificati senza categoria e filtri anagrafici")
		}

		Map params = [activePage              : paging.getActivePage(), pageSize: paging.getPageSize(),
					  anagrafeFiltroList      : anagrafeFiltroList,
					  categoriaTipoCertificato: categoriaTipoCertificato,
					  filtro                  : b.toString(),
					  order                   : SortUtils.descrizioneAsc]
		return cerTipoCertificatoService.listByParams(params)
	}

}
