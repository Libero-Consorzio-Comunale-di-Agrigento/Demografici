package restrict.statocivile.dizionari.comunicazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivFormulaAggiuntiva
import it.finmatica.de4gsdzk.statocivile.CivFormulaAggiuntivaService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class FormulaAggiuntivaListaViewModel extends DizionarioListaViewModel{

    CivFormulaAggiuntiva dettaglio
    List<CivFormulaAggiuntiva> lista

    List<ETipoAtto> listaTipiAtto
    ETipoAtto tipoAttoEnum

    @WireVariable
    private CivFormulaAggiuntivaService civFormulaAggiuntivaService

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {

        self = w

        pagingEnabled = false
        addEnabled = false

        List<Map> eList = [Etichette.Formule_CIA]

        eList.addAll(CivFormulaAggiuntiva.etichetteDomain)

        listaTipiAtto = [ETipoAtto.NAS, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]

        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        // Aggiungo etichette tipo formula aggiuntiva
        eList.addAll(Arrays.asList(ETipoFormulaAggiuntiva.values())*.etichettaDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Formule_CIA)

        resize()

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Command void onSelectTipoAtto() {
        onRicarica()
    }

    void resetDettaglio() {
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/comunicazione/formulaAggiuntivaDettaglio.zul"
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info("usePaging: " + usePaging)
        //PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE))
        PageRequest pr = new PageRequest(0, Integer.MAX_VALUE)

        Page<CivFormulaAggiuntiva> p = null
        if (tipoAttoEnum != null) {
            p = civFormulaAggiuntivaService.listAllByTipoAttoOrderBySequenza(new Integer(tipoAttoEnum.valore), pr)
        }
        return new Paginazione(p?.getContent()?:[], p?.getTotalElements()?:0)
    }

    @Command onModifica() {
        if (modifyEnabled && dettaglio){
            if (userModifyEnabled){
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, tipoAttoEnum: tipoAttoEnum])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
