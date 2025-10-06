package restrict.certificazione.dizionari.generale

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato
import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificatoService
import it.finmatica.de4gsdzk.certificazione.CerTariffaDiritto
import it.finmatica.de4gsdzk.certificazione.CerTariffaDirittoService
import it.finmatica.de4gsdzk.utils.*
import it.finmatica.de4gsdzk.utils.controlbar.ControlBarListaAttributes
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.statocivile.DizionarioListaViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class TariffaDirittoCategoriaListaViewModel extends DizionarioListaViewModel {

    final List<Map> addPlusList = []

    @WireVariable
    private CerCategoriaTipoCertificatoService cerCategoriaTipoCertificatoService

    @WireVariable
    private CerTariffaDirittoService cerTariffaDirittoService

    @Delegate
    ControlBarListaAttributes cbLista = new ControlBarListaAttributes()

    CerTariffaDiritto tariffaDiritto
    Component opener
    List<CerCategoriaTipoCertificato> listaCategoriaTipoCertificato = []

    CerCategoriaTipoCertificato dettaglio
    List<CerCategoriaTipoCertificato> lista

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w,
         @ExecutionArgParam("tariffaDiritto") CerTariffaDiritto tariffaDiritto,
         @ExecutionArgParam("opener") Component opener) {

        self = w

        addEnabled = false
        modifyEnabled = false
        deleteEnabled = true
        addPlusEnabled = true
        pagingEnabled = false

        totalSizeLabel = ""

        List<Map<String, String>> eList = []
        eList.addAll(CerTariffaDiritto.etichetteDomain)
        eList.addAll(CerCategoriaTipoCertificato.etichetteDomain)
        doInitEtichette(eList)

        this.opener = opener
        this.opener.addEventListener(CustomEvents.ON_SAVE_MASTER, { event ->
            // Ottengo l'oggetto modificato dal master
            CerTariffaDiritto dettaglio = event.data.dettaglio as CerTariffaDiritto

            // Aggiungo le informazioni detail all'oggetto
            dettaglio.categoriaTipiCertificatoList = lista

            // Salvo l'oggetto completo
            this.tariffaDiritto = cerTariffaDirittoService.save(dettaglio)

            // Comunico il salvataggio dell'oggetto al master
            Events.postEvent(CustomEvents.ON_SAVE_DETAIL, this.opener, ['tarrifaDirittoId': this.tariffaDiritto.id])

            // Ricarico il detail
            onRicarica()
        })

        msgTitle = getEtichetta(Etichette.Categorie_Tipo_Certificato)

        listaCategoriaTipoCertificato = cerCategoriaTipoCertificatoService.listAll()

        if (tariffaDiritto.id != null) {
            // Devo ricaricare la tariffaDiritto perché l'include prende in maniera statica i parametri
            this.tariffaDiritto = cerTariffaDirittoService.get(tariffaDiritto.id)
            caricaLista()
        } else {
            this.tariffaDiritto = tariffaDiritto
            createLista()
        }

    }

    void createLista() {
        this.lista = []
        caricaAddPlusList()
    }

    void caricaLista() {
        Paginazione p = eseguiQuery(Boolean.TRUE)
        lista = p.lista
        updateTotalSize(p.count)

        caricaAddPlusList()

        refreshUi()
    }

    @Override
    void resetDettaglio() {
        dettaglio = null
        BindUtils.postNotifyChange(null, null, this, "dettaglio")
    }

    Paginazione eseguiQuery(Boolean usePaging) {
        log.info("usePaging: " + usePaging)

        List<CerCategoriaTipoCertificato> l = cerTariffaDirittoService.listAllByTariffaDiritto(tariffaDiritto.id)

        return new Paginazione(l, l.size())
    }

    private void caricaAddPlusList() {
        // aggiunge le categorie mancanti al menu +
        addPlusList.clear()
        List<Integer> categorieInserite = lista.collect { it.id }
        for (CerCategoriaTipoCertificato categoria : listaCategoriaTipoCertificato) {
            if (!categorieInserite.contains(categoria.id)) {
                addPlusList.add([id: categoria.id, idDomain: categoria, descrizione: categoria.descrizione, tipo: "T"])
            }
        }
    }

    @Command
    void onInserisciPlus(@BindingParam("idDomain") CerCategoriaTipoCertificato categoriaTipoCertificato) {
        if (addPlusEnabled && userModifyEnabled) {
            aggiungiRecord(categoriaTipoCertificato)
        } else {
            Messagebox.show(getEtichetta(Etichette.Funzione_non_abilitata), msgTitle, Messagebox.OK, Messagebox.EXCLAMATION)
        }
    }

    private void aggiungiRecord(CerCategoriaTipoCertificato categoriaTipoCertificato) {
        lista.add(categoriaTipoCertificato)

        updateTotalSize(lista.size())
        caricaAddPlusList()

        refreshUi()
    }

    void eliminaRecord() {
        if (deleteEnabled && dettaglio && userModifyEnabled) {
            lista.remove(dettaglio)

            updateTotalSize(lista.size())
            caricaAddPlusList()

            refreshUi()
        }
    }

    String getMessaggioCancellazione() {
        if (dettaglio) {
            return "${dettaglio.descrizione}:\n" + getEtichetta(EtichetteMessaggi.Ask_Cancellazione_Record)
        }
        return ""
    }

    @Override
    String getUriDettaglio() {
        throw new UnsupportedOperationException()
    }

}
