package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.archivi.ArcViaService
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
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

class BandboxVia extends CustomBandbox {
    BandboxVia() {
        super()

        this.setStyle("text-transform:uppercase")

        attributoDaLeggere = "denominazione"

        Executions.createComponents("/restrict/afc/bandboxVia.zul", this, null)

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)

        paging.setPageSize(Paginazione.pageSize)

        Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
        for (CustomListheader c : compList) {
            c.bbParent = this
        }

        List<Map> eList = ArcComuneBaseDomain.etichetteDomain
        eList.addAll(etichetteBB)
        eList.addAll([EtichetteMessaggi.Errore_Via])

        etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

        errorTitle = getEtichetta(etichette, Etichette.Validazione)
        errorMsg = getEtichetta(etichette, EtichetteMessaggi.Errore_Via)
    }

    protected void loadData(String filtro, Boolean searchEqual = Boolean.FALSE) {
        PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize(), new Sort(SortUtils.denominazioneOrdinamentoAsc))
        Page p = Holders.getApplicationContext().getBean(ArcViaService.class).listAllByDenominazione(filtro, pr)
        listbox.setModel(new ListModelList<ArcVia>(p.getContent()))
        paging.setTotalSize((int) p.getTotalElements())
    }

}
