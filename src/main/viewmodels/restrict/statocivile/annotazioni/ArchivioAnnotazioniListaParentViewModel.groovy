package restrict.statocivile.annotazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.StampaAttoService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import it.finmatica.de4gsdzk.zkutils.CustomPopupAnnotazione
import org.springframework.dao.EmptyResultDataAccessException
import org.zkoss.bind.BindContext
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class ArchivioAnnotazioniListaParentViewModel extends AbstractListaViewModel implements TraitCancellazioneCampi {

    List<Map> tipiComune
    Map tipoComune

    List<Integer> listaUffici

    List<EStatoAnnotazione> listaStatoAnnotazione

    CustomPopupAnnotazione ppAnnotazione

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private StampaAttoService stampaAttoService

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivAttoService civAttoService

    void doInit(Window w, List<Map> eList=[]) {
        self = w

        eList.addAll([Etichette.Annotazioni, Etichette.Tipo_Atto, Etichette.Comune, Etichette.Altro_comune, Etichette.Annulla,
                      Etichette.Chiudi, Etichette.Modello_Personalizzato, Etichette.Generata_da, Etichette.Atto_non_in_Archivio])
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_comune, EtichetteMessaggi.Ask_Formato_etichette])
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        // Aggiungo etichette delle Annotazioni
        eList.addAll(CivAnnotazioneAtto.etichetteDomain)
        eList.addAll(CivFormulaAnnotazione.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        // Aggiungo etichette sullo stato delle Annotazioni
        listaStatoAnnotazione = [null]
        listaStatoAnnotazione.addAll(Arrays.asList(EStatoAnnotazione.values()))
        eList.addAll(Arrays.asList(EStatoAnnotazione.values())*.etichettaDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.Annotazioni)

        listaUffici = [null] + statoCivileService.listUffici()

        ArcComune comune = statoCivileService.getComuneCliente()
        tipiComune = [[label:"${comune.descrizioneComune}", value: 1], [label:getEtichetta(Etichette.Altro_comune), value: 0]]
        tipoComune = tipiComune[0]
    }

    @Command void onPreviewAnnotazione(@ContextParam(ContextType.BIND_CONTEXT) BindContext ctx, @BindingParam("annotazioneAtto") CivAnnotazioneAtto annotazioneAtto) {
        ppAnnotazione.annotazioneAtto = annotazioneAtto
        ppAnnotazione.open(ctx.getComponent(), 'before_start')
        BindUtils.postNotifyChange(null, null, this, "ppAnnotazione")
    }

    @Command void onClosePreviewAnnotazione() {
        ppAnnotazione.close()
    }

    void stampaEtichetta(String formato, CivAnnotazioneAtto annotazioneAtto) {
        CivAttoBaseDomain abd = getAttoAnnotazione(annotazioneAtto)
        stampaAttoService.downloadEtichetta(formato, annotazioneAtto, abd)
    }

    @Command void onStampaEtichetta(@BindingParam("annotazioneAtto") CivAnnotazioneAtto annotazioneAtto) {
        if (annotazioneAtto?.id) {

            Messagebox.Button[] buttons = [Messagebox.Button.YES, Messagebox.Button.NO, Messagebox.Button.RETRY, Messagebox.Button.CANCEL]
            String[] buttonLabels = [TestoUtils.formatoA4, TestoUtils.formatoA3, getEtichetta(Etichette.Modello_Personalizzato), getEtichetta(Etichette.Annulla)]

            Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Formato_etichette), msgTitle, buttons, buttonLabels , Messagebox.QUESTION, null,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            switch (e.getName()) {
                                case Messagebox.ON_YES:
                                    stampaEtichetta(TestoUtils.formatoA4, annotazioneAtto)
                                    break
                                case Messagebox.ON_NO:
                                    stampaEtichetta(TestoUtils.formatoA3, annotazioneAtto)
                                    break
                                case Messagebox.ON_RETRY:
                                    stampaEtichetta(TestoUtils.formatoCustom, annotazioneAtto)
                                    break
                            }
                        }
                    }
            )
        }
    }

    CivAttoBaseDomain getAttoAnnotazione(CivAnnotazioneAtto aa){
        CivAttoBaseDomain abd = null
        if (aa?.id != null){
            try {
                abd = civAttoService.getAttoFromAnnotazione(aa.getTipoAtto(), aa.ufficio, aa.anno, aa.atto, aa.parte, aa.serie)
            } catch (EmptyResultDataAccessException e){
                log.error(e.getMessage())
            }
        }
        return abd
    }

}