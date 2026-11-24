package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anpr.AnprMotivoEsenzioneBolloService
import it.finmatica.de4gsdzk.anpr.AnprTipoCertificatoEsterno
import it.finmatica.de4gsdzk.anpr.AnprTipoCertificatoEsternoService
import it.finmatica.de4gsdzk.ansc.AnscMotivoEsenzioneBolloService
import it.finmatica.de4gsdzk.ansc.AnscTipoCertificatoEsternoService
import it.finmatica.de4gsdzk.certificazione.CerMotivoEsenzioneBolloBaseDomain
import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.ETipoCompetenzaCertificazioneOnLine
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxMotivoEsenzioneBollo extends CustomBandbox {

    ETipoCompetenzaCertificazioneOnLine tipoCompetenzaOnline

    BandboxMotivoEsenzioneBollo() {
        super()

        attributoDaLeggere = "descrizione"

        Executions.createComponents("/restrict/afc/bandboxMotivoEsenzioneBollo.zul", this, null)

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)

        Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
        for (CustomListheader c : compList) {
            c.bbParent = this
        }

        List<Map> eList = CerMotivoEsenzioneBolloBaseDomain.etichetteDomain
        eList.addAll(etichetteBB)

        etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

        paging.setPageSize(Paginazione.pageSize)

        errorTitle = getEtichetta(etichette, Etichette.getEtichetta("Validazione"))
        errorMsg = getEtichetta(etichette, Etichette.getEtichetta("Dato_non_valido"))
    }

    protected void loadData(String filtro, Boolean searchEqual = Boolean.FALSE) {
        StringBuilder b = new StringBuilder((filtro ?: ""))
        if (!(searchEqual)) {
            b.insert(0, "%")
            b.append("%")
        }
        Page p = getPage(b)

        listbox.setModel(new ListModelList<CerMotivoEsenzioneBolloBaseDomain>(p.getContent()))
        paging.setTotalSize((int) p.getTotalElements())
        label.value = (getEtichetta(etichette, Etichette.getEtichetta("Numero_record_trovati")) ?: "") + paging.totalSize
    }

    private getPage(StringBuilder b) {

        PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize(), new Sort(SortUtils.idAsc))
        if (tipoCompetenzaOnline == ETipoCompetenzaCertificazioneOnLine.AN) {
            AnprMotivoEsenzioneBolloService anprMotivoEsenzioneBolloService = Holders.getApplicationContext().getBean(AnprMotivoEsenzioneBolloService.class)
            return anprMotivoEsenzioneBolloService.listAllByDescrizione(b.toString(), pr)
        }

        if (tipoCompetenzaOnline == ETipoCompetenzaCertificazioneOnLine.SC) {
            AnscMotivoEsenzioneBolloService anscMotivoEsenzioneBolloService = Holders.getApplicationContext().getBean(AnscMotivoEsenzioneBolloService.class)
            return anscMotivoEsenzioneBolloService.listAllByDescrizione(b.toString(), pr)
        }

        return new PageImpl<>([], pr, 0)
    }

}
