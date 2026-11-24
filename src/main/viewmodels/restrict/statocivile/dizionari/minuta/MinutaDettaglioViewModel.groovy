package restrict.statocivile.dizionari.minuta

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel
import restrict.statocivile.TraitTemplateListaStringhe

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MinutaDettaglioViewModel extends DizionarioDettaglioViewModel implements TraitTemplateListaStringhe {

    CivMinuta dettaglio

    ETipoAtto tipoAttoEnum

    List<CivCategoriaTipoAtto> listaCategoria
    List<CivCategoriaTipoRichiesta> listaTipoRichieste

    ETipoOperazione tipoOperazione

    @WireVariable
    private CivMinutaService civMinutaService

    @WireVariable
    private CivCategoriaTipoAttoService civCategoriaTipoAttoService

    @WireVariable
    private CivCategoriaTipoRichiestaService civCategoriaTipoRichiestaService

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Minuta"), Etichette.getEtichetta("Testo"), Etichette.getEtichetta("Variabili_Cerca")]
        eList.addAll(CivMinuta.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        // Aggiungo etichette tipo richiesta
        eList.addAll([Etichette.getEtichetta("Tipo_richiesta")])

        // Aggiungo etichette messaggi
        eList.addAll(Etichette.getEtichetta("Warn_Categoria_obsoleta_ANSC"))

        doInitEtichette(eList)

        setListaStringhe( gsdService.listVariabili(CivTestoMinuta.class, tipoAttoEnum.valore), getEtichetta(Etichette.getEtichetta("Variabili_Cerca")), 13)

        msgTitle = getEtichetta(Etichette.getEtichetta("Minuta"))

        formLabel = msgTitle?.toUpperCase()

        resize()

        // Per label da esibire nello zul
        this.tipoAttoEnum = tipoAttoEnum

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAtto:tipoAttoEnum.valore])
        }

        caricaCategorie()
        caricaTipoRichieste()
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            tipoOperazione = ETipoOperazione.UPD
            dettaglio = civMinutaService.getWithTesto(id)
            if (dettaglio.testo == null){
                dettaglio.testo = new CivTestoMinuta(tipoAtto: dettaglio.tipoAtto, minuta:dettaglio)
            }
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        CivTestoMinuta testo = new CivTestoMinuta(tipoAtto: params.tipoAtto)
        dettaglio = new CivMinuta(tipoAtto: params.tipoAtto, testo: testo)
        testo.minuta = dettaglio
        tipoOperazione = ETipoOperazione.INS
    }

    void caricaCategorie(){
        listaCategoria = [null]
        if (dettaglio?.tipoAtto){
            List<CivCategoriaTipoAtto> lca = civCategoriaTipoAttoService.listAllByTipoAttoAndFlagFormuleIsNullOrderByDescrizione(dettaglio.tipoAtto)
            listaCategoria.addAll(lca)

            if (dettaglio.categoriaDomain != null && !(dettaglio.categoriaDomain.id in lca*.id)) {
                listaCategoria.add(dettaglio.categoriaDomain)
            }
        }
    }

    void caricaTipoRichieste() {
        listaTipoRichieste = [null]
        if (dettaglio?.categoriaDomain) {
            List<CivCategoriaTipoRichiesta> lctr = civCategoriaTipoRichiestaService.listAllByCivCategoriaTipoAtto(dettaglio.categoriaDomain)
            listaTipoRichieste.addAll(lctr)
        }
        BindUtils.postNotifyChange(null, null, this, "listaTipoRichieste")
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()
            if (anscOn && !(dettaglio.categoriaDomain?.flagAnsc ?: false)) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Warn_Categoria_obsoleta_ANSC")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }

            CivMinuta c = civMinutaService.save(tipoOperazione, dettaglio)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command
    void onSelectCategoria() {
        resetSelectedTipoRichiesta()
        caricaTipoRichieste()
    }

    private resetSelectedTipoRichiesta() {
        dettaglio.tipoRichiesta = null
        BindUtils.postNotifyChange(null, null, dettaglio, "tipoRichiesta")
    }

}
