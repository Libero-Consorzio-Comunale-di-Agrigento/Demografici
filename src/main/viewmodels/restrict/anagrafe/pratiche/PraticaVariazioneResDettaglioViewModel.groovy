package restrict.anagrafe.pratiche

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.anagrafe.*
import it.finmatica.de4gsdzk.anagrafe.pratiche.*
import it.finmatica.de4gsdzk.archivi.ArcDatiNumerazioneCivicoService
import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.errors.De4gsdzkRuntimeException
import it.finmatica.de4gsdzk.statocivile.embed.indirizzo.famiglia.IndirizzoResidenteFamiglia
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.event.Event
import org.zkoss.zk.ui.event.Events
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class PraticaVariazioneResDettaglioViewModel extends AbstractPraticaDettaglioViewModel implements TraitGestioneCivico {


    @WireVariable
    AnaDichiarazioneVariazioneResService anaDichiarazioneVariazioneResService
    @WireVariable
    AnaSoggettoVariazioneResService anaSoggettoVariazioneResService
    @WireVariable
    ArcDatiNumerazioneCivicoService arcDatiNumerazioneCivicoService

    AnaDichiarazioneVariazioneRes dichiarazioneVariazioneRes
    AnaSoggettoVariazioneRes soggettoDummy = new AnaSoggettoVariazioneRes(numeroOrdine: 9, anagrafe: new AnaAnagrafe(nome: "DICHIARANTE", cognome: "ALTRO"))


    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w, @ExecutionArgParam("id") Long id, @ExecutionArgParam("modifica") boolean modifica,
         @ExecutionArgParam("idAvanzamento") Integer idAvanzamento, @ExecutionArgParam("readOnly") boolean readOnly) {

        doInit(w, id, modifica, readOnly)

        if (!modifica) {
            onSelectVariazione()
        }

        List<Map<String, String>> eList = [Etichette.getEtichetta("Variazione")]
        eList.addAll(AnaDichiarazioneVariazioneRes.etichetteDomain)
        eList.addAll(Etichette.getEtichetta("Rapporto_Parentela_Non_Istat"))
        eList.addAll(etichetteGestioneCivico)

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
        return dichiarazioneVariazioneRes
    }

    @Override
    List<ISoggettoPratica> getSoggetti() {
        dichiarazioneVariazioneRes.soggettiVariazioneRes?.sort { it.numeroOrdine }
        return dichiarazioneVariazioneRes.soggettiVariazioneRes
    }

    @Override
    List<ISoggettoPratica> getSoggettiNonOrdinati() {
        return dichiarazioneVariazioneRes.soggettiVariazioneRes
    }


    @Override
    void caricaDettaglio(Object id) {
        caricaPratica(id as Long)
        dichiarazioneVariazioneRes = anaDichiarazioneVariazioneResService.findByPratica(pratica as AnaPratica)
        if (dichiarazioneVariazioneRes == null) {
            //Entro in questo caso solo se arrivo da un recupero pratica
            creaDettaglio([:])
        } else {
            popolaListaDichiaranti()
            selectedDichiarante = listaDichiaranti.find { it.numeroOrdine == dichiarazioneVariazioneRes.sottoscritto }
            if (dichiarazioneVariazioneRes.codFamigliaProv != null) { // Caso variazione
                popolaRapportoParentelaLists()
                popolaRapportoParentelaLists(ETipoFamiglia.FAMIGLIA)
                for (AnaSoggettoVariazioneRes s : dichiarazioneVariazioneRes.soggettiVariazioneRes) {
                    if (s.anagrafe.sesso == ESesso.M) {
                        s.rapportoParentelaPrecedente = rapportoParentelaMPrecList.find { it.codiceRapportoParentela == s.codRpPrecedente }
                        s.rapportoParentelaNuovo = rapportoParentelaMList.find { it.codiceRapportoParentela == s.nuovoCodRp }
                    } else {
                        s.rapportoParentelaPrecedente = rapportoParentelaFPrecList.find { it.codiceRapportoParentela == s.codRpPrecedente }
                        s.rapportoParentelaNuovo = rapportoParentelaFList.find { it.codiceRapportoParentela == s.nuovoCodRp }
                    }

                }

            }
        }

        caricaElementiCivico(dichiarazioneVariazioneRes?.indirizzo?.via?.id)
    }

    @Override
    void creaDettaglio(Map params) {
        dichiarazioneVariazioneRes = new AnaDichiarazioneVariazioneRes()
        dichiarazioneVariazioneRes.pratica = pratica
        dichiarazioneVariazioneRes.idPratica = pratica.idPratica

        dichiarazioneVariazioneRes.tipoConvivenza = listaTipoConvivenza.first()
        dichiarazioneVariazioneRes.tipoFamiglia = ETipoFamiglia.FAMIGLIA

        caricaElementiCivico()
    }

    @Override
    void selezionaVia(ArcVia c) {
        copiaDatiIndirizzo(dichiarazioneVariazioneRes.indirizzo, null)
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
    @Command
    void onRicercaFamiglia() {
        civico.copyTo(dichiarazioneVariazioneRes.indirizzo)
        super.onRicercaFamiglia()
    }

    @Override
    protected void caricaDatiFamiglia(AnaIndirizzoStradario famiglia) {
        super.caricaDatiFamiglia(famiglia)
        civico = DatiCivico.fromEntity(dichiarazioneVariazioneRes.indirizzo)
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
        return ETipoPratica.VAR
    }

    @Override
    protected void popolaCampiAggiuntiviSoggetto(ISoggettoPratica sogg) {
        AnaSoggettoVariazioneRes soggetto = sogg as AnaSoggettoVariazioneRes
        // Campi specifici della variazione
        soggetto.annoPratica = pratica.anno
        soggetto.numeroPratica = pratica.numero
    }

    @Override
    void salvaSoggetto(ISoggettoPratica soggetto) {
        anaSoggettoVariazioneResService.saveOrUpdate(soggetto as AnaSoggettoVariazioneRes)
    }

    void inserisciSoggettiFamiglia(AnaFamiglia famiglia, Boolean interoNucleo) {
        dichiarazioneVariazioneRes.codFamigliaProv = famiglia.codice
        //Salvo la dichiarazione così se non ha ancora un id le viene assegnato
        salvaDichiarazione()
        List<AnaAnagrafe> famigliari = anaAnagrafeService.listAllFamigliariAttiviByFamiglia(famiglia)

        rapportoParentelaFPrecList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.F, famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA)
        rapportoParentelaMPrecList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.M, famiglia.convivenza ? ETipoFamiglia.CONVIVENZA : ETipoFamiglia.FAMIGLIA)
        popolaRapportoParentelaLists()


        for (AnaAnagrafe f : famigliari) {
            AnaSoggettoVariazioneRes sogg = new AnaSoggettoVariazioneRes()
            sogg.anagrafe = f
            sogg.dichiarazioneVariazioneRes = dichiarazioneVariazioneRes
            sogg.flagSoggetto = interoNucleo
            sogg.numeroOrdine = dichiarazioneVariazioneRes.soggettiVariazioneRes.size() + 1
            sogg.pratica = pratica
            sogg.idPratica = pratica.idPratica
            sogg.annoPratica = pratica.anno
            sogg.numeroPratica = pratica.numero
            sogg.archivioAnagrafe = archivioAnagrafe
            sogg.tipoPratica = tipoPratica

            anaSoggettoVariazioneResService.saveOrUpdate(sogg)

            dichiarazioneVariazioneRes.soggettiVariazioneRes.add(sogg)

        }

        tuttiSoggettiSelezionati = interoNucleo

        // Impostiamo i rapporti parentela di default
        impostaRapportoParentelaDefault()
        //Salvo i soggetti inseriti
        salvaDichiarazione()

    }

    @Override
    ISoggettoPratica getNewSoggetto() {
        return new AnaSoggettoVariazioneRes()
    }

    void checkDatiAggiuntiviPratica() {
        if(pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }
        String sezione = "Famiglia"
        if (dichiarazioneVariazioneRes.flagAggregazione == null || dichiarazioneVariazioneRes.tipoFamiglia == null ||
                dichiarazioneVariazioneRes.indirizzo.via == null ||
                (dichiarazioneVariazioneRes.flagAggregazione && dichiarazioneVariazioneRes.indirizzo.numeroCivico == null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
        sezione = "Convivenza"
        if (!dichiarazioneVariazioneRes.flagAggregazione && dichiarazioneVariazioneRes.tipoFamiglia == ETipoFamiglia.CONVIVENZA) {
            if (dichiarazioneVariazioneRes.tipoConvivenza == null || dichiarazioneVariazioneRes.convivenza == null ||
                    dichiarazioneVariazioneRes.cognomeIntestatarioConvivenza == null ||
                    dichiarazioneVariazioneRes.nomeIntestatarioConvivenza == null ||
                    dichiarazioneVariazioneRes.dataIntestatarioConvivenza == null ||
                    dichiarazioneVariazioneRes.dataIstituzioneConvivenza == null) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
            }
        }

    }

    void checkRapportoParentelaNuovaSuSoggettoSelezionato(AnaSoggettoVariazioneRes s, String sezione) {
        if (s.flagSoggetto && s.rapportoParentelaNuovo == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
    }

    void checkRapportoParentelaPrecSuSoggettoNonSelezionato(AnaSoggettoVariazioneRes s, String sezione) {
        if (!s.flagSoggetto && isSoggettoISSelezionato() && s.rapportoParentelaPrecedente == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
    }

    void checkRapportiParentela(AnaSoggettoVariazioneRes s, String sezione) {
        if (!dichiarazioneVariazioneRes.flagAggregazione && !isAllSoggettiSelezionati()) {
            checkRapportoParentelaNuovaSuSoggettoSelezionato(s, sezione)
            checkRapportoParentelaPrecSuSoggettoNonSelezionato(s, sezione)
        } else if (dichiarazioneVariazioneRes.flagAggregazione) {
            checkRapportoParentelaNuovaSuSoggettoSelezionato(s, sezione)
        }
    }

    void checkNumeroOrdine(AnaSoggettoVariazioneRes s, String sezione) {
        if (s.numeroOrdine == null) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_obbligatori_sezione"), sezione)
        }
    }

    void checkTipoFamiglia(AnaSoggettoVariazioneRes s) {
        if (s.flagSoggetto && s.rapportoParentelaNuovo?.tipoFamiglia != dichiarazioneVariazioneRes.tipoFamiglia) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Rapporto_Parentela_Errato")))
        }
    }

    void checkAlmenoUnSoggettoInserito() {
        if (dichiarazioneVariazioneRes.soggettiVariazioneRes.size() < 1) {
            throw new CampoMandatoryRuntimeException(getEtichetta(Etichette.getEtichetta("Inserire_Soggetti")))
        }
    }

    void checkAlmenoUnaVariazione() {
        boolean almenoUnaVariazione = dichiarazioneVariazioneRes.soggettiVariazioneRes.any { it.flagSoggetto == true }
        if (!almenoUnaVariazione) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("Inserire_Variazioni")))
        }
    }

    void checkCapoFamiglia() {
        if (dichiarazioneVariazioneRes.flagAggregazione) { // Aggregazione sì
            if (dichiarazioneVariazioneRes.soggettiVariazioneRes.count { (it.flagSoggetto && it.rapportoParentelaNuovo?.codiceRapportoParentela == CAPO_FAMIGLIA) } > 0) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Aggregazione")))
            }
        } else { // Aggregazione no
            if (dichiarazioneVariazioneRes.soggettiVariazioneRes.count { (it.flagSoggetto && it.rapportoParentelaNuovo?.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Creazione")))
            }
        }
    }

    void checkCapoConvivenza() {
        if (dichiarazioneVariazioneRes.flagAggregazione) { // Aggregazione sì
            int countCC = (int) dichiarazioneVariazioneRes.soggettiVariazioneRes.count { (it.flagSoggetto && it.rapportoParentelaNuovo?.codiceRapportoParentela == CAPO_CONVIVENZA) }
            if (dichiarazioneVariazioneRes.famigliaDest?.flagEsisteCC && countCC > 0) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Presente_Aggregazione")))
            } else if (!dichiarazioneVariazioneRes.famigliaDest?.flagEsisteCC && countCC > 1) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Aggregazione")))
            }
        } else { // Aggregazione no
            if (dichiarazioneVariazioneRes.soggettiVariazioneRes.count { (it.flagSoggetto && it.rapportoParentelaNuovo?.codiceRapportoParentela == CAPO_CONVIVENZA) } > 1) {
                throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("CC_Creazione")))
            }
        }
    }

    void checkFamigliaProvenienza() {
        dichiarazioneVariazioneRes.flagInteroNucleo = dichiarazioneVariazioneRes.soggettiVariazioneRes.every { it.flagSoggetto == true }
        if (!dichiarazioneVariazioneRes.flagInteroNucleo &&
                dichiarazioneVariazioneRes.soggettiVariazioneRes.count { (!it.flagSoggetto && it.rapportoParentelaPrecedente?.codiceRapportoParentela == CAPO_FAMIGLIA) } != 1) {
            throw new De4gsdzkRuntimeException(getEtichetta(Etichette.getEtichetta("IS_Famiglia_Prec")))
        }
    }

    void checkSoggettiPratica() {
        if(pratica.flagPerfezionamento || pratica.flagAnnullamento) {
            return
        }
        checkAlmenoUnSoggettoInserito()
        for (AnaSoggettoVariazioneRes s : dichiarazioneVariazioneRes.soggettiVariazioneRes) {
            checkNumeroOrdine(s, "Soggetti")
            checkRapportiParentela(s, "Soggetti")
            checkTipoFamiglia(s)
        }
        checkAlmenoUnaVariazione()
        if (dichiarazioneVariazioneRes.tipoFamiglia == ETipoFamiglia.FAMIGLIA) { // Famiglia
            checkCapoFamiglia()
        }
        if (dichiarazioneVariazioneRes.tipoFamiglia == ETipoFamiglia.CONVIVENZA) { // Convivenza
            checkCapoConvivenza()
        }
        checkFamigliaProvenienza()
    }

    @Override
    void popolaDefault() {

    }

    @Override
    void salvaDichiarazione() {
        if (dichiarazioneVariazioneRes.id == null) {
            dichiarazioneVariazioneRes.id = gsdService.getIntegerIdFromSequence(dichiarazioneVariazioneRes, dichiarazioneVariazioneRes.getTableName())
        }

        dichiarazioneVariazioneRes.annoPratica = pratica.anno
        dichiarazioneVariazioneRes.numeroPratica = pratica.numero
        dichiarazioneVariazioneRes.dataDecorrenza = pratica.dataDecorrenza
        dichiarazioneVariazioneRes.sottoscritto = selectedDichiarante?.numeroOrdine
        if (dichiarazioneVariazioneRes.tipoConvivenza?.id == null) { // Oggetto dummy
            dichiarazioneVariazioneRes.tipoConvivenza = null
        }

        for (AnaSoggettoVariazioneRes s : dichiarazioneVariazioneRes.soggettiVariazioneRes) {
            s.annoPratica = pratica.anno
            s.numeroPratica = pratica.numero
        }
        civico.copyTo(dichiarazioneVariazioneRes.indirizzo)

        // Sostituisce la PersistentBag di Hibernate con un ArrayList semplice prima del merge,
        // per evitare che preserveSnapshot tenti di caricare entità già eliminate via orphanRemoval
        // in una precedente chiamata a salvaDichiarazione() (es. da checkAndSalvaPratica in onInserisciSoggetto).
        //dichiarazioneVariazioneRes.soggettiVariazioneRes = new ArrayList<>(dichiarazioneVariazioneRes.soggettiVariazioneRes)
        anaDichiarazioneVariazioneResService.saveOrUpdate(dichiarazioneVariazioneRes)

    }

    @Override
    void annullaDichiarazione() {

    }

    @Override
    AnaFamiglia inserisciFamiglia() {
        AnaFamiglia famiglia = new AnaFamiglia()

        famiglia.fascia = EFascia.ISCRITTO_APR
        famiglia.codice = gsdService.getCodiceFamiglia(famiglia.fascia)
        famiglia.id = gsdService.getCodiceFamigliaUnique(famiglia.fascia, famiglia.codice)

        IndirizzoResidenteFamiglia indirizzo = new IndirizzoResidenteFamiglia()
        copiaDatiIndirizzo(indirizzo.indirizzo, dichiarazioneVariazioneRes.indirizzo)
        famiglia.indirizzo = indirizzo

        famiglia.convivenza = dichiarazioneVariazioneRes.tipoFamiglia == ETipoFamiglia.CONVIVENZA
        if (famiglia.convivenza) {
            famiglia.tipoConvivenza = dichiarazioneVariazioneRes.tipoConvivenza
            famiglia.descrizioneConvivenza = dichiarazioneVariazioneRes.convivenza
            famiglia.intestatarioConvivenza = dichiarazioneVariazioneRes.intestatarioConvivenza
            famiglia.cognomeIntestatario = dichiarazioneVariazioneRes.cognomeIntestatarioConvivenza
            famiglia.nomeIntestatario = dichiarazioneVariazioneRes.nomeIntestatarioConvivenza
            famiglia.intestatario = "${dichiarazioneVariazioneRes.cognomeIntestatarioConvivenza}/${dichiarazioneVariazioneRes.nomeIntestatarioConvivenza}"
            famiglia.dataIntestatarioConvivenza = dichiarazioneVariazioneRes.dataIntestatarioConvivenza
            famiglia.dataIstituzioneConvivenza = dichiarazioneVariazioneRes.dataIstituzioneConvivenza
        } else {
            for (AnaSoggettoVariazioneRes s : dichiarazioneVariazioneRes.soggettiVariazioneRes) {
                // Usa rapportoParentelaNuovo invece di rapportoParentela
                if (s.flagSoggetto && s.rapportoParentelaNuovo?.codiceRapportoParentela == CAPO_FAMIGLIA) {
                    famiglia.intestatario = "${s.anagrafe.cognome}/${s.anagrafe.nome}"
                    famiglia.nomeIntestatario = s.anagrafe.nome
                    famiglia.cognomeIntestatario = s.anagrafe.cognome
                    break
                }
            }
        }

        salvaFamiglia(famiglia)
        dichiarazioneVariazioneRes.famigliaDest = famiglia
        dichiarazioneVariazioneRes.codFamigliaDest = famiglia.codice
        return famiglia

    }

    @Override
    AnaFamiglia updateFamiglia(String id) {
        AnaFamiglia famiglia = anaFamigliaService.get(id, null)

        IndirizzoResidenteFamiglia indirizzo = famiglia.indirizzo as IndirizzoResidenteFamiglia
        copiaDatiIndirizzo(indirizzo.indirizzo, dichiarazioneVariazioneRes.indirizzo)

        famiglia.convivenza = dichiarazioneVariazioneRes.tipoFamiglia == ETipoFamiglia.CONVIVENZA
        if (famiglia.convivenza) {
            famiglia.tipoConvivenza = dichiarazioneVariazioneRes.tipoConvivenza
            famiglia.descrizioneConvivenza = dichiarazioneVariazioneRes.convivenza
            famiglia.intestatarioConvivenza = dichiarazioneVariazioneRes.intestatarioConvivenza
            famiglia.cognomeIntestatario = dichiarazioneVariazioneRes.cognomeIntestatarioConvivenza
            famiglia.nomeIntestatario = dichiarazioneVariazioneRes.nomeIntestatarioConvivenza
            famiglia.intestatario = "${dichiarazioneVariazioneRes.cognomeIntestatarioConvivenza}/${dichiarazioneVariazioneRes.nomeIntestatarioConvivenza}"
            famiglia.dataIntestatarioConvivenza = dichiarazioneVariazioneRes.dataIntestatarioConvivenza
            famiglia.dataIstituzioneConvivenza = dichiarazioneVariazioneRes.dataIstituzioneConvivenza
        } else {
            for (AnaSoggettoVariazioneRes s : dichiarazioneVariazioneRes.soggettiVariazioneRes) {
                // Usa rapportoParentelaNuovo invece di rapportoParentela
                if (s.flagSoggetto && s.rapportoParentelaNuovo?.codiceRapportoParentela == CAPO_FAMIGLIA) {
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
        for (AnaSoggettoVariazioneRes s : dichiarazioneVariazioneRes.soggettiVariazioneRes) {
            if (!s.flagAnnullamento && s.flagSoggetto) {

                if(!(s.rapportoParentelaPrecedente.id.equals(s.rapportoParentelaNuovo.id)) ||
                    dichiarazioneVariazioneRes.codFamigliaProv != dichiarazioneVariazioneRes.codFamigliaDest) {
                    s.anagrafe.dataInizioParentela = pratica.dataDecorrenza
                }

                s.anagrafe.dataResidenza = pratica.dataDecorrenza

                if (dichiarazioneVariazioneRes.flagAggregazione) {
                    s.anagrafe.famiglia = dichiarazioneVariazioneRes.famigliaDest
                    s.anagrafe.codFamiglia = dichiarazioneVariazioneRes.codFamigliaDest
                } else {
                    s.anagrafe.famiglia = famiglia
                    s.anagrafe.codFamiglia = famiglia.codice
                }

                anaAnagrafeService.saveOrUpdate(s.anagrafe)
            }
        }

    }

    @Override
    void annullaSoggetti() {

    }

    @Override
    void popolaRapportoParentelaLists(ETipoFamiglia tipoFamiglia = null) {
        if (tipoFamiglia) {
            rapportoParentelaFPrecList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.F, tipoFamiglia)
            rapportoParentelaMPrecList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.M, tipoFamiglia)
        } else {
            rapportoParentelaFList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.F, dichiarazioneVariazioneRes.tipoFamiglia)
            rapportoParentelaMList = anaRapportoParentelaService.findAllBySessoAndTipoFamiglia(ESesso.M, dichiarazioneVariazioneRes.tipoFamiglia)
        }

    }

    @Override
    void selezionaRapportoParentela(ISoggettoPratica sogg, String rapporto, boolean mostraMessaggio = true) {
        AnaSoggettoVariazioneRes soggetto = sogg as AnaSoggettoVariazioneRes
        if (rapporto == 'P') {
            soggetto.codRpPrecedente = soggetto.rapportoParentelaPrecedente.codiceRapportoParentela
            soggetto.sequenzaRpPrecedente = soggetto.rapportoParentelaPrecedente.sequenza

        } else {
            soggetto.nuovoCodRp = soggetto.rapportoParentelaNuovo.codiceRapportoParentela
            soggetto.nuovaSequenzaRp = soggetto.rapportoParentelaNuovo.sequenza
        }

    }

    void eliminaFamiglia() {
        new ArrayList<>(dichiarazioneVariazioneRes.soggettiVariazioneRes).each {
            anaSoggettoVariazioneResService.delete(it as AnaSoggettoVariazioneRes)
        }
        dichiarazioneVariazioneRes.soggettiVariazioneRes = new ArrayList<>()
        dichiarazioneVariazioneRes.codFamigliaProv = null
        dichiarazioneVariazioneRes.famigliaProv = null
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
