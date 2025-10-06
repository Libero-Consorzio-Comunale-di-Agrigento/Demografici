package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivTipoAttoService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import restrict.statocivile.DizionarioListaViewModel

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class TipoAttoListaParentViewModel extends DizionarioListaViewModel {

    CivTipoAtto dettaglio
    List<CivTipoAtto> lista

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    List<ETipoAtto> listaTipiAtto
    ETipoAtto tipoAttoEnum

    @WireVariable
    private CivTipoAttoService civTipoAttoService

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Page p = null
        if (tipoAttoEnum == null) {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            List<ENaturaAtto> listaNatura = NaturaUtils.getValoriByTipoAtto(tipoAttoEnum)
            if ((tipoAttoEnum != null) && (listaNatura?.size() > 0) ){
                Map params = [activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                              natura    : listaNatura, filtro: filtro, order: SortUtils.sequenzaAsc,
                              fetch     : [[campo:'categoriaDomain', tipo: JoinType.LEFT]]]
                params << getAdditionalFilters()
                p = civTipoAttoService.list(new Integer(tipoAttoEnum.valore), params)
            }
        }
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    abstract Map getAdditionalFilters()

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/tipoAtto/tipoAttoDettaglio.zul"
    }

    @Command void onInserisci() {
        if (addEnabled && userModifyEnabled){
            if (tipoAttoEnum != null) {
                apriDettaglio(getUriDettaglio(), [tipoAttoEnum: tipoAttoEnum])
            } else {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && userModifyEnabled && dettaglio){
            if (dettaglio.tipoAtto.intValue() == tipoAttoEnum?.valore) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.id, tipoAttoEnum: tipoAttoEnum])
            } else {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_apertura_record), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getMessaggioCancellazione(){
        if (dettaglio) {
            return (dettaglio.descrizione + ":\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record))
        }
        return ""
    }

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            civTipoAttoService.delete(dettaglio)
            onRicarica()
        }
    }

}
