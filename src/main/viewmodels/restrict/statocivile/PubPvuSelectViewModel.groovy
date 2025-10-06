package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivVerbaleBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivProcessoVerbale
import it.finmatica.de4gsdzk.statocivile.CivProcessoVerbaleSelectService
import it.finmatica.de4gsdzk.statocivile.CivPubblicazione
import it.finmatica.de4gsdzk.statocivile.CivPubblicazioneSelectService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PubPvuSelectViewModel extends AbstractRecuperoSelectViewModel {

    String windowTitle

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<CivVerbaleBaseDomain> lista
    CivVerbaleBaseDomain dettaglio

    @WireVariable
    private CivProcessoVerbaleSelectService civProcessoVerbaleSelectService

    @WireVariable
    private CivPubblicazioneSelectService civPubblicazioneSelectService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        addEnabled = false
        modifyEnabled = false
        searchEnabled = true

        List<Map> eList = [Etichette.Processi_Verbali, Etichette.Pubblicazioni, Etichette.Seleziona_Processo_Verbale, Etichette.Seleziona_Pubblicazione]
        eList.addAll(CivPubblicazione.etichetteDomain)
        eList.addAll(CivProcessoVerbale.etichetteDomain)
        eList.addAll(etichetteRecuperoDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        doInitEtichette(eList)

        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        totalSizeLabel = ""

        this.tipoAttoEnum = tipoAttoEnum
        switch (tipoAttoEnum) {
            case ETipoAtto.MAT:
                msgTitle = getEtichetta(Etichette.Pubblicazioni)
                windowTitle = getEtichetta(Etichette.Seleziona_Pubblicazione)
                caricaLista()
                break
            case ETipoAtto.UCI:
                msgTitle = getEtichetta(Etichette.Processi_Verbali)
                windowTitle = getEtichetta(Etichette.Seleziona_Processo_Verbale)
                caricaLista()
                break
        }
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(SortUtils.dataRegistrazioneAscOnly))

        Page p = null
        switch (tipoAttoEnum) {
            case ETipoAtto.MAT:
                p = civPubblicazioneSelectService.listAllByCognome1LikeIgnoreCaseOrNome1LikeIgnoreCaseOrCognome2LikeIgnoreCaseOrNome2LikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro?:"%"), pr)
                break
            case ETipoAtto.UCI:
                p = civProcessoVerbaleSelectService.listAllByCognome1LikeIgnoreCaseOrNome1LikeIgnoreCaseOrCognome2LikeIgnoreCaseOrNome2LikeIgnoreCase(SqlUtils.beginsAndEndsLike(filtro?:"%"), pr)
                break
        }
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    @Command void onSeleziona() {
        if (dettaglio){
            // SOGGETTO 1
            String s1 = checkAnagrafe1(dettaglio)
            if (s1){
                Messagebox.show(s1, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }

            // SOGGETTO 2
            String s2 = checkAnagrafe2(dettaglio)
            if (s2){
                Messagebox.show(s2, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }

            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [idVerbale: dettaglio.id, idAnagrafe1: dettaglio.idAnagrafe1, idAnagrafe2: dettaglio.idAnagrafe2] )
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.Nessun_dato_disponibile), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
