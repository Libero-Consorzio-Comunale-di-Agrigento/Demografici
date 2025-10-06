package it.finmatica.de4gsdzk.zkutils

import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.certificazione.*
import it.finmatica.de4gsdzk.config.Holders
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.TestoUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageImpl
import org.springframework.data.domain.PageRequest
import org.zkoss.xel.fn.CommonFns
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zul.ListModelList

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

class BandboxDiritto extends CustomCurrencyFakeBandbox {

    EDiritto diritto
    ETipoImportoDiritto tipoImporto

    List<CerTariffaDiritto> tariffaDirittoList

    BandboxDiritto() {
        super()

        Executions.createComponents("/restrict/afc/bandboxDiritto.zul", this, null)

        Selectors.wireVariables(this, this, null)
        Selectors.wireComponents(this, this, false)
        Selectors.wireEventListeners(this, this)

        List<Map> eList = CerTariffaDiritto.etichetteDomain
        eList.addAll(etichetteBB)

        Iterable<Component> compList = this.queryAll("listbox listhead customlistheader")
        for (CustomListheader c : compList) {
            c.dfbParent = this
        }
        setupVisibilyListHeaders()

        etichette = Holders.getApplicationContext().getBean(GsdEtichettaService.class).listAndInsertWhereIdIn(eList)

        paging.setPageSize(Paginazione.pageSize)

        errorTitle = getEtichetta(etichette, Etichette.Validazione)
        errorMsg = getEtichetta(etichette, Etichette.Dato_non_valido)
    }

    private void setupVisibilyListHeaders() {
        Iterable<Component> compListheader = this.queryAll("listbox listhead customlistheader")
        for (CustomListheader c : compListheader) {
            if (c.visibilityHandler) {
                switch (c.visibilityHandler) {
                    case 'IMPORTO_1':
                        c.visible = tipoImporto == ETipoImportoDiritto.IMPORTO_1
                        break
                    case 'IMPORTO_2':
                        c.visible = tipoImporto == ETipoImportoDiritto.IMPORTO_2
                        break
                }
            }
        }
    }

    void setDiritto(String s) {
        diritto = EDiritto.valueOf(s)

        CerTariffaDirittoService cerTariffaDirittoService = Holders.getApplicationContext().getBean(CerTariffaDirittoService.class)
        tariffaDirittoList = cerTariffaDirittoService.listAllByDiritto(diritto)
    }

    void setModalitaRilascio(CerModalitaRilascio modalitaRilascio) {
        if (modalitaRilascio == null) {
            tipoImporto = null
            attributoDaLeggere = null
            return
        }

        if (modalitaRilascio.isInBollo()) {
            tipoImporto = ETipoImportoDiritto.IMPORTO_2
            attributoDaLeggere = "importo2"
        } else {
            tipoImporto = ETipoImportoDiritto.IMPORTO_1
            attributoDaLeggere = "importo1"
        }
        setupVisibilyListHeaders()
    }

    protected void loadData(String filtro, Boolean searchEqual = Boolean.FALSE) {
        Page p = getPage(filtro)

        listbox.setModel(new ListModelList<CerTariffaDiritto>(p.getContent()))
        paging.setTotalSize((int) p.getTotalElements())
        label.value = (getEtichetta(etichette, Etichette.Numero_record_trovati) ?: "") + paging.totalSize
    }

    private Page<CerTariffaDiritto> getPage(String filtro) {
        List found

        if (TestoUtils.isVuoto(filtro)) {
            found = tariffaDirittoList
        } else {
            found = tariffaDirittoList.findAll {

                String importoItem = ""
                switch (tipoImporto) {
                    case ETipoImportoDiritto.IMPORTO_1:
                        importoItem = it.importo1 != null ? CommonFns.formatNumber(it.importo1, getFormat()) : ""
                        break
                    case ETipoImportoDiritto.IMPORTO_2:
                        importoItem = it.importo2 != null ? CommonFns.formatNumber(it.importo2, getFormat()) : ""
                        break
                }

                return importoItem.startsWith(filtro)
            }
        }

        PageRequest pr = new PageRequest(paging.getActivePage(), paging.getPageSize())
        return new PageImpl<CerTariffaDiritto>(found, pr, found.size())
    }

}
