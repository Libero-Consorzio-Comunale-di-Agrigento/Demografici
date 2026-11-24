package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazioneService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zk.ui.select.annotation.Listen
import org.zkoss.zk.ui.select.annotation.Wire
import org.zkoss.zul.Combobox
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichettaEnum

class BandboxAnnotazioni extends CustomBandbox {

	@Wire("combobox")
	protected Combobox combobox

	Integer tipoAtto

	List<ETipoAnnotazione> listaTipoAnnotazione
	void setListaTipoAnnotazione(List<ETipoAnnotazione> listaTipoAnnotazione) {
		this.listaTipoAnnotazione = listaTipoAnnotazione
		List<Map> eList = []
		eList.addAll(listaTipoAnnotazione*.etichettaDesc)
		Map etichetteTipoAnnotazione = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)
		etichette.putAll(etichetteTipoAnnotazione)
	}

	ETipoOrdinamentoAnnotazione tipoOrdinamentoDefaultValue
	void setTipoOrdinamentoDefaultValue(ETipoOrdinamentoAnnotazione tipoOrdinamentoDefaultValue){
		this.tipoOrdinamentoDefaultValue = tipoOrdinamentoDefaultValue
		if (tipoOrdinamentoDefaultValue){
			for (Map m : combobox.getModel()){
				if (m.value == tipoOrdinamentoDefaultValue){
					combobox.getModel().addToSelection(m)
					break
				}
			}
		}
	}

	BandboxAnnotazioni() {
		super()

		attributoDaLeggere = "descrizioneEstesa"

		Executions.createComponents("/restrict/afc/bandboxAnnotazioni.zul", this, null)

		Selectors.wireVariables(this, this, null)
		Selectors.wireComponents(this, this, false)
		Selectors.wireEventListeners(this, this)

		List<ETipoOrdinamentoAnnotazione> listaTipoOrdinamento = Arrays.asList(ETipoOrdinamentoAnnotazione.values())

		List<Map> eList = CivFormulaAnnotazione.etichetteDomain
		eList.addAll(CivAnnotazioneAtto.etichetteDomain)
		eList.addAll(etichetteBB)
        eList.addAll(listaTipoOrdinamento*.etichettaDesc)

		etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

		paging.setPageSize(Paginazione.pageSize)

		List<Map> listaTipoOrdinamentoModel = []
		for (ETipoOrdinamentoAnnotazione to:listaTipoOrdinamento){
			listaTipoOrdinamentoModel.add([label: getEtichettaEnum(etichette, to), value: to])
		}
		combobox.setModel(new ListModelList(listaTipoOrdinamentoModel))

		Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
		for (CustomListheader c: compList){
			c.bbParent = this
		}

		errorTitle = getEtichetta(etichette, Etichette.getEtichetta("Validazione"))
		errorMsg = getEtichetta(etichette, Etichette.getEtichetta("Dato_non_valido"))
	}

	protected void loadData(String filtro, Boolean searchEqual=Boolean.FALSE) {
		StringBuilder b = new StringBuilder((filtro?:""))
		if (!(searchEqual)){
			b.insert(0,"%")
			b.append("%")
		}
		Map params = [activePage: paging.getActivePage(), pageSize: paging.getPageSize(),
					  tipoAtto: tipoAtto, tipiAnnotazione:listaTipoAnnotazione ,
					  tipoOrdinamento: combobox.getSelectedItem()?.value?.value, filtroEsteso: b.toString(),
					  order: SortUtils.formulaAsc]

		Page p = Holders.getApplicationContext().getBean(CivFormulaAnnotazioneService.class).list(params)
		listbox.setModel(new ListModelList<CivFormulaAnnotazione>(p.getContent()))
		paging.setTotalSize((int)p.getTotalElements())
		label.value = (getEtichetta(etichette, Etichette.getEtichetta("Numero_record_trovati"))?:"") + paging.totalSize
	}

	@Listen("onSelect = combobox")
	public void selectComboData() {
		paging.setActivePage(0)
		loadData(textbox?.getValue())
	}

}
