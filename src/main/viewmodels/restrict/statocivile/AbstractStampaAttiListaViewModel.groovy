package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.utils.*
import restrict.AbstractStampaListaViewModel

@Slf4j
abstract class AbstractStampaAttiListaViewModel extends AbstractStampaListaViewModel implements TraitStampaCampi {

    IRicercaAtto ricerca
    Boolean anscOn = Boolean.FALSE

    abstract void esporta(ETipoFile tipo)

    void doInit(List<Map<String, String>> eList=[]) {
        super.doInit(eList)
        anscOn = arcParametroService.isIntegrazioneAnscAttiva()
    }

    protected RicercaAttoStampa getRicercaAttoStampa() {
        (RicercaAttoStampa) ricerca
    }

    protected String getNomeFileXUfficio() {
        return (ricerca.ufficio ? getEtichetta(Etichette.getEtichetta("Ufficio"))+" "+ricerca.ufficio : getEtichetta(Etichette.getEtichetta("Tutti_gli_uffici")))
    }

    protected String getParametri(List<Map> ranges) {
        List<String> parametri = new LinkedList<>()
        for (def range : ranges)
            if (range.da || range.a) {
                String p = range.label + ":"
                if (range.da)
                    p += " " + getEtichetta(Etichette.getEtichetta("Dal")) + " " + DataUtils.toString(range.da)
                if (range.a)
                    p += " " + getEtichetta(Etichette.getEtichetta("Al")) + " " + DataUtils.toString(range.a)
                parametri.add(p)
            }
        return parametri.join(" - ")
    }

}