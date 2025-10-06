package restrict.statocivile.dizionari.minuta

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivMinuta
import it.finmatica.de4gsdzk.statocivile.CivMinutaService
import it.finmatica.de4gsdzk.statocivile.CivTipoAttoService
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

    @WireVariable
    private CivMinutaService civMinutaService

    @WireVariable
    private CivTipoAttoService civTipoAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        searchEnabled = true

        List<Map<String, String>> eList = [Etichette.Effettua_Ricerca, Etichette.Minute, Etichette.Tipi_Atto_associati]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_atto])

        eList.addAll(CivMinuta.etichetteDomain)

        listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault
        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Minute)

        formLabel = msgTitle?.toUpperCase()

        totalSizeLabel = ""

        resize()
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
            PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE))
            p = civMinutaService.listAllByTipoAttoAndDescrizioneLike(new Integer(tipoAttoEnum.valore), SqlUtils.beginsAndEndsLike(filtro), pr)

            // carica sotto lista
            for (CivMinuta m : p) {
                Map paramsTipiAtto = [codiceMinuta: m.codice, senzaFormule: Boolean.TRUE, order: SortUtils.descrizioneAsc,
                              fetch: [[campo:'categoriaDomain', tipo: JoinType.LEFT]]]
                List listaTipiAtto = civTipoAttoService.list(new Integer(tipoAttoEnum.valore), paramsTipiAtto)?.getContent()?:[]
                l.add(new Tuple2(m, listaTipiAtto))
            }
        } else {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
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
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && userModifyEnabled && dettaglio){
            if (dettaglio.first.tipoAtto.intValue() == tipoAttoEnum?.valore) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.first.id, tipoAttoEnum: tipoAttoEnum])
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

}
