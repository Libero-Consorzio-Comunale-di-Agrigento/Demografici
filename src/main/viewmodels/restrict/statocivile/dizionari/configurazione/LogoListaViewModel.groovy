package restrict.statocivile.dizionari.configurazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.zkutils.CustomAImage
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zul.Window
import restrict.afc.AbstractLogoListaViewModel

@Slf4j
class LogoListaViewModel extends AbstractLogoListaViewModel {

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        doInit(w, [])
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        List l = []
        List<ArcParametro> listaLoghi = arcParametroService.listAllByIdLikeOrId(ArcParametro.LOGO_CIV, ArcParametro.LOGO_SCIA)
        for (ArcParametro p : listaLoghi) {
            CustomAImage image = null
            if (p.blobAllegato) {
                image = new CustomAImage("${p.valore}", p.blobAllegato, (p.id.contentEquals(ArcParametro.LOGO_CIV) ? "550px" : ""))
            }
            l.add(new Tuple2(p, image))
        }
        return new Paginazione(l, l.size())
    }
}
