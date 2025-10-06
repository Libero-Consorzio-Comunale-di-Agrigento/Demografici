package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivAttoBaseDomain
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.IAttoMatUci
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.Command
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.EventListener
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import restrict.AbstractListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
abstract class RiferimentiAttoListaParentViewModel extends AbstractListaViewModel{

    CivAttoBaseDomain atto

    ETipoAtto tipoAttoEnum
    String tipoAttoLabel = ""

    Boolean anscOn = Boolean.FALSE

    CivDatiProvenienzaAtto datiProvenienza

    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @WireVariable
    private CivAttoService civAttoService

    @WireVariable
    private ArcParametroService arcParametroService

    @WireVariable
    private CivDatiProvenienzaAttoService civDatiProvenienzaAttoService

    void doInit(List<Map<String, String>> eList, Long pkAtto, ETipoAtto tipoAttoEnum, Map<String, ?> attoParams=null) {

        eList.addAll([Etichette.Estremi_Atto, Etichette.Chiusura, Etichette.SEZIONE_DATI_ATTO, Etichette.SEZIONE_ATTO_ORIGINALE])
        //Aggiungo messaggi
        eList.addAll([EtichetteMessaggi.Ask_Modifiche_In_Sospeso, EtichetteMessaggi.Ask_Cancellazione_Record])
        eList.addAll(etichetteListaDefault)

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaDesc)

        // Aggiungo etichette Occhiello (per la stampa della CIA)
        eList.addAll(CivOcchiello.etichetteDomain)

        // Aggiungo etichette File
        eList.addAll(FileUtils.etichetteFileUtils)

        this.tipoAttoEnum = tipoAttoEnum
        switch (tipoAttoEnum) {
            case ETipoAtto.NAS:
                eList.addAll(CivNascita.etichetteDomain)
                break
            case ETipoAtto.MAT:
                eList.addAll(CivMatrimonio.etichetteDomain)
                break
            case ETipoAtto.PUB:
                eList.addAll(CivPubblicazione.etichetteDomain)
                break
            case ETipoAtto.MOR:
                eList.addAll(CivMorte.etichetteDomain)
                break
            case ETipoAtto.PVU:
                eList.addAll(CivProcessoVerbale.etichetteDomain)
                break
            case ETipoAtto.UCI:
                eList.addAll(CivUnioneCivile.etichetteDomain)
                break
            case ETipoAtto.CIT:
                eList.addAll(CivCittadinanza.etichetteDomain)
                break
        }

        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        anscOn = arcParametroService.isIntegrazioneAnscAttiva()

        caricaAtto(tipoAttoEnum, pkAtto, attoParams)

        datiProvenienza = civDatiProvenienzaAttoService.getByUkAtto(atto.idAtto)
    }

    Boolean isAttoDivorzioScioglimento(CivAttoBaseDomain atto){
        return ( (atto instanceof IAttoMatUci) && ( ((IAttoMatUci)atto).divorzio) )
    }

    Boolean isAttoDaAttestareAnsc(CivAttoBaseDomain atto){
        Boolean b = civAttoService.hasAllegatiInviatiAnsc(atto.getTipoAttoEnum(), atto.id)
        return b
    }

    protected void caricaAtto(ETipoAtto tipoAttoEnum, Long pkAtto, Map<String, ?> attoParams=null){
        atto = civAttoService.getAtto(tipoAttoEnum, pkAtto, attoParams)
        tipoAttoLabel = getEtichettaEnum(atto.getTipoAttoEnum())
        if (isAttoDivorzioScioglimento(atto)){
            tipoAttoLabel = FormUtils.getAttoCustomLabels(tipoAttoEnum, etichette)["AttoDivorzio"]
        }
    }

    abstract boolean getLoadOnCloseData()

    @Command void onChiudi () {
        if (getLoadOnCloseData()){
            Integer codiceRecord = civAttoService.getCodiceRecord(tipoAttoEnum, atto.id)
            Events.postEvent(Events.ON_CLOSE, self, [ricarica:( (codiceRecord != null) && (codiceRecord?.intValue() == 3) ) ])
        } else {
            Events.postEvent(Events.ON_CLOSE, self, [:])
        }
    }

    @Command void onBackFromList() {
        Messagebox.show(getEtichetta(EtichetteMessaggi.Ask_Modifiche_In_Sospeso), getEtichetta(Etichette.Chiusura), Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new EventListener() {
                    void onEvent(Event e){
                        if (Messagebox.ON_YES.equals(e.getName())){
                            Events.postEvent(CustomEvents.ON_BACK_FROM_LIST, self, [:])
                            onChiudi()
                        }
                    }
                }
        )
    }

}
