package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.Sezione
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class IndexViewModel extends AbstractIndexViewModel {

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        logoEnte = null

        doInit([])

        selectedModulo = new Sezione("HOME PAGE", 'home', "Home page", "/restrict/home/index.zul", "home.png")
    }

    void loadSezioni() {
        log.info('Sono in home page')
    }

    @Override
    protected void loadHeaderFunctions() {
        headerFunctions = [:]
    }

}
