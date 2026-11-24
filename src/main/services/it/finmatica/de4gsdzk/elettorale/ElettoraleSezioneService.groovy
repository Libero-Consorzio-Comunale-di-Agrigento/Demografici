package it.finmatica.de4gsdzk.elettorale

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
class ElettoraleSezioneService {

    private final ArcParametroService arcParametroService
    private final CompetenzaService competenzaService

    ElettoraleSezioneService(ArcParametroService arcParametroService, CompetenzaService competenzaService) {
        this.arcParametroService = arcParametroService
        this.competenzaService = competenzaService
    }

    List<SezioneBusiness> listMenuPrincipale() {
        List<SezioneBusiness> l = []

        SezioneBusiness liste = new SezioneBusiness(Sezione.ARCHIVIO, Etichette.getEtichetta("Archivio"))
        liste.addSubSezione(new SezioneBusiness(Sezione.ARCHIVIO_ELETTORI, Etichette.getEtichetta("Archivio_Elettori")))
        l.add(liste)

        SezioneBusiness dizionari = new SezioneBusiness(Sezione.DIZIONARI, Etichette.getEtichetta("Dizionari"))
        dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_DATI_GENERALI, Etichette.getEtichetta("Dati_Generali")))
        dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_CONFIGURAZIONE, Etichette.getEtichetta("Configurazione")))
        if (arcParametroService.isWsMinintAttivo()) {
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_WS_MININT, Etichette.getEtichetta("Web_Service_Ministero_Interno")))
        }
        l.add(dizionari)

        return l
    }
}
