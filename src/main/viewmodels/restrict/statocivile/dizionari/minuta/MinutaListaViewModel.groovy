package restrict.statocivile.dizionari.minuta

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivMinuta
import it.finmatica.de4gsdzk.statocivile.CivMinutaService
import it.finmatica.de4gsdzk.statocivile.CivTipoAttoService
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

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MinutaListaViewModel extends DizionarioListaViewModel{

    Tuple2<CivMinuta, List> dettaglio
    List<Tuple2<CivMinuta, List>> lista

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<ETipoAtto> listaTipiAtto
    ETipoAtto tipoAttoEnum

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private CivMinutaService civMinutaService

    @WireVariable
    private CivTipoAttoService civTipoAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        searchEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Effettua_Ricerca"), Etichette.getEtichetta("Minute"), Etichette.getEtichetta("Tipi_Atto_associati")]

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_atto")])

        eList.addAll(CivMinuta.etichetteDomain)

        listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault
        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Minute"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()
        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), SortUtils.codiceAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), SortUtils.codiceDesc)])

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
        Page<CivMinuta> p = null

        if (tipoAttoEnum != null){
            PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
            p = civMinutaService.listAllByTipoAttoAndDescrizioneLike(new Integer(tipoAttoEnum.valore), SqlUtils.beginsAndEndsLike(filtro), pr)

            // carica sotto lista
            for (CivMinuta m : p) {
                Map paramsTipiAtto = [codiceMinuta: m.codice, senzaFormule: Boolean.TRUE, order: SortUtils.descrizioneAsc,
                              fetch: [[campo:'categoriaDomain', tipo: JoinType.LEFT]]]
                List listaTipiAtto = civTipoAttoService.list(new Integer(tipoAttoEnum.valore), paramsTipiAtto)?.getContent()?:[]
                l.add(new Tuple2(m, listaTipiAtto))
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_atto")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }

        return new Paginazione(l, p?.getTotalElements()?:0)
    }

    @Command void onSelectTipoAtto() {
        onRicarica()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/minuta/minutaDettaglio.zul"
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
        if (modifyEnabled && userModifyEnabled && dettaglio){
            if (dettaglio.first.tipoAtto.intValue() == tipoAttoEnum?.valore) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.first.id, tipoAttoEnum: tipoAttoEnum])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_apertura_record")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
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
