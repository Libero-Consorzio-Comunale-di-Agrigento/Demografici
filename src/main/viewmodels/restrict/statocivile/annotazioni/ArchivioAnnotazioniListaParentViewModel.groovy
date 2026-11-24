package restrict.statocivile.annotazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.StampaAttoService
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.CivFormulaAnnotazione
import it.finmatica.de4gsdzk.utils.EStatoAnnotazione
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.TestoUtils
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
    private GsdService gsdService

    @WireVariable
    private CivAttoService civAttoService

    void doInit(Window w, List<Map> eList=[]) {
        self = w

        eList.addAll([Etichette.getEtichetta("Annotazioni"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Comune"), Etichette.getEtichetta("Altro_comune"), Etichette.getEtichetta("Annulla"),
                      Etichette.getEtichetta("Chiudi"), Etichette.getEtichetta("Modello_Personalizzato"), Etichette.getEtichetta("Generata_da"), Etichette.getEtichetta("Atto_non_in_Archivio")])
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_comune"), Etichette.getEtichetta("Ask_Formato_etichette")])
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

        msgTitle = getEtichetta(Etichette.getEtichetta("Annotazioni"))

        listaUffici = [null] + gsdService.listUffici()

        ArcComune comune = gsdService.getComuneCliente()
        tipiComune = [[label:"${comune.descrizioneComune}", value: 1], [label:getEtichetta(Etichette.getEtichetta("Altro_comune")), value: 0]]
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
            String[] buttonLabels = [TestoUtils.formatoA4, TestoUtils.formatoA3, getEtichetta(Etichette.getEtichetta("Modello_Personalizzato")), getEtichetta(Etichette.getEtichetta("Annulla"))]

            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Formato_etichette")), msgTitle, buttons, buttonLabels , Messagebox.QUESTION, null,
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