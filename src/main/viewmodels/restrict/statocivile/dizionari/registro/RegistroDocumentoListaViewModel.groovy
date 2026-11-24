package restrict.statocivile.dizionari.registro

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiEntrata
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiService
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiUscita
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
class RegistroDocumentoListaViewModel extends DizionarioListaViewModel{

    CivRegistroDocumentiBaseDomain dettaglio
    List<CivRegistroDocumentiBaseDomain> lista

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    List<ETipoDocumento> listaTipiDocumento
    ETipoDocumento tipoDocumento

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivRegistroDocumentiService civRegistroDocumentiService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        searchEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Tipo_Documento"), Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Registri_Documenti"), Etichette.getEtichetta("Compilare_tipo_registro")]
        eList.addAll(CivRegistroDocumentiUscita.etichetteDomain)

        // Aggiungo etichette tipo documento
        listaTipiDocumento = Arrays.asList(ETipoDocumento.values())
        eList.addAll(listaTipiDocumento*.etichettaDesc)

        // Aggiungo archivio documento
        eList.addAll(Arrays.asList(ETipoArchivioDocumento.values())*.etichettaDesc)

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Registri_Documenti"))

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), SortUtils.idAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), SortUtils.idDesc)])

        selectedOrder = listaOrder[0]

        resize()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page<CivRegistroDocumentiBaseDomain> p = civRegistroDocumentiService.listAllByDescrizioneLike(tipoDocumento, SqlUtils.beginsAndEndsLike(filtro), pr)

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command void onSelectTipoDocumento() {
        onRicarica()
    }

    String getUriDettaglio(){
        return "dizionari/registro/registroDocumentoDettaglio.zul"
    }

    @Command onInserisci() {
        if (addEnabled && userModifyEnabled) {
            if (tipoDocumento != null) {
                apriDettaglio(getUriDettaglio(), [tipoDocumento: tipoDocumento])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_registro")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command onModifica() {
        if (modifyEnabled && userModifyEnabled && dettaglio){
            if ( ((dettaglio instanceof CivRegistroDocumentiUscita)  && tipoDocumento.isUscita()) ||
                 ((dettaglio instanceof CivRegistroDocumentiEntrata) && tipoDocumento.isEntrata()) ){
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, tipoDocumento: tipoDocumento])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_apertura_record")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
