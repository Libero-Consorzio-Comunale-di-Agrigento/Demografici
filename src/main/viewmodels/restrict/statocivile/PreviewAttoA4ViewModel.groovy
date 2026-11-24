package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdMenuDitta
import it.finmatica.de4gsdzk.GsdMenuDittaService
import it.finmatica.de4gsdzk.StampaAttoService
import it.finmatica.de4gsdzk.errors.EmptyReportException
import it.finmatica.de4gsdzk.errors.MultiplePagesException
import it.finmatica.de4gsdzk.errors.StampaAttoProvvisorioException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import net.sf.jasperreports.engine.JREmptyDataSource
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta as getEtichetta

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PreviewAttoA4ViewModel extends PreviewAttoParentViewModel{

    String descrizioneAtto = ""

    final int maxA4RowCharacters = 120

    @Delegate
    ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private CivTestoLiberoService civTestoLiberoService

    @WireVariable
    private CivFormulaTestoLiberoService civFormulaTestoLiberoService

    @WireVariable
    private CivOcchielloService civOcchielloService

    @WireVariable
    private CivMargineService civMargineService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    @WireVariable
    private GsdMenuDittaService gsdMenuDittaService

    @WireVariable
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @WireVariable
    private StampaAttoService stampaAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto,
               @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum , @ExecutionArgParam("rigeneraTesto") Boolean rigeneraTesto) {

        doInit(w)

        saveRecordEnabled = true
        printRecordEnabled = true

        caricaAtto(tipoAttoEnum, pkAtto)

        datiProvenienza = civDatiProvenienzaAttoService.getByUkAtto(atto.idAtto)

        margine = civMargineService.getByUkAtto(atto.idAtto)

        GsdMenuDitta md = gsdMenuDittaService.getUniqueRecord()
        descrizioneAtto = TestoUtils.getDescrizioneAtto(atto, etichette, md?.id, anscIntestazioneOn)

        generaFormuleMargine(rigeneraTesto)

        caricaTestoAtto(rigeneraTesto)

        if (occhiello){
            if ( ( (occhiello?.cognome?:"").length() > TestoUtils.maxGeneralitaLength) ||
                 ( (occhiello?.nome?:"").length() > TestoUtils.maxGeneralitaLength) ||
                 ( (occhiello?.cognomeConiuge?:"").length() > TestoUtils.maxGeneralitaLength) ||
                 ( (occhiello?.nomeConiuge?:"").length() > TestoUtils.maxGeneralitaLength) ){
                Messagebox.show(getEtichetta(etichette, Etichette.getEtichetta("Warn_Dati_Occhiello")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        }

        resize()
    }

    void caricaTestoAtto(Boolean rigeneraTesto) {
        //Pubblicazioni e processi verbali non gestiscono l'occhiello
        if ((atto.getTipoAttoEnum() != ETipoAtto.PUB) && (atto.getTipoAttoEnum() != ETipoAtto.PVU)){
            occhiello = civOcchielloService.getByUkAtto(atto.idAtto)
        }

        dettaglio = civTestoLiberoService.getByUkAtto(atto.idAtto)
        if (!(dettaglio)){
            dettaglio = new CivTestoLibero()
            DomainUtils.initFromAtto(dettaglio, atto)
        }

        if (rigeneraTesto) {
            dettaglio.testo = ""
            List<CivFormulaTestoLibero> formuleTestoLista = civFormulaTestoLiberoService.listAllByUkAttoAndRichiamoNotIn(atto.idAtto, [FormulaUtils.getRichiamoMargine()])

            //Le formule del testo devono essere composte in un unico testo
            StringBuilder testoRigenerato = new StringBuilder("")
            Map frammentiTestoXRichiamo = TestoUtils.getFrammentiNonFormattatiXRichiamo(formuleTestoLista)
            for (String s: frammentiTestoXRichiamo.values()){
                testoRigenerato.append(s)
            }
            dettaglio.testo = testoRigenerato.toString()
            onSalvaRecord()
            return
        }

        formuleMargine = []
        // refs #73234
        List<CivFormulaTestoLibero> formuleMargineLista = civFormulaTestoLiberoService.listAllByUKAttoAndRichiamo(atto.idAtto, FormulaUtils.getRichiamoMargine())
        for (CivFormulaTestoLibero f : formuleMargineLista){
            formuleMargine.add(f)
            f.numeroRighe = TestoUtils.calcolaRigheA4(f.testo, maxA4RowCharacters)
            if (f.numeroRighe == 1){
                numRighe++
            }
        }

        formuleAnnotazioni = []
        List<CivAnnotazioneAtto> formuleAnnotazioniLista = civAnnotazioneAttoService.listAllByUkAttoAndStatoAndStampaSuAtto(atto.idAtto, EStatoAnnotazione.E, Boolean.TRUE)
        if (formuleAnnotazioniLista?.size() > 0){
            for (CivAnnotazioneAtto f : formuleAnnotazioniLista){
                formuleAnnotazioni.add(f)
                f.numeroRighe = TestoUtils.calcolaRigheA4(f.testoAtto, maxA4RowCharacters)
                if (f.numeroRighe == 1){
                    numRighe++
                }
            }
        }

        numRighe = TestoUtils.calcolaRigheA4(dettaglio.testo, maxA4RowCharacters)
        if (numRighe == 1){
            numRighe++
        }

        refreshUi()
    }
    
    //TODO: update del margine in base alle pagine stampate
    private void aggiornaMargine(int pagine) {
        log.info("Pagine scaricate: $pagine")
    }

    @Command void onStampaRecord() {

        onSalvaRecord()
        int pagine = 0

        JREmptyDataSource jasperSource = new JREmptyDataSource()//usare null per connessione DB

        try {
            Map options = [dataSource: jasperSource, checkSinglePage: blocca]
            pagine = stampaAttoService.downloadReportAtto(atto, dettaglio, margine, occhiello, formuleMargine, formuleAnnotazioni, etichette, options)?.pages
        } catch (StampaAttoProvvisorioException ignored) {
            Messagebox.show( (getEtichetta(etichette, ignored.getEtichetta())?:ignored.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } catch (EmptyReportException ignored) {
            Messagebox.show( (getEtichetta(etichette, ignored.getEtichetta())?:ignored.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
        } catch (MultiplePagesException ignored) {
            if (blocca) {
                Messagebox.show(getEtichetta(etichette, Etichette.getEtichetta("Errore_report_troppo_lungo")), msgTitle, Messagebox.OK, Messagebox.ERROR)
            } else {
                Map options = [dataSource: jasperSource, checkSinglePage: false]
                pagine = stampaAttoService.downloadReportAtto(atto, dettaglio, margine, occhiello, formuleMargine, formuleAnnotazioni, etichette, options)?.pages
            }
        } catch (Exception exc) {
            Messagebox.show(exc.getMessage(), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }

        if (pagine) {
            aggiornaMargine(pagine)
        }
    }

}
