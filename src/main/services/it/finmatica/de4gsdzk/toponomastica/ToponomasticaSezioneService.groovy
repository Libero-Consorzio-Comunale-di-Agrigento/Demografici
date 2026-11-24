package it.finmatica.de4gsdzk.toponomastica

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
class ToponomasticaSezioneService {

    private final CompetenzaService competenzaService

    ToponomasticaSezioneService(CompetenzaService competenzaService) {
        this.competenzaService = competenzaService
    }

    List<SezioneBusiness> listMenuPrincipale() {
        List<SezioneBusiness> l = []

        SezioneBusiness dizionari = new SezioneBusiness(Sezione.DIZIONARI, Etichette.getEtichetta("Dizionari"))
        dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_NUMERAZIONE_CIVICA, Etichette.getEtichetta("Numerazione_Civica")))
        l.add(dizionari)

        return l
    }
}
