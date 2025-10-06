package restrict.statocivile.dizionari.comunicazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicolo
import it.finmatica.de4gsdzk.statocivile.CivTipoDocumentoFascicoloService
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
class TipoDocumentoFascicoloListaViewModel extends DizionarioListaViewModel{

    CivTipoDocumentoFascicolo dettaglio
    List<CivTipoDocumentoFascicolo> lista

    List<ETipoAtto> listaTipiAtto
    ETipoAtto tipoAttoEnum

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {

        self = w

        List<Map> eList = [Etichette.Tipi_Documento_Fascicolo, Etichette.Funzione_non_abilitata]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_atto])

        searchEnabled = true
        deleteEnabled = true

        eList.addAll(CivTipoDocumentoFascicolo.etichetteDomain)

        listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault

        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Tipi_Documento_Fascicolo)

        resize()

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    @Command void onSelectTipoAtto() {
        onRicarica()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Page<CivTipoDocumentoFascicolo> p = null

        if (tipoAttoEnum != null) {
            PageRequest pr = new PageRequest(usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE)
            p = civTipoDocumentoFascicoloService.listAllByTipoAttoOrderByDescrizione(tipoAttoEnum, Boolean.FALSE, filtro, pr)
        } else {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/comunicazione/tipoDocumentoFascicoloDettaglio.zul"
    }

    @Command onInserisci() {
        if (addEnabled && userModifyEnabled){
            if (tipoAttoEnum == null){
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else {
                apriDettaglio(getUriDettaglio(), [tipoAttoEnum: tipoAttoEnum])
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command onModifica() {
        if (modifyEnabled && dettaglio){
            if (userModifyEnabled){
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, tipoAttoEnum: tipoAttoEnum])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    String getMessaggioCancellazione(){
        if (dettaglio) {
            return (dettaglio.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record))
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            civTipoDocumentoFascicoloService.delete(dettaglio)
            onRicarica()
        }
    }
}
