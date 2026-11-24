package restrict.statocivile.dizionari.registro

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModello
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloService
import it.finmatica.de4gsdzk.GestioneTestiGsdProjection
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ModelloDATListaViewModel extends DizionarioListaViewModel{

    GestioneTestiGsdProjection dettaglio
    List<GestioneTestiGsdProjection> lista

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        addEnabled = false
        additionalListaToolbarbutton = "/restrict/afc/controlbar/toolbarbuttonDownloadOrigineDati.zul"

        List<Map<String, String>> eList = [Etichette.getEtichetta("Modelli_DAT"), Etichette.getEtichetta("scarica_origine_dati_tooltip")]
        eList.addAll(GestioneTestiGsdModello.etichetteDomain)

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Modelli_DAT"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc)])

        selectedOrder = listaOrder[0]

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page<GestioneTestiGsdProjection> p = gestioneTestiGsdModelloService.listByGruppoAndAmbito(EGruppo.CIV, EAmbito.TB, pr)

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "dizionari/registro/modelloDATDettaglio.zul"
    }

    @Command onModifica() {
        if (modifyEnabled && userModifyEnabled && dettaglio){
            apriDettaglio(getUriDettaglio(), [id: dettaglio.id])
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onDownloadOrigineDati() {
        byte[] zip = gestioneTestiGsdModelloService.generateZipFromServer("/WEB-INF/originedati/civ")
        Filedownload.save(zip, ETipoFile.ZIP.contentType, "Civ.zip")
    }

}
