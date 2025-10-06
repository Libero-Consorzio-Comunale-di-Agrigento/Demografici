package restrict.statocivile.dizionari.tipoAtto

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.CivTipoAtto
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TipoAttoListaViewModel extends TipoAttoListaParentViewModel{

    final List<Map> addPlusList = []

    Boolean flagAnsc

    List<ETipoEvento> listaTipiEvento
    ETipoEvento selectedTipoEvento

    @WireVariable
    private ArcParametroService arcParametroService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w){
        self = w

        addEnabled = false
        addPlusEnabled = true
        searchEnabled = true
        deleteEnabled = true

        listaTipiAtto = [ETipoAtto.NAS, ETipoAtto.MAT, ETipoAtto.UCI, ETipoAtto.MOR, ETipoAtto.CIT]

        List<Map<String, String>> eList = [Etichette.Tipi_di_Atto, Etichette.Funzione_non_abilitata, Etichette.Atto_Divorzio, Etichette.Atto_Scioglimento]
        // Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Compilare_tipo_atto])

        eList.addAll(CivTipoAtto.etichetteDomain)

        // Aggiungo etichette natura atto
        eList += ENaturaAtto.values()*.getEtichettaDesc() as Map

        // Aggiungo etichette tipo atto
        eList.addAll(listaTipiAtto*.etichettaPluralDesc)
        eList.addAll(listaTipiAtto*.etichettaDesc)

        // Aggiungo etichette per radio button flagANSC
        eList.add(Etichette.Valido_ANSC)
        eList.addAll([Etichette.SI, Etichette.NO])

        // Aggiungo le etichette per la combobox tipi evento
        eList.add(Etichette.Tipo)
        eList.addAll([Etichette.Tutti, ETipoEvento.Unione_Civile.etichettaDesc, ETipoEvento.Scioglimento.etichettaDesc, ETipoEvento.Matrimonio.etichettaDesc, ETipoEvento.Divorzio.etichettaDesc])

        doInitEtichette(eList)

        totalSizeLabel = ""

        msgTitle = getEtichetta(Etichette.Tipi_di_Atto)

        formLabel = msgTitle?.toUpperCase()

        // Default settato a true se integrazione ansc attiva
        flagAnsc = arcParametroService.isIntegrazioneAnscAttiva()
    }

    @Command void onSelectTipoAtto() {
        refreshListaTipiEvento()

        addPlusList.clear()

        //etichette custom
        etichetteCustom = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)

        addPlusList.add([id: tipoAttoEnum.id, idDomain: Boolean.FALSE, descrizione: getEtichettaEnum(tipoAttoEnum), tipo: CivTipoAtto.TIPO_BASE])
        if ( (tipoAttoEnum == ETipoAtto.MAT) || (tipoAttoEnum == ETipoAtto.UCI) ){
            addPlusList.add([id: tipoAttoEnum.id, idDomain: Boolean.TRUE, descrizione: etichetteCustom.get("AttoDivorzio"), tipo: CivTipoAtto.TIPO_BASE])
        }
        onRicarica()
    }

    private refreshListaTipiEvento() {
        selectedTipoEvento = null
        switch (tipoAttoEnum) {
            case ETipoAtto.UCI:
                listaTipiEvento = [null, ETipoEvento.Unione_Civile, ETipoEvento.Scioglimento]
                break
            case ETipoAtto.MAT:
                listaTipiEvento = [null, ETipoEvento.Matrimonio, ETipoEvento.Divorzio]
                break
            default:
                listaTipiEvento = null
        }
        BindUtils.postNotifyChange(null, null, this, "selectedTipoEvento")
        BindUtils.postNotifyChange(null, null, this, "listaTipiEvento")
    }

    @Command
    void onSelectFlagAnsc() {
        if (tipoAttoEnum == null) {
            MessaggioUtils.showMsgBox(msgTitle, MessaggioUtils.E, getEtichetta(EtichetteMessaggi.Compilare_tipo_atto))
            return
        }
        onRicarica()
    }

    @Command
    void onSelectTipoEvento() {
        if (tipoAttoEnum == null) {
            return
        }
        onRicarica()
    }

    @Command void onInserisciPlus(@BindingParam("idDomain") Boolean divorzio) {
        if (addPlusEnabled && userModifyEnabled){
            if (tipoAttoEnum != null) {
                apriDettaglio(uriDettaglio, [tipoAttoEnum: tipoAttoEnum, divorzio:divorzio])
            } else {
                Messagebox.show(getEtichetta(EtichetteMessaggi.Compilare_tipo_atto), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
            }
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    @Override
    Map getAdditionalFilters() {
        return [flagAnsc: flagAnsc, selectedTipoEvento: selectedTipoEvento]
    }
}
