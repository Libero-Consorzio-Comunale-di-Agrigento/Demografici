package restrict.statocivile.rubricaNascite

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.anagrafe.AnaAnagrafeBaseDomain
import it.finmatica.de4gsdzk.archivi.ArcComune
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.CivRubricaNascite
import it.finmatica.de4gsdzk.statocivile.CivRubricaNasciteService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarDettaglioAttributes
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDettaglioViewModel
import restrict.TraitCancellazioneCampi
import restrict.TraitComune
import restrict.TraitGestioneCaseCampi

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RubricaNasciteDettaglioViewModel extends AbstractDettaglioViewModel implements TraitCancellazioneCampi, TraitGestioneCaseCampi, TraitComune {

    CivRubricaNascite dettaglio

    final List<ESesso> listaSesso = ESesso.values().toList()

    Map<String, Boolean> minuscole = [:]

    Boolean ricercaSoggettoInANPROn = Boolean.TRUE

    @Delegate ControlBarDettaglioAttributes cbDettaglio = new ControlBarDettaglioAttributes()

    @WireVariable
    private CivRubricaNasciteService civRubricaNasciteService

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private ArcComuneBaseService arcComuneBaseService

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id) {

        self = w

        saveRecordEnabled = true
        deleteRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Rubrica_Nascite"), Etichette.getEtichetta("Cancella"), Etichette.getEtichetta("Minuscole"),
                                           Etichette.getEtichetta("SEZIONE_DATI_REGISTRAZIONE"), Etichette.getEtichetta("SEZIONE_DATI_NASCITA"), Etichette.getEtichetta("SEZIONE_DATI_ATTO"), Etichette.getEtichetta("SEZIONE_GENITORI")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Errore_Inserimento_Record_Rubrica_Duplicato"), Etichette.getEtichetta("Errore_data_futura"),
                      Etichette.getEtichetta("Ask_Cancellazione_Record"), Etichette.getEtichetta("Ask_Conferma_Salvataggio")])

        eList.addAll(etichetteDettaglioDefault)
        eList.addAll(CivRubricaNascite.etichetteDomain)

        // Aggiungo etichette della Controlbar
        eList.addAll(ControlBarDettaglioAttributes.etichetteCbDettaglioDesc)

        // Aggiungo etichette sesso
        eList += ESesso.values()*.getEtichettaDesc() as Map

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Rubrica_Nascite"))

        formLabel = msgTitle?.toUpperCase()

        minuscole = [cognome:Boolean.FALSE, nome: Boolean.FALSE,
                     cognomePadre:Boolean.FALSE, nomePadre: Boolean.FALSE,
                     cognomeMadre:Boolean.FALSE, nomeMadre: Boolean.FALSE]
        arcParametroService.checkMinuscoleOn(minuscole)

        ricercaSoggettoInANPROn = arcParametroService.isRicercaSoggettoInANPRAttiva()

        if (id) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([annoRegistrazione: DataUtils.getAnnoCorrente()])
        }
    }

    @Override
    void caricaDettaglio(Object id) {
        dettaglio = civRubricaNasciteService.get((Long) id)

        DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)

        refreshUi()
    }

    @Override
    void creaDettaglio(Map params) {
        dettaglio = civRubricaNasciteService.create(params)
        ArcComune comune = arcComuneBaseService.getComuneCliente()
        if (comune) {
            riempiComune(dettaglio.comuneNascita, comune)
        }
    }

    @Command void onSelectDataNascita(){
        if (DataUtils.isDataFutura(dettaglio.dataNascita)){
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_data_futura")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
//        else {
//            if ( (dettaglio.attoNascita.anno == null) && (dettaglio.dataNascita != null) ){
//                dettaglio.attoNascita.anno = DataUtils.getAnnoFromData(dettaglio.dataNascita)
//            }
//            refreshUi()
//        }
    }

    void selezionaComune(ETipoComuneAtto tca, ArcComuneBaseDomain c){
        switch (tca) {
            case ETipoComuneAtto.CN_NATO:
                riempiComune(dettaglio.comuneNascita, c)
                break
            case ETipoComuneAtto.CA_SOGG_1_NAS:
                dettaglio.codiceComuneAttoNascita = c?.codiceComune
                dettaglio.descrizioneComuneAttoNascita = c?.descrizioneComune
                dettaglio.codiceProvinciaAttoNascita = c?.codiceProvincia
                dettaglio.siglaProvinciaAttoNascita = c?.siglaProvincia
                break
        }
        refreshUi()
    }

    @Command void onCancellaCampoRubrica(@ContextParam(ContextType.TRIGGER_EVENT) Event e){
        onCancellaCampo(e)
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            salvaInRubrica()
        }
    }

    void salvaInRubrica(boolean force=false) {
        try {
            CivRubricaNascite c = civRubricaNasciteService.save(dettaglio, force)
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        } catch(RecordDuplicatoRuntimeException r) {
            Messagebox.show(etichette[r.getMessage()] + "\n" + getEtichetta(Etichette.getEtichetta("Ask_Conferma_Salvataggio")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK == e.getName()) {
                            salvaInRubrica(true)
                        }
                    }
                }
            )
        }
    }

    @Command void onEliminaRecord() {
        if (userModifyEnabled) {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Ask_Cancellazione_Record")), msgTitle, Messagebox.OK | Messagebox.CANCEL, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_OK.equals(e.getName())) {
                            eliminaNascitaInRubrica()
                            onChiudi()
                        }
                    }
                }
            )
        }
    }

    void eliminaNascitaInRubrica(){
        if (deleteRecordEnabled && userModifyEnabled) {
            civRubricaNasciteService.delete(dettaglio)
        }
    }

    Boolean isUserModifyEnabled(){
        //FIXME competenze
        //return competenzaService.hasRuolo(ConfigurazioneUtils.RUOLO_CIV_SU)
        return true
    }

    @Command void onCaricaSoggetti(@BindingParam("tipoSoggetto") String tipoSoggetto){
        ETipoSoggetto ts = ETipoSoggetto.valueOf(tipoSoggetto)
        Map params
        if (ts == ETipoSoggetto.NATO_A){
            params = [cognome: dettaglio.getCognome(), nome: dettaglio.getNome(), sesso : dettaglio.getSesso(), dataNascita: dettaglio.getDataNascita()]
        }
        if (params){
            Window w = (Window) Executions.createComponents(FormUtils.getUriAnagrafeSelect(ricercaSoggettoInANPROn), self, params)
            w.addEventListener(CustomEvents.ON_SELECT_RECORD, { event ->
                if (event.data instanceof AnaAnagrafeBaseDomain){
                    AnaAnagrafeBaseDomain ana = (AnaAnagrafeBaseDomain)event.data
                    if (ts == ETipoSoggetto.NATO_A){

                        dettaglio.cognome = ana?.cognome
                        dettaglio.nome = ana?.nome
                        dettaglio.sesso = ana?.sesso
                        dettaglio.dataNascita = ana?.dataNascita
                        dettaglio.comuneNascita.codice = ana?.codiceComuneNascita
                        dettaglio.comuneNascita.descrizione = ana?.descrizioneComuneNascita
                        dettaglio.comuneNascita.codiceProvincia = ana?.codiceProvinciaNascita
                        dettaglio.comuneNascita.siglaProvincia = ana?.siglaProvinciaNascita

                        dettaglio.attoNascita = ana?.attoNascita
                        dettaglio.codiceComuneAttoNascita = ana?.comuneAttoNascita?.codice
                        dettaglio.codiceProvinciaAttoNascita = ana?.comuneAttoNascita?.codiceProvincia
                        dettaglio.descrizioneComuneAttoNascita = ana?.comuneAttoNascita?.descrizione
                        dettaglio.siglaProvinciaAttoNascita = ana?.comuneAttoNascita?.siglaProvincia

                        dettaglio.cognomePadre = ana?.cognomePadre
                        dettaglio.nomePadre = ana?.nomePadre
                        dettaglio.cognomeMadre = ana?.cognomeMadre
                        dettaglio.nomeMadre = ana?.nomeMadre

                        DomainUtils.allineaTestoMinuscole(dettaglio, minuscole)
                    }
                    refreshUi()
                }
            })
            w.doModal()
        }
    }
}
