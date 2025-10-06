package restrict.statocivile.documenti

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.CivVisualizzazioneDocumentiBaseDomain
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiService
import it.finmatica.de4gsdzk.statocivile.CivRegistroDocumentiUscita
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiEntrata
import it.finmatica.de4gsdzk.statocivile.CivVisualizzazioneDocumentiUscita
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractListaViewModel
import restrict.statocivile.TraitStampaAttoCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class DocumentoParentListaViewModel extends AbstractListaViewModel implements TraitStampaAttoCampi{

    Boolean showDetailsProtocollazione = Boolean.TRUE

    ETipoDocumento tipoDocumento

    CivVisualizzazioneDocumentiBaseDomain dettaglio
    List<CivVisualizzazioneDocumentiBaseDomain> lista

    List<Integer> listaAnni
    Integer anno

    List<CivRegistroDocumentiBaseDomain> listaRegistri
    CivRegistroDocumentiBaseDomain registro

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    String csvCharsetName

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    GsdEtichettaService gsdEtichettaService

    @WireVariable
    CivRegistroDocumentiService civRegistroDocumentiService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private ExportService exportService

    void doInit(Window w, List<Map> eList, ETipoDocumento tipoDocumento) {
        self = w

        searchEnabled = true
        addEnabled = false

        eList.addAll([Etichette.Tipo_Documento, Etichette.Protocollo_crescente, Etichette.Protocollo_decrescente,
                      Etichette.Documenti_Non_Associati, Etichette.Documenti_Associati,
                      Etichette.Documenti_Numerati, Etichette.Documenti_Non_Numerati,
                      Etichette.Estremi_Atto_decrescente, Etichette.Estremi_Atto_crescente,
                      Etichette.Generalita_crescente, Etichette.Generalita_decrescente])
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_registro])
        eList.addAll(etichetteListaDefault)
        eList.addAll(CivRegistroDocumentiUscita.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        this.tipoDocumento = tipoDocumento

        csvCharsetName = arcParametroService.getCsvCharsetName()

        totalSizeLabel = ""

        if (showDetailsProtocollazione) {
            listaOrder.add(new OrderBy(getEtichetta(Etichette.Protocollo_crescente),            SortUtils.protocolloAsc))
            listaOrder.add(new OrderBy(getEtichetta(Etichette.Protocollo_decrescente),          SortUtils.protocolloDesc))
        } else {
            listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_decrescente),        SortUtils.estremiAttoDesc))
            listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_crescente),          SortUtils.estremiAttoAsc))
        }
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_crescente),        SortUtils.cognomeNomeAsc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_decrescente),      SortUtils.cognomeNomeDesc))

        selectedOrder = listaOrder[0]

        resize()
    }

    @Override void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    @Override void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    void caricaListaRegistri() {
        listaRegistri = [(CivRegistroDocumentiBaseDomain) null] + civRegistroDocumentiService.listAll(tipoDocumento)
        registro = null
        caricaListaAnni()
    }

    void caricaListaAnni() {
        log.info("punto di estensione")
    }

    static final String uriDettaglioDocumentoUscita = "/restrict/statocivile/documenti/documentoUscitaDettaglio.zul"
    static final String uriDettaglioDocumentoEntrata = "/restrict/statocivile/documenti/documentoEntrataDettaglio.zul"

    @Command onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                if (dettaglio instanceof CivVisualizzazioneDocumentiUscita) {
                    apriDettaglio(uriDettaglioDocumentoUscita, [id: dettaglio.idTrasportoESeppellimento, identificativoAtto: dettaglio.idAtto])
                } else if (dettaglio instanceof CivVisualizzazioneDocumentiEntrata) {
                    apriDettaglio(uriDettaglioDocumentoEntrata, [id: dettaglio.idDisposizioniTrattamento, registro: registro])
                }
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    /** Se seleziono un tipo documento, aggiorno i risultati */
    @Command void onSelectTipoDocumento() {
        anno = null
        onRicarica()
    }

    /** Se seleziono un registro, aggiorno l'elenco degli anni per cui tale registro ha degli atti numerati */
    @Command void onSelectRegistro() {
        caricaListaAnni()
        BindUtils.postNotifyChange(null, null, this, ".")
    }

    /** Se seleziono un anno, ricarico la lista */
    @Command void onSelectAnno() {
        onRicarica()
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    abstract String getDescrizioneStato()

    @Command void onEsportaCsv() {
        esporta(ETipoFile.CSV)
    }

    @Command void onEsportaExcel() {
        esporta(ETipoFile.XLS)
    }

    void esporta(ETipoFile tipo) {
        // Popolo la lista nella form
        onRicarica()
        if ( (lista == null) || (lista.isEmpty()) ){
            Messagebox.show(getEtichetta(Etichette.Nessun_record_trovato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }

        Paginazione p = eseguiQuery(Boolean.FALSE)
        List<CivVisualizzazioneDocumentiBaseDomain> listaExport = p?.lista
        if ( (listaExport == null) || (listaExport.isEmpty()) ){
            return
        }

        List<ExportField> exportFields = []

        if ( (tipo == ETipoFile.XLS) || (tipo == ETipoFile.CSV) ) {

            if (showDetailsProtocollazione || (tipoDocumento == ETipoDocumento.Entrata) ) {
                exportFields.add(new ExportField("numeroProtocollo", getEtichetta(Etichette.Protocollo),
                        ((tipo == ETipoFile.CSV) ? ExportUtils.STRING_FORMAT : ExportUtils.INTEGER_FORMAT),
                        ((tipo == ETipoFile.CSV) ? calcolaValoreExportStringFromInteger : null)))
                exportFields.add(new ExportField("annoProtocollo", getEtichetta(Etichette.Anno_Protocollo),
                        ((tipo == ETipoFile.CSV) ? ExportUtils.STRING_FORMAT : ExportUtils.INTEGER_FORMAT),
                        ((tipo == ETipoFile.CSV) ? calcolaValoreExportStringFromInteger : null)))
                exportFields.add(new ExportField("dataProtocollo", getEtichetta(Etichette.Data), ExportUtils.DATE_FORMAT))
            }
            if (tipoDocumento == ETipoDocumento.Uscita) {
                exportFields.add(new ExportField("ufficio", getEtichetta(Etichette.Ufficio), ExportUtils.INTEGER_FORMAT))
                exportFields.add(new ExportField("anno", getEtichetta(Etichette.Anno),
                        ((tipo == ETipoFile.CSV) ? ExportUtils.STRING_FORMAT : ExportUtils.INTEGER_FORMAT),
                        ((tipo == ETipoFile.CSV) ? calcolaValoreExportStringFromInteger : null)))
                exportFields.add(new ExportField("parte", getEtichetta(Etichette.Parte), ExportUtils.INTEGER_FORMAT))
                exportFields.add(new ExportField("serie", getEtichetta(Etichette.Serie)))
                exportFields.add(new ExportField("atto", getEtichetta(Etichette.Numero_Atto),
                        ((tipo == ETipoFile.CSV) ? ExportUtils.STRING_FORMAT : ExportUtils.INTEGER_FORMAT),
                        ((tipo == ETipoFile.CSV) ? calcolaValoreExportStringFromInteger : null)))
            }
            exportFields.add(new ExportField("nominativo", getEtichetta(Etichette.Cognome_Nome)))

            StringBuilder b = new StringBuilder(msgTitle)
            b.append("_")
            b.append(getDescrizioneStato())

            ExportObject eo = new ExportObject("", exportFields, listaExport, null, null, csvCharsetName)
            exportService.export(tipo, eo, b.toString())
        }
    }

}
