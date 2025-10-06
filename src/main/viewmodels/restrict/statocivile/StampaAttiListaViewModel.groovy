package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.springframework.data.domain.Page
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StampaAttiListaViewModel extends AbstractStampaAttiListaViewModel {

    ETipoAtto tipoAttoEnum

    List<CivAttoBaseDomain> lista

    final List<EStatoAtto> listaStati = [EStatoAtto.CONSOLIDATO, EStatoAtto.IN_INSERIMENTO]
    final List<ESesso> listaSesso = ESesso.values().toList() + [null]
    final List<ETipoLuogoEvento> listaLuoghi = ETipoLuogoEvento.values().toList() + [null]
    final List<ETipoIndividuiAtto> listaIndividui = ETipoIndividuiAtto.values().toList()
    List<ETipoEvento> listaTipi
    List<ENaturaAtto> listaNature
    List<Integer> listaUffici

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private StatoCivileService statoCivileService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private ExportService exportService

    @Init init(@ContextParam(ContextType.COMPONENT) Window window, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {

        self = window

        backFromListEnabled = true
        pagingEnabled = true
        excelExportEnabled = true
        csvExportEnabled = true
        pdfExportEnabled = ((tipoAttoEnum != ETipoAtto.PVU) && (tipoAttoEnum != ETipoAtto.PUB))

        this.tipoAttoEnum = tipoAttoEnum

        List<Map<String, String>> eList = [Etichette.Data_Processo_Verbale, Etichette.Data_Pubblicazione, Etichette.CONSOLIDATO, Etichette.IN_INSERIMENTO,
                                           Etichette.Estremi_Atto_decrescente, Etichette.Estremi_Atto_crescente, Etichette.Data_Evento_decrescente, Etichette.Data_Evento_crescente,
                                           Etichette.Stato, Etichette.FONTE, Etichette.STATO_CIVILE, Etichette.Tutti_gli_uffici, Etichette.Tipo,
                                           Etichette.Residenza, Etichette.Dal, Etichette.Al, Etichette.ANNULLATO,
                                           Etichette.Totale_Atti, Etichette.Di_cui_annullati, Etichette.Maschi, Etichette.Femmine, Etichette.Non_conosciuto]
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_campi_estrazione, EtichetteMessaggi.Errore_funzionalita_export])
        eList.addAll(RicercaAttoStampa.etichetteRicercaStampaDesc)
        eList.addAll(CivNascita.etichetteDomain)
        eList.addAll(CivMorte.etichetteDomain)
        eList.addAll(CivMatrimonio.etichetteDomain)
        eList.addAll(CivUnioneCivile.etichetteDomain)
        eList.addAll(CivCittadinanza.etichetteDomain)

        eList.addAll(ESesso.values()*.getEtichettaDesc())
        eList.addAll(ETipoLuogoEvento.values()*.getEtichettaDesc())
        eList.addAll(ETipoIndividuiAtto.values()*.getEtichettaDesc())

        listaNature = NaturaUtils.getValoriByTipoAtto(tipoAttoEnum)
        eList.addAll(listaNature*.getEtichettaDesc())
        listaNature += [null]

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        listaTipi = [null]
        if (tipoAttoEnum == ETipoAtto.MAT){
            listaTipi.add(ETipoEvento.Matrimoni)
            listaTipi.add(ETipoEvento.Divorzi)
            eList.addAll([ETipoEvento.Matrimoni.etichettaDesc, ETipoEvento.Divorzi.etichettaDesc])
        }
        if (tipoAttoEnum == ETipoAtto.UCI) {
            listaTipi.add(ETipoEvento.Unioni_Civili)
            listaTipi.add(ETipoEvento.Scioglimenti)
            eList.addAll([ETipoEvento.Unioni_Civili.etichettaDesc, ETipoEvento.Scioglimenti.etichettaDesc])
        }

        doInit(eList)

        //etichette custom
        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        msgTitle = getEtichetta(tipoAttoEnum.etichettaPluralDesc)

        formLabel = msgTitle?.toUpperCase() + " (" + getEtichetta(Etichette.Estrazioni)?.toUpperCase() + ")"

        listaUffici = [null] + statoCivileService.listUffici()

        ricerca = new RicercaAttoStampa(tipoAttoEnum)
        ricerca.tipoIndividuiAtto = ETipoIndividuiAtto.T
        ricerca.stato = EStatoAtto.CONSOLIDATO
        ricerca.escludiAnnullati = Boolean.TRUE

        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_decrescente),    SortUtils.estremiAttoDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Estremi_Atto_crescente),      SortUtils.estremiAttoAsc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Evento_decrescente),     SortUtils.dataEventoDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Evento_crescente),       SortUtils.dataEventoAsc))

        //Default: estremi atto discendente
        selectedOrder = listaOrder[0]
    }

    @Override
    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    private Map getParams(Boolean usePaging=false) {
        Map params = [ activePage:(usePaging?activePage:null), pageSize: (usePaging?pageSize:null),
                       sesso: ricercaAttoStampa.sesso, tipoIndividuiAtto: ricercaAttoStampa.tipoIndividuiAtto,
                       natura: ricercaAttoStampa.natura, escludiAnnullati: ricercaAttoStampa.escludiAnnullati,
                       stato: ricercaAttoStampa.stato, ufficio: ricercaAttoStampa.ufficio,
                       annoDa: ricercaAttoStampa.annoDa, annoA: ricercaAttoStampa.annoA,
                       dataEventoDa: ricercaAttoStampa.dataEventoDa, dataEventoA: ricercaAttoStampa.dataEventoA,
                       dataRegistrazioneDa: ricercaAttoStampa.dataRegistrazioneDa, dataRegistrazioneA: ricercaAttoStampa.dataRegistrazioneA,
                       order : selectedOrder?.campi]
        if (ricercaAttoStampa.hasTipoLuogoEvento()){
            params.put("tipoLuogoEvento", ricercaAttoStampa.tipoLuogoEvento)
        }
        if (ricercaAttoStampa.isIMatrimonio()){
            params.put("tipo", ricercaAttoStampa.tipo)
        }
        if (ricercaAttoStampa.hasTipoAttoInfo()){
            params.put("addJoinTipoAtto", Boolean.TRUE)
        }
        return params
    }

    Paginazione eseguiQuery(Boolean usePaging){
        Page<CivAttoBaseDomain> p = null
        try{
            p = civAttoService.search(tipoAttoEnum, getParams(usePaging))
        } catch (CampoMandatoryRuntimeException ex) {
            resetRicerca()
            Messagebox.show((getEtichetta(ex.getEtichetta())?:getEtichetta(EtichetteMessaggi.Compilare_campi_estrazione)), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void esporta(ETipoFile tipo) {

        if ( ((tipoAttoEnum == ETipoAtto.PVU) || (tipoAttoEnum == ETipoAtto.PUB)) && (tipo == ETipoFile.PDF) ){
            Messagebox.show(getEtichetta(EtichetteMessaggi.Errore_funzionalita_export), msgTitle, Messagebox.OK, Messagebox.ERROR)
            return
        }

        // Popolo la lista nella form
        onRicarica()
        if ( (lista == null) || (lista.isEmpty()) ){
            Messagebox.show(getEtichetta(Etichette.Nessun_record_trovato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }

        Paginazione p = eseguiQuery(Boolean.FALSE)
        List<CivAttoBaseDomain> listaExport = p?.lista
        if ( (listaExport == null) || (listaExport.isEmpty()) ){
            return
        }

        List<ExportField> exportFields = []

        // campi per Excel e CSV
        if ( (tipo == ETipoFile.XLS) || (tipo == ETipoFile.CSV) ) {

            if (ricercaAttoStampa.isIMatrimonio()) {
                exportFields.add(new ExportField("divorzio", getEtichetta(Etichette.Tipo_Atto), ExportUtils.STRING_FORMAT, calcolaValoreExportEnum))
            }

            exportFields.add(new ExportField("cognome1Lista", ((String) etichetteCustom.get('Cognome1'))))
            exportFields.add(new ExportField("nome1Lista", ((String) etichetteCustom.get('Nome1'))))

            if (ricercaAttoStampa.hasSesso()) {
                exportFields.add(new ExportField("codiceSesso1Lista", getEtichetta(Etichette.Sesso)))
            }

            if (ricercaAttoStampa.isDoppioSoggetto()) {
                exportFields.add(new ExportField("cognome2Lista", ((String) etichetteCustom.get('Cognome2'))))
                exportFields.add(new ExportField("nome2Lista", ((String) etichetteCustom.get('Nome2'))))
            }

            exportFields.add(new ExportField("dataEventoLista", ((String) etichetteCustom.get('DataEvento')), ExportUtils.DATE_FORMAT))

            if (tipo == ETipoFile.CSV) {
                exportFields.add(new ExportField("anno", getEtichetta(Etichette.Anno), ExportUtils.STRING_FORMAT, calcolaValoreExportStringFromInteger))
                exportFields.add(new ExportField("atto", getEtichetta(Etichette.Numero_Atto), ExportUtils.STRING_FORMAT, calcolaValoreExportStringFromInteger))
            } else {
                exportFields.add(new ExportField("anno", getEtichetta(Etichette.Anno), ExportUtils.INTEGER_FORMAT))
                exportFields.add(new ExportField("atto", getEtichetta(Etichette.Numero_Atto), ExportUtils.INTEGER_FORMAT))
            }
            if (ricercaAttoStampa.hasParte()) {
                exportFields.add(new ExportField("parte", getEtichetta(Etichette.Parte), ExportUtils.INTEGER_FORMAT))
            }
            if (ricercaAttoStampa.hasSerie()) {
                exportFields.add(new ExportField("serie", getEtichetta(Etichette.Serie)))
            }
            exportFields.add(new ExportField("ufficio", getEtichetta(Etichette.Ufficio), ExportUtils.INTEGER_FORMAT))

            exportFields.add(new ExportField("natura", getEtichetta(Etichette.Natura_Atto), ExportUtils.STRING_FORMAT, calcolaValoreExportEnum))

            exportFields.add(new ExportField("dataRegistrazione", getEtichetta(Etichette.Data_Registrazione), ExportUtils.DATE_FORMAT, calcolaValoreExportLista))

            if (ricercaAttoStampa.hasTipoLuogoEvento()) {
                exportFields.add(new ExportField("eventoNelComuneLista", getEtichetta(Etichette.Luogo), ExportUtils.STRING_FORMAT, calcolaValoreExportEnum))
            }

        }
        // campi per PDF
        else if (tipo == ETipoFile.PDF) {
            exportFields.add(new ExportField("natura","", ExportUtils.STRING_FORMAT, calcolaValoreNameEnum) )
            exportFields.add(new ExportField("cognome1Lista", etichetteCustom.get("Cognome1")))
            exportFields.add(new ExportField("nome1Lista", etichetteCustom.get("Nome1")))
            exportFields.add(new ExportField("comuneResidenza1", etichetteCustom.get("Residenza1"),     ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
            exportFields.add(new ExportField("codiceSesso1Lista", getEtichetta(Etichette.Sesso),        ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
            exportFields.add(new ExportField("codiceFiscale1", getEtichetta(Etichette.Codice_Fiscale),  ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
            exportFields.add(new ExportField("dataNascita1", getEtichetta(Etichette.Data_Nascita),      ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
            exportFields.add(new ExportField("comuneNascita1", getEtichetta(Etichette.Comune_Nascita),  ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
            switch(tipoAttoEnum) {
                case ETipoAtto.NAS:
                    exportFields.add(new ExportField("extra1Lista", etichetteCustom.get("Extra1"), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf)) // cognomeNomePadre
                    exportFields.add(new ExportField("extra2Lista", etichetteCustom.get("Extra2"), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf)) // cognomeNomeMadre
                    exportFields.add(new ExportField("extra3Lista","") )                                                                      // null
                    break
                case ETipoAtto.MOR:
                    exportFields.add(new ExportField("extra1Lista", etichetteCustom.get("Extra1"), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf)) // decodifica stato civile
                    exportFields.add(new ExportField("extra2Lista", etichetteCustom.get("Extra2"), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf)) // dataEventoLista
                    exportFields.add(new ExportField("extra3Lista", etichetteCustom.get("Extra3"), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf)) // comune - provincia decesso
                    break
                case ETipoAtto.CIT:
                    exportFields.add(new ExportField("extra1Lista", etichetteCustom.get("Extra1"), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf)) // codiceSesso1Lista
                    exportFields.add(new ExportField("extra2Lista", etichetteCustom.get("Extra2"), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf)) // dataEventoLista
                    exportFields.add(new ExportField("extra3Lista", etichetteCustom.get("Extra3"), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf)) // tipoAttoDomain?.getDescrizioneEstesa()
                    break
                case ETipoAtto.MAT:
                case ETipoAtto.UCI:
                    exportFields.add(new ExportField("cognome2Lista", etichetteCustom.get("Cognome2")))
                    exportFields.add(new ExportField("nome2Lista", etichetteCustom.get("Nome2")))
                    exportFields.add(new ExportField("comuneResidenza2", etichetteCustom.get("Residenza2"),     ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
                    exportFields.add(new ExportField("codiceSesso2Lista", getEtichetta(Etichette.Sesso),        ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
                    exportFields.add(new ExportField("codiceFiscale2", getEtichetta(Etichette.Codice_Fiscale),  ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
                    exportFields.add(new ExportField("dataNascita2", getEtichetta(Etichette.Data_Nascita),      ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
                    exportFields.add(new ExportField("comuneNascita2", getEtichetta(Etichette.Comune_Nascita),  ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
                    exportFields.add(new ExportField("dataEventoLista", etichetteCustom.get("DataEvento"),      ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
                    exportFields.add(new ExportField("comuneMatrimonio", etichetteCustom.get("LuogoEvento"),    ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
                    break
            }
            exportFields.add(new ExportField("estremiAttoLista", etichetteCustom.get("Atto"), ExportUtils.STRING_FORMAT))
        }

        StringBuilder b = new StringBuilder(msgTitle)
        b.append(getNomeFileXAnno(getEtichetta(Etichette.Anno), ricercaAttoStampa.annoDa, ricercaAttoStampa.annoA))
        b.append(getNomeFileXData(getEtichetta(Etichette.Data_Evento), ricercaAttoStampa.dataEventoDa, ricercaAttoStampa.dataEventoA))
        b.append(getNomeFileXData(getEtichetta(Etichette.Data_Registrazione), ricercaAttoStampa.dataRegistrazioneDa, ricercaAttoStampa.dataRegistrazioneA))
        b.append(getNomeFileXStato(getEtichetta(Etichette.Stato), getEtichetta(ricercaAttoStampa.stato.name())))

        Map reportParams = [
                TIPO_ATTO: tipoAttoEnum.getId(),
                ENTE: statoCivileService.getComuneCliente().getDescrizioneComune(),
                TITOLO: (etichetteCustom.get("Elenco") + " - " + getNomeFileXUfficio() + (ricercaAttoStampa.stato == EStatoAtto.IN_INSERIMENTO?"\n" + getEtichetta(ricercaAttoStampa.stato.name()).toUpperCase():"") ),
                FONTE: getEtichetta(Etichette.FONTE) + " " + getEtichetta(Etichette.STATO_CIVILE),
                PARAMETRI: getParametri([
                        [label: getEtichetta(Etichette.Anno), da: ricercaAttoStampa.annoDa, a: ricercaAttoStampa.annoA],
                        [label: getEtichetta(Etichette.Data_Evento), da: ricercaAttoStampa.dataEventoDa, a: ricercaAttoStampa.dataEventoA],
                        [label: getEtichetta(Etichette.Data_Registrazione), da: ricercaAttoStampa.dataRegistrazioneDa, a: ricercaAttoStampa.dataRegistrazioneA]
                ]),
                TOTALE: getEtichetta(Etichette.Totale_Atti),
                MASCHI: getEtichetta(Etichette.Maschi),
                FEMMINE: getEtichetta(Etichette.Femmine),
                ND: getEtichetta(Etichette.Non_conosciuto),
                ANNULLATI: getEtichetta(Etichette.Di_cui_annullati)
        ]
        ExportObject eo = new ExportObject((ricercaAttoStampa.isDoppioSoggetto() ? "stampa_atti_doppi" : "stampa_atti"), exportFields, listaExport, reportParams, null, csvCharsetName)
        exportService.export(tipo, eo, b.toString())
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

}