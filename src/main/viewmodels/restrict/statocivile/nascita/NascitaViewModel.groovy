package restrict.statocivile.nascita

import groovy.util.logging.Slf4j
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class NascitaViewModel {

   /* Window self

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w
    }

    int selectedChildIndex = 0
    def listaN
    def recordN

    @AfterCompose afterCompose() {

    }

    @Command void onGoNext() {
        selectedChildIndex++
        BindUtils.postNotifyChange(null, null, this, "selectedChildIndex")
    }

    @Command void onGoPrevious() {
        if (selectedChildIndex > 0){
            selectedChildIndex--
        }
        BindUtils.postNotifyChange(null, null, this, "selectedChildIndex")
    } */


}
