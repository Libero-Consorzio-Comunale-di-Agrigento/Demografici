package restrict.statocivile.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.utils.CustomEvents
import it.finmatica.de4gsdzk.utils.ETipoEvento
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Sezione
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractResizedViewModel

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichettaEnum

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class LuogoViewModel extends AbstractResizedViewModel{

    Window self

    Map etichette = [:]

    List<Sezione> sezioniLuogo = []
    Sezione selectedSezioneLuogo

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Luogo")]
        // Aggiungo etichette tipo luogo
        eList.addAll([ETipoEvento.Nascita.etichettaDesc, ETipoEvento.Matrimonio.etichettaDesc, ETipoEvento.Decesso.etichettaDesc])

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        sezioniLuogo = [new Sezione(getEtichettaEnum(etichette, ETipoEvento.Nascita),       ETipoEvento.Nascita.name(),"",  "/restrict/statocivile/dizionari/generale/luogoNascitaLista.zul"),
                        new Sezione(getEtichettaEnum(etichette, ETipoEvento.Matrimonio),    ETipoEvento.Matrimonio.name(),"","/restrict/statocivile/dizionari/generale/luogoMatrimonioLista.zul"),
                        new Sezione(getEtichettaEnum(etichette, ETipoEvento.Decesso),       ETipoEvento.Decesso.name(),"",  "/restrict/statocivile/dizionari/generale/luogoDecessoLista.zul")]

        selectedSezioneLuogo = sezioniLuogo.get(0)

        self.addEventListener(CustomEvents.ON_SELECT_LUOGO, new org.zkoss.zk.ui.event.EventListener() {
            public void onEvent(Event event) {
                if (event.data.selectedSezioneLuogo instanceof Sezione) {
                    updSezione(event.data.selectedSezioneLuogo)
                }
            }
        })
    }

    void updSezione(Sezione s){
        selectedSezioneLuogo = s
        BindUtils.postNotifyChange(null, null, this, "*")
    }
}
