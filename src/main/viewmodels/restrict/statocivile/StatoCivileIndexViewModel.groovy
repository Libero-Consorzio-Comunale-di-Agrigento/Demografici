package restrict.statocivile

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.EModulo
import it.finmatica.de4gsdzk.utils.ETipoAtto
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Sezione
import org.zkoss.bind.annotation.ContextParam
import org.zkoss.bind.annotation.ContextType
import org.zkoss.bind.annotation.Init
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Window
import restrict.AbstractIndexViewModel

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichettaEnum

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class StatoCivileIndexViewModel extends AbstractIndexViewModel {

    @WireVariable
    private ArcParametroService arcParametroService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map> eList = [Etichette.getEtichetta("Dizionari"), Etichette.getEtichetta("Dati_Generali"), Etichette.getEtichetta("Tipi_di_Atto"), Etichette.getEtichetta("Richiami"),
                           Etichette.getEtichetta("Minute"), Etichette.getEtichetta("Registri_Documenti"), Etichette.getEtichetta("Annotazioni"), Etichette.getEtichetta("Comunicazioni"), Etichette.getEtichetta("Funzioni_Ansc"),
                           Etichette.getEtichetta("Formule_Annotazione"), Etichette.getEtichetta("Documenti"), Etichette.getEtichetta("Rubrica_Nascite"), Etichette.getEtichetta("Configurazione"), Etichette.getEtichetta("ANSC")]
        //Aggiungo etichette menu laterale
        eList.addAll([Etichette.getEtichetta("Gestione_Atti_di_Nascita"), Etichette.getEtichetta("Gestione_Atti_di_Matrimonio"), Etichette.getEtichetta("Gestione_Pubblicazioni_Di_Matrimonio"),
                      Etichette.getEtichetta("Gestione_Processi_Verbali"), Etichette.getEtichetta("Gestione_Atti_di_Unione_Civile"), Etichette.getEtichetta("Gestione_Atti_di_Morte"),
                      Etichette.getEtichetta("Gestione_Atti_di_Cittadinanza"), Etichette.getEtichetta("Gestione_Registrazioni_comunali"),
                      Etichette.getEtichetta("Gestione_Comunicazioni_Da_Elaborare"), Etichette.getEtichetta("Gestione_Comunicazioni_Archiviate"),
                      Etichette.getEtichetta("Gestione_Annotazioni_Da_Elaborare"), Etichette.getEtichetta("Gestione_Annotazioni_Archiviate"), Etichette.getEtichetta("Gestione_Notifiche"),
                      Etichette.getEtichetta("Gestione_Documenti_Uscita"), Etichette.getEtichetta("Gestione_Documenti_Entrata"), Etichette.getEtichetta("Gestione_Rubrica_Nascite"), Etichette.getEtichetta("Servizi_Ansc")])

        // Aggiungo etichette tipo atto
        eList.addAll(Arrays.asList(ETipoAtto.values())*.etichettaPluralDesc)

        doInit(eList)

        selectedModulo = new Sezione(getEtichettaEnum(etichette, EModulo.STATO_CIVILE), EModulo.STATO_CIVILE.name(), "", EModulo.STATO_CIVILE.uri, EModulo.STATO_CIVILE.img)

        loadSezioni()
        selectedSezione = null
        selectedSubSezione = null
    }

    void loadSezioni() {
        //FIXME: gestire competenze
        Boolean anscOn = arcParametroService.isIntegrazioneAnscAttiva()
        sezioni =  []
        if (1 == 1){ //Competenza su atti di nascita
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Atti_di_Nascita")), ETipoAtto.NAS.name(), "", "/restrict/statocivile/nascita/nascitaLista.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Atti_Nascita")), Sezione.NASCITE, "", "", "", subSezioni))
        }
        if (1 == 1){ //Competenza su atti di matrimonio
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Pubblicazioni_Di_Matrimonio")), ETipoAtto.PUB.name(), "", "/restrict/statocivile/matrimonio/pubblicazione/pubblicazioneLista.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Atti_di_Matrimonio")), ETipoAtto.MAT.name(), "", "/restrict/statocivile/matrimonio/matrimonio/matrimonioLista.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Atti_Matrimonio")), Sezione.MATRIMONI, "", "", "", subSezioni))
        }
        if (1 == 1){ //Competenza su atti di unione civile
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Processi_Verbali")), ETipoAtto.PVU.name(), "", "/restrict/statocivile/unione/processoVerbale/processoVerbaleLista.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Atti_di_Unione_Civile")), ETipoAtto.UCI.name(), "", "/restrict/statocivile/unione/unione/unioneCivileLista.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Atti_Unione_Civile")), Sezione.UNIONI_CIVILI, "", "", "", subSezioni))
        }
        if (1 == 1){ //Competenza su atti di decesso
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Atti_di_Morte")), ETipoAtto.MOR.name(), "",  "/restrict/statocivile/morte/morteLista.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Atti_Morte")), Sezione.DECESSI, "", "", "", subSezioni))
        }
        if (1 == 1){ //Competenza su atti di cittadinanza
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Atti_di_Cittadinanza")), ETipoAtto.CIT.name(), "", "/restrict/statocivile/cittadinanza/cittadinanzaLista.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Atti_Cittadinanza")), Sezione.CITTADINANZE, "", "", "", subSezioni))
        }
        if (1 == 1){ //Competenza su annotazioni
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Annotazioni_Da_Elaborare")), Sezione.ANNOTAZIONI_DA_ELABORARE, "", "/restrict/statocivile/annotazioni/registrazioneAnnotazioni.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Annotazioni_Archiviate")),   Sezione.ANNOTAZIONI_ELABORATE, "", "/restrict/statocivile/annotazioni/archivioAnnotazioni.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Annotazioni")), Sezione.ANNOTAZIONI, "", "", "", subSezioni))
        }
        if (1 == 1){ //Competenza su comunicazioni
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Comunicazioni_Da_Elaborare")), Sezione.COMUNICAZIONI_DA_ELABORARE, "", "/restrict/statocivile/comunicazioni/comunicazioniDaElaborare.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Comunicazioni_Archiviate")),   Sezione.COMUNICAZIONI_ELABORATE, "", "/restrict/statocivile/comunicazioni/archivioComunicazioni.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Comunicazioni")), Sezione.COMUNICAZIONI, "", "", "", subSezioni))
        }
        if (anscOn) { //Competenza su ansc
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Registrazioni_comunali")), Sezione.RICERCA_ATTI_ANSC, "", "/restrict/statocivile/ricercaAtti/ricercaAttiAnscLista.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Notifiche")), Sezione.NOTIFICHE, "", "/restrict/statocivile/notifiche/notificaLista.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Funzioni_Ansc")), Sezione.ANSC, "", "", "", subSezioni))
        }
        if (1 == 1) { //Competenza su documenti
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Documenti_Uscita")), Sezione.DOCUMENTI_USCITA, "", "/restrict/statocivile/documenti/documentoUscita.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Documenti_Entrata")), Sezione.DOCUMENTI_ENTRATA, "", "/restrict/statocivile/documenti/documentoEntrataAssociatoLista.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Documenti")), Sezione.DOCUMENTI, "", "", "", subSezioni))
        }
        if (1 == 1) { //Competenza su rubriche
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Gestione_Rubrica_Nascite")), Sezione.RUBRICA_NASCITE, "", "/restrict/statocivile/rubricaNascite/rubricaNasciteLista.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Rubrica_Nascite")), Sezione.RUBRICA_NASCITE, "", "", "", subSezioni))
        }
        if (1 == 1){ //Competenza su dizionari
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Dati_Generali")),                                                        Sezione.DIZIONARIO_DATI_GENERALI,  "",   "/restrict/statocivile/dizionari/generale/datoGenerale.zul"))
            subSezioni.add(new Sezione((getEtichetta(etichette, Etichette.getEtichetta("Tipi_di_Atto")) + " / " + getEtichetta(etichette, Etichette.getEtichetta("Richiami"))), Sezione.DIZIONARIO_TIPI_ATTO,  "",       "/restrict/statocivile/dizionari/tipoAtto/tipoAtto.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Minute")),                                                               Sezione.DIZIONARIO_MINUTE,  "",          "/restrict/statocivile/dizionari/minuta/minutaLista.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Formule_Annotazione")),                                                  Sezione.DIZIONARIO_ANNOTAZIONI,  "",     "/restrict/statocivile/dizionari/annotazione/formulaAnnotazioneLista.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Comunicazioni")),                                                        Sezione.DIZIONARIO_COMUNICAZIONI,  "",   "/restrict/statocivile/dizionari/comunicazioni/comunicazione.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Registri_Documenti")),                                                   Sezione.DIZIONARIO_REGISTRI,  "",        "/restrict/statocivile/dizionari/registro/registro.zul"))
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Configurazione")),                                                       Sezione.DIZIONARIO_CONFIGURAZIONE,  "",  "/restrict/statocivile/dizionari/configurazione/configurazione.zul"))
            if (anscOn) {
                subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("ANSC")),                                                             Sezione.DIZIONARI_ANSC, "", "/restrict/statocivile/dizionari/ansc/ansc.zul"))
            }
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Dizionari")),                                                               Sezione.DIZIONARI,  "", "", "dictionary.png", subSezioni))
        }

        /*
        if (anscOn){ //Competenza su dizionari ANSC
            List<Sezione> subSezioni = []
            subSezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("Servizi_Ansc")), Sezione.DIZIONARIO_SERVIZIO,  "",   "/restrict/statocivile/ansc/ansc.zul"))
            sezioni.add(new Sezione(getEtichetta(etichette, Etichette.getEtichetta("ANSC")),    Sezione.DIZIONARI_ANSC,  "", "", "", subSezioni))
        }
        */
    }

}
