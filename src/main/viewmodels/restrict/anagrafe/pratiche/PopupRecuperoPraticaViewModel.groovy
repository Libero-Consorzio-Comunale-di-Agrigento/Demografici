package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.GsdEtichettaService
import it.finmatica.de4gsdzk.GsdService
import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.utils.DataUtils
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.smartdoc.api.DocumentaleRuntimeException
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window
import restrict.AbstractPopupViewModel

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PopupRecuperoPraticaViewModel extends AbstractPopupViewModel {

    AnaPratica pratica

    AnaRecuperoPraticaBaseDomain praticaRecuperata
    String archivio
    AnaVariazione variazione
    AnaDizionarioPratiche iniziativa

    ETipoSiNo numeraPratica
    boolean abilitaNumero
    final List<ETipoSiNo> listaSiNo = [ETipoSiNo.SI, ETipoSiNo.NO]

    @WireVariable
    private AnaRecuperoPraticaService anaRecuperoPraticaService
    @WireVariable
    private AnaPraticaService anaPraticaService
    @WireVariable
    private AnaVariazioneService anaVariazioneService
    @WireVariable
    protected AnaDizionarioPraticheService anaDizionarioPraticheService
    @WireVariable
    private AnaPraticaAllegatoService anaPraticaAllegatoService
    @WireVariable
    private GsdService gsdService
    @WireVariable
    private GsdEtichettaService gsdEtichettaService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("archivio") String a, @ExecutionArgParam("pratica") AnaRecuperoPraticaBaseDomain p) {
        self = w
        archivio = a
        praticaRecuperata = p

        abilitaNumero = false
        numeraPratica = ETipoSiNo.SI

        List<Map> eList = [Etichette.getEtichetta("Sezione_Informazioni_Pratica"), Etichette.getEtichetta("Chiudi"), Etichette.getEtichetta("Salva")]
        eList.addAll([Etichette.getEtichetta("Inserimento_Pratica_Effettuato_Con_Successo"), Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"),
                      Etichette.getEtichetta("Trasferimeto_File_Eseguito_Con_Successo"), Etichette.getEtichetta("Abilita_Numero")])
        eList.addAll(AnaPratica.etichetteDomain)
        eList.addAll(ETipoAnagrafe.values()*.getEtichettaDesc())
        eList.addAll(ETipoPratica.values()*.getEtichettaDesc())
        eList.addAll(ETipoSiNo.values()*.getEtichettaDesc())


        etichette = gsdEtichettaService.listAndInsertWhereIdIn(eList)

        msgTitle = getEtichetta(Etichette.getEtichetta("Sezione_Informazioni_Pratica"))

        variazione = anaVariazioneService.getVariazioneWebAnpr(ETipoAnagrafe.RESIDENTI, praticaRecuperata.tipoPratica, archivio)
        iniziativa = anaDizionarioPraticheService.findByCodiceAndArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(variazione.tipoRichiestaDefault, ETipoAnagrafe.RESIDENTI, praticaRecuperata.tipoPratica, ETipoArchivioDizionario.INIZIATIVA)

        pratica = new AnaPratica(archivioAnagrafe: ETipoAnagrafe.RESIDENTI,
                tipoPratica: praticaRecuperata.tipoPratica,
                data: DataUtils.getDataCorrente(),
                dataDecorrenza: praticaRecuperata.dataInoltro,
                anno: DataUtils.getAnnoCorrente(),
                codiceVariazione: variazione.codiceVariazioneTpr,
                codiceIniziativa: variazione.tipoRichiestaDefault)

    }

    @Command
    void onSelectNumera() {
        pratica.numero = null
        refreshUi()
    }

    @Command
    void onSalva() {
        //Controllo che il numero inserito sia corretto
        if (pratica.anno == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"))
        }
        if (numeraPratica == ETipoSiNo.SI && abilitaNumero) {
            if (pratica.numero == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"))
            }
            String msgErrore = gsdService.controllaNumeroPratica(pratica.archivioAnagrafe, pratica.tipoPratica, pratica.anno, pratica.numero, pratica.getTableName())
            if (msgErrore != null) {
                throw new De4gsdzkRuntimeException(msgErrore)
            }
        }

        //Salva Pratica
        pratica.id = gsdService.getIdFromSequence(pratica, pratica.getTableName())
        if (pratica.numero == null) {
            pratica.numero = gsdService.getNumeroPratica(pratica.archivioAnagrafe, pratica.anno, pratica.tipoPratica, numeraPratica)
        }
        anaPraticaService.saveOrUpdate(pratica)

        //Aggiorna il record di recupero pratica con anno/numero
        praticaRecuperata.pratica = pratica.numero
        praticaRecuperata.annoPratica = pratica.anno
        anaRecuperoPraticaService.saveOrUpdate(praticaRecuperata)

        //Copia allegati in allegati pratica
        int count = 0
        for (IAllegatoPratica a : praticaRecuperata.allegati) {
            try {
                salvaAllegato(a)
            } catch (Exception ignored) {
                count++
            }
        }

        String msg = "Pratica: ${ETipoAnagrafe.RESIDENTI.getEtichettaDesc().defaultValue} - ${pratica.tipoPratica.etichettaDesc.defaultValue} - ${pratica.numero > 0 ? pratica.numero : getEtichetta(Etichette.getEtichetta("Provvisorio"))} / ${pratica.anno}\n"
        if(praticaRecuperata.allegati.size() > 0) {
            if(count == 0) {
                msg += "${getEtichetta(Etichette.getEtichetta("Trasferimeto_File_Eseguito_Con_Successo"))}\n"
            } else {
                msg += "Fascicolo della pratica: il trasferimento di ${count} allegati su ${praticaRecuperata.allegati.size()} è fallito\n"
            }
        }
        msg += "${getEtichetta(Etichette.getEtichetta("Inserimento_Pratica_Effettuato_Con_Successo"))}"

        //Messaggio se si vuole entrare nella pratica (se sì redirect su scheramta corretta altrimenti ritorna alla lista)
        Messagebox.show(msg, msgTitle, Messagebox.YES | Messagebox.NO, Messagebox.QUESTION,
                new org.zkoss.zk.ui.event.EventListener() {
                    void onEvent(Event e) {
                        if (Messagebox.ON_YES == e.getName()) {
                            Map params = ["id": pratica.id, modifica: true, readOnly: (pratica.flagPerfezionamento || pratica.flagAnnullamento)]
                            String uri
                            switch (pratica.tipoPratica) {
                                case ETipoPratica.ISC:
                                    uri = "/restrict/anagrafe/pratiche/praticaIscrizioneResDettaglio.zul"
                                    break
                                case ETipoPratica.VAR:
                                    uri = "/restrict/anagrafe/pratiche/praticaVariazioneResDettaglio.zul"
                                    break
                            }
                            if (uri) {
                                //Lista di partenza dei recuperi
                                Component listaWindow = self.parent
                                Window dettaglio = (Window) Executions.createComponents(uri, listaWindow.parent, params)
                                listaWindow.setVisible(false)
                                dettaglio.addEventListener(Events.ON_CLOSE, { evt ->
                                    listaWindow.setVisible(true)
                                })
                                dettaglio.doEmbedded()
                                onChiudi()
                            }
                        } else {
                            onChiudi()
                        }
                    }
                })
    }

    private void salvaAllegato(IAllegatoPratica a) {
        AnaPraticaAllegato allegato = anaPraticaAllegatoService.create(pratica, a.nome)
        anaPraticaAllegatoService.save(allegato)

        try {
            anaPraticaAllegatoService.saveAllegatoDocumentale(allegato, a.blob)
        } catch (DocumentaleRuntimeException dre) {
            log.error(dre.message, dre)
            anaPraticaAllegatoService.saveAllegatoLocale(allegato, a.blob)
//            throw dre
        } catch (Exception ex) {
            log.error(ex.message, ex)
            anaPraticaAllegatoService.delete(allegato)
            throw ex
        }
    }

}
