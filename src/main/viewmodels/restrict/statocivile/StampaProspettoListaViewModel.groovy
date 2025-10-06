package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.statocivile.CivNascita
import it.finmatica.de4gsdzk.statocivile.StatoCivileService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
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
    private StatoCivileService statoCivileService

    @WireVariable
    private ExportService exportService

    @Init init(@ContextParam(ContextType.COMPONENT) Window window) {

        self = window

        backFromListEnabled = true
        pdfExportEnabled = true

        List<Map<String, String>> eList = [Etichette.CONSOLIDATO, Etichette.IN_INSERIMENTO, Etichette.Stato,
                                           Etichette.Nascita, Etichette.Verbale_Pubblicazione, Etichette.Pubblicazioni,
                                           Etichette.Matrimonio, Etichette.Morte, Etichette.Cittadinanza,
                                           Etichette.Processo_Verbale, Etichette.Unione_Civile, Etichette.Verbali, Etichette.Atti,
                                           Etichette.Prospetto_Atti, Etichette.FONTE, Etichette.STATO_CIVILE, Etichette.Dal, Etichette.Al]
        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_campi_prospetto])

        eList.addAll(RicercaAttoStampa.etichetteRicercaStampaDesc)
        eList.addAll(CivNascita.etichetteDomain)

        doInit(eList)

        msgTitle = getEtichetta(Etichette.Prospetto_Atti)

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
            l = statoCivileService.listProspettoAtti(ricercaAttoStampa)
            if ( (l == null) || l.isEmpty() ) {
                Messagebox.show(getEtichetta(Etichette.Nessun_record_trovato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            }
        } catch (CampoMandatoryRuntimeException ex) {
            Messagebox.show((getEtichetta(ex.getEtichetta())?:ex.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        return new Paginazione(l, l.size())
    }

    void esporta(ETipoFile tipo){
        if (tipo != ETipoFile.PDF) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Errore_Operazione_non_consentita)
        }

        Paginazione p = eseguiQuery(Boolean.FALSE)
        List<ProspettoAtti> listaExport = p?.lista
        if ( (listaExport == null) || (listaExport.isEmpty()) ){
            return
        }

        List<ExportField> exportFields = []

        exportFields.add(new ExportField("ANNO", getEtichetta(Etichette.Anno)))
        exportFields.add(new ExportField("UFFICIO", getEtichetta(Etichette.Ufficio)))

        exportFields.add(new ExportField("NAS1A", getEtichetta(Etichette.Nascita) + " I A"))
        exportFields.add(new ExportField("NAS1B", getEtichetta(Etichette.Nascita) + " I B"))
        exportFields.add(new ExportField("NAS2A", getEtichetta(Etichette.Nascita) + " II A"))
        exportFields.add(new ExportField("NAS2B", getEtichetta(Etichette.Nascita) + " II B"))

        exportFields.add(new ExportField("PUB1",  getEtichetta(Etichette.Verbale_Pubblicazione) + " I"))
        exportFields.add(new ExportField("PUB2A", getEtichetta(Etichette.Verbale_Pubblicazione) + " II A"))
        exportFields.add(new ExportField("PUB2B", getEtichetta(Etichette.Verbale_Pubblicazione) + " II B"))

        exportFields.add(new ExportField("MAT1",  getEtichetta(Etichette.Matrimonio) + " I"))
        exportFields.add(new ExportField("MAT2A", getEtichetta(Etichette.Matrimonio) + " II A"))
        exportFields.add(new ExportField("MAT2B", getEtichetta(Etichette.Matrimonio) + " II B"))
        exportFields.add(new ExportField("MAT2C", getEtichetta(Etichette.Matrimonio) + " II C"))

        exportFields.add(new ExportField("MOR1",  getEtichetta(Etichette.Morte) + " I"))
        exportFields.add(new ExportField("MOR2A", getEtichetta(Etichette.Morte) + " II A"))
        exportFields.add(new ExportField("MOR2B", getEtichetta(Etichette.Morte) + " II B"))
        exportFields.add(new ExportField("MOR2C", getEtichetta(Etichette.Morte) + " II C"))
        exportFields.add(new ExportField("MOR2BB", getEtichetta(Etichette.Morte) + " II BBIS"))

        exportFields.add(new ExportField("CIT", getEtichetta(Etichette.Cittadinanza)))

        exportFields.add(new ExportField("UCI_V", getEtichetta(Etichette.Processo_Verbale)))

        exportFields.add(new ExportField("UCI_A", getEtichetta(Etichette.Unione_Civile)))

        StringBuilder b = new StringBuilder(msgTitle)
        b.append(getNomeFileXAnno(getEtichetta(Etichette.Anno), ricercaAttoStampa.annoDa, ricercaAttoStampa.annoA))
        b.append(getNomeFileXData(getEtichetta(Etichette.Data_Registrazione), ricercaAttoStampa.dataRegistrazioneDa, ricercaAttoStampa.dataRegistrazioneA))

        Map reportParams = [
                ENTE            : statoCivileService.getComuneCliente().getDescrizioneComune(),
                TITOLO          : msgTitle,
                FONTE           : getEtichetta(Etichette.FONTE) + " " + getEtichetta(Etichette.STATO_CIVILE),
                NASCITA         : getEtichetta(Etichette.Nascita),
                PUBBLICAZIONI   : getEtichetta(Etichette.Pubblicazioni),
                MATRIMONIO      : getEtichetta(Etichette.Matrimonio),
                MORTE           : getEtichetta(Etichette.Morte),
                CITTADINANZA    : getEtichetta(Etichette.Cittadinanza),
                UNIONI_CIVILI   : getEtichetta(Etichette.Unione_Civile),
                VERBALI         : getEtichetta(Etichette.Verbali),
                ATTI            : getEtichetta(Etichette.Atti),
                PARAMETRI: getParametri([
                        [label: getEtichetta(Etichette.Anno), da: ricercaAttoStampa.annoDa, a: ricercaAttoStampa.annoA],
                        [label: getEtichetta(Etichette.Data_Registrazione), da: ricercaAttoStampa.dataRegistrazioneDa, a: ricercaAttoStampa.dataRegistrazioneA]
                ])
        ]
        ExportObject eo = new ExportObject("stampa_atti_prospetto", exportFields, listaExport, reportParams, null, csvCharsetName)
        exportService.export(tipo, eo, b.toString())
    }

}