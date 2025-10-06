package restrict.statocivile.annotazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.apache.commons.lang.time.DateUtils
import org.springframework.dao.EmptyResultDataAccessException
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.BindUtils
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
class ArchivioAnnotazioniPerAnnotazioneListaViewModel extends ArchivioAnnotazioniListaParentViewModel {

    List<Map> lista = []
    private Map _dettaglio

    List<ETipoAnnotazione> listaTipoAnnotazione

    ETipoOrdinamentoAnnotazione tipoOrdinamentoDefaultValue

    RicercaAnnotazione ricercaAnnotazione

    String totalSizeDettaglioLabel

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private CivAttoService civAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        addEnabled = false
        modifyEnabled = false

        ricercaAnnotazione = new RicercaAnnotazione()

        List<Map> eList = [Etichette.Atti, Etichette.Cognome, Etichette.Nome, Etichette.Numero_Atti,
                           Etichette.Gestione_Annotazioni_Archiviate, Etichette.Per_Annotazione]

        // Aggiungo etichette ricerca
        eList.addAll(RicercaAnnotazione.etichetteRicercaAnnDesc)

        // Aggiungo etichette sul tipo delle Annotazioni
        listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]
        eList.addAll(listaTipoAnnotazione*.etichettaDesc)

        doInit(w, eList)

        formLabel = getEtichetta(Etichette.Gestione_Annotazioni_Archiviate)?.toUpperCase() + " - " + getEtichetta(Etichette.Per_Annotazione)?.toUpperCase()

        onSelectTipoComune()

        tipoOrdinamentoDefaultValue = ETipoOrdinamentoAnnotazione.Tutte

        resize()
    }

    @AfterCompose(superclass = true)
    void afterCompose() {
        if (!ppAnnotazione) {
            List<Component> components = Selectors.find(self, '#ppAnnotazione')
            ppAnnotazione = components ? components.first() : null
        }
    }

    @Command void onSelectTipoComune() {
        //svuoto l'annotazione?
        //ricercaAnnotazione.formulaDfa = null
        resetRicerca()
    }

    void caricaLista() {
        totalSizeDettaglioLabel = ""
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = []
        List<CivFormulaAnnotazione> l = p.lista
        for (CivFormulaAnnotazione fa: l){
            Map m = [formulaDfa: fa]
            lista.add(m)
        }
        if (lista.size() == 1){
            setDettaglio(lista[0])
        }
        updateTotalSize(p.count)

        BindUtils.postNotifyChange(null, null, this, "totalSizeDettaglioLabel")
        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE))

        Map params = getParamsBase()
        Page<CivFormulaAnnotazione> p = null
        if ( (tipoComune.value == 1) || (tipoComune.value == 0) ){
            p = civAnnotazioneAttoService.listAllDistinctFormulaDfa(params.dal, params.al, (ricercaAnnotazione.formulaDfa?.id?:"%"), params.stati, params.listaTipiatto, pr)
        } else {
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_comune), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    Map<String,?> getParamsBase(){
        Map p = [:]
        Date dal = ricercaAnnotazione.dal
        if (dal == null){
            dal = DateUtils.addYears((new Date()).clearTime(), ((-1) * 2000) )
        }
        p["dal"] = dal
        Date al = ricercaAnnotazione.al
        if (al == null){
            al = DateUtils.addYears((new Date()).clearTime(), 2000)
        }
        p["al"] = al

        List<EStatoAnnotazione> listaStati = (ricercaAnnotazione.stato?[ricercaAnnotazione.stato]:Arrays.asList(EStatoAnnotazione.values()))
        p["stati"] = listaStati

        List<Integer> listaTipiatto = []
        if ( (tipoComune.value == 1) || (tipoComune.value == 0) ) {
            if (tipoComune.value == 1) {
                for (ETipoAtto ta : [ETipoAtto.NAS, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]) {
                    listaTipiatto.add(new Integer(ta.valore))
                }
            }
            if (tipoComune.value == 0) {
                for (int i : [CivMatrimonio.tipoAttoAnnotazioneSuAttoNascitaAltroComune, CivMatrimonio.tipoAttoAnnotazioneSuAttoMatrimonioAltroComune,
                              CivUnioneCivile.tipoAttoAnnotazioneSuAttoNascitaAltroComune, CivUnioneCivile.tipoAttoAnnotazioneSuAttoUnioneCivileAltroComune,
                              CivMorte.tipoAttoAnnotazioneSuAttoNascitaAltroComune, CivCittadinanza.tipoAttoAnnotazioneSuAttoNascitaAltroComune] ) {
                    listaTipiatto.add(new Integer(i) )
                }
            }
        }
        p["listaTipiatto"] = listaTipiatto
        return p
    }

    void resetDettaglio(){
        setDettaglio(null)
        refreshDettaglio()
    }

    Map getDettaglio(){
        return _dettaglio
    }

    void setDettaglio(Map m){
        _dettaglio = m

        if (_dettaglio){
            _dettaglio.annotazioni = []
            Map params = getParamsBase()
            List<CivAnnotazioneAtto> aaLista = civAnnotazioneAttoService.listAllByFormulaDfaAndDataRegistrazioneAndStatoAndTipoAttoIn(params.dal, params.al, _dettaglio.formulaDfa?.id, params.stati, params.listaTipiatto)
            totalSizeDettaglioLabel = (getEtichetta(Etichette.Numero_Atti)?:"") + ": " + aaLista.size()
            for (CivAnnotazioneAtto aa: aaLista){
                Map<String,?> a = ["annotazione" : aa]
                CivAttoBaseDomain abd
                try{
                    abd = civAttoService.getAttoFromAnnotazione(aa.getTipoAtto(), aa.ufficio, aa.anno, aa.atto, aa.parte, aa.serie)
                    a.put("attoAnnotazione", [tipoAttoEnum: abd.getTipoAttoEnum(), ufficio: abd.ufficio, anno: abd.anno, atto: abd.atto, parte: abd.parte, serie: abd.serie,
                                              cognome: abd.getCognome1EstremiAtto(aa.tipoFormula), nome: abd.getNome1EstremiAtto(aa.tipoFormula),
                                              cognome2:abd.getCognome2EstremiAtto(), nome2: abd.getNome2EstremiAtto()])
                } catch (EmptyResultDataAccessException e){
                    log.error(e.getMessage())
                    a.put("attoAnnotazione", [tipoAttoEnum: aa.getTipoAttoRifEnum(), ufficio: aa.ufficio, anno: aa.anno, atto: aa.atto, parte: aa.parte, serie: aa.serie,
                                              cognome: ("*** " + getEtichetta(Etichette.Atto_non_in_Archivio) + " ***"), nome: "", fake: Boolean.TRUE,
                                              cognome2: "", nome2: ""])
                }
                _dettaglio.annotazioni.add(a)
            }
            BindUtils.postNotifyChange(null, null, this, "totalSizeDettaglioLabel")
        }
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    @Command void onSelectFormulaAnnotazione(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CivFormulaAnnotazione) {
            ricercaAnnotazione.formulaDfa = (CivFormulaAnnotazione) event.getData()
        } else {
            ricercaAnnotazione.formulaDfa = null
        }
        onRicarica()
        BindUtils.postNotifyChange(null, null, this, "ricercaAnnotazione")
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

    @Override
    protected void resetRicerca(){
        totalSizeDettaglioLabel = ""
        super.resetRicerca()
    }

}