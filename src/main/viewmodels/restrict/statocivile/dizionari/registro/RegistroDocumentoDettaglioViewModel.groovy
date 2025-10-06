package restrict.statocivile.dizionari.registro

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CivNumerazioneDocumentiBaseDomain
import it.finmatica.de4gsdzk.CivRegistroDocumentiBaseDomain
import it.finmatica.de4gsdzk.statocivile.*
import it.finmatica.de4gsdzk.utils.ETipoArchivioDocumento
import it.finmatica.de4gsdzk.utils.ETipoDocumento
import it.finmatica.de4gsdzk.utils.ETipoOperazione
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioDettaglioViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class RegistroDocumentoDettaglioViewModel extends DizionarioDettaglioViewModel {

    CivRegistroDocumentiBaseDomain dettaglio

    List<CivNumerazioneDocumentiBaseDomain> listaNumeriDocumenti
    LinkedHashSet<CivNumerazioneDocumentiBaseDomain> listaNumeriDaSalvare

    ETipoDocumento tipoDocumento

    ETipoOperazione tipoOperazione

    List listaTipiRegistro

    @WireVariable
    private CivTipoRegistroService civTipoRegistroService

    @WireVariable
    private CivRegistroDocumentiService civRegistroDocumentiService

    @Init init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Integer id, @ExecutionArgParam("tipoDocumento") ETipoDocumento tipoDocumento) {

        self = w

        saveRecordEnabled = true

        List<Map<String, String>> eList = [Etichette.Tipo_Documento,  Etichette.Registro_Documenti_Uscita, Etichette.Registro_Documenti_Entrata,
                                           Etichette.Numeratori, Etichette.Anno, Etichette.Protocollo]
        eList.addAll(CivRegistroDocumentiBaseDomain.etichetteDomain)

        // Aggiungo etichetta tipo documento
        eList.add(tipoDocumento.getEtichettaDesc())

        this.tipoDocumento = tipoDocumento
        switch (tipoDocumento) {
            case ETipoDocumento.Entrata:
                listaTipiRegistro = ETipoArchivioDocumento.values().toList()
                eList += listaTipiRegistro*.getEtichettaDesc() as Map
                break
            case ETipoDocumento.Uscita:
                listaTipiRegistro = civTipoRegistroService.listAll()
                break
        }

        doInitEtichette(eList)

        switch (tipoDocumento) {
            case ETipoDocumento.Entrata:
                msgTitle = getEtichetta(Etichette.Registro_Documenti_Entrata)
                break
            case ETipoDocumento.Uscita:
                msgTitle = getEtichetta(Etichette.Registro_Documenti_Uscita)
                break
        }

        formLabel = msgTitle?.toUpperCase()

        resize()

        if (id != null){
            caricaDettaglio(id)
        } else {
            creaDettaglio([:])
        }
    }

    void caricaDettaglio(def id) {
        Tuple2<CivRegistroDocumentiBaseDomain, Collection<CivNumerazioneDocumentiBaseDomain>> obj = civRegistroDocumentiService.get(tipoDocumento, id)
        dettaglio = obj?.getFirst()
        listaNumeriDocumenti = obj?.getSecond()
        listaNumeriDaSalvare = new LinkedHashSet<>()
        tipoOperazione = ETipoOperazione.UPD
        refreshUi()
    }

    void creaDettaglio(Map params){
        if (tipoDocumento.isUscita()) {
            dettaglio = new CivRegistroDocumentiUscita(params)
        } else {
            dettaglio = new CivRegistroDocumentiEntrata(params)
        }
        listaNumeriDocumenti = []
        listaNumeriDaSalvare = new LinkedHashSet<>()
        tipoOperazione = ETipoOperazione.INS
    }

    @Command void onSalvaRecord() {
        if (dettaglio) {
            CivRegistroDocumentiBaseDomain c = civRegistroDocumentiService.save(tipoDocumento, tipoOperazione, dettaglio, listaNumeriDaSalvare)
            Messagebox.show(getEtichetta(EtichetteMessaggi.Salvataggio_Completato), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
            caricaDettaglio(c.id)
        }
    }

    @Command void onCambiaNumero(@BindingParam("numerazione") CivNumerazioneDocumentiBaseDomain n) {
        listaNumeriDaSalvare.add(n)
    }

    String getDescTipoRegistro(Object item) {
        if (item instanceof CivTipoRegistro){
            return item.descrizione
        } else {
            return getEtichettaEnum((Enum) item)
        }
    }

}
