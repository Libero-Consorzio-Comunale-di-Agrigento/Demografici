package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GestioneTestiGsdModelloService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneListaViewModel extends DizionarioListaViewModel {

    Tuple2<CivComunicazione, List> dettaglio
    List<Tuple2<CivComunicazione, List>> lista
    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    final List<ETipoComunicazione> listaTipiComunicazione = Arrays.asList(ETipoComunicazione.values())
    ETipoComunicazione tipoComunicazione

    List listaTipiAtto = []
    ETipoAtto tipoAttoEnum

    final List<ETipoAnnotazione> listaTipoAnnotazione = [ETipoAnnotazione.M, ETipoAnnotazione.C]
    ETipoOrdinamentoAnnotazione tipoOrdinamentoDefaultValue
    CivFormulaAnnotazione formulaDfa

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivComunicazioneService civComunicazioneService

    @WireVariable
    private CivComunicazioneAttoService civComunicazioneAttoService

    @WireVariable
    private CivComunicazioneFormulaService civComunicazioneFormulaService

    @WireVariable
    private GestioneTestiGsdModelloService gestioneTestiGsdModelloService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        addEnabled = true
        pagingEnabled = true
        searchEnabled = true
        modifyEnabled = true
        additionalListaToolbarbutton = "/restrict/afc/controlbar/toolbarbuttonDownloadOrigineDati.zul"

        List<Map<String, String>> eList = [Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Tipo_Atto"), Etichette.getEtichetta("Formula"), Etichette.getEtichetta("Associazioni"),
                                           Etichette.getEtichetta("scarica_origine_dati_tooltip"), Etichette.getEtichetta("Tutti"), Etichette.getEtichetta("Tutte")]
        // Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_tipo_comunicazione")])
        eList.addAll(CivComunicazione.etichetteDomain)

        // Aggiungo etichette tipo comunicazione
        eList += ETipoComunicazione.values()*.getEtichettaDesc() as Map

        eList += ETipoAtto.values()*.getEtichettaDesc() as Map

        eList.addAll([Etichette.getEtichetta("Descrizione_crescente"), Etichette.getEtichetta("Descrizione_decrescente"),
                      Etichette.getEtichetta("Codice_crescente"), Etichette.getEtichetta("Codice_decrescente")])

        doInitEtichette(eList)

        listaTipiAtto = TipoAttoUtils.listaTipiAttoDefault + [null]

        // Aggiungo etichette sul tipo delle Annotazioni
        eList.addAll(listaTipoAnnotazione*.etichettaDesc)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni"))

        formLabel = msgTitle?.toUpperCase()

        tipoOrdinamentoDefaultValue = ETipoOrdinamentoAnnotazione.Tutte

        totalSizeLabel = ""

        //Ordinamento
        listaOrder.addAll([new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_crescente")), SortUtils.descrizioneAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Descrizione_decrescente")), SortUtils.descrizioneDesc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_crescente")), SortUtils.idAsc),
                           new OrderBy(getEtichetta(Etichette.getEtichetta("Codice_decrescente")), SortUtils.idDesc)])

        selectedOrder = listaOrder[0]
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        List l = []
        Page<CivComunicazione> p = null

        if (tipoComunicazione == null){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Compilare_tipo_comunicazione")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            Map params = [activePage : (usePaging ? activePage : null), pageSize: (usePaging ? pageSize : null),
                          tipoAtto: (tipoAttoEnum?new Integer(tipoAttoEnum.valore):null), tipoComunicazione: tipoComunicazione,
                          idFormulaDfa: (formulaDfa?.id?:null), filtro: filtro,
                          order: selectedOrder?.campi]

            p = civComunicazioneService.list(params)

            // carica sotto liste
            for (CivComunicazione c : p) {
                List lista = []
                switch (c.tipoComunicazione) {
                    case ETipoComunicazione.A:
                        List<Integer> li = civComunicazioneAttoService.listAllTipiAttoByComunicazione(c)
                        for (Integer i:li){
                            if (i){
                                lista.add(TipoAttoUtils.fromValoreDefault(i))
                            }
                        }
                        break
                    case ETipoComunicazione.N:
                        if (formulaDfa?.id){
                            lista = civComunicazioneFormulaService.listAllByComunicazioneAndFormulaLike(c, formulaDfa?.id, new PageRequest(0, Integer.MAX_VALUE)).toList()
                        } else {
                            lista = civComunicazioneFormulaService.listAllByComunicazione(c, new PageRequest(0, Integer.MAX_VALUE)).toList()
                        }
                        break
                }
                l.add(new Tuple2(c, lista))
            }
        }

        return new Paginazione(l, p?.getTotalElements()?:0)
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/comunicazioni/comunicazioneDettaglio.zul"
    }

    @Command void onInserisci() {
        if (addEnabled && userModifyEnabled) {
            apriDettaglio(getUriDettaglio(), [:])
        }
    }

    @Command void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), [id: dettaglio.first.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onSelectTipoComunicazione() {
        tipoAttoEnum = null
        formulaDfa = null
        onRicarica()
    }

    @Command void onSelectFormulaAnnotazione(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (event?.data instanceof CivFormulaAnnotazione) {
            formulaDfa = (CivFormulaAnnotazione) event.data
        } else {
            formulaDfa = null
        }
        onRicarica()
    }

    @Command void onCancellaFormulaAnnotazione() {
        onSelectFormulaAnnotazione(null)
    }

    /**
     * Restituisce il testo di un elemento della sottolista
     *
     * @param subItem l'elemento
     * @param trim (opzionale) se tagliare dopo un certo numero di caratteri
     * @return il testo
     */
    String getSubItemText(Object subItem, int trim=0) {
        String ret = subItem ?: subItem.toString()
        if (subItem instanceof ETipoAtto) {
            ret =  getEtichettaEnum(subItem)
        } else if (subItem instanceof CivComunicazioneFormula) {
            ret = subItem.formula.descrizioneEstesa
        }
        int l = ret.length()
        if (trim && l>trim) {
            ret = ret.substring(0, Math.min(l-3, trim))+"..."
        }
        return ret
    }


    @Command void onDownloadOrigineDati() {
        byte[] zip = gestioneTestiGsdModelloService.generateZipFromServer("/WEB-INF/originedati/civ")
        Filedownload.save(zip, ETipoFile.ZIP.contentType, "Civ.zip")
    }
}