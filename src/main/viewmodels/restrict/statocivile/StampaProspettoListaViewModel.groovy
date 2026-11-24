package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.statocivile.CivNascita
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StampaProspettoListaViewModel extends AbstractStampaAttiListaViewModel {

    List<ProspettoAtti> lista

    final List<EStatoAtto> listaStati = [null] + [EStatoAtto.CONSOLIDATO, EStatoAtto.IN_INSERIMENTO]

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private ExportService exportService

    @Init init(@ContextParam(ContextType.COMPONENT) Window window) {

        self = window

        backFromListEnabled = true
        pdfExportEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("CONSOLIDATO"), Etichette.getEtichetta("IN_INSERIMENTO"), Etichette.getEtichetta("Stato"),
                                           Etichette.getEtichetta("Nascita"), Etichette.getEtichetta("Verbale_Pubblicazione"), Etichette.getEtichetta("Pubblicazioni"),
                                           Etichette.getEtichetta("Matrimonio"), Etichette.getEtichetta("Morte"), Etichette.getEtichetta("Cittadinanza"),
                                           Etichette.getEtichetta("Processo_Verbale"), Etichette.getEtichetta("Unione_Civile"), Etichette.getEtichetta("Verbali"), Etichette.getEtichetta("Atti"),
                                           Etichette.getEtichetta("Prospetto_Atti"), Etichette.getEtichetta("FONTE"), Etichette.getEtichetta("STATO_CIVILE"), Etichette.getEtichetta("Dal"), Etichette.getEtichetta("Al")]
        // Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Compilare_campi_prospetto")])

        eList.addAll(RicercaAttoStampa.etichetteRicercaStampaDesc)
        eList.addAll(CivNascita.etichetteDomain)

        doInit(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Prospetto_Atti"))

        formLabel = msgTitle?.toUpperCase()

        ricerca = new RicercaAttoStampa()
    }

    @Override
    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        log.info ("usePaging: " + usePaging)

        List<ProspettoAtti> l = []
        try{
            l = gsdService.listProspettoAtti(ricercaAttoStampa)
            if ( (l == null) || l.isEmpty() ) {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
        } catch (CampoMandatoryRuntimeException ex) {
            Messagebox.show((getEtichetta(ex.getEtichetta())?:ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        return new Paginazione(l, l.size())
    }

    void esporta(ETipoFile tipo){
        if (tipo != ETipoFile.PDF) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Errore_Operazione_non_consentita"))
        }

        Paginazione p = eseguiQuery(Boolean.FALSE)
        List<ProspettoAtti> listaExport = p?.lista
        if ( (listaExport == null) || (listaExport.isEmpty()) ){
            return
        }

        List<ExportField> exportFields = []

        exportFields.add(new ExportField("ANNO", getEtichetta(Etichette.getEtichetta("Anno"))))
        exportFields.add(new ExportField("UFFICIO", getEtichetta(Etichette.getEtichetta("Ufficio"))))

        exportFields.add(new ExportField("NAS1A", getEtichetta(Etichette.getEtichetta("Nascita")) + " I A"))
        exportFields.add(new ExportField("NAS1B", getEtichetta(Etichette.getEtichetta("Nascita")) + " I B"))
        exportFields.add(new ExportField("NAS2A", getEtichetta(Etichette.getEtichetta("Nascita")) + " II A"))
        exportFields.add(new ExportField("NAS2B", getEtichetta(Etichette.getEtichetta("Nascita")) + " II B"))

        exportFields.add(new ExportField("PUB1",  getEtichetta(Etichette.getEtichetta("Verbale_Pubblicazione")) + " I"))
        exportFields.add(new ExportField("PUB2A", getEtichetta(Etichette.getEtichetta("Verbale_Pubblicazione")) + " II A"))
        exportFields.add(new ExportField("PUB2B", getEtichetta(Etichette.getEtichetta("Verbale_Pubblicazione")) + " II B"))

        exportFields.add(new ExportField("MAT1",  getEtichetta(Etichette.getEtichetta("Matrimonio")) + " I"))
        exportFields.add(new ExportField("MAT2A", getEtichetta(Etichette.getEtichetta("Matrimonio")) + " II A"))
        exportFields.add(new ExportField("MAT2B", getEtichetta(Etichette.getEtichetta("Matrimonio")) + " II B"))
        exportFields.add(new ExportField("MAT2C", getEtichetta(Etichette.getEtichetta("Matrimonio")) + " II C"))

        exportFields.add(new ExportField("MOR1",  getEtichetta(Etichette.getEtichetta("Morte")) + " I"))
        exportFields.add(new ExportField("MOR2A", getEtichetta(Etichette.getEtichetta("Morte")) + " II A"))
        exportFields.add(new ExportField("MOR2B", getEtichetta(Etichette.getEtichetta("Morte")) + " II B"))
        exportFields.add(new ExportField("MOR2C", getEtichetta(Etichette.getEtichetta("Morte")) + " II C"))
        exportFields.add(new ExportField("MOR2BB", getEtichetta(Etichette.getEtichetta("Morte")) + " II BBIS"))

        exportFields.add(new ExportField("CIT", getEtichetta(Etichette.getEtichetta("Cittadinanza"))))

        exportFields.add(new ExportField("UCI_V", getEtichetta(Etichette.getEtichetta("Processo_Verbale"))))

        exportFields.add(new ExportField("UCI_A", getEtichetta(Etichette.getEtichetta("Unione_Civile"))))

        StringBuilder b = new StringBuilder(msgTitle)
        b.append(getNomeFileXAnno(getEtichetta(Etichette.getEtichetta("Anno")), ricercaAttoStampa.annoDa, ricercaAttoStampa.annoA))
        b.append(getNomeFileXData(getEtichetta(Etichette.getEtichetta("Data_Registrazione")), ricercaAttoStampa.dataRegistrazioneDa, ricercaAttoStampa.dataRegistrazioneA))

        Map reportParams = [
                ENTE            : gsdService.getComuneCliente().getDescrizioneComune(),
                TITOLO          : msgTitle,
                FONTE           : getEtichetta(Etichette.getEtichetta("FONTE")) + " " + getEtichetta(Etichette.getEtichetta("STATO_CIVILE")),
                NASCITA         : getEtichetta(Etichette.getEtichetta("Nascita")),
                PUBBLICAZIONI   : getEtichetta(Etichette.getEtichetta("Pubblicazioni")),
                MATRIMONIO      : getEtichetta(Etichette.getEtichetta("Matrimonio")),
                MORTE           : getEtichetta(Etichette.getEtichetta("Morte")),
                CITTADINANZA    : getEtichetta(Etichette.getEtichetta("Cittadinanza")),
                UNIONI_CIVILI   : getEtichetta(Etichette.getEtichetta("Unione_Civile")),
                VERBALI         : getEtichetta(Etichette.getEtichetta("Verbali")),
                ATTI            : getEtichetta(Etichette.getEtichetta("Atti")),
                PARAMETRI: getParametri([
                        [label: getEtichetta(Etichette.getEtichetta("Anno")), da: ricercaAttoStampa.annoDa, a: ricercaAttoStampa.annoA],
                        [label: getEtichetta(Etichette.getEtichetta("Data_Registrazione")), da: ricercaAttoStampa.dataRegistrazioneDa, a: ricercaAttoStampa.dataRegistrazioneA]
                ])
        ]
        ExportObject eo = new ExportObject("stampa_atti_prospetto", exportFields, listaExport, reportParams, null, csvCharsetName)
        InputStream exportStream = exportService.export(tipo, eo)
        Filedownload.save(exportStream, tipo.contentType, ExportService.buildFilename(b.toString(), tipo))
    }

}