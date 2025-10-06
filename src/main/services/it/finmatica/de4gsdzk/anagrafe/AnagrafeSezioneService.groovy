package it.finmatica.de4gsdzk.anagrafe

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CompetenzaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Sezione
import it.finmatica.de4gsdzk.utils.SezioneBusiness
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class AnagrafeSezioneService {

    private final ArcParametroService arcParametroService
    private final CompetenzaService competenzaService

    AnagrafeSezioneService(ArcParametroService arcParametroService, CompetenzaService competenzaService) {
        this.arcParametroService = arcParametroService
        this.competenzaService = competenzaService
    }

    List<SezioneBusiness> listMenuPrincipale() {
        List<SezioneBusiness> l = []
        SezioneBusiness visualizzazione = new SezioneBusiness(Sezione.VISUALIZZAZIONE, Etichette.Visualizzazione)
        visualizzazione.addSubSezione(new SezioneBusiness(Sezione.VISUALIZZAZIONE_INDIVIDUO, Etichette.Visualizzazione_Individuo))
        visualizzazione.addSubSezione(new SezioneBusiness(Sezione.VISUALIZZAZIONE_FAMIGLIA, Etichette.Visualizzazione_Famiglia))
        l.add(visualizzazione)

        SezioneBusiness dizionari = new SezioneBusiness(Sezione.DIZIONARI, Etichette.Dizionari)
        dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_DATI_GENERALI, Etichette.Dati_Generali))
        dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_CONFIGURAZIONE, Etichette.Configurazione))
        l.add(dizionari)

        return l
    }
}
