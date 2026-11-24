package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.statocivile.CivTipoAttoService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Filedownload
import org.zkoss.zul.Messagebox
import restrict.AbstractListaViewModel
import restrict.TraitCancellazioneCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class AttoListaParentViewModel extends AbstractListaViewModel implements TraitStampaCampi, TraitCancellazioneCampi {

    List<CivAttoBaseDomain> lista
    CivAttoBaseDomain dettaglio

    RicercaAtto ricercaAtto

    List<Integer> listaUffici = []

    final List<EStatoAtto> listaStati = [null] + Arrays.asList(EStatoAtto.values())

    final List<ETipoSiNo> listaSiNo = [null] + Arrays.asList(ETipoSiNo.values())

    List<Map> addPlusList = []

    List<Map<String, String>> filtriList = []

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    String csvCharsetName

    Boolean anscOn = Boolean.FALSE

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    @WireVariable
    private GsdService gsdService

    @WireVariable
    private CivTipoAttoService civTipoAttoService

    @WireVariable
    private CompetenzaService competenzaService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private ExportService exportService

    void doInit(List<Map<String, String>> eList=[]) {
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarListaAttributes.etichetteCbDesc)

        // Aggiungo etichette tipo si no
        eList.addAll(Arrays.asList(ETipoSiNo.values())*.etichettaDesc)

        // Aggiungo etichette ricerca
        eList.addAll(RicercaAtto.etichetteRicercaDesc)

        // Aggiungo etichette natura
        eList.addAll(Arrays.asList(ENaturaAtto.values())*.etichettaDesc)

        eList.addAll([Etichette.getEtichetta("Estremi_Atto_decrescente"), Etichette.getEtichetta("Estremi_Atto_crescente"), Etichette.getEtichetta("Funzione_non_abilitata"),
                      Etichette.getEtichetta("Data_Evento_decrescente"), Etichette.getEtichetta("Data_Evento_crescente"), Etichette.getEtichetta("Id_Atto_Ansc"),
                      Etichette.getEtichetta("Estrazioni"), Etichette.getEtichetta("Indici_Annuali"), Etichette.getEtichetta("Indici_Decennali"), Etichette.getEtichetta("Formule_Chiusura"), Etichette.getEtichetta("Prospetto_Atti")])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        etichetteCustom = FormUtils.getAttoCustomLabels(getTipoAttoEnum(), etichette)

        filtriList = [[codice: "ESTRAZIONE", descrizione: getEtichetta(Etichette.getEtichetta("Estrazioni"))],
                      [codice: "PROSPETTO", descrizione: getEtichetta(Etichette.getEtichetta("Prospetto_Atti"))],
        ]

        if ( (getTipoAttoEnum() != ETipoAtto.PUB) && (getTipoAttoEnum() != ETipoAtto.PVU) ){
            filtriList.add([codice: "CHIUSURA", descrizione: getEtichetta(Etichette.getEtichetta("Formule_Chiusura"))])
            filtriList.add([codice: "INDICI_A", descrizione: getEtichetta(Etichette.getEtichetta("Indici_Annuali"))])
            //filtriList.add([codice: "INDICI_D", descrizione: getEtichetta(Etichette.getEtichetta("Indici_Decennali"))])
        }

        caricaListaUffici()

        csvCharsetName = arcParametroService.getCsvCharsetName()
        anscOn = arcParametroService.isIntegrazioneAnscAttiva()
    }

    protected void caricaListaUffici(){
        listaUffici = gsdService.listUffici()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    void resetDettaglio(){
        dettaglio = null
        refreshDettaglio()
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        if (dettaglio?.id){
            if (dettaglio.getBloccato()){
                return competenzaService.isCivSuperUser()
            }  else {
                //In modifica possono entrare tutti su atti non bloccati?
                return true
            }
        } else {
            return Boolean.TRUE
        }
    }

    @Command void onCancellaCampoRicerca(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        String p = e?.target?.getAttribute("proprieta")
        cancellaCampo(ricercaAtto, p)
    }

    @Command void onFiltriPlus(@BindingParam("codice") String codice) {
        if (filtriExtraEnabled){
            if (userModifyEnabled) {
                switch (codice) {
                    case "ESTRAZIONE":
                        apriDettaglio("stampaAttiLista.zul", ["tipoAttoEnum": getTipoAttoEnum()])
                        break
                    case "INDICI_A":
                        apriDettaglio("stampaIndiciLista.zul", ["tipoAttoEnum": getTipoAttoEnum(), "tipoIndiceEnum": ETipoIndice.A])
                        break
                    case "INDICI_D":
                        apriDettaglio("stampaIndiciLista.zul", ["tipoAttoEnum": getTipoAttoEnum(), "tipoIndiceEnum": ETipoIndice.D])
                        break
                    case "CHIUSURA":
                        apriDettaglio("stampaFormuleChiusuraLista.zul", ["tipoAttoEnum": getTipoAttoEnum()])
                        break
                    case "PROSPETTO":
                        apriDettaglio("stampaProspettoLista.zul", [:])
                        break
                    case "XPMO":
                        apriDettaglio("morte/morteXPMO.zul", [:])
                        break
                }
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    abstract ETipoAtto getTipoAttoEnum()

    abstract String getUriDettaglio(ETipoOperazione tipoOperazione)

    abstract String getUriDettaglioPregresso(ETipoOperazione tipoOperazione)

    void esporta(ETipoFile tipo){
        //if (lista && lista.size() > 0) {
            if ( (tipo == ETipoFile.XLS) || (tipo == ETipoFile.CSV) ) {
                onRicarica()
                if ((lista == null) || (lista.isEmpty())) {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_record_trovato")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                    return
                }

                Paginazione p = eseguiQuery(Boolean.FALSE)
                List<CivAttoBaseDomain> listaExport = p.lista

                if ((listaExport == null) || (listaExport.isEmpty())) {
                    return
                }

                List<ExportField> exportFields = []
                if ((getTipoAttoEnum() == ETipoAtto.MAT) || (getTipoAttoEnum() == ETipoAtto.UCI)) {
                    exportFields.add(new ExportField("divorzio", getEtichetta(Etichette.getEtichetta("Tipo_Atto")), ExportUtils.STRING_FORMAT, calcolaValoreExportEnumAtto))
                }

                exportFields.add(new ExportField("cognome1Lista", ((String) etichetteCustom.get('Cognome1'))))
                exportFields.add(new ExportField("nome1Lista", ((String) etichetteCustom.get('Nome1'))))

                if ((getTipoAttoEnum() == ETipoAtto.NAS) || (getTipoAttoEnum() == ETipoAtto.MOR) || (getTipoAttoEnum() == ETipoAtto.CIT) || (getTipoAttoEnum() == ETipoAtto.PVU) || (getTipoAttoEnum() == ETipoAtto.UCI)) {
                    exportFields.add(new ExportField("codiceSesso1Lista", getEtichetta(Etichette.getEtichetta("Sesso"))))
                }

                if ((getTipoAttoEnum() == ETipoAtto.PUB) || (getTipoAttoEnum() == ETipoAtto.MAT) || (getTipoAttoEnum() == ETipoAtto.PVU) || (getTipoAttoEnum() == ETipoAtto.UCI)) {
                    exportFields.add(new ExportField("cognome2Lista", ((String) etichetteCustom.get('Cognome2'))))
                    exportFields.add(new ExportField("nome2Lista", ((String) etichetteCustom.get('Nome2'))))
                    if ((getTipoAttoEnum() == ETipoAtto.PVU) || (getTipoAttoEnum() == ETipoAtto.UCI)) {
                        exportFields.add(new ExportField("codiceSesso2Lista", getEtichetta(Etichette.getEtichetta("Sesso"))))
                    }
                }

                exportFields.add(new ExportField("dataEventoLista", ((String) etichetteCustom.get('DataEvento')), ExportUtils.DATE_FORMAT))

                if (tipo == ETipoFile.CSV) {
                    exportFields.add(new ExportField("attoLista.anno", getEtichetta(Etichette.getEtichetta("Anno")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))
                } else {
                    exportFields.add(new ExportField("attoLista.anno", getEtichetta(Etichette.getEtichetta("Anno")), ExportUtils.INTEGER_FORMAT, calcolaValoreExportAnnidato))
                }
                exportFields.add(new ExportField("attoLista.atto", getEtichetta(Etichette.getEtichetta("Numero_Atto")), ExportUtils.STRING_FORMAT, calcolaValoreExportNumeroProvvisorio))
                if (ricercaAtto.hasParte()) {
                    if (tipo == ETipoFile.CSV) {
                        exportFields.add(new ExportField("attoLista.parte", getEtichetta(Etichette.getEtichetta("Parte")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))
                    } else {
                        exportFields.add(new ExportField("attoLista.parte", getEtichetta(Etichette.getEtichetta("Parte")), ExportUtils.INTEGER_FORMAT, calcolaValoreExportAnnidato))
                    }
                }
                if (ricercaAtto.hasSerie()) {
                    exportFields.add(new ExportField("attoLista.serie", getEtichetta(Etichette.getEtichetta("Serie")),ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))
                }

                if (tipo == ETipoFile.CSV) {
                    exportFields.add(new ExportField("attoLista.ufficio", getEtichetta(Etichette.getEtichetta("Ufficio")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))
                } else {
                    exportFields.add(new ExportField("attoLista.ufficio", getEtichetta(Etichette.getEtichetta("Ufficio")), ExportUtils.INTEGER_FORMAT, calcolaValoreExportAnnidato))
                }


                if(tipoAttoEnum.isAttoAnsc()) {
                    exportFields.add(new ExportField("attoLista.idAttoAnsc", getEtichetta(Etichette.getEtichetta("Id_Atto_Ansc")), ExportUtils.STRING_FORMAT, calcolaValoreExportAnnidato))
                }

                exportFields.add(new ExportField("natura", getEtichetta(Etichette.getEtichetta("Natura_Atto")), ExportUtils.STRING_FORMAT, calcolaValoreExportEnumAtto))

                ExportObject eo = new ExportObject("", exportFields, listaExport, null, null, csvCharsetName)
                InputStream exportStream = exportService.export(tipo, eo)
                Filedownload.save(exportStream, tipo.contentType, ExportService.buildFilename(msgTitle, tipo))
            }
        //} else {
        //    Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        //}
    }

    @Command void onEsportaCsv() {
        esporta(ETipoFile.CSV)
    }

    @Command void onEsportaExcel() {
        esporta(ETipoFile.XLS)
    }

    List<Map> getAddMenu(Integer ta, List<ENaturaAtto> ln, Map params ){
        List<Map<String, Object>> l = gsdService.listVociMenuTipiAttoByTipoAtto(ta, params)
        List<Map> mMenu = []
        for (Map m:l){
            switch (m.TIPO) {
                case CivTipoAtto.TIPO_BASE:
                    mMenu.add([id: m.ID, descrizione: m.DESCRIZIONE_VOCE, tipo: m.TIPO, idDomain: new Integer(m.ID.intValue())])
                    break
                case CivTipoAtto.TIPO_CATEGORIA:
                    //List<CivTipoAtto> subList = civTipoAttoService.listAllByTipoAttoAndCategoriaAndNaturaInList(ta, new Integer(m.ID_CATEGORIA.intValue()), ln)
                    List<CivTipoAtto> subList = civTipoAttoService.listAllByTipoAttoAndCategoriaAndNaturaInListAndNotFlagPregressoAndNotFlagDismesso(ta, new Integer(m.ID_CATEGORIA.intValue()), ln)
                    mMenu.add([id: m.ID, descrizione: m.DESCRIZIONE_VOCE, tipo: m.TIPO, subList:subList])
                    break
                case CivTipoAtto.TIPO_PREGRESSO:
                    List<Map<String, Object>> s = gsdService.listVociMenuTipiAttoByTipoAtto(ta, [flagPregresso: true, tipo: CivTipoAtto.TIPO_BASE])
                    List<Map> subList = []
                    for (Map ms:s){
                        subList.add([id:ms.ID, descrizione: ms.DESCRIZIONE_VOCE])
                    }
                    mMenu.add([id: m.ID, descrizione: m.DESCRIZIONE_VOCE, tipo: m.TIPO, subList:subList])
                    break
            }
        }
        return mMenu
    }

    @Command void onModifica() {
        if (dettaglio){
            if (userModifyEnabled){
                Map<String, ?> params = new HashMap<String, ?>()
                params.put("id", dettaglio.id)
                if (dettaglio.isCodRec0()){
                    params.put("composizioneTestoAttiva", Boolean.TRUE)
                    apriDettaglio(getUriDettaglioPregresso(ETipoOperazione.UPD), params)
                } else {
                    apriDettaglio(getUriDettaglio(ETipoOperazione.UPD), params)
                }
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    @Command void onInserisciPlus(@BindingParam("idDomain") Integer idTipoAttoDomain, @BindingParam("tipo") String tipo) {
        if (addPlusEnabled && idTipoAttoDomain){
            if (userModifyEnabled) {
                Map<String, ?> params = new HashMap<String, ?>()
                params.put("tipoAttoDomain", civTipoAttoService.get(idTipoAttoDomain))
                if (tipo == CivTipoAtto.TIPO_PREGRESSO){
                    params.put("composizioneTestoAttiva", Boolean.FALSE)
                    apriDettaglio(getUriDettaglioPregresso(ETipoOperazione.INS), params)
                } else {
                    apriDettaglio(getUriDettaglio(ETipoOperazione.INS), params)
                }
            } else {
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Funzione_non_abilitata")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

}
