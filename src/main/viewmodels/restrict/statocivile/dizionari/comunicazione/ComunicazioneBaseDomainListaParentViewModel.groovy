package restrict.statocivile.dizionari.comunicazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivComunicazione
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneRelazioneBaseDomain
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import it.finmatica.de4gsdzk.utils.ETipoIndividuiAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class ComunicazioneBaseDomainListaParentViewModel<E extends CivComunicazioneRelazioneBaseDomain> extends DizionarioListaViewModel {

    CivComunicazione comunicazione

    E dettaglio
    List<E> lista

    Component opener

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    void doInit(Window w, List<Map<String, String>> eList=[]) {

        self = w

        deleteEnabled = true

        eList.addAll(CivComunicazioneRelazioneBaseDomain.etichetteDomain)

        // etichette delle enum
        eList += ETipoIndividuiAtto.values()*.getEtichettaDesc() as Map

        doInitEtichette(eList)

        totalSizeLabel = ""

    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)
        refreshUi()
    }

    void resetDettaglio() {
        dettaglio = null
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    @Command void onModifica() {
        if (modifyEnabled && dettaglio) {
            if (userModifyEnabled) {
                apriDettaglio(getUriDettaglio(), (opener?:self), [id: dettaglio.id])
            } else {
                Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        }
    }

    abstract void eliminaRelazione(E c)

    void eliminaRecord(){
        if (deleteEnabled && dettaglio){
            eliminaRelazione(dettaglio)
        }
    }

}
