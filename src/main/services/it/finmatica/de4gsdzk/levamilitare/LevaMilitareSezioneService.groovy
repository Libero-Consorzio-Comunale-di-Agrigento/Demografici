package it.finmatica.de4gsdzk.levamilitare

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
class LevaMilitareSezioneService {

    private final CompetenzaService competenzaService

    LevaMilitareSezioneService(CompetenzaService competenzaService) {
        this.competenzaService = competenzaService
    }

    List<SezioneBusiness> listMenuPrincipale() {
        List<SezioneBusiness> l = []

        SezioneBusiness dizionari = new SezioneBusiness(Sezione.DIZIONARI, Etichette.getEtichetta("Dizionari"))
        dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_CONFIGURAZIONE, Etichette.getEtichetta("Configurazione")))
        l.add(dizionari)

        return l
    }
}
