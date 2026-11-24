package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.*
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.BindingParam
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class GestioneCaratteriSpecialiViewModel extends AbstractCommonViewModel {

    GsdBaseDomain dettaglio
    EGruppo gruppo

    @WireVariable
    private GsdEtichettaService gsdEtichettaService
    @WireVariable
    private GsdService gsdService
    @WireVariable
    private CampiCaratteriSpecialiDizionarioService campiCaratteriSpecialiDizionarioService
    @WireVariable
    private CampiCaratteriSpecialiService campiCaratteriSpecialiService

    List<CampoCaratteriSpecialiDizionario> listaTipologiaCampi
    List<CampoCaratteriSpeciali> listaCampiSpeciali

    List<CampoCaratteriSpeciali> listaCampiSpecialiCancellati = []


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("gruppo") EGruppo gruppo,
         @ExecutionArgParam("dettaglio") GsdBaseDomain dettaglio) {

        self = w
        this.dettaglio = dettaglio
        this.gruppo = gruppo

        listaTipologiaCampi = campiCaratteriSpecialiDizionarioService.findAllByGruppoIn([EGruppo.GSD] + gruppo)
        listaCampiSpeciali = campiCaratteriSpecialiService.findAllByTabellaAndIdRif(dettaglio.getTableName(), dettaglio.id.toString())

        List<Map<String, String>> eList = CampoCaratteriSpeciali.etichetteDomain
        eList.addAll([Etichette.getEtichetta("inserisci_campo_tooltip"), Etichette.getEtichetta("elimina_campo_tooltip"),
                      Etichette.getEtichetta("Salva"), Etichette.getEtichetta("Chiudi")])

        msgTitle = getEtichetta(Etichette.getEtichetta("Caratteri_Speciali"))
        formLabel = msgTitle?.toUpperCase()

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

    }

    @Command
    void onChiudi() {
        Events.postEvent(Events.ON_CLOSE, self, [:])
    }

    @Command
    void onSalva() {
        checkDatiObbligatori()

        for(CampoCaratteriSpeciali c : listaCampiSpecialiCancellati) {
            campiCaratteriSpecialiService.delete(c)
        }

        for (CampoCaratteriSpeciali c : listaCampiSpeciali) {
            if(c.id == null) {
                c.id = gsdService.getIdFromSequence(c, c.getTableName())
            }
            c.cognome = c.cognome.toUpperCase()
            c.nome = c.nome.toUpperCase()
            campiCaratteriSpecialiService.saveOrUpdate(c)
        }

        onChiudi()
    }

    private void checkDatiObbligatori() {
        for (CampoCaratteriSpeciali c : listaCampiSpeciali) {
            if(c.campo == null || c.cognome == null || c.nome == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"))
            }

        }

    }

    @Command
    void onInserisciCampo() {
        CampoCaratteriSpeciali campo = new CampoCaratteriSpeciali()
        campo.tabella = dettaglio.getTableName()
        campo.idRif = dettaglio.id.toString()

        listaCampiSpeciali.add(campo)
        refreshUi()
    }

    @Command
    void onEliminaCampo(@BindingParam("campo") CampoCaratteriSpeciali campo) {
        listaCampiSpeciali.remove(campo)
        if(campo.id != null) {
            //Tengo traccia del campo -> l'eliminazione definitiva la farò al momento del salvataggio
            listaCampiSpecialiCancellati.add(campo)
        }

        refreshUi()
    }

    @Command
    void onSelectTipo(@BindingParam("campo") CampoCaratteriSpeciali campo) {

        String cognomeNome = gsdService.getCognomeNome(campo.tabella, campo.idRif, campo.campo)

        if(cognomeNome != null) {
            String[] parts = cognomeNome.split('/')
            campo.cognome = parts[0].trim().toUpperCase()
            campo.nome = parts[1].trim().toUpperCase()
        } else {
            campo.cognome = null
            campo.nome = null
        }

        refreshUi()
    }



}
