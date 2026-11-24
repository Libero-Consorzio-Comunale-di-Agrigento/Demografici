package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRichiamoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivRichiamoComposizione
import it.finmatica.de4gsdzk.statocivile.CivRichiamoComposizioneService
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormula
import it.finmatica.de4gsdzk.statocivile.CivRichiamoFormulaService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
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
class RichiamoComposizioneListaViewModel extends DizionarioListaViewModel{

    Map<String, ?> dettaglio
    List<Map<String, ?>> lista

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<ETipoAtto> listaTipiAtto
    ETipoAtto tipoAttoEnum

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private CivRichiamoComposizioneService civRichiamoComposizioneService

    @WireVariable
    private CivRichiamoFormulaService civRichiamoFormulaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        searchEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Richiami_Composizione"), Etichette.getEtichetta("Formule"), Etichette.getEtichetta("Funzione_non_abilitata"),
                                           Etichette.getEtichetta("Compilare_tipo_atto")]

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Richiamo_crescente"), Etichette.getEtichetta("Richiamo_decrescente")])

        eList.addAll(CivRichiamoBaseDomain.etichetteDomain)
        eList.addAll(CivRichiamoComposizione.etichetteDomain)
        eList.addAll(CivRichiamoFormula.etichetteDomain)

        listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault
        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Richiami_Composizione"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Richiamo_crescente")), SortUtils.richiamoProgressivoAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Richiamo_decrescente")),  SortUtils.richiamoProgressivoDesc)])

        selectedOrder = listaOrder[0]
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        List l = []
        long tot = 0
        if (tipoAttoEnum != null){
            PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
            Page<CivRichiamoComposizione> p = civRichiamoComposizioneService.listByTipoAtto(new Integer(tipoAttoEnum.valore), filtro, pr)
            if (p?.getContent()){
                for (CivRichiamoComposizione rc: p?.getContent()){
                    List<String> formule = (civRichiamoFormulaService.listAllFormuleByTipoAttoAndRichiamoAndProgressivo(rc)?:[])
                    l.add([richiamo:rc, formule: formule])
                }
            }
            tot = (p?.getTotalElements()?:0)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_atto")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
        return new Paginazione(l, tot)
    }

    @Command void onSelectTipoAtto() {
        onRicarica()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/tipoAtto/richiamoComposizioneDettaglio.zul"
    }

    @Command void onInserisci() {
        if (addEnabled && userModifyEnabled){
            if (tipoAttoEnum != null) {
                apriDettaglio(getUriDettaglio(), [tipoAttoEnum: tipoAttoEnum])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_atto")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && userModifyEnabled && dettaglio?.richiamo){
            if (dettaglio.richiamo instanceof CivRichiamoComposizione){
                CivRichiamoComposizione cr = (CivRichiamoComposizione) dettaglio.richiamo
                if (cr.tipoAtto.intValue() == tipoAttoEnum?.valore) {
                    apriDettaglio(getUriDettaglio(), [id: cr.id, tipoAttoEnum: tipoAttoEnum])
                } else {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_apertura_record")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                }
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

}
