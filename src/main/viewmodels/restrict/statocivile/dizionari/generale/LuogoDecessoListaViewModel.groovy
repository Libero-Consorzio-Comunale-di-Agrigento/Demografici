package restrict.statocivile.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ILuogoEvento
import it.finmatica.de4gsdzk.statocivile.CivLuogoDecesso
import it.finmatica.de4gsdzk.statocivile.CivLuogoDecessoService
import it.finmatica.de4gsdzk.utils.ETipoEvento
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.utils.Sezione
import it.finmatica.de4gsdzk.utils.SqlUtils
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Sort
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class LuogoDecessoListaViewModel extends LuogoEventoListaViewModel{

    @WireVariable
    private CivLuogoDecessoService civLuogoDecessoService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("sezioni") List<Sezione> sezioniLuogo,
               @ExecutionArgParam("opener") Component opener) {

        List<Map<String, String>> eList = CivLuogoDecesso.etichetteDomain

        doInit(w, sezioniLuogo, opener, ETipoEvento.Decesso, eList)
    }

    String getUriDettaglio(){
        return "/restrict/statocivile/dizionari/generale/luogoDecessoDettaglio.zul"
    }

    Paginazione eseguiQuery(Boolean usePaging){
        PageRequest pr = new PageRequest((usePaging?activePage:0), (usePaging?pageSize:Integer.MAX_VALUE), new Sort(selectedOrder?.campi))
        Page<CivLuogoDecesso> p = civLuogoDecessoService.listAllByDescrizioneLike(SqlUtils.beginsAndEndsLike(filtro), pr)
        return new Paginazione((p?.getContent()?:[]), (p?.getTotalElements()?:0))
    }

    void eliminaLuogo(ILuogoEvento luogo){
        if (deleteEnabled){
            civLuogoDecessoService.delete(luogo)
            onRicarica()
        }
    }

}
