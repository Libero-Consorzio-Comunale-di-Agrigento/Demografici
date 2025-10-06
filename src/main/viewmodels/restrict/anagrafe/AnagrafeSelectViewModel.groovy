package restrict.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdAnagrafeBaseDomain
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafe
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnagrafeSelectViewModel extends AbstractSelectViewModel{

    List<AnaAnagrafe> lista = []
    AnaAnagrafe dettaglio

    String cognome
    String nome
    Date dataNascita
    ESesso sesso

    String codiceFiscale

    Boolean checkConiuge
    Boolean soloResidenti

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private AnaAnagrafeService anaAnagrafeService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("cognome") String cognome,
               @ExecutionArgParam("nome") String nome, @ExecutionArgParam("dataNascita") Date dataNascita,
               @ExecutionArgParam("sesso") ESesso sesso, @ExecutionArgParam("checkConiuge") Boolean checkConiuge,
               @ExecutionArgParam("soloResidenti") Boolean soloResidenti, @ExecutionArgParam("codiceFiscale") String codiceFiscale) {
        self = w

        searchEnabled = false
        addEnabled = false
        modifyEnabled = false

        List<Map> eList = [Etichette.Seleziona_Soggetto]
        eList.addAll(GsdAnagrafeBaseDomain.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.Seleziona_Soggetto)

        this.sesso = sesso
        this.cognome = (cognome?:'')
        this.nome = (nome?:'')
        this.dataNascita = dataNascita
        this.checkConiuge = checkConiuge
        this.soloResidenti = soloResidenti
        this.codiceFiscale = codiceFiscale

        totalSizeLabel = ""

        caricaLista()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(SortUtils.cognomeNomeNatoAsc))
        RicercaSoggetto rs = new RicercaSoggetto(cognome, nome, codiceFiscale, sesso, dataNascita, null, EArchivioSorgenteSoggetto.ANA)

        Page p = anaAnagrafeService.listAllByRicercaSoggetto(rs, soloResidenti, pr)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command onSeleziona() {
        if (dettaglio){
            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, dettaglio)
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.Nessun_dato_disponibile), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
