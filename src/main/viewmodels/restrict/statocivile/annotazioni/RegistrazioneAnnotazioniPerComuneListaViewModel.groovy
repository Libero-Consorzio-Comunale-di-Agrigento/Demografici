package restrict.statocivile.annotazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.statocivile.CivAttoService
import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazioneService
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RegistrazioneAnnotazioniPerComuneListaViewModel extends RegistrazioneAnnotazioniListaParentViewModel {

    List<ETipoAtto> listaTipiAtto
    ETipoAtto  tipoAttoEnum

    @WireVariable
    private CivSoggettoAnnotazioneService civSoggettoAnnotazioneService

    @WireVariable
    private CivAttoService civAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        pagingAnnotazioneEnabled = true
        addAnnotazioneEnabled = false
        modifyAnnotazioneEnabled = true

        List<Map> eList = []
        // Aggiungo etichette tipo atto
        listaTipiAtto = [ETipoAtto.NAS, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]
        eList.addAll(listaTipiAtto*.etichettaDesc)

        doInit(w, eList)

        tipoAttoEnum = ETipoAtto.NAS

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_decrescente),        SortUtils.getEstremiAttoDesc()))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_crescente),          SortUtils.getEstremiAttoAsc() ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_decrescente),          SortUtils.cognomeNomeDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_crescente),            SortUtils.cognomeNomeAsc ))

        //Default: estremi atto desc
        selectedOrder = listaOrder[0]

        resize()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        if ( (totalSize == 0) && (tipoAttoEnum != null) ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Inserimento_Annotazione), msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                    new org.zkoss.zk.ui.event.EventListener(){
                        void onEvent(Event e){
                            if (Messagebox.ON_YES.equals(e.getName())){
                                onCreaAnnotazione()
                            }
                        }
                    }
            )
        }

        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Page<CivSoggettoAnnotazione> p = null

        if (tipoAttoEnum == null){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                           ufficio: ricercaAtto.ufficio, anno: ricercaAtto.anno, parte: ricercaAtto.parte, serie: ricercaAtto.serie,
                           atto: ricercaAtto.atto, idAttoAnsc: ricercaAtto.idAttoAnsc, cognome: ricercaAtto.cognome, nome: ricercaAtto.nome,
                           tipoComune: 1, tipoAtto: new Integer(tipoAttoEnum.valore), order: selectedOrder?.campi ]
            p = civSoggettoAnnotazioneService.list(params)
        }

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Override
    void reloadOnClose(){
        log.info("Non devo ricaricare")
    }

    @Command void onSelectTipoAtto() {
        ricercaAtto.setTipoAtto(tipoAttoEnum)
        resetRicerca()
    }

    void onCreaAnnotazione() {
        if (userModifyEnabled) {
            // Se la ricerca non ha restituito risultati e voglio forzare inserimento
            Integer tipoAtto = new Integer(tipoAttoEnum.valore)
            Map params = [soggettoAnnotazione: new CivSoggettoAnnotazione(tipoAttoRif: tipoAtto, tipoAttoAnnotazione: tipoAtto, tipoComune: 1)]
            apriDettaglio(getUriDettaglio(), params)
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onModifica() {
        if (modifyAnnotazioneEnabled && userModifyEnabled && dettaglio){
            if (tipoAttoEnum) {
                CivAttoBaseDomain atto = civAttoService.getAttoFromAnnotazione(dettaglio.getTipoAtto(), dettaglio.ufficio, dettaglio.anno, dettaglio.atto, dettaglio.parte, dettaglio.serie)
                apriPreviewAnnotazioni(atto)
            } else {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void apriPreviewAnnotazioni(CivAttoBaseDomain atto){
        if ( (atto.id != null) && (!(wPreviewAnnotazioniOpen)) ) {
            try{
                wPreviewAnnotazioniOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/annotazioniAttoLista.zul", self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum()])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    self.setVisible(true)
                    wPreviewAnnotazioniOpen = Boolean.FALSE
                    if (event.data?.goToComunicazioni){
                        apriPreviewComunicazioni(atto, null)
                    }
                })
                w.doEmbedded()
            } catch (Exception ex){
                log.error("Errore apertura form annotazioni atto", ex)
                wPreviewAnnotazioniOpen = Boolean.FALSE
                throw ex
            }
        }
    }

    void apriPreviewComunicazioni(CivAttoBaseDomain atto, Boolean priorita){
        if ((atto.id != null) && (!(wPreviewComunicazioniOpen)) ) {
            try {
                wPreviewComunicazioniOpen = Boolean.TRUE
                Window w = (Window) Executions.createComponents("/restrict/statocivile/comunicazioniAttoLista.zul", self.parent, [pkAtto: atto.id, tipoAttoEnum: atto.getTipoAttoEnum(), priorita: priorita])
                self.setVisible(false)
                w.addEventListener(Events.ON_CLOSE, { event ->
                    self.setVisible(true)
                    wPreviewComunicazioniOpen = Boolean.FALSE
                })
                w.doEmbedded()
            } catch (Exception ex) {
                log.error("Errore apertura form comunicazioni atto", ex)
                wPreviewComunicazioniOpen = Boolean.FALSE
                throw ex
            }
        }
    }

}
