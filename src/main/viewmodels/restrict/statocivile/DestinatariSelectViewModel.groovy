package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.IComunicazioneDestinatario
import it.finmatica.de4gsdzk.statocivile.CivComunicazioneDestinatarioService
import it.finmatica.de4gsdzk.statocivile.CivEnteService
import it.finmatica.de4gsdzk.utils.ETipoEnteDestinatario
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractDestinatariSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class DestinatariSelectViewModel extends AbstractDestinatariSelectViewModel{

    @WireVariable
    private CivEnteService civEnteService

    @WireVariable
    private CivComunicazioneDestinatarioService civComunicazioneDestinatarioService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("idArcCom") Long idArcCom) {
        self = w

        doInit(idArcCom)

    }

    List<IComunicazioneDestinatario> popolaListaDestinatariDaEscludere(Long idArcCom) {
        return civComunicazioneDestinatarioService.listAllByArchivioComunicazione(idArcCom)
    }


    Paginazione eseguiQuery(Boolean usePaging) {
        log.info("usePaging: " + usePaging)

        switch (tipoEnteDestinatario) {
            case ETipoEnteDestinatario.ENTE:
                ente = null
                if (idEntiDaEscludere.size() > 0){
                    listaEnti = civEnteService.listAllByTipoEnteDestinatarioAndIdNotIn(tipoEnteDestinatario, idEntiDaEscludere)
                } else {
                    listaEnti = civEnteService.listAllByTipoEnteDestinatario(tipoEnteDestinatario)
                }
                break
            case ETipoEnteDestinatario.COMUNE:
                comune = null
                break
            default:
                Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
                break
        }
        return null
    }

}
