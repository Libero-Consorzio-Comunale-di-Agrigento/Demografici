package restrict.statocivile.rubricaNascite

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.ExportService
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.export.ExportField
import it.finmatica.de4gsdzk.export.ExportObject
import it.finmatica.de4gsdzk.export.ExportUtils
import it.finmatica.de4gsdzk.statocivile.CivRubricaNascite
import it.finmatica.de4gsdzk.statocivile.CivRubricaNasciteService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarStampaAttributes
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.TraitComune
import restrict.statocivile.AbstractStampaAttiListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StampaRubricaNasciteListaViewModel extends AbstractStampaAttiListaViewModel implements TraitComune {

    List<CivRubricaNascite> lista
    CivRubricaNascite dettaglio

    final List<ESesso> listaSesso = [null] + ESesso.values().toList()

    List<OrderBy> listaOrder = []
    OrderBy selectedOrder

    @Delegate
    ControlBarStampaAttributes cbStampa = new ControlBarStampaAttributes()

    @WireVariable
    private CivRubricaNasciteService civRubricaNasciteService

    @WireVariable
    private ArcComuneBaseService arcComuneBaseService

    @WireVariable
    private ExportService exportService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        backFromListEnabled = true
        pagingEnabled = true
        excelExportEnabled = true
        csvExportEnabled = true
        pdfExportEnabled = true

        ricerca = new RicercaRubricaNascite()

        List<Map<String, String>> eList = [Etichette.Rubrica_Nascite, Etichette.Effettua_Ricerca, Etichette.Cancella,
                                           Etichette.Data_Registrazione_decrescente, Etichette.Data_Registrazione_crescente,
                                           Etichette.Generalita_crescente, Etichette.Generalita_decrescente,
                                           Etichette.Data_Nascita_decrescente, Etichette.Data_Nascita_crescente,
                                           Etichette.FONTE, Etichette.STATO_CIVILE, Etichette.Tutti_gli_uffici,
                                           Etichette.Residenza, Etichette.Dal, Etichette.Al, Etichette.Atto_Nascita,
                                           Etichette.Totale_Atti, Etichette.Maschi, Etichette.Femmine, Etichette.Non_conosciuto]
        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_campi_estrazione])

        eList.addAll(RicercaRubricaNascite.etichetteRicercaRubricaDesc)
        eList.addAll(CivRubricaNascite.etichetteDomain)

        // Aggiungo etichette liste chiuse
        eList += ESesso.values()*.getEtichettaDesc() as Map

        doInit(eList)

        msgTitle = getEtichetta(Etichette.Rubrica_Nascite)

        formLabel = msgTitle?.toUpperCase() + " (" + getEtichetta(Etichette.Estrazioni)?.toUpperCase() + ")"

        //ordinamento
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Registrazione_decrescente),          SortUtils.dataRegistrazioneDescOnly))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Registrazione_crescente),            SortUtils.dataRegistrazioneAscOnly))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_crescente),                    SortUtils.cognomeNomeAsc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Generalita_decrescente),                  SortUtils.cognomeNomeDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Nascita_decrescente),                SortUtils.dataNascitaDesc))
        listaOrder.add(new OrderBy(getEtichetta(Etichette.Data_Nascita_crescente),                  SortUtils.dataNascitaAsc))

        selectedOrder = listaOrder[0]

        resize()
    }

    @Override void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    @Override Paginazione eseguiQuery(Boolean usePaging) {
        PageRequest pr = new PageRequest( usePaging?activePage:0, usePaging?pageSize:Integer.MAX_VALUE, new Sort(selectedOrder.campi))

        Page<CivRubricaNascite> p = null
        try{
            p = civRubricaNasciteService.search(((RicercaRubricaNascite) ricerca), pr)
        } catch (CampoMandatoryRuntimeException ex) {
            resetRicerca()
            Messagebox.show((getEtichetta(ex.getEtichetta())?:getEtichetta(EtichetteMessaggi.Compilare_campi_estrazione)), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        switch (tca) {
            case ETipoComuneAtto.CA_SOGG_1_NAS:
                ((RicercaRubricaNascite) ricerca).descrizioneComuneAttoNascita = c?.descrizioneComune
                ((RicercaRubricaNascite) ricerca).codiceProvinciaAttoNascita = c?.codiceProvincia
                ((RicercaRubricaNascite) ricerca).codiceComuneAttoNascita = c?.codiceComune
                break
        }
        refreshUi()
    }

    void esporta(ETipoFile tipo){
        // Popolo la lista nella form
        onRicarica()
        if ( (lista == null) || (lista.isEmpty()) ){
            Messagebox.show(getEtichetta(Etichette.Nessun_record_trovato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            return
        }

        Paginazione p = eseguiQuery(Boolean.FALSE)
        List<CivRubricaNascite> listaExport = p?.lista
        if ( (listaExport == null) || (listaExport.isEmpty()) ){
            return
        }

        List<ExportField> exportFields = []

        if ( (tipo == ETipoFile.XLS) || (tipo == ETipoFile.CSV) ) {

            exportFields.add(new ExportField("cognome", getEtichetta(Etichette.Cognome)))
            exportFields.add(new ExportField("nome", getEtichetta(Etichette.Nome)))

            exportFields.add(new ExportField("codiceSesso1Lista", getEtichetta(Etichette.Sesso)))

            exportFields.add(new ExportField("dataNascita", getEtichetta(Etichette.Data_Nascita), ExportUtils.DATE_FORMAT))

            if (tipo == ETipoFile.CSV) {
                exportFields.add(new ExportField("annoRegistrazione", getEtichetta(Etichette.Anno_Registrazione), ExportUtils.STRING_FORMAT, calcolaValoreExportStringFromInteger))
            } else {
                exportFields.add(new ExportField("annoRegistrazione", getEtichetta(Etichette.Anno_Registrazione), ExportUtils.INTEGER_FORMAT))
            }
            exportFields.add(new ExportField("dataRegistrazione", getEtichetta(Etichette.Data_Registrazione), ExportUtils.DATE_FORMAT))

            if (tipo == ETipoFile.CSV) {
                exportFields.add(new ExportField("anno", getEtichetta(Etichette.Anno), ExportUtils.STRING_FORMAT, { it, propertyName -> calcolaValoreExportStringFromInteger(it?.attoNascita, 'anno') }))
                exportFields.add(new ExportField("atto", getEtichetta(Etichette.Numero_Atto), ExportUtils.STRING_FORMAT, { it, propertyName -> calcolaValoreExportStringFromInteger(it?.attoNascita, 'atto') }))
                exportFields.add(new ExportField("parte", getEtichetta(Etichette.Parte), ExportUtils.STRING_FORMAT, { it, propertyName -> calcolaValoreExportStringFromInteger(it?.attoNascita, 'parte') }))
                exportFields.add(new ExportField("serie", getEtichetta(Etichette.Serie), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.attoNascita?.serie ?: null }))
                exportFields.add(new ExportField("ufficio", getEtichetta(Etichette.Ufficio), ExportUtils.STRING_FORMAT, { it, propertyName -> calcolaValoreExportStringFromInteger(it?.attoNascita, 'ufficio') }))
            } else {
                exportFields.add(new ExportField("anno", getEtichetta(Etichette.Anno), ExportUtils.INTEGER_FORMAT, { it, propertyName -> it?.attoNascita?.anno ?: null }))
                exportFields.add(new ExportField("atto", getEtichetta(Etichette.Numero_Atto), ExportUtils.INTEGER_FORMAT, { it, propertyName -> it?.attoNascita?.atto ?: null }))
                exportFields.add(new ExportField("parte", getEtichetta(Etichette.Parte), ExportUtils.INTEGER_FORMAT, { it, propertyName -> (it?.attoNascita?.parte ?: null) as Number }))
                exportFields.add(new ExportField("serie", getEtichetta(Etichette.Serie), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.attoNascita?.serie ?: null }))
                exportFields.add(new ExportField("ufficio", getEtichetta(Etichette.Ufficio), ExportUtils.INTEGER_FORMAT, { it, propertyName -> (it?.attoNascita?.ufficio ?: null) as Number }))
            }
            exportFields.add(new ExportField("idAttoAnsc", getEtichetta(Etichette.Id_Atto_Ansc), ExportUtils.STRING_FORMAT, { it, propertyName -> it?.attoNascita?.idAttoAnsc ?: null }))
            exportFields.add(new ExportField("descrizioneComuneAttoNascita", getEtichetta(Etichette.Comune_Atto_Nascita)))
        } else if (tipo == ETipoFile.PDF) {
            exportFields.add(new ExportField("natura",  "",                                    ExportUtils.STRING_FORMAT, calcolaValoreExportNull))
            exportFields.add(new ExportField("cognome1Lista", getEtichetta(Etichette.Cognome)))
            exportFields.add(new ExportField("nome1Lista", getEtichetta(Etichette.Nome)))
            exportFields.add(new ExportField("comuneResidenza1", getEtichetta(Etichette.Paternita),     ExportUtils.STRING_FORMAT, {CivRubricaNascite e, String prop -> e.paternita}))
            exportFields.add(new ExportField("extra1Lista", getEtichetta(Etichette.Maternita)))
            exportFields.add(new ExportField("codiceSesso1Lista", getEtichetta(Etichette.Sesso),        ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
            exportFields.add(new ExportField("dataNascita1", getEtichetta(Etichette.Data_Nascita),      ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
            exportFields.add(new ExportField("codiceFiscale1", "",                             ExportUtils.STRING_FORMAT, calcolaValoreExportNull))
            exportFields.add(new ExportField("extra2Lista", getEtichetta(Etichette.Data_Registrazione), ExportUtils.STRING_FORMAT, calcolaValoreExportPdf))
            exportFields.add(new ExportField("comuneNascita1", getEtichetta(Etichette.Comune_Nascita)))
            exportFields.add(new ExportField("extra3Lista", getEtichetta(Etichette.Comune_Atto_Nascita)))
            exportFields.add(new ExportField("estremiAttoLista", getEtichetta(Etichette.Atto_Nascita)))
        }

        StringBuilder b = new StringBuilder(msgTitle)
        b.append(getNomeFileXAnno(getEtichetta(Etichette.Anno_Registrazione), ((RicercaRubricaNascite) ricerca).annoRegistrazioneDa, ((RicercaRubricaNascite) ricerca).annoRegistrazioneA))
        b.append(getNomeFileXData(getEtichetta(Etichette.Data_Registrazione), ((RicercaRubricaNascite) ricerca).dataRegistrazioneDa, ((RicercaRubricaNascite) ricerca).dataRegistrazioneA))

        Map reportParams = [
                TIPO_ATTO: "RNA",
                ENTE: arcComuneBaseService.getComuneCliente().getDescrizioneComune(),
                TITOLO: getEtichetta(Etichette.Rubrica_Nascite),
                FONTE: getEtichetta(Etichette.FONTE) + " " + getEtichetta(Etichette.STATO_CIVILE),
                PARAMETRI: getParametri([
                        [label: getEtichetta(Etichette.Anno_Registrazione), da: ((RicercaRubricaNascite) ricerca).annoRegistrazioneDa, a: ((RicercaRubricaNascite) ricerca).annoRegistrazioneA],
                        [label: getEtichetta(Etichette.Data_Registrazione), da: ((RicercaRubricaNascite) ricerca).dataRegistrazioneDa, a: ((RicercaRubricaNascite) ricerca).dataRegistrazioneA],
                        [label: getEtichetta(Etichette.Data_Nascita), da: ((RicercaRubricaNascite) ricerca).dataNascitaDa, a: ((RicercaRubricaNascite) ricerca).dataNascitaA]
                ]),
                TOTALE: getEtichetta(Etichette.Totale_Atti),
                MASCHI: getEtichetta(Etichette.Maschi),
                FEMMINE: getEtichetta(Etichette.Femmine),
                ND: getEtichetta(Etichette.Non_conosciuto)
        ]
        ExportObject eo = new ExportObject("stampa_atti", exportFields, listaExport, reportParams, null, csvCharsetName)
        exportService.export(tipo, eo, b.toString())
    }

    void resetLista(){
        lista = []
        refreshLista()
    }

}
