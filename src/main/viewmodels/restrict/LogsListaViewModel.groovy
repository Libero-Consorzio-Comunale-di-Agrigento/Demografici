package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.ETipoLog
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
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
    Boolean wsMinIntAttivo = Boolean.FALSE

    List<ETipoLog> listaTipiLog = []

    @WireVariable
    private ArcParametroService arcParametroService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("sezione") String sezione) {
        self = w

        wsMinIntAttivo = arcParametroService.isWsMinintAttivo()
        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        EGruppo gruppo = EGruppo.valueOf(sezione.toUpperCase())
        switch (gruppo) {
            case EGruppo.CIV:
                listaTipiLog = [ETipoLog.Doc_Area, ETipoLog.Firma_Remota, ETipoLog.Istat, ETipoLog.ANPR, ETipoLog.Gestione_Testi]
                if (anscOn) {
                    listaTipiLog.add(ETipoLog.ANSC)
                }
                break
            case EGruppo.CER:
                listaTipiLog = [ETipoLog.ANPR, ETipoLog.Gestione_Testi]
                if (anscOn) {
                    listaTipiLog.add(ETipoLog.ANSC)
                }
                if (arcParametroService.isIntegrazionePagamentiAttiva()) {
                    listaTipiLog.add(ETipoLog.Wspa)
                }
                break
            case EGruppo.ANA:
                listaTipiLog = [ETipoLog.ANPR, ETipoLog.Gsd, ETipoLog.Gestione_Testi]
                break
            case EGruppo.LEV:
                listaTipiLog = []
                break
            case EGruppo.ELE:
                if (wsMinIntAttivo) {
                    listaTipiLog.add(ETipoLog.Ws_min_int)
                }
                break
        }

        doInit([])
    }
}
