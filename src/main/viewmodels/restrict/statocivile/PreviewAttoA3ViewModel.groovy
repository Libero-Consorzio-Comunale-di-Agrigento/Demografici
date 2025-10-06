package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PreviewAttoA3ViewModel extends PreviewAttoParentViewModel{

    int scrollChars = 3
    String tipoAttoLabel = ""

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
    private CivAnnotazioneAttoService civAnnotazioneAttoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto,
               @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum , @ExecutionArgParam("rigeneraTesto") Boolean rigeneraTesto) {

        doInit(w)

        saveRecordEnabled = true
        printRecordEnabled = true

        caricaAtto(tipoAttoEnum, pkAtto)

        tipoAttoLabel = TestoUtils.getDescrizioneTipoAtto(atto, etichette)

        datiProvenienza = civDatiProvenienzaAttoService.getByUkAtto(atto.idAtto)

        margine = civMargineService.getByUkAtto(atto.idAtto)
        generaFormuleMargine(rigeneraTesto)

        resize()

        caricaTestoAtto(rigeneraTesto)
    }

    void caricaTestoAtto(Boolean rigeneraTesto) {
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
            List<CivFormulaTestoLibero> formuleTesto = civFormulaTestoLiberoService.listAllByUkAttoAndRichiamoNotIn(atto.idAtto, [FormulaUtils.getRichiamoMargine()])

            //Le formule del testo devono essere composte in un unico testo
            StringBuilder testoRigenerato = new StringBuilder("")
            Map frammentiTestoXRichiamo = TestoUtils.getFrammentiXRichiamo(formuleTesto, numColonne)
            for (String s: frammentiTestoXRichiamo.values()){
                testoRigenerato.append(s)
            }
            dettaglio.testo = testoRigenerato.toString()

            dettaglio.tratteggio = Boolean.FALSE
            manageTratteggio()
            onSalvaRecord()
            return
        }

        formuleMargine = []
        if (getChiaviMargine().size() > 0){
            List<CivFormulaTestoLibero> formuleMargineLista = civFormulaTestoLiberoService.listAllByUKAttoAndRichiamo(atto.idAtto, FormulaUtils.getRichiamoMargine())
            for (CivFormulaTestoLibero f : formuleMargineLista){
                formuleMargine.add(f)
                aggiornaTestoFormulaMargine(f)
            }
        }

        formuleAnnotazioni = []
        List<CivAnnotazioneAtto> formuleAnnotazioniLista = civAnnotazioneAttoService.listAllByUkAttoAndStatoAndStampaSuAtto(atto.idAtto, EStatoAnnotazione.E, Boolean.TRUE)
        for (CivAnnotazioneAtto f : formuleAnnotazioniLista){
            formuleAnnotazioni.add(f)
            f.testoAtto = TestoUtils.formattaTesto(f.testoAtto, f.numeroColonne)
        }

        refreshUi()
    }

    private void aggiornaTestoFormulaMargine(CivFormulaTestoLibero f){
        StringBuilder testoMargine = new StringBuilder("")
        Map frammentiMargineXRichiamo = TestoUtils.getFrammentiXRichiamo([f], f.numeroColonne)
        for (String s: frammentiMargineXRichiamo.values()){
            testoMargine.append(s)
        }
        f.testo = testoMargine.toString()
    }

    @Command void onAggiungiTogliTratteggio() {
        if (testoEditable){
            manageTratteggio()
        }
    }

    void manageTratteggio(){
        Map m = TestoUtils.aggiungiTogliCarattere(dettaglio.tratteggio, TestoUtils.carattereRiempitivo, dettaglio.testo, numColonne, numRighe)
        dettaglio.testo = (m.testo?:"") + (m.aggiunta?:"")

        dettaglio.tratteggio = !(dettaglio.tratteggio)
        refreshUi()
    }

    @Command void onStampaRecord() {
        if (atto.isProvvisorio()){
            Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Errore_stampa_provvisorio), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return
        }

        Map vTesto = civTestoLiberoService.validaTesto(dettaglio.testo, numRighe, numColonne, blocca)
        if (vTesto?.messaggio){
            Messagebox.show(vTesto.messaggio, msgTitle, Messagebox.OK, vTesto.tipo)
            if (vTesto?.tipo == Messagebox.ERROR){
                return
            }
        }

        Map vMargine = civTestoLiberoService.validaMargine(formuleMargine)
        if (vMargine?.messaggio){
            Messagebox.show(vMargine.messaggio, msgTitle, Messagebox.OK, vMargine.tipo)
            return
        }

        onSalvaRecord()

        /*
        // genero la stampa e faccio download
        GestioneTestiModelloAtto g = gestioneTestiModelloAttoService.getByUkModello(atto.tipoAtto, atto.parte, atto.serie, margine?.tipoMargineLaterale, [fetch:[[campo:'modello', tipo: JoinType.LEFT]]])
        if (g){
            try{
                GestioneTestiGsdModello m = gestioneTestiGsdModelloService.get(g.modello.id)
                // genero mappa parametri
                Map<?, ?> parametriQuery =  [ 'id' : atto.id,
                                              'parteRomana': TestoUtils.getParteRomana(atto.parte?.intValue())]
                String formato = statoCivileService.getFormatoAtti()
                String formato = TipoFile.PDF.estensione
                ArcParametro p = arcParametroService.get(ArcParametro.ATTI_ODT)
                if ((p?.valore?.trim()?.toUpperCase() == ETipoSN.S.name()){
                    formato = TipoFile.ODT.estensione
                }
                InputStream is = gestioneTestiService.stampaUnione(new ByteArrayInputStream(m.fileTemplate), new String (m.tipoModello.query), parametriQuery, formato, true)
                Filedownload.save(is.getBytes(), FileUtils.getMimeType(formato), "${atto.idAtto}.${formato}")
                is.close()
            } catch (Exception ex){
                log.error(ex.getMessage())
                Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Errore_generazione_testo), msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        } else {
            Messagebox.show(getEtichetta(etichette, EtichetteMessaggi.Errore_modello_testo_non_trovato), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        */
    }

}
