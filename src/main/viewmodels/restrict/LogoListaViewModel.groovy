package restrict

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametro
import it.finmatica.de4gsdzk.utils.EGruppo
import it.finmatica.de4gsdzk.utils.Paginazione
import it.finmatica.de4gsdzk.zkutils.CustomAImage
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.ExecutionArgParam
import org.zkoss.bind.annotation.Init
import org.zkoss.zul.Window
import restrict.afc.AbstractLogoListaViewModel

@Slf4j
class LogoListaViewModel extends AbstractLogoListaViewModel {

    List<String> listaParametri

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("sezione") String sezione) {
        EGruppo gruppo = EGruppo.valueOf(sezione.toUpperCase())
        switch (gruppo) {
            case EGruppo.CIV:
                listaParametri = [ArcParametro.LOGO_CIV, ArcParametro.LOGO_SCIA]
                break
            case EGruppo.CER:
                listaParametri = [ArcParametro.LOGO_CER]
                break
            case EGruppo.ANA:
                listaParametri = [ArcParametro.LOGO_ANA, ArcParametro.SAP4_TIM]
                break
            case EGruppo.LEV:
                listaParametri = [ArcParametro.LOGO_LEV]
                break
            case EGruppo.ELE:
                listaParametri = [ArcParametro.LOGO_ELE, ArcParametro.LISTE_TIM, ArcParametro.LISTE_TIM1,
                                  ArcParametro.RSEI_TIM, ArcParametro.LISTE_FIR2]
                break
        }
        doInit(w, [])
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        List l = []
        List<ArcParametro> listaLoghi = arcParametroService.listAllByIdIn(listaParametri)
        for (ArcParametro p : listaLoghi) {
            CustomAImage image = null
            if (p.blobAllegato) {
                image = new CustomAImage("${p.valore}", p.blobAllegato, (p.id.startsWith("LOGO") ? "550px" : ""))
            }
            l.add(new Tuple2(p, image))
        }
        return new Paginazione(l, l.size())
    }
}
