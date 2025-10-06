package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IstMscMsuBaseDomain
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.ETipoModelloIstat
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class AnnotazioneSDSUDettaglioViewModel extends IstatDettaglioParentViewModel{

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAnnotazione") Long pkAnnotazione,
               @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.SEZIONE_MODELLO_SDSU, Etichette.SEZIONE_DATI_PROCEDURA,
                           Etichette.SEZIONE_DATI_MATRIMONIO, Etichette.SEZIONE_MARITO, Etichette.SEZIONE_MOGLIE,
                           Etichette.SEZIONE_DATI_UNIONE_CIVILE, Etichette.SEZIONE_CONTRAENTE_1, Etichette.SEZIONE_CONTRAENTE_2]

        eList.addAll(IstMscMsuBaseDomain.etichetteDomain)

        doInit(eList, tipoAttoEnum, ETipoModelloIstat.PROVV, Etichette.SEZIONE_MODELLO_SDSU)

        if (pkAtto && pkAnnotazione){
            caricaAtto(tipoAttoEnum, pkAtto, [fetch:[[campo:'nazionalita1', tipo: JoinType.LEFT], [campo:'nazionalita2', tipo: JoinType.LEFT]]])

            List<Long> ll = caricaListaIdModelliDaAnnotazione(pkAnnotazione)
            if (ll.size() == 1){
                caricaDettaglio(ll.get(0))
            } else {
                Messagebox.show("Errore in fase di recupero modello per l'annotazione selezionata", msgTitle, Messagebox.OK, Messagebox.ERROR)
                onChiudi()
            }

            caricaListeArchivi("ISTMSDSU_V_DIZ", dettaglio.anno)

            caricaListaTipoProvvedimento()

            caricaListeStatoCivile()

        } else {
            onChiudi()
        }
    }

}
