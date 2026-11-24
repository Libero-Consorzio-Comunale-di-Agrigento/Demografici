package restrict.statocivile.dizionari.comunicazioni

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.errors.RecordDuplicatoRuntimeException
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class ComunicazioneEnteDettaglioViewModel extends DizionarioDettaglioViewModel {

    CivComunicazioneEnte dettaglio

    ETipoOperazione tipoOperazione

    ETipoAtto tipoAttoEnum
    ETipoComunicazione tipoComunicazione

    List<CivEnte> listaEnti

    @WireVariable private CivComunicazioneEnteService civComunicazioneEnteService
    @WireVariable private CivEnteService civEnteService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("tipoAtto") Integer tipoAtto){
        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Annotazione"), Etichette.getEtichetta("Comunicazioni_Ente")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Errore_Inserimento_Relazione_Duplicata")])

        eList.addAll(CivComunicazioneEnte.etichetteDomain)

        // Aggiungo etichette tipo atto
        eList.addAll(ETipoAtto.values()*.getEtichettaDesc())

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Comunicazioni_Ente"))

        formLabel = msgTitle?.toUpperCase()

        listaEnti = civEnteService.listAll(new Sort(SortUtils.idAsc)) as List<CivEnte>

        if (id != null) {
            caricaDettaglio(id)
        } else {
            creaDettaglio([tipoAtto: tipoAtto])
        }

        if (dettaglio.tipoAtto.intValue() != 0){
            this.tipoAttoEnum = TipoAttoUtils.fromValoreDefault(dettaglio.tipoAtto)
            tipoComunicazione = ETipoComunicazione.A
        } else {
            tipoComunicazione = ETipoComunicazione.N
        }

        resize()
    }

    void caricaDettaglio(def id) {
        if (id != null) {
            dettaglio = civComunicazioneEnteService.get(id)
            tipoOperazione = ETipoOperazione.UPD
        }
        refreshUi()
    }

    void creaDettaglio(Map params) {
        dettaglio = new CivComunicazioneEnte(tipoAtto: params.tipoAtto)
        tipoOperazione = ETipoOperazione.INS
    }

    @Command
    void onSalvaRecord() {
        if (dettaglio) {
            try {
                CivComunicazioneEnte c = civComunicazioneEnteService.save(dettaglio)
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Salvataggio_Completato")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                caricaDettaglio(c.id)
            } catch(RecordDuplicatoRuntimeException ignore) {
                Messagebox.show((getEtichetta(ignore.getEtichetta())?:ignore.getMessage()), msgTitle, Messagebox.OK, Messagebox.ERROR)
            }
        }
    }

    @Command
    void onSelectComunicazione(@ContextParam(ContextType.TRIGGER_EVENT) Event event) {
        if (tipoOperazione.isUpdate()) {
            return
        }
        CivComunicazione c = null
        if (event?.target?.selectedItem instanceof CivComunicazione) {
            c = (CivComunicazione) event.target.selectedItem
        }
        dettaglio.comunicazione = c
        refreshUi()
    }

    @Command void onCancellaComunicazione(){
        onSelectComunicazione(null)
    }

    String getTipo() {
        return tipoAttoEnum ? getEtichettaEnum(tipoAttoEnum) : getEtichetta(Etichette.getEtichetta("Annotazione"))
    }

}