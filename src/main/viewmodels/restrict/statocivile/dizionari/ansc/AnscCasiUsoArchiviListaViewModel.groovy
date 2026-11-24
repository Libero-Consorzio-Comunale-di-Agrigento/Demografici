package restrict.statocivile.dizionari.ansc

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ansc.AnscCasoUso
import it.finmatica.de4gsdzk.ansc.AnscCasoUsoService
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivio
import it.finmatica.de4gsdzk.ansc.AnscEndPointServizioArchivioService
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
class AnscCasiUsoArchiviListaViewModel extends DizionarioListaViewModel{

    List<AnscEndPointServizioArchivio> lista
    AnscEndPointServizioArchivio dettaglio

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    final List<ETipoArchivioAnsc> listaTipiArchivioAnsc = [ETipoArchivioAnsc.NAS, ETipoArchivioAnsc.MAT, ETipoArchivioAnsc.UCI,
                                                           ETipoArchivioAnsc.MOR, ETipoArchivioAnsc.CIT]
    ETipoArchivioAnsc tipoArchivioAnsc

    List<AnscCasoUso> listaCasiUso = []
    AnscCasoUso casoUso

    @WireVariable
    private AnscEndPointServizioArchivioService anscEndPointServizioArchivioService

    @WireVariable
    private AnscCasoUsoService anscCasoUsoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        addEnabled = true
        searchEnabled = false
        deleteEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Tipi_di_Atto"), Etichette.getEtichetta("Funzione_non_abilitata"),
                                           Etichette.getEtichetta("Casi_Uso_Servizi"),
                                           Etichette.getEtichetta("Compilare_tipo_archivio"), Etichette.getEtichetta("Ask_Cancellazione_associazione_servizio_ANSC")]

        eList.addAll(AnscEndPointServizio.etichetteDomain)
        eList.addAll(AnscEndPointServizioArchivio.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(listaTipiArchivioAnsc*.etichettaDesc)

        eList.addAll([Etichette.getEtichetta("CdU_crescente"), Etichette.getEtichetta("CdU_decrescente")])

        doInitEtichette(eList)

        totalSizeLabel = ""

        msgTitle = getEtichetta(Etichette.getEtichetta("Casi_Uso_Servizi"))

        formLabel = msgTitle?.toUpperCase()

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("CdU_crescente")), [new Sort.Order(Sort.Direction.ASC, "idCasoUso"), new Sort.Order(Sort.Direction.ASC, "sequenza")]),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("CdU_decrescente")), [new Sort.Order(Sort.Direction.DESC, "idCasoUso"), new Sort.Order(Sort.Direction.ASC, "sequenza")])])

        selectedOrder = listaOrder[0]

        tipoArchivioAnsc = ETipoArchivioAnsc.NAS
        onSelectArchivio()

    }

    @Command void onSelectArchivio() {
        caricaCasiUso()
        caricaLista()
    }

    @Command void onSelectCasoUso() {
        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest((usePaging ? activePage : 0), (usePaging ? pageSize : Integer.MAX_VALUE), new Sort(selectedOrder?.campi))

        Page<AnscEndPointServizioArchivio> p = anscEndPointServizioArchivioService.findAllByArchivioAndCasoUso(tipoArchivioAnsc, casoUso?.id, pr)

        return new Paginazione((p?.getContent() ?: []), (p?.getTotalElements() ?: 0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/ansc/anscCasiUsoArchiviDettaglio.zul"
    }

    @Command void onInserisci() {
        if (tipoArchivioAnsc){
            if (userModifyEnabled){
                Map<String, ?> params = new HashMap<String, ?>()
                params.put("tipoArchivioAnsc", tipoArchivioAnsc)
                apriDettaglio(getUriDettaglio(), params)
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_archivio")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && userModifyEnabled && dettaglio){
            if (dettaglio.archivio == tipoArchivioAnsc) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, tipoArchivioAnsc: tipoArchivioAnsc])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_apertura_record")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio?.servizio) {
            return String.format(getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_associazione_servizio_ANSC")), dettaglio.servizio.descrizione)
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            anscEndPointServizioArchivioService.delete(dettaglio)
            onRicarica()
        }
    }

    void caricaCasiUso() {
        listaCasiUso = anscCasoUsoService.findAllByTipoAtto(tipoArchivioAnsc.tipoAtto.valore)
        casoUso = listaCasiUso.first()
    }

}
