package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.ArcComuneBaseDomain
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.archivi.ArcComuneBaseService
import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivicoService
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.IndirizzoCivico
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.*
import org.zkoss.bind.annotation.*
import org.zkoss.zhtml.Filedownload
import org.zkoss.zk.ui.Executions
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Messagebox
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PraticaIscrizioneResDettaglioViewModel extends AbstractPraticaDettaglioViewModel implements TraitGestioneCivico {

    private static final String ANNULLATA = 'A'
    static final String CONVIVENTE = 'CV'

    /** Codici provvedimento (da dizionario AnaDizionarioPratiche) */
    private static final String PROVVEDIMENTO_PROVENIENZA_ITALIANA = "1"
    private static final String PROVVEDIMENTO_ESTERO = "2"
    private static final String PROVVEDIMENTO_IRREPERIBILITA = "3"
    private static final String PROVVEDIMENTO_MOTIVO = "4"

    @WireVariable
    AnaDichiarazioneIscrizioneResService anaDichiarazioneIscrizioneResService
    @WireVariable
    AnaSoggettoIscrizioneResService anaSoggettoIscrizioneResService
    @WireVariable
    ArcComuneBaseService arcComuneBaseService
    @WireVariable
    AnaAnagrafeService anaAnagrafeService
    @WireVariable
    AnaRapportoParentelaService anaRapportoParentelaService
    @WireVariable
    AnaRapportoParentelaIstatService anaRapportoParentelaIstatService
    @WireVariable
    Apr4ModelPdfService apr4ModelPdfService
    @WireVariable
    DichiarazioneResidenzaPdfService dichiarazioneResidenzaPdfService
    @WireVariable
    ArcDatiNumerazioneCivicoService arcDatiNumerazioneCivicoService

    AnaDichiarazioneIscrizioneRes dichiarazioneIscrizioneRes
    AnaSoggettoIscrizioneRes soggettoDummy = new AnaSoggettoIscrizioneRes(numeroOrdine: 9, anagrafe: new AnaAnagrafe(nome: "DICHIARANTE", cognome: "ALTRO"))

    List<AnaDizionarioPratiche> listaRichieste
    List<AnaDizionarioPratiche> listaProvvedimenti
    final List<EConteggio> listaConteggio = EConteggio.values().toList()

    private static final String CAPO_FAMIGLIA = 'CF'
    private static final String CAPO_CONVIVENZA = 'CC'

    List<AnaDizionarioPratiche> listaMotivoCancellazione

    private AnaStato statoInAttesa
    protected AnaStato statoImmigrazioneAnnullata
    protected AnaStato statoResidenteEstero
    protected AnaStato statoReimmigrazione


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("modifica") boolean modifica,
         @ExecutionArgParam("idAvanzamento") Integer idAvanzamento, @ExecutionArgParam("readOnly") boolean readOnly) {

        listaMotivoCancellazione = anaDizionarioPraticheService.findAllByArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(ETipoAnagrafe.AIRE, ETipoPratica.CANC, ETipoArchivioDizionario.MOTIVO)
        listaStati = arcComuneBaseService.getStatiEsteri()
        listaRichieste = anaDizionarioPraticheService.findAllByArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(archivioAnagrafe, tipoPratica, ETipoArchivioDizionario.RICHIESTA)
        listaProvvedimenti = anaDizionarioPraticheService.findAllByArchivioAnagrafeAndTipoPraticaAndCodiceArchivio(archivioAnagrafe, tipoPratica, ETipoArchivioDizionario.PROVVEDIMENTO)

        doInit(w, id, modifica, readOnly)
        statoInAttesa = anaStatoService.getStatoInAttesa()
        statoImmigrazioneAnnullata = anaStatoService.getStatoImmigrazioneAnnullata()
        statoResidenteEstero = anaStatoService.getStatoResidenteEstero()
        statoReimmigrazione = anaStatoService.getStatoReimmigrazione()


        if (!modifica) {
            onSelectVariazione()
        }

        List<Map<String, String>> eList = []
        eList.addAll(AnaDichiarazioneIscrizioneRes.etichetteDomain)
        eList.addAll(ModelloAireCancellazione.etichetteDomain)
        eList.addAll(Etichette.getEtichetta("Rapporto_Parentela_Non_Istat"), Etichette.getEtichetta("Errore_generazione_modello_apr4"))

        eList.addAll([Etichette.getEtichetta("Stampa_Modello_Apr4_tooltip"), Etichette.getEtichetta("Stampa_Dichiarazione_Residenza_tooltip")])
        eList.addAll(etichetteGestioneCivico)
        eList.addAll([Etichette.getEtichetta("Variazione_Non_Corretta"), Etichette.getEtichetta("Selezionare_Variazione_Corretta"),
                      Etichette.getEtichetta("Famiglia_Cancellata")])

        doInitEtichette(eList)

        if (idAvanzamento != null) {
            // Posticipa l'apertura dopo che la window è completamente renderizzata
            self.addEventListener("onAfterInit", { event ->
                openAvanzamentoPratica((Integer) event.data)
            })
            Events.echoEvent("onAfterInit", self, idAvanzamento)
        }

    }


    @Override
    IDichiarazionePratica getDichiarazione() {
        return dichiarazioneIscrizioneRes
    }

    @Override
    List<ISoggettoPratica> getSoggetti() {
        dichiarazioneIscrizioneRes.soggettiIscrizioneRes.sort { it.numeroOrdine }
        return dichiarazioneIscrizioneRes.soggettiIscrizioneRes
    }

    @Override
    List<ISoggettoPratica> getSoggettiNonOrdinati() {
        return dichiarazioneIscrizioneRes.soggettiIscrizioneRes
    }


    @Override
    void caricaDettaglio(Object id) {
        caricaPratica(id as Long)
        dichiarazioneIscrizioneRes = anaDichiarazioneIscrizioneResService.findByPratica(pratica as AnaPratica)
        if (dichiarazioneIscrizioneRes == null) {
            //Entro in questo caso solo se arrivo da un recupero pratica
            creaDettaglio([:])
        } else {
            if (dichiarazioneIscrizioneRes.comuneProvenienza) {
                comuneProvenienzaEstero = gsdService.checkComuneEstero(dichiarazioneIscrizioneRes.comuneProvenienza.codiceProvincia, dichiarazioneIscrizioneRes.comuneProvenienza.codice)
            }

            popolaListaDichiaranti()
            selectedDichiarante = listaDichiaranti.find { it.numeroOrdine == dichiarazioneIscrizioneRes.sottoscritto }
            popolaRapportoParentelaLists()
            if (dichiarazioneIscrizioneRes.codFamigliaProv != null) { // Caso AIRE
                popolaRapportoParentelaLists(ETipoFamiglia.FAMIGLIA)
                for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
                    if (s.anagrafe.sesso == ESesso.M) {
                        s.rapportoParentelaPrecedente = rapportoParentelaMPrecList.find { it.codiceRapportoParentela == s.codRpPrecedente }
                        s.rapportoParentelaNuovo = rapportoParentelaMList.find { it.codiceRapportoParentela == s.nuovoCodRp }
                    } else {
                        s.rapportoParentelaPrecedente = rapportoParentelaFPrecList.find { it.codiceRapportoParentela == s.codRpPrecedente }
                        s.rapportoParentelaNuovo = rapportoParentelaFList.find { it.codiceRapportoParentela == s.nuovoCodRp }
                    }

                }
            } else {
                for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
                    if (s.anagrafe.sesso == ESesso.M) {
                        s.rapportoParentelaNuovo = rapportoParentelaMList.find { it.codiceRapportoParentela == s.nuovoCodRp }
                    } else {
                        s.rapportoParentelaNuovo = rapportoParentelaFList.find { it.codiceRapportoParentela == s.nuovoCodRp }
                    }

                }
            }

            if (dichiarazioneIscrizioneRes.provvedimento?.codice == PROVVEDIMENTO_ESTERO) {
                selectedStato = listaStati.find { it.codiceProvincia == dichiarazioneIscrizioneRes.codiceStato }
            }
            if (dichiarazioneIscrizioneRes.codFamigliaProv != null) {
                if (pratica?.dichiarazioneCancellazioneAir) {
                    pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.motivoCancellazione = listaMotivoCancellazione.find { it.codice == pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.codiceMotivo }
                } else {
                    pratica.dichiarazioneCancellazioneAir = new AnaDichiarazioneCancellazioneAir()
                }

            }
        }

        caricaElementiCivico(dichiarazioneIscrizioneRes?.indirizzo?.via?.id)
    }

    @Override
    void selezionaVia(ArcVia c) {
        copiaDatiIndirizzo(dichiarazioneIscrizioneRes.indirizzo, null)
        super.selezionaVia(c)
        caricaElementiCivico(c?.id, true)
    }

    @Override
    @Command
    void onCancellaCampoPratica(@BindingParam("sezione") String sezione, @ContextParam(ContextType.TRIGGER_EVENT) Event e) {
        String p = e?.target?.getAttribute("proprieta")?.trim()
        super.onCancellaCampoPratica(sezione, e)
        if (sezione == 'F' && p == 'indirizzo.via') {
            caricaElementiCivico()
        }
    }

    @Override
    void creaDettaglio(Map params) {
        dichiarazioneIscrizioneRes = new AnaDichiarazioneIscrizioneRes()
        dichiarazioneIscrizioneRes.pratica = pratica
        dichiarazioneIscrizioneRes.idPratica = pratica.idPratica

        dichiarazioneIscrizioneRes.tipoConvivenza = listaTipoConvivenza.first()
        dichiarazioneIscrizioneRes.conteggio = EConteggio.COMPORTA
        dichiarazioneIscrizioneRes.tipoFamiglia = ETipoFamiglia.FAMIGLIA

        caricaElementiCivico()
    }

    @Override
    @Command
    void onRicercaFamiglia() {
        civico.copyTo(dichiarazioneIscrizioneRes.indirizzo)
        super.onRicercaFamiglia()
    }

    @Override
    protected void caricaDatiFamiglia(AnaIndirizzoStradario famiglia) {
        super.caricaDatiFamiglia(famiglia)
        civico = DatiCivico.fromEntity(dichiarazioneIscrizioneRes.indirizzo)
    }

    @Override
    Object getDettaglio() {
        return pratica
    }

    EFascia getFascia() {
        return EFascia.ISCRITTO_APR
    }

    ETipoAnagrafe getArchivioAnagrafe() {
        return ETipoAnagrafe.RESIDENTI
    }

    ETipoPratica getTipoPratica() {
        return ETipoPratica.ISC
    }

    @Override
    protected void popolaCampiAggiuntiviSoggetto(ISoggettoPratica sogg) {
        // Campi specifici dell'iscrizione
        (sogg as AnaSoggettoIscrizioneRes).idDichiarazione = dichiarazioneIscrizioneRes.idDichiarazione
        (sogg as AnaSoggettoIscrizioneRes).annoDichiarazione = pratica.anno
        (sogg as AnaSoggettoIscrizioneRes).numeroDichiarazione = pratica.numero

        List<AnaRapportoParentela> list = sogg.anagrafe.sesso == ESesso.M ? rapportoParentelaMList : rapportoParentelaFList
        sogg.rapportoParentelaNuovo = list?.find {
            it.codiceRapportoParentela == sogg.anagrafe.codRp
        }
        // Setta i campi nuovoCodRp, nuovaSequenzaRp, rapportoParentela, istRp
        if (sogg.rapportoParentelaNuovo) {
            selezionaRapportoParentela(sogg, 'N', false)
        }
    }

    @Override
    void salvaSoggetto(ISoggettoPratica soggetto) {
        anaSoggettoIscrizioneResService.saveOrUpdate(soggetto as AnaSoggettoIscrizioneRes)
    }

    void inserisciSoggettiFamiglia(AnaFamiglia famiglia, Boolean interoNucleo) {
        selectedVariazione = listaVariazioni.find { it.codiceMovimento == 1 && it.evento.id == 4}
        onSelectVariazione()
        salva(false) //Aggiorno la variazione prima di procedere
        dichiarazioneIscrizioneRes.codFamigliaProv = famiglia.codice
        List<AnaAnagrafe> famigliari = anaAnagrafeService.listAllFamigliariAttiviByFamiglia(famiglia)

        rapportoParentelaFPrecList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.F, famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA)
        rapportoParentelaMPrecList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.M, famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA)
        popolaRapportoParentelaLists()


        for (AnaAnagrafe f : famigliari) {
            AnaSoggettoIscrizioneRes sogg = new AnaSoggettoIscrizioneRes()
            sogg.anagrafe = f
            sogg.dichiarazioneIscrizioneRes = dichiarazioneIscrizioneRes
            sogg.idDichiarazione = dichiarazioneIscrizioneRes.idDichiarazione
            sogg.flagSoggetto = interoNucleo
            sogg.numeroOrdine = dichiarazioneIscrizioneRes.soggettiIscrizioneRes.size() + 1
            sogg.pratica = pratica
            sogg.idPratica = pratica.idPratica
            sogg.sesso = f.sesso
            sogg.annoDichiarazione = pratica.anno
            sogg.numeroDichiarazione = pratica.numero
            sogg.archivioAnagrafe = archivioAnagrafe
            sogg.tipoPratica = tipoPratica
            sogg.rapportoParentela = anaRapportoParentelaIstatService.findBySessoAndCodiceRapportoParentela(f.sesso, f.rapportoParentela?.codiceRapportoParentela)
            if (sogg.rapportoParentela == null) {
                sogg.rapportoParentela = anaRapportoParentelaIstatService.findBySessoAndCodiceRapportoParentela(f.sesso, CONVIVENTE)
            }

            anaSoggettoIscrizioneResService.saveOrUpdate(sogg)

            dichiarazioneIscrizioneRes.soggettiIscrizioneRes.add(sogg)
            //Necessario per salvare il codice famiglia provenienza
            anaDichiarazioneIscrizioneResService.updateCodiceFamiglia(dichiarazioneIscrizioneRes.id, dichiarazioneIscrizioneRes.codFamigliaProv)

        }

        tuttiSoggettiSelezionati = interoNucleo

        // Impostiamo i rapporti parentela di default
        impostaRapportoParentelaDefault()

        pratica.dichiarazioneCancellazioneAir = new AnaDichiarazioneCancellazioneAir()
        pratica.dichiarazioneCancellazioneAir.pratica = pratica
        pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.annoPratica = pratica.anno
        pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.pratica = pratica.numero
        pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.motivoCancellazione = listaMotivoCancellazione.first()
        pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.numeroFoglio = dichiarazioneIscrizioneRes.codFamigliaProv

        //Salvo i soggetti inseriti
        salvaDichiarazione()
    }

    @Override
    ISoggettoPratica getNewSoggetto() {
        return new AnaSoggettoIscrizioneRes()
    }

    void checkDatiAggiuntiviPratica() {
        if (pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }

        if(!selectedVariazione.flagPreliminare) { //Perfezionamento definitivo
            AnaVariazione reimmigrazioneAire = anaVariazioneService.findByFlagReimmigrazioneAireIsTrue()
            if (dichiarazione.codFamigliaProv != null && selectedVariazione.id != reimmigrazioneAire.id) { //Reimmigrazione AIRE
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Variazione_Non_Corretta")))
            }
            if (soggetti.size() > 0 && dichiarazione.codFamigliaProv == null && selectedVariazione.id == reimmigrazioneAire.id) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Variazione_Non_Corretta")))
            }
        }

        String sezione = "Famiglia"
        if (dichiarazioneIscrizioneRes.flagAggregazione == null || dichiarazioneIscrizioneRes.tipoFamiglia == null ||
                dichiarazioneIscrizioneRes.indirizzo.via == null ||
                (dichiarazioneIscrizioneRes.flagAggregazione && dichiarazioneIscrizioneRes.indirizzo.numeroCivico == null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }

        if(dichiarazioneIscrizioneRes.famigliaDest?.fascia != null && dichiarazioneIscrizioneRes.famigliaDest.fascia != EFascia.ISCRITTO_APR) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Famiglia_Cancellata"))
        }

        sezione = "Convivenza"
        if (!dichiarazioneIscrizioneRes.flagAggregazione && dichiarazioneIscrizioneRes.tipoFamiglia == ETipoFamiglia.CONVIVENZA) {
            if (dichiarazioneIscrizioneRes.tipoConvivenza == null || dichiarazioneIscrizioneRes.convivenza == null ||
                    dichiarazioneIscrizioneRes.cognomeIntestatarioConvivenza == null ||
                    dichiarazioneIscrizioneRes.nomeIntestatarioConvivenza == null ||
                    dichiarazioneIscrizioneRes.dataIntestatarioConvivenza == null ||
                    dichiarazioneIscrizioneRes.dataIstituzioneConvivenza == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
        }



    }

    void checkSoggettiPratica() {
        if (pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }
        String sezione = "Inserire almeno un soggetto"
        if (dichiarazioneIscrizioneRes.soggettiIscrizioneRes.size() < 1) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }

        sezione = "Soggetti"
        for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
            if (s.numeroOrdine == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
            if (dichiarazioneIscrizioneRes.codFamigliaProv != null) { //caso AIRE
                if (s.flagSoggetto && s.rapportoParentelaNuovo == null) {
                    throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
                }
                if (!s.flagSoggetto && s.rapportoParentelaPrecedente == null) {
                    throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
                }
                if (s.flagSoggetto && s.rapportoParentela?.tipoFamiglia != dichiarazioneIscrizioneRes.tipoFamiglia) {
                    throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Rapporto_Parentela_Errato")))
                }
            } else {
                if (s.rapportoParentela?.tipoFamiglia != dichiarazioneIscrizioneRes.tipoFamiglia) {
                    throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Rapporto_Parentela_Errato")))
                }
            }

        }

        if (dichiarazioneIscrizioneRes.tipoFamiglia == ETipoFamiglia.FAMIGLIA) { // Famiglia
            if (dichiarazioneIscrizioneRes.flagAggregazione) { // Aggregazione sì
                if (dichiarazioneIscrizioneRes.codFamigliaProv == null) { // Caso standard
                    if (dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (it.rapportoParentela?.codiceRapportoParentela == CAPO_FAMIGLIA) } > 0) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Aggregazione")))
                    }
                } else { //Caso AIRE
                    if (dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (it.flagSoggetto && it.rapportoParentelaNuovo.codiceRapportoParentela == CAPO_FAMIGLIA) } > 0 ||
                            (!tuttiSoggettiSelezionati && dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (!it.flagSoggetto && it.rapportoParentelaPrecedente.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1)) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Errati")))
                    }
                }

            } else { // Aggregazione no
                if (dichiarazioneIscrizioneRes.codFamigliaProv == null) { // Caso standard
                    if (dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (it.rapportoParentela?.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Creazione")))
                    }
                } else { //Caso AIRE
                    if (dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (it.flagSoggetto && it.rapportoParentelaNuovo.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1 ||
                            (!tuttiSoggettiSelezionati && dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (!it.flagSoggetto && it.rapportoParentelaPrecedente.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1)) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Creazione")))
                    }
                }
            }
        } else { // Convivenza
            if (dichiarazioneIscrizioneRes.flagAggregazione) { // Aggregazione sì
                if (dichiarazioneIscrizioneRes.codFamigliaProv == null) { //Caso standard
                    int countCC = (int) dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (it.rapportoParentela?.codiceRapportoParentela == CAPO_CONVIVENZA) }
                    if (dichiarazioneIscrizioneRes.famigliaDest?.flagEsisteCC && countCC > 0) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Presente_Aggregazione")))
                    } else if (!dichiarazioneIscrizioneRes.famigliaDest?.flagEsisteCC && countCC > 1) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Aggregazione")))
                    }
                } else { //Caso AIRE
                    int countCC = (int) dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (it.flagSoggetto && it.rapportoParentelaNuovo.codiceRapportoParentela == CAPO_CONVIVENZA) }
                    if (dichiarazioneIscrizioneRes.famigliaDest?.flagEsisteCC && countCC > 0) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Presente_Aggregazione")))
                    } else if (!dichiarazioneIscrizioneRes.famigliaDest?.flagEsisteCC && countCC > 1) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Aggregazione")))
                    } else if (!tuttiSoggettiSelezionati && dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (!it.flagSoggetto && it.rapportoParentelaPrecedente.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Errati")))
                    }
                }

            } else { // Aggregazione no
                if (dichiarazioneIscrizioneRes.codFamigliaProv == null) {
                    if (dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (it.rapportoParentela?.codiceRapportoParentela == CAPO_CONVIVENZA) } > 1) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Creazione")))
                    }
                } else { //Caso AIRE
                    if (dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (it.flagSoggetto && it.rapportoParentelaNuovo.codiceRapportoParentela == CAPO_CONVIVENZA) } > 1) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Creazione")))
                    } else if (!tuttiSoggettiSelezionati && dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (!it.flagSoggetto && it.rapportoParentelaPrecedente.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1) {
                        throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Errati")))
                    }
                }
            }
        }

        // Controllo famiglia provenienza
        if (dichiarazioneIscrizioneRes.codFamigliaProv != null) {
            dichiarazioneIscrizioneRes.flagInteroNucleo = dichiarazioneIscrizioneRes.soggettiIscrizioneRes.every { it.flagSoggetto == true }
            if (!dichiarazioneIscrizioneRes.flagInteroNucleo &&
                    dichiarazioneIscrizioneRes.soggettiIscrizioneRes.count { (!it.flagSoggetto && it.rapportoParentelaPrecedente.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Famiglia_Prec")))
            }
        }
    }

    @Override
    void popolaDefault() {
        if (!modifica) {
            if (dichiarazioneIscrizioneRes.comuneProvenienza?.codice == null) { //Provenienza non indicata

                dichiarazioneIscrizioneRes.richiesta = listaRichieste.find { it.codice == selectedVariazione.codiceRichiestaDefault.toString() }
                dichiarazioneIscrizioneRes.provvedimento = listaProvvedimenti.find { it?.codice == selectedVariazione.codiceProvvedimentoDefault.toString() }

            } else { //Provenieneza indicata

                if (comuneProvenienzaEstero) { //  Comune di provenienza estero
                    selectedStato = listaStati.find { it.codiceProvincia == dichiarazioneIscrizioneRes.comuneProvenienza.codiceProvincia }
                    if (dichiarazioneIscrizioneRes.comuneIscrizioneAire?.codice == null || (
                            dichiarazioneIscrizioneRes.comuneIscrizioneAire?.codice == gsdService.getComuneCliente().codiceComune && dichiarazioneIscrizioneRes.comuneIscrizioneAire?.codiceProvincia == gsdService.getComuneCliente().codiceProvincia)) {
                        // Comune di iscrizione AIRE nullo o corrisponde al mio
                        dichiarazioneIscrizioneRes.richiesta = listaRichieste.find { it.codice == null }
                        dichiarazioneIscrizioneRes.provvedimento = listaProvvedimenti.find { it?.codice == PROVVEDIMENTO_ESTERO }

                    } else { // Comune di iscrizione AIRE valorizzato
                        dichiarazioneIscrizioneRes.richiesta = listaRichieste.find { it.codice == "2" }
                        dichiarazioneIscrizioneRes.provvedimento = listaProvvedimenti.find { it?.codice == PROVVEDIMENTO_ESTERO }
                    }

                } else { // Comune di provenienza italiano
                    dichiarazioneIscrizioneRes.richiesta = listaRichieste.find { it.codice == "1" }
                    dichiarazioneIscrizioneRes.provvedimento = listaProvvedimenti.find { it?.codice == PROVVEDIMENTO_PROVENIENZA_ITALIANA }

                }
            }

            dichiarazioneIscrizioneRes.motivo = selectedVariazione.motivoDefault
        }

    }

    @Override
    void riempiComuneProvenienza(ETipoComuneAtto tipoComune, ArcComuneBaseDomain c) {
        switch (tipoComune) {
            case ETipoComuneAtto.PROV:
                riempiComune(dichiarazioneIscrizioneRes.comuneProvenienza, c)
                comuneProvenienzaEstero = gsdService.checkComuneEstero(dichiarazioneIscrizioneRes.comuneProvenienza.codiceProvincia, dichiarazioneIscrizioneRes.comuneProvenienza.codice)
                popolaDefault()
                if(!comuneProvenienzaEstero) {
                    selezionaComune(ETipoComuneAtto.ISC_AIRE, null)
                }
                break
            case ETipoComuneAtto.ISC_AIRE:
                riempiComune(dichiarazioneIscrizioneRes.comuneIscrizioneAire, c)
                popolaDefault()
                break
        }
    }

    @Override
    void salvaDichiarazione() {

        if (dichiarazioneIscrizioneRes.id == null) {
            dichiarazioneIscrizioneRes.id = gsdService.getIntegerIdFromSequence(dichiarazioneIscrizioneRes, dichiarazioneIscrizioneRes.getTableName())
        }

        dichiarazioneIscrizioneRes.idDichiarazione = pratica.idPratica
        dichiarazioneIscrizioneRes.anno = pratica.anno
        dichiarazioneIscrizioneRes.numero = pratica.numero
        dichiarazioneIscrizioneRes.annoPratica = pratica.anno
        dichiarazioneIscrizioneRes.numeroPratica = pratica.numero
        dichiarazioneIscrizioneRes.dataPratica = pratica.data
        dichiarazioneIscrizioneRes.dataDecorrenza = pratica.dataDecorrenza
        dichiarazioneIscrizioneRes.iniziativa = pratica.codiceIniziativa
        dichiarazioneIscrizioneRes.codiceRichiesta = dichiarazioneIscrizioneRes.richiesta?.codice
        dichiarazioneIscrizioneRes.codiceProvvedimento = dichiarazioneIscrizioneRes.provvedimento?.codice
        dichiarazioneIscrizioneRes.codiceStato = selectedStato?.codiceProvincia
        dichiarazioneIscrizioneRes.sottoscritto = selectedDichiarante?.numeroOrdine
        if (dichiarazioneIscrizioneRes.tipoConvivenza?.id == null) { // Oggetto dummy
            dichiarazioneIscrizioneRes.tipoConvivenza = null
        }
        if (dichiarazioneIscrizioneRes.provvedimento?.codice != PROVVEDIMENTO_ESTERO) {
            dichiarazioneIscrizioneRes.codiceStato = null
        }
        if (dichiarazioneIscrizioneRes.provvedimento?.codice != PROVVEDIMENTO_IRREPERIBILITA) {
            dichiarazioneIscrizioneRes.dataIrreperibilita = null
        }
        if (dichiarazioneIscrizioneRes.provvedimento?.codice != PROVVEDIMENTO_MOTIVO) {
            dichiarazioneIscrizioneRes.motivo = null
        }

        for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
            s.annoDichiarazione = pratica.anno
            s.numeroDichiarazione = pratica.numero
        }
        civico.copyTo(dichiarazioneIscrizioneRes.indirizzo)

        //Date modello AIRE
        if (dichiarazioneIscrizioneRes.codFamigliaProv != null && pratica?.dichiarazioneCancellazioneAir) {
            pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.dataDecorrenza = pratica.dataDecorrenza
            pratica.dichiarazioneCancellazioneAir.modelloAireCancellazione.dataProtocolloAire = pratica.data
        }
        // Sostituisce la PersistentBag di Hibernate con un ArrayList semplice prima del merge,
        // per evitare che preserveSnapshot tenti di caricare entità già eliminate via orphanRemoval
        // in una precedente chiamata a salvaDichiarazione() (es. da checkAndSalvaPratica in onInserisciSoggetto).
        dichiarazioneIscrizioneRes.soggettiIscrizioneRes = new ArrayList<>(dichiarazioneIscrizioneRes.soggettiIscrizioneRes)
        anaDichiarazioneIscrizioneResService.saveOrUpdate(dichiarazioneIscrizioneRes)

    }

    @Override
    void annullaDichiarazione() {
        dichiarazioneIscrizioneRes.statoPratica = ANNULLATA
        if(pratica.flagPerfezionamentoPreliminare && !dichiarazioneIscrizioneRes.flagAggregazione) {
            //Pratica perfezionata preliminarmente e senza aggregazione
            //Tolgo il riferimento alla famglia creata nella fase di perfezionamento preliminare
            dichiarazioneIscrizioneRes.codFamigliaDest = null
            dichiarazioneIscrizioneRes.famigliaDest = null
            anaDichiarazioneIscrizioneResService.saveOrUpdate(dichiarazioneIscrizioneRes)
        }
    }

    @Override
    AnaFamiglia inserisciFamiglia() {
        AnaFamiglia famiglia = new AnaFamiglia()

        famiglia.fascia = EFascia.ISCRITTO_APR
        famiglia.codice = gsdService.getCodiceFamiglia(famiglia.fascia)
        famiglia.id = gsdService.getCodiceFamigliaUnique(famiglia.fascia, famiglia.codice)

        IndirizzoResidenteFamiglia indirizzoRes = new IndirizzoResidenteFamiglia()
        IndirizzoCivico indirizzo = indirizzoRes.indirizzo
        copiaDatiIndirizzo(indirizzo, dichiarazioneIscrizioneRes.indirizzo)
        famiglia.indirizzo = indirizzoRes

        famiglia.convivenza = dichiarazioneIscrizioneRes.tipoFamiglia == ETipoFamiglia.CONVIVENZA
        if (famiglia.convivenza) {
            famiglia.tipoConvivenza = dichiarazioneIscrizioneRes.tipoConvivenza
            famiglia.descrizioneConvivenza = dichiarazioneIscrizioneRes.convivenza
            famiglia.intestatarioConvivenza = dichiarazioneIscrizioneRes.intestatarioConvivenza
            famiglia.cognomeIntestatario = dichiarazioneIscrizioneRes.cognomeIntestatarioConvivenza
            famiglia.nomeIntestatario = dichiarazioneIscrizioneRes.nomeIntestatarioConvivenza
            famiglia.intestatario = "${dichiarazioneIscrizioneRes.cognomeIntestatarioConvivenza}/${dichiarazioneIscrizioneRes.nomeIntestatarioConvivenza}"
            famiglia.dataIntestatarioConvivenza = dichiarazioneIscrizioneRes.dataIntestatarioConvivenza
            famiglia.dataIstituzioneConvivenza = dichiarazioneIscrizioneRes.dataIstituzioneConvivenza
        } else {
            for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
                if (s.rapportoParentela?.codiceRapportoParentela == CAPO_FAMIGLIA) {
                    famiglia.intestatario = "${s.anagrafe.cognome}/${s.anagrafe.nome}"
                    famiglia.nomeIntestatario = s.anagrafe.nome
                    famiglia.cognomeIntestatario = s.anagrafe.cognome
                    break
                }
            }

        }

        salvaFamiglia(famiglia)
        dichiarazioneIscrizioneRes.famigliaDest = famiglia
        dichiarazioneIscrizioneRes.codFamigliaDest = famiglia.codice
        anaDichiarazioneIscrizioneResService.saveOrUpdate(dichiarazioneIscrizioneRes)
        return famiglia

    }

    @Override
    AnaFamiglia updateFamiglia(String id) {
        AnaFamiglia famiglia = anaFamigliaService.get(id, null)

        IndirizzoCivico indirizzo = (famiglia.indirizzo as IndirizzoResidenteFamiglia).indirizzo
        copiaDatiIndirizzo(indirizzo, dichiarazioneIscrizioneRes.indirizzo)

        famiglia.convivenza = dichiarazioneIscrizioneRes.tipoFamiglia == ETipoFamiglia.CONVIVENZA
        if (famiglia.convivenza) {
            famiglia.tipoConvivenza = dichiarazioneIscrizioneRes.tipoConvivenza
            famiglia.descrizioneConvivenza = dichiarazioneIscrizioneRes.convivenza
            famiglia.intestatarioConvivenza = dichiarazioneIscrizioneRes.intestatarioConvivenza
            famiglia.cognomeIntestatario = dichiarazioneIscrizioneRes.cognomeIntestatarioConvivenza
            famiglia.nomeIntestatario = dichiarazioneIscrizioneRes.nomeIntestatarioConvivenza
            famiglia.intestatario = "${dichiarazioneIscrizioneRes.cognomeIntestatarioConvivenza}/${dichiarazioneIscrizioneRes.nomeIntestatarioConvivenza}"
            famiglia.dataIntestatarioConvivenza = dichiarazioneIscrizioneRes.dataIntestatarioConvivenza
            famiglia.dataIstituzioneConvivenza = dichiarazioneIscrizioneRes.dataIstituzioneConvivenza
        } else {
            for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
                if (s.rapportoParentela?.codiceRapportoParentela == CAPO_FAMIGLIA) {
                    famiglia.intestatario = "${s.anagrafe.cognome}/${s.anagrafe.nome}"
                    famiglia.nomeIntestatario = s.anagrafe.nome
                    famiglia.cognomeIntestatario = s.anagrafe.cognome
                    break
                }
            }

        }

        salvaFamiglia(famiglia)
        return famiglia

    }

    @Override
    void perfezionaSoggetti(AnaStato stato, Integer fascia, AnaFamiglia famiglia) {
        for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
            if (!s.flagAnnullamento && s.flagSoggetto) {

                if(!pratica.flagPerfezionamento || dichiarazioneIscrizioneRes.codFamigliaProv != null) { //Perfezionamento preliminare o reimmi
                    s.fasciaRipristino = s.anagrafe.fascia
                    s.statoRipristino = s.anagrafe.stato
                    s.dataInizioFamigliaRipristino = s.anagrafe.dataInizioParentela
                    s.dataInizioResidenzaRipristino = s.anagrafe.dataResidenza
                    s.codFamigliaRipristino = s.anagrafe.codFamiglia
                    s.codRpRipristino = s.anagrafe.codRp
                    s.sequenzaRpRipristino = s.anagrafe.sequenzaParentela
                    anaSoggettoIscrizioneResService.saveOrUpdate(s)
                }

                if(pratica.flagPerfezionamento && fascia == 1 && stato.id == 2 &&
                        s.fasciaRipristino == EFascia.CANCELLATO_APR && s.statoRipristino.id == 51) {
                    s.anagrafe.fascia = EFascia.ISCRITTO_APR
                    s.anagrafe.stato = statoReimmigrazione
                } else {
                    s.anagrafe.fascia = EFascia.ISCRITTO_APR
                    s.anagrafe.stato = stato
                }

                s.anagrafe.dataUltimoEvento = pratica.dataDecorrenza
                s.anagrafe.dataInizioParentela = pratica.dataDecorrenza
                s.anagrafe.dataResidenza = pratica.dataDecorrenza
                if (dichiarazioneIscrizioneRes.flagAggregazione) {
                    s.anagrafe.famiglia = dichiarazioneIscrizioneRes.famigliaDest
                    s.anagrafe.codFamiglia = dichiarazioneIscrizioneRes.codFamigliaDest
                } else {
                    s.anagrafe.famiglia = famiglia
                    s.anagrafe.codFamiglia = famiglia.codice
                }

            }
            //Aggiornamento rapporto parentela in anagrafe per il caso AIRE
            if(dichiarazioneIscrizioneRes.codFamigliaProv != null && !s.flagAnnullamento) {
                if(s.flagSoggetto) {
                    s.anagrafe.codRp = s.nuovoCodRp
                    s.anagrafe.sequenzaParentela = s.nuovaSequenzaRp
                } else {
                    s.anagrafe.codRp = s.codRpPrecedente
                    s.anagrafe.sequenzaParentela = s.sequenzaRpPrecedente
                }
            }
            s.anagrafe.dataRegistrazione = DataUtils.getDataCorrente()
            anaAnagrafeService.saveOrUpdate(s.anagrafe)
        }
        if(dichiarazioneIscrizioneRes.codFamigliaProv != null && dichiarazioneIscrizioneRes.flagInteroNucleo) { //Reimmi con intero nucleo
            dichiarazioneIscrizioneRes.famigliaProv.fascia = EFascia.CANCELLATO_AIRE
            anaFamigliaService.saveOrUpdate(dichiarazioneIscrizioneRes.famigliaProv)
        }

    }

    @Override
    void annullaSoggetti() {
        if(pratica.flagPerfezionamentoPreliminare) { //Perfezionamento preliminare già effettuato -> rollback
            ripristinaSoggetti()
        }
        for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
            //Nel caso reimmigrazione non verrà effettuata alcuna modifica del soggetto
            //perché questo è in fascia 3 e in caso di annullamento ci deve restare

            AnaAnagrafe anagrafe = anaAnagrafeService.findByIdWithStato(s.anagrafe.id) //Necessario per caricarsi da DB l'attuale stato del soggetto
            if (s.flagAnnullamento == true &&
                    anagrafe.fascia == EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA && anagrafe.stato?.id == statoInAttesa.id) {
                s.anagrafe.stato = statoImmigrazioneAnnullata
                s.anagrafe.dataRegistrazione = DataUtils.getDataCorrente()
                anaAnagrafeService.saveOrUpdate(s.anagrafe)
            }
        }
    }

    void ripristinaSoggetti() {
        for (AnaSoggettoIscrizioneRes s : dichiarazioneIscrizioneRes.soggettiIscrizioneRes) {
            if (s.flagAnnullamento == true && s.anagrafe.fascia == EFascia.ISCRITTO_APR) {

                if(s.fasciaRipristino == null || s.statoRipristino == null) {
                    if (dichiarazioneIscrizioneRes.codFamigliaProv == null) {
                        s.anagrafe.fascia = EFascia.ISCRIZIONE_ATTESA_O_ANNULLATA
                        s.anagrafe.stato = statoImmigrazioneAnnullata
                    } else { //Reimmigrazione AIRE
                        s.anagrafe.fascia = EFascia.ISCRITTO_AIRE
                        s.anagrafe.stato = statoResidenteEstero
                    }
                } else {
                    s.anagrafe.fascia = s.fasciaRipristino
                    s.anagrafe.stato = s.statoRipristino
                }
                s.anagrafe.dataInizioParentela = s.dataInizioFamigliaRipristino
                s.anagrafe.dataResidenza = s.dataInizioResidenzaRipristino
                s.anagrafe.codFamiglia = s.codFamigliaRipristino
                s.anagrafe.codRp = s.codRpRipristino
                s.anagrafe.sequenzaParentela = s.sequenzaRpRipristino

                s.anagrafe.famiglia = null
                s.anagrafe.dataRegistrazione = DataUtils.getDataCorrente()
                anaAnagrafeService.saveOrUpdate(s.anagrafe)
            }
        }
    }

    @Override
    void popolaRapportoParentelaLists(ETipoFamiglia tipoFamiglia = null) {
        if (tipoFamiglia) {
            rapportoParentelaFPrecList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.F, tipoFamiglia)
            rapportoParentelaMPrecList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.M, tipoFamiglia)
        } else {
            rapportoParentelaFList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.F, dichiarazioneIscrizioneRes.tipoFamiglia)
            rapportoParentelaMList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.M, dichiarazioneIscrizioneRes.tipoFamiglia)
        }

    }

    @Override
    void selezionaRapportoParentela(ISoggettoPratica sogg, String rapporto, boolean mostraMessaggio = true) {
        if (rapporto == 'P') {
            (sogg as AnaSoggettoIscrizioneRes).codRpPrecedente = (sogg as AnaSoggettoIscrizioneRes).rapportoParentelaPrecedente.codiceRapportoParentela
            (sogg as AnaSoggettoIscrizioneRes).sequenzaRpPrecedente = (sogg as AnaSoggettoIscrizioneRes).rapportoParentelaPrecedente.sequenza

        } else {
            (sogg as AnaSoggettoIscrizioneRes).nuovoCodRp = (sogg as AnaSoggettoIscrizioneRes).rapportoParentelaNuovo.codiceRapportoParentela
            (sogg as AnaSoggettoIscrizioneRes).nuovaSequenzaRp = (sogg as AnaSoggettoIscrizioneRes).rapportoParentelaNuovo.sequenza
            (sogg as AnaSoggettoIscrizioneRes).rapportoParentela = anaRapportoParentelaIstatService.findBySessoAndCodiceRapportoParentela(sogg.anagrafe.sesso, (sogg as AnaSoggettoIscrizioneRes).rapportoParentelaNuovo.codiceRapportoParentela)
            if ((sogg as AnaSoggettoIscrizioneRes).rapportoParentela == null) {
                (sogg as AnaSoggettoIscrizioneRes).rapportoParentela = anaRapportoParentelaIstatService.findBySessoAndCodiceRapportoParentela(sogg.anagrafe.sesso, CONVIVENTE)
                if(mostraMessaggio) {
                    Messagebox.show(getEtichetta(Etichette.getEtichetta("Rapporto_Parentela_Non_Istat")), msgTitle, Messagebox.OK, Messagebox.INFORMATION)
                }
            }
            (sogg as AnaSoggettoIscrizioneRes).istRp = (sogg as AnaSoggettoIscrizioneRes).rapportoParentela?.istRp
            if(dichiarazioneIscrizioneRes.codFamigliaProv == null) {
                (sogg as AnaSoggettoIscrizioneRes).anagrafe.codRp = (sogg as AnaSoggettoIscrizioneRes).nuovoCodRp
                (sogg as AnaSoggettoIscrizioneRes).anagrafe.sequenzaParentela = (sogg as AnaSoggettoIscrizioneRes).nuovaSequenzaRp
                anaAnagrafeService.saveOrUpdate((sogg as AnaSoggettoIscrizioneRes).anagrafe)
            }

        }

    }

    @Command
    void onStampaModelloApr4() {
        checkDatiObbligatoriPratica()
        checkDatiObbligatoriSoggettiEDichiarante()
        salva(false)

        Window w = (Window) Executions.createComponents("/restrict/afc/popupUfficialeAnagrafe.zul", self, [sorgente: 'P'])
        w.addEventListener(CustomEvents.ON_CLOSE_RELOAD, { event ->
            if (dichiarazioneIscrizioneRes.soggettiIscrizioneRes.size() == 1) {
                generateUnComponente(dichiarazioneIscrizioneRes.getAnno(), dichiarazioneIscrizioneRes.getNumero(), event.data.ufficialeAnagrafe as String)
            } else { // > 1
                generateApr4DueComponenti(dichiarazioneIscrizioneRes.getAnno(), dichiarazioneIscrizioneRes.getNumero(), event.data.ufficialeAnagrafe as String)
            }
        })
        w.doModal()
    }

    void generateApr4DueComponenti(Integer anno, Integer numeroDic, String ufficialeAnagrafe) {
        if (!numeroDic) {
            return
        }

        byte[] result = apr4ModelPdfService.generateApr4DueComponenti(anno, numeroDic, ufficialeAnagrafe)

        if (result) {
            String pdfFile = "MODELLO_APR4_${pratica.anno}_${pratica.numero}.pdf"
            Filedownload.save(result, ETipoFile.PDF.contentType, pdfFile)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_generazione_modello_apr4")), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
    }

    void generateUnComponente(Integer anno, Integer numeroDic, String ufficialeAnagrafe) {
        if (!numeroDic) {
            return
        }

        byte[] result = apr4ModelPdfService.generateApr4UnComponenti(anno, numeroDic, ufficialeAnagrafe)

        if (result) {
            String pdfFileUnComponente = "MODELLO_APR4_${pratica.anno}_${pratica.numero}.pdf"
            Filedownload.save(result, ETipoFile.PDF.contentType, pdfFileUnComponente)
        } else {
            Messagebox.show(getEtichetta(Etichette.getEtichetta("Errore_generazione_modello_apr4")), msgTitle, Messagebox.OK, Messagebox.ERROR)
        }
    }

    @Command
    void onStampaDichiarazioneResidenza() {
        checkDatiObbligatoriPratica()
        checkDatiObbligatoriSoggettiEDichiarante()
        salva(false)

        try {
            byte[] result = dichiarazioneResidenzaPdfService.generateDichiarazioneResidenzaPdf(pratica)
            String pdfFile = "DICHIARAZIONE_RESIDENZA_${pratica.anno}_${pratica.numero}.pdf"
            Filedownload.save(result, ETipoFile.PDF.contentType, pdfFile)
        } catch (De4gsdzkRuntimeException e) {
            log.error("Errore generazione dichiarazione residenza", e)
            Messagebox.show(e.message, "Errore", Messagebox.OK, Messagebox.ERROR)
        }
    }

    void eliminaFamiglia() {
        new ArrayList<>(dichiarazioneIscrizioneRes.soggettiIscrizioneRes).each {
            anaSoggettoIscrizioneResService.delete(it as AnaSoggettoIscrizioneRes)
        }
        dichiarazioneIscrizioneRes.soggettiIscrizioneRes = new ArrayList<>()
        dichiarazioneIscrizioneRes.codFamigliaProv = null
        dichiarazioneIscrizioneRes.famigliaProv = null
        tuttiSoggettiSelezionati = false
        salvaDichiarazione()
    }

    @Override
    void filtraVariazioni() {
        //Solo per rettifiche
    }

    @Override
    boolean isRettificaIndividuo() {
        return false
    }

    @Override
    boolean isRettificaFamiglia() {
        return false
    }
}
