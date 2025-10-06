package restrict.statocivile.annotazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.lang.time.DateUtils
import org.springframework.dao.EmptyResultDataAccessException
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ArchivioAnnotazioniPerTipoAttoListaViewModel extends ArchivioAnnotazioniListaParentViewModel {

    List<CivAnnotazioneAtto> lista = []
    CivAnnotazioneAtto dettaglio

    ETipoAtto tipoAttoEnum
    List<ETipoAtto> listaTipiAtto

    final RicercaAnnotazione ricercaAnnotazione = new RicercaAnnotazione()

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private CivAttoService civAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        addEnabled = false
        modifyEnabled = false

        List<Map> eList = [Etichette.Estremi_Atto, Etichette.Estremi_Atto_decrescente, Etichette.Estremi_Atto_crescente,
                           Etichette.Data_Registrazione, Etichette.Gestione_Annotazioni_Archiviate, Etichette.Per_Tipo_Atto]
        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_atto])
        // Aggiungo etichette ricerca
        eList.addAll(RicercaAnnotazione.etichetteRicercaAnnDesc)
        doInit(w, eList)

        formLabel = getEtichetta(Etichette.Gestione_Annotazioni_Archiviate)?.toUpperCase() + " - " + getEtichetta(Etichette.Per_Tipo_Atto)?.toUpperCase()

        onSelectTipoComune()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_decrescente),        SortUtils.getEstremiAttoDesc()))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_crescente),          SortUtils.getEstremiAttoAsc()))

        selectedOrder = listaOrder[0]

        resize()
    }

    @AfterCompose(superclass = true)
    void afterCompose() {
        if (!ppAnnotazione) {
            List<Component> components = Selectors.find(self, '#ppAnnotazione')
            ppAnnotazione = components ? components.first() : null
        }
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Page<CivAnnotazioneAtto> p = null

        if (tipoComune != null) {
            if (tipoAttoEnum == null) {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            } else {
                Map params = [activePage: (usePaging ? activePage : null), pageSize: (usePaging ? pageSize : null),
                              ufficio   : ricercaAnnotazione.ufficio, anno: ricercaAnnotazione.anno, parte: ricercaAnnotazione.parte, serie: ricercaAnnotazione.serie,
                              atto      : ricercaAnnotazione.atto, idAttoAnsc: ricercaAnnotazione.idAttoAnsc,
                              dal: ((ricercaAnnotazione.dal == null)?DateUtils.addYears((new Date()).clearTime(), ((-1) * 2000) ):ricercaAnnotazione.dal),
                              al:  ((ricercaAnnotazione.al == null)?DateUtils.addYears((new Date()).clearTime(), 2000):ricercaAnnotazione.al),
                              fetch: [[campo: 'formulaDfa']], order: selectedOrder?.campi]
                if (tipoComune.value == 1){
                    params.put("tipoAtto", new Integer(tipoAttoEnum.valore))
                }
                if (tipoComune.value == 0){
                    switch (tipoAttoEnum){
                        case ETipoAtto.MAT:
                            params.put("tipiAtto", [new Integer(CivMatrimonio.tipoAttoAnnotazioneSuAttoNascitaAltroComune), new Integer(CivMatrimonio.tipoAttoAnnotazioneSuAttoMatrimonioAltroComune)])
                            break
                        case ETipoAtto.UCI:
                            params.put("tipiAtto", [new Integer(CivUnioneCivile.tipoAttoAnnotazioneSuAttoNascitaAltroComune), new Integer(CivUnioneCivile.tipoAttoAnnotazioneSuAttoUnioneCivileAltroComune)])
                            break
                        case ETipoAtto.MOR:
                            params.put("tipoAtto", new Integer(CivMorte.tipoAttoAnnotazioneSuAttoNascitaAltroComune))
                            break
                        case ETipoAtto.CIT:
                            params.put("tipoAtto", new Integer(CivCittadinanza.tipoAttoAnnotazioneSuAttoNascitaAltroComune))
                            break
                    }
                }
                p = civAnnotazioneAttoService.list(params)
            }
        } else {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_comune), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getEstremiAtto(CivAnnotazioneAtto aa) {
        String s = ""
        if (aa?.id != null){
            try {
                CivAttoBaseDomain abd = civAttoService.getAttoFromAnnotazione(aa.getTipoAtto(), aa.ufficio, aa.anno, aa.atto, aa.parte, aa.serie)
                s = abd.getNominativoEstremiAtto(aa.tipoFormula, aa.tipoAttoAnnotazione)
                if (aa.isAttoDiAltroComune()){
                    s = s + " " + getEtichetta(Etichette.Generata_da) + " " + getEtichettaEnum(abd.getTipoAttoEnum()) + " "
                }
            } catch (EmptyResultDataAccessException e){
                log.error(e.getMessage())
                s = ("*** " + getEtichetta(Etichette.Atto_non_in_Archivio) + " ***")
            }
        }
        return s
    }

    @Command void onSelectTipoComune() {
        if (tipoComune.value == 1){
            listaTipiAtto = [ETipoAtto.NAS, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]
        }
        if (tipoComune.value == 0){
            listaTipiAtto = [ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]
        }
        tipoAttoEnum = null
        ricercaAnnotazione.cancella()
        resetRicerca()
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaAnnotazione, p)
        resetRicerca()
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

    @Command void onSelectTipoAtto() {
        ricercaAnnotazione.cancella()
        resetRicerca()
    }
}