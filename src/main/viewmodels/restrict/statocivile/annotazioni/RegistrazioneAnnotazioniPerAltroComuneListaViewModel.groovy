package restrict.statocivile.annotazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivAnnotazioneAtto
import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazione
import it.finmatica.de4gsdzk.statocivile.CivSoggettoAnnotazioneService
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.OrderBy
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.SortUtils
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RegistrazioneAnnotazioniPerAltroComuneListaViewModel extends RegistrazioneAnnotazioniListaParentViewModel {

    List<ETipoAtto> listaTipiAttoRiferimento
    ETipoAtto tipoAttoEnumRiferimento

    List<Map> addPlusList = []

    @WireVariable
    private CivSoggettoAnnotazioneService civSoggettoAnnotazioneService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        pagingAnnotazioneEnabled = true
        addAnnotazioneEnabled = false
        addPlusAnnotazioneEnabled = true
        modifyAnnotazioneEnabled = true

        List<Map> eList = [Etichette.Tipo_Atto_Destinazione, Etichette.Sposo, Etichette.Sposa,
                           Etichette.Contraente_1, Etichette.Contraente_2, Etichette.su_atto_nascita,
                           Etichette.su_atto_matrimonio, Etichette.su_atto_unione_civile,
                           Etichette.su_atto_nascita_sposo, Etichette.su_atto_nascita_sposa, Etichette.su_atto_nascita_altro_soggetto,
                           Etichette.su_atto_nascita_contraente1, Etichette.su_atto_nascita_contraente2]

        listaTipiAttoRiferimento = [ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]

        doInit(w, eList)

        caricaAddPlusList()

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_decrescente),        SortUtils.getEstremiAttoDesc()))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_crescente),          SortUtils.getEstremiAttoAsc() ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_decrescente),          SortUtils.cognomeNomeDesc ))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_crescente),            SortUtils.cognomeNomeAsc ))

        //Default: estremi atto desc
        selectedOrder = listaOrder[0]

        resize()
    }

    void caricaAddPlusList(){
        addPlusList = []
        List<ETipoAtto> taList = [ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]
        for (ETipoAtto ta:taList){
            Integer tr = new Integer(ta.valore)
            Integer taNas = new Integer(ETipoAtto.NAS.valore)
            List<Map> subList =[]
            if ( (ta == ETipoAtto.MAT) || (ta == ETipoAtto.UCI) ){
                if (ta == ETipoAtto.MAT) {
                    subList.addAll([[descrizione: getEtichetta(Etichette.su_atto_nascita_sposo),          tipoFormula: CivAnnotazioneAtto.tipo_formula_1, tipoAttoRif: tr, tipoAttoAnnotazione: taNas],
                                    [descrizione: getEtichetta(Etichette.su_atto_nascita_sposa),          tipoFormula: CivAnnotazioneAtto.tipo_formula_5, tipoAttoRif: tr, tipoAttoAnnotazione: taNas],
                                    [descrizione: getEtichetta(Etichette.su_atto_nascita_altro_soggetto), tipoFormula: CivAnnotazioneAtto.tipo_formula_X, tipoAttoRif: tr, tipoAttoAnnotazione: taNas],
                                    [descrizione: getEtichetta(Etichette.su_atto_matrimonio) ,            tipoFormula: CivAnnotazioneAtto.tipo_formula_1, tipoAttoRif: tr, tipoAttoAnnotazione: new Integer(ETipoAtto.MAT.valore)]] )
                }
                if (ta == ETipoAtto.UCI) {
                    subList.addAll([[descrizione: getEtichetta(Etichette.su_atto_nascita_contraente1), tipoFormula: CivAnnotazioneAtto.tipo_formula_1, tipoAttoRif: tr, tipoAttoAnnotazione: taNas],
                                    [descrizione: getEtichetta(Etichette.su_atto_nascita_contraente2), tipoFormula: CivAnnotazioneAtto.tipo_formula_5, tipoAttoRif: tr, tipoAttoAnnotazione: taNas],
                                    [descrizione: getEtichetta(Etichette.su_atto_unione_civile),       tipoFormula: CivAnnotazioneAtto.tipo_formula_1, tipoAttoRif: tr, tipoAttoAnnotazione: new Integer(ETipoAtto.UCI.valore)]] )
                }
                addPlusList.add([descrizione: (getEtichetta(Etichette.Generata_da) + " " + getEtichettaEnum(ta)), tipo: CivTipoAtto.TIPO_CATEGORIA, subList: subList])
            } else {
                subList.add([descrizione: getEtichetta(Etichette.su_atto_nascita), tipoFormula: CivAnnotazioneAtto.tipo_formula_1, tipoAttoRif: tr, tipoAttoAnnotazione: taNas])
                addPlusList.add([descrizione: (getEtichetta(Etichette.Generata_da) + " " + getEtichettaEnum(ta)), tipo: CivTipoAtto.TIPO_CATEGORIA, subList: subList])
            }
        }
        refreshUi()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Page<CivSoggettoAnnotazione> p = null

        if (tipoAttoEnumRiferimento == null){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        } else {
            Map params = [activePage: (usePaging ? activePage : null), pageSize: (usePaging ? pageSize : null),
                          ufficio   : ricercaAtto.ufficio, anno: ricercaAtto.anno, parte: ricercaAtto.parte, serie: ricercaAtto.serie,
                          atto      : ricercaAtto.atto, idAttoAnsc: ricercaAtto.idAttoAnsc, cognome: ricercaAtto.cognome, nome: ricercaAtto.nome,
                          tipoComune: 0, tipoAttoRif: new Integer(tipoAttoEnumRiferimento.valore),
                          order     : selectedOrder?.campi]
            p = civSoggettoAnnotazioneService.list(params)
        }

        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    @Command void onSelectTipoAtto() {
        ricercaAtto.setTipoAtto(tipoAttoEnumRiferimento)
        resetRicerca()
    }

    @Command void onInserisciPlus(@BindingParam("tipoFormula") String tipoFormula, @BindingParam("tipoAttoRif") Integer tipoAttoRif, @BindingParam("tipoAttoAnnotazione") Integer tipoAttoAnnotazione) {
        if (addPlusAnnotazioneEnabled && userModifyEnabled){
            Map params = [soggettoAnnotazione: new CivSoggettoAnnotazione(tipoAttoRif: tipoAttoRif, tipoAttoAnnotazione: tipoAttoAnnotazione, tipoFormula:tipoFormula, tipoComune: 0)]
            apriDettaglio(getUriDettaglio(), params)
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Command void onModifica() {
        if (modifyAnnotazioneEnabled && userModifyEnabled && dettaglio){
            if (tipoAttoEnumRiferimento) {
                Map params = [soggettoAnnotazione: dettaglio]
                apriDettaglio(getUriDettaglio(), params)
            } else {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}