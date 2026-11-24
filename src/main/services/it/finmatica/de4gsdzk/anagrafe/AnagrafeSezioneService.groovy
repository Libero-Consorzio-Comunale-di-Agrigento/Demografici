package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CompetenzaService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Sezione
import it.finmatica.de4gsdzk.utils.SezioneBusiness
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnagrafeSezioneService {

    private final CompetenzaService competenzaService

    AnagrafeSezioneService(CompetenzaService competenzaService) {
        this.competenzaService = competenzaService
    }

    List<SezioneBusiness> listMenuPrincipale() {
        List<SezioneBusiness> l = []
        if (competenzaService.isAnaAny()) {
            SezioneBusiness visualizzazione = new SezioneBusiness(Sezione.VISUALIZZAZIONE, Etichette.getEtichetta("Visualizzazione"))
            visualizzazione.addSubSezione(new SezioneBusiness(Sezione.VISUALIZZAZIONE_INDIVIDUO, Etichette.getEtichetta("Visualizzazione_Individuo")))
            visualizzazione.addSubSezione(new SezioneBusiness(Sezione.VISUALIZZAZIONE_FAMIGLIA, Etichette.getEtichetta("Visualizzazione_Famiglia")))
            l.add(visualizzazione)
        }

        if (competenzaService.isAnaSuperUser()) {

            SezioneBusiness pratiche = new SezioneBusiness(Sezione.PRATICHE, Etichette.getEtichetta("Pratiche"))
            pratiche.addSubSezione(new SezioneBusiness(Sezione.GESTIONE_PRATICHE, Etichette.getEtichetta("Gestione_Pratiche")))
            l.add(pratiche)

            SezioneBusiness dizionari = new SezioneBusiness(Sezione.DIZIONARI, Etichette.getEtichetta("Dizionari"))
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_DATI_GENERALI, Etichette.getEtichetta("Dati_Generali")))
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_DOCUMENTI, Etichette.getEtichetta("Documenti")))
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_COMUNICAZIONI, Etichette.getEtichetta("Comunicazioni")))
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_PROVVEDIMENTI, Etichette.getEtichetta("Provvedimenti")))
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_CONFIGURAZIONE, Etichette.getEtichetta("Configurazione")))
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_ANPR, Etichette.getEtichetta("ANPR")))
            l.add(dizionari)
        }

        return l
    }
}
