package restrict.statocivile.morte

import it.finmatica.de4gsdzk.utils.Etichette
import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.statocivile.IstMd4Bis
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.statocivile.IstatDettaglioParentViewModel

import javax.persistence.criteria.JoinType

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class MorteD4BisDettaglioViewModel extends IstatDettaglioParentViewModel {

    List<ArchivioIstat> listaGenereParto = []
    List<ArchivioIstat> listaTipoFiliazione = []
    List<ArchivioIstat> listaTipoParto = []
    List<ArchivioIstat> listaLuogoDecesso = []
    List<ArchivioIstat> listaLuogoParto = []
    List<ArchivioIstat> listaPresentazione = []
    List<ArchivioIstat> listaConsanguineita = []
    List<ArchivioIstat> listaMortalitaInfantile = []

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("pkAtto") Long pkAtto, @ExecutionArgParam("tipoAttoEnum") ETipoAtto tipoAttoEnum) {
        self = w

        saveRecordEnabled = true

        List<Map> eList = [Etichette.getEtichetta("SEZIONE_MODELLO_D4BIS"), Etichette.getEtichetta("SEZIONE_DATI_DECESSO"), Etichette.getEtichetta("SEZIONE_DECEDUTO"),
                           Etichette.getEtichetta("SEZIONE_PARTO"), Etichette.getEtichetta("SEZIONE_MADRE"), Etichette.getEtichetta("SEZIONE_PADRE"), Etichette.getEtichetta("SEZIONE_PRECEDENTI")]
        eList.addAll(IstMd4Bis.etichetteDomain)

        // Aggiungo etichette tipo si/no
        eList.addAll(Arrays.asList(ETipoSiNo.values())*.etichettaDesc)

        doInit(eList, tipoAttoEnum, ETipoModelloIstat.D4BIS, Etichette.getEtichetta("SEZIONE_MODELLO_D4BIS"))

        if (pkAtto){
            caricaAtto(tipoAttoEnum, pkAtto, [fetch:[[campo:'nazionalita', tipo: JoinType.LEFT]]])

            caricaDettaglio(null)

            caricaListeArchivi("ISTMD4_V_DIZ", dettaglio.anno)

            caricaListaNazionalita()

        } else {
            onChiudi()
        }
    }

    @Override
    List<ArchivioIstat> caricaListeArchivi(String viewName, Integer anno){

        List<ArchivioIstat> l = super.caricaListeArchivi(viewName, anno)

        listaMortalitaInfantile = [new ArchivioIstat(1, getEtichettaEnum(ETipoSiNo.SI)), new ArchivioIstat(2, getEtichettaEnum(ETipoSiNo.NO))]

        listaGenereParto = []
        listaTipoFiliazione = [null]
        listaTipoParto = [null]
        listaLuogoDecesso = [null]
        listaLuogoParto = [null]
        listaPresentazione = [null]
        listaConsanguineita = []

        for (ArchivioIstat m:l){
            switch (m.archivioIstat) {
                case ETipoArchivioIstat.GPA:
                    listaGenereParto.add(m)
                    break
                case ETipoArchivioIstat.TFI:
                    listaTipoFiliazione.add(m)
                    break
                case ETipoArchivioIstat.LDE:
                    listaLuogoDecesso.add(m)
                    break
                case ETipoArchivioIstat.LPA:
                    listaLuogoParto.add(m)
                    break
                case ETipoArchivioIstat.PRE:
                    listaPresentazione.add(m)
                    break
                case ETipoArchivioIstat.TPA:
                    listaTipoParto.add(m)
                    break
                case ETipoArchivioIstat.CON:
                    listaConsanguineita.add(m)
                    break
            }
        }

        return l
    }

    @Command void onChangeEtaDecesso(@ContextParam(ContextType.TRIGGER_EVENT) Event event, @BindingParam("tipo") String tipo){
        ((IstMd4Bis)dettaglio).indicazioneEtaDecesso = null
        ((IstMd4Bis)dettaglio).etaDecesso = event?.target?.value
        if (event?.target?.value != null){
            switch (tipo) {
                case "ore":
                    ((IstMd4Bis)dettaglio).indicazioneEtaDecesso = new Integer(1)
                    break
                case "giorni":
                    ((IstMd4Bis)dettaglio).indicazioneEtaDecesso = new Integer(2)
                    break
                case "mesi":
                    ((IstMd4Bis)dettaglio).indicazioneEtaDecesso = new Integer(3)
                    break
            }
        }
        refreshUi()
    }

    @Command void onSelectMortalitaInfantile(){
        refreshUi()
    }

}
