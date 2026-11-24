package restrict.statocivile.cittadinanza

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.CivCittadinanza
import it.finmatica.de4gsdzk.statocivile.CivCittadinanzaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Paginazione
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractSelectViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CittadinanzaMinorenniListaSelectViewModel extends AbstractSelectViewModel{

    CivCittadinanza attoPadre

    List<Map<String, Object>> lista = []
    List<Map<String, Object>> dettagli

    List<Integer> minorenniGestiti = []

    @WireVariable
    private CivCittadinanzaService civCittadinanzaService

    @WireVariable
    private GsdService gsdService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("atto") CivCittadinanza atto) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Estremi_Atto"), Etichette.getEtichetta("Crea_atti_con_numerazione_provvisoria"), Etichette.getEtichetta("Crea_atti_con_numerazione_definitiva")]
        //Aggiungo messaggi
        eList.addAll([Etichette.getEtichetta("Errore_creazione_atto_cittadinanza_minorenne")])
        eList.addAll(CivCittadinanza.etichetteDomain)

        doInitEtichette(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Atto_Cittadinanza"))

        totalSizeLabel = ""

        this.attoPadre = atto

        minorenniGestiti = []

        caricaLista()
    }

    void caricaLista(){
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        refreshLista()
    }

    Paginazione eseguiQuery(Boolean usePaging){
        log.info ("usePaging: " + usePaging)

        List<Map<String, Object>> l = gsdService.listMinorenni(attoPadre.idAtto)

        return new Paginazione(l, l.size())
    }

    void resetDettaglio(){
        dettagli = null
        refreshDettagli()
    }

    @Command void onSeleziona(@BindingParam("provvisori") Boolean provvisori) {
        if (dettagli){
            elaboraCittadinanzaMinorenni(dettagli, provvisori)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Nessun_dato_disponibile")), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    void elaboraCittadinanzaMinorenni(List<Map<String, Object>> lista, Boolean provvisori){
        for (Map<String, Object> mf : lista){
            // Mi assicuro che al minorenne non sia già stato associato un atto di cittadinanza
            Integer matricolaFiglio = new Integer(mf.MATRICOLA.intValue())
            if ( (!(minorenniGestiti.contains(matricolaFiglio))) && (mf.ATTO_FG == null) ) {
                Long idCivdta = null
                if (mf.ID_CIVDTA != null){
                    idCivdta = new Long (mf.ID_CIVDTA.longValue())
                }
                try{
                    civCittadinanzaService.saveCittadinanzaMinorenne(attoPadre, matricolaFiglio, idCivdta, provvisori)
                    minorenniGestiti.add(matricolaFiglio)
                } catch (RuntimeException e){
                    // Segnalo e vado avanti
                    Messagebox.show(String.format(getEtichetta(Etichette.getEtichetta("Errore_creazione_atto_cittadinanza_minorenne")), mf.COGNOME_NOME ), msgTitle, Messagebox.OK, Messagebox.ERROR)
                }
            }
        }
        onRicarica()
    }

}
