package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.WireVariable

@Slf4j
abstract class AbstractStampaListaViewModel extends AbstractListaViewModel {

    String csvCharsetName
    Boolean corniceOn = Boolean.TRUE

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    protected ArcParametroService arcParametroService

    abstract void esporta(ETipoFile tipo)

    void doInit(List<Map<String, String>> eList=[]) {
        eList.addAll([Etichette.getEtichetta("Elabora"), Etichette.getEtichetta("Chiudi")])

        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarStampaAttributes.etichetteCbStampaListDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        csvCharsetName = arcParametroService.getCsvCharsetName()
        corniceOn = arcParametroService.isCorniceStampaAttiva()
    }

    abstract IRicerca getRicerca()

    @Command void onEsportaCsv() {
        esporta(ETipoFile.CSV)
    }

    @Command void onEsportaExcel() {
        esporta(ETipoFile.XLS)
    }

    @Command void onEsportaXML() {
        esporta(ETipoFile.XML)
    }

    @Command void onEsportaPDF() {
        esporta(ETipoFile.PDF)
    }

    @Command void onBackFromList() {
        Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
        onChiudi()
    }

    @Override
    void resetDettaglio() {
        log.info ("not implemented")
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")?.trim()
        CancellaCampoUtils.cancellaCampo(ricerca, p)
        refreshUi()
    }

    protected String getNomeFileXAnno(String label, Integer annoDa, Integer annoA, String separator="_"){
        StringBuilder b = new StringBuilder("")
        if (annoDa || annoA){
            b.append(separator)
            b.append(label)
            if (annoDa){
                String s = getConcatenazioneLabelValoreString(getEtichetta(Etichette.getEtichetta("Dal")), annoDa.toString(), separator)
                b.append(s)
            }
            if (annoA){
                String s = getConcatenazioneLabelValoreString(getEtichetta(Etichette.getEtichetta("Al")), annoA.toString(), separator)
                b.append(s)

            }
        }
        return b.toString()
    }

    protected String getNomeFileXData(String label, Date dataDa, Date dataA, String separator="_", String formatoData="dd-MM-yyyy"){
        StringBuilder b = new StringBuilder("")
        if (dataDa || dataA){
            b.append(separator)
            b.append(label)
            if (dataDa){
                String s = getConcatenazioneLabelValoreString(getEtichetta(Etichette.getEtichetta("Dal")), DataUtils.fromDateToString(dataDa, formatoData), separator)
                b.append(s)
            }
            if (dataA){
                String s = getConcatenazioneLabelValoreString(getEtichetta(Etichette.getEtichetta("Al")), DataUtils.fromDateToString(dataA, formatoData), separator)
                b.append(s)
            }
        }
        return b.toString()
    }

    protected String getNomeFileXStato(String label, String valore, String separator="_"){
        return getConcatenazioneLabelValoreString(label, valore, separator)
    }

    protected String getConcatenazioneLabelValoreString(String label, String valore, String separator="_"){
        StringBuilder b = new StringBuilder("")
        b.append(separator)
        b.append(label)
        b.append(separator)
        b.append(valore)
        return b.toString()
    }

}