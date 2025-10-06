package restrict.statocivile.cittadinanza

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivCategoriaTipoAtto
import it.finmatica.de4gsdzk.utils.ETipoRichiesta
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.MotivoRichiestaSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MotivoCittadinanzaSelectViewModel extends MotivoRichiestaSelectViewModel {
    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("categoria") CivCategoriaTipoAtto categoria,
         @ExecutionArgParam("tipoRichiesta") ETipoRichiesta tipoRichiesta) {
        doInit(w, categoria, tipoRichiesta)
    }
}
