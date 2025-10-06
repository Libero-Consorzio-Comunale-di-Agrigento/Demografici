package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TipoAttoDettaglioViewModel extends AbstractDettaglioViewModel{

    CivTipoAtto dettaglio

    ETipoAtto tipoAttoEnum

    List<ENaturaAtto> listaNatura

    List<ETipoDivorzio> listaTipiDivorzio = []
    List<ETipoDivorzioAltro> listaTipiDivorzioAltro = []

    List<CivCategoriaTipoAtto> listaCategoria

    List<CivTipoDocumentoFascicolo> listaTipoDocumento

    List<Map> listaMinuta

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private CivTipoAttoService civTipoAttoService

    @WireVariable
    private CivCategoriaTipoAttoService civCategoriaTipoAttoService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivMinutaService civMinutaService

    @WireVariable
    private CivTipoDocumentoFascicoloService civTipoDocumentoFascicoloService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum, @ExecutionArgParam("divorzio") Boolean divorzio){
        self = w

        saveRecordEnabled = true

        // Per label da esibire nello zul
        this.tipoAttoEnum = tipoAttoEnum

        List<Map<String, String>> eList = [Etichette.Tipo_Divorzio, Etichette.Tipo_Verbale, Etichette.Atto_Divorzio, Etichette.Atto_Scioglimento]
        eList.addAll(etichetteDettaglioDefault)

        eList.addAll(CivTipoAtto.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        if (tipoAttoEnum in [ETipoAtto.MAT, ETipoAtto.UCI]){
            // Aggiungo etichette tipo di divorzio
            listaTipiDivorzio = Arrays.asList(ETipoDivorzio.values())
            eList.addAll(listaTipiDivorzio*.etichettaDesc)
            eList.add(Etichette.Cessazione_Annullamento)
            if (tipoAttoEnum == ETipoAtto.MAT){
                listaTipiDivorzioAltro = [null] + [ETipoDivorzioAltro.M, ETipoDivorzioAltro.C, ETipoDivorzioAltro.D]
            } else {
                listaTipiDivorzioAltro = [ETipoDivorzioAltro.M, ETipoDivorzioAltro.A]
            }
            eList.addAll(Arrays.asList(ETipoDivorzioAltro.values())*.etichettaDesc)
        }

        // Aggiungo etichette natura atto
        if (divorzio){
            listaNatura = NaturaUtils.getValoriDivorzio()
        } else {
            listaNatura = NaturaUtils.getValoriByTipoAtto(tipoAttoEnum)
        }
        listaNatura.remove(ENaturaAtto.N)
        eList += listaNatura*.getEtichettaDesc() as Map

        // Aggiungo etichetta tipo atto
        eList.add(tipoAttoEnum.getEtichettaDesc())

        // Aggiunto etichette messaggi
        eList.addAll(EtichetteMessaggi.Warn_Categoria_obsoleta_ANSC)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        //etichette custom
        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        if (tipoAttoEnum in [ETipoAtto.PUB, ETipoAtto.PVU]){
            msgTitle = getEtichetta(Etichette.Tipo_Verbale)
        } else {
            msgTitle = getEtichetta(Etichette.Tipo_Atto)
        }

        formLabel = msgTitle?.toUpperCase()  + " - " + getEtichettaEnum(this.tipoAttoEnum)?.toUpperCase()

        listaTipoDocumento = [null] + civTipoDocumentoFascicoloService.listAllByTipoAttoOrderByDescrizione(tipoAttoEnum)?.toList()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            Map<String, ?> params = new HashMap<String, ?>()
            params.put("tipoAtto", new Integer(tipoAttoEnum.valore))
            params.put("divorzio", divorzio)
            if (divorzio){
                params.put("natura", ENaturaAtto.D)
                params.put("parte", new Integer(2))
                if (tipoAttoEnum == ETipoAtto.MAT){
                    params.put("serie", CivTipoAtto.SERIE_C)
                }
            }
            creaDettaglio(params)
        }

        caricaEtichetteCustomTipoDivorzio()
    }

    private void caricaEtichetteCustomTipoDivorzio(){
        etichetteCustom += FormUtils.getTipoDivorzioCustomLabels(dettaglio.categoriaDomain, etichette)
    }

    void caricaDettaglio(def id) {
        if (id != null){
            dettaglio = civTipoAttoService.get(id)
            caricaCategorie()
            caricaMinute()
        }
        refreshUi()
    }

    void creaDettaglio(Map params){
        dettaglio = new CivTipoAtto(params)
        dettaglio.sequenza = civTipoAttoService.getMaxSequenzaByTipoAtto(dettaglio.tipoAtto)
        if (dettaglio.divorzio){
            onSelectParteSerie()
        }
    }

    void caricaCategorie(){
        listaCategoria = [null]
        if (dettaglio?.tipoAtto && dettaglio?.natura){
            List<CivCategoriaTipoAtto> lca = civCategoriaTipoAttoService.listAllByTipoAttoAndParteAndSerieAndNatura(dettaglio.tipoAtto,
                    dettaglio.parte, dettaglio.serie, dettaglio.natura, [divorzio: dettaglio.divorzio, order: SortUtils.descrizioneAsc])
            listaCategoria.addAll(lca)

            if (dettaglio.categoriaDomain != null && !(dettaglio.categoriaDomain.id in lca*.id)) {
                listaCategoria.add(dettaglio.categoriaDomain)
            }
        }
    }

    private void caricaMinute(){
        listaMinuta = []
        if (dettaglio?.tipoAtto!=null) {
            Boolean loadMinute = !(dettaglio.categoriaDomain?.flagFormule)
            if (loadMinute){
                listaMinuta = [null]
                List l = (civMinutaService.listAllByTipoAttoAndDescrizioneLike(dettaglio.tipoAtto, null, new PageRequest(0, Integer.MAX_VALUE))?.getContent()?:[])
                if (l?.size() > 0){
                    listaMinuta.addAll(l)
                }
            }
        }
    }

    @Command void onSelectParteSerie() {
        onSelectNatura()
        dettaglio.codiceMinuta = null
        caricaMinute()
        refreshUi()
    }

    @Command void onSelectNatura() {
        dettaglio.categoriaDomain = null
        caricaCategorie()
        refreshUi()
    }

    @Command void onSelectCategoria() {
        caricaMinute()
        caricaEtichetteCustomTipoDivorzio()
        refreshUi()
    }

    @Command void onSelectTipoDivorzio() {
        if (dettaglio.tipoDivorzio != ETipoDivorzio.A){
            dettaglio.tipoDivorzioAltro = null
        }
        refreshUi()
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()
            if (anscOn && !(dettaglio.categoriaDomain?.flagAnsc ?: false)) {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Warn_Categoria_obsoleta_ANSC), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }

            CivTipoAtto c = civTipoAttoService.save(dettaglio, tipoAttoEnum)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

}
