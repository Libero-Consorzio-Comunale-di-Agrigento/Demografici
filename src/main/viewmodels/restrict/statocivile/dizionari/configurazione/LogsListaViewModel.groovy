package restrict.statocivile.dizionari.configurazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.ETipoLog
import org.zkoss.bind.annotation.Command
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.afc.AbstractLogsListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class LogsListaViewModel extends AbstractLogsListaViewModel {

    Boolean anscOn = Boolean.FALSE

    List<ETipoLog> listaTipiLog = [ETipoLog.Doc_Area, ETipoLog.Firma_Remota, ETipoLog.Istat, ETipoLog.ANPR, ETipoLog.Gestione_Testi]

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map<String, String>> eList = []

        anscOn = arcParametroService.isIntegrazioneAnscAttiva()
        if (anscOn){
            listaTipiLog.add(ETipoLog.ANSC)
        }

        doInit(eList)
    }
}
