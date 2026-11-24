package restrict.statocivile.cittadinanza

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivCittadinanza
import it.finmatica.de4gsdzk.statocivile.CivCittadinanzaSelect
import it.finmatica.de4gsdzk.statocivile.CivCittadinanzaSelectService
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
import restrict.statocivile.AbstractRecuperoSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CittadinanzaSelectViewModel extends AbstractRecuperoSelectViewModel{

    List<CivCittadinanzaSelect> lista
    CivCittadinanzaSelect dettaglio

    Boolean anscOn = Boolean.FALSE

    CivCategoriaTipoAtto categoriaDomain

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private CivCittadinanzaSelectService civCittadinanzaSelectService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("categoriaDomain") CivCategoriaTipoAtto categoriaDomain) {
        self = w

        addEnabled = false
        modifyEnabled = false

        List<Map<String, String>> eList = [Etichette.getEtichetta("Atti_Cittadinanza"), Etichette.getEtichetta("Tipo_recupero")]
        eList.addAll(CivCittadinanza.etichetteDomain)
        eList.addAll(CivAttoBaseDomain.etichetteDomain)
        eList.addAll(etichetteRecuperoDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Atti_Cittadinanza"))

        this.tipoAttoEnum = ETipoAtto.CIT

        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        totalSizeLabel = ""

        this.categoriaDomain = categoriaDomain

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(SortUtils.dataRegistrazioneAscOnly))

        Page p = civCittadinanzaSelectService.listAllByCategoria(categoriaDomain.codice, pr)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    @Command void onSeleziona() {
        if (dettaglio){
            // SOGGETTO 1
            String s1 = checkAnagrafe1(dettaglio)
            if (s1){
                Messagebox.show(s1, msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }

            Events.sendEvent(CustomEvents.ON_SELECT_RECORD, self, [idCittadinanza: dettaglio.id, idAnagrafe1: dettaglio.idAnagrafe1] )
            onChiudi()
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

}
