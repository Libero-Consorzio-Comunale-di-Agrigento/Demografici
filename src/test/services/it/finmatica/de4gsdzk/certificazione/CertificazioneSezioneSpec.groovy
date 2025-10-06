package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.CompetenzaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.pagamento.EServizioPagamento
import it.finmatica.de4gsdzk.utils.Sezione
import it.finmatica.de4gsdzk.utils.SezioneBusiness
import spock.lang.Specification

class CertificazioneSezioneSpec extends Specification {

    ArcParametroService arcParametroService
    CompetenzaService competenzaService
    CertificazioneSezioneService certificazioneSezioneService

    void setup() {
        arcParametroService = Mock(ArcParametroService)
        competenzaService = Mock(CompetenzaService)
        certificazioneSezioneService = new CertificazioneSezioneService(arcParametroService, competenzaService)
    }

    void "Menu Principale per ruolo SuperUser di Certificazione"() {
        given: "Utente con ruolo SuperUser"
        competenzaService.isCerSuperUser() >> true
        List<String> sezioniAllowed = [
                Sezione.CERTIFICAZIONE,
                Sezione.GESTIONE_CERTIFICAZIONE,
                Sezione.PAGAMENTI,
                Sezione.PAGAMENTI_DA_INVIARE,
                Sezione.PAGAMENTI_INVIATI,
                Sezione.PAGAMENTI_RICERCA_PAGAMENTO,
                Sezione.DIZIONARI,
                Sezione.DIZIONARIO_DATI_GENERALI,
                Sezione.DIZIONARIO_PAGAMENTO,
                Sezione.DIZIONARIO_CONFIGURAZIONE
        ]

        when: "Si recupera il menu principale"
        List<String> sezioni = extractSezioniIds(certificazioneSezioneService.listMenuPrincipale())

        then: "Contiene solo le sezioni consentite"
        sezioni.every { it in sezioniAllowed }
    }

    void "Menu Principale per ruolo Certificazione qualsiasi"() {
        given: "Utente con qualsiasi ruolo di certificazione"
        competenzaService.isCerAny() >> true
        List<String> sezioniAllowed = [
                Sezione.CERTIFICAZIONE,
                Sezione.GESTIONE_CERTIFICAZIONE,
                Sezione.PAGAMENTI,
                Sezione.PAGAMENTI_DA_INVIARE,
                Sezione.PAGAMENTI_INVIATI,
                Sezione.PAGAMENTI_RICERCA_PAGAMENTO
        ]

        when: "Si recupera il menu principale"
        List<String> sezioni = extractSezioniIds(certificazioneSezioneService.listMenuPrincipale())

        then: "Contiene solo le sezioni consentite"
        sezioni.every { it in sezioniAllowed }
    }

    void "Menu Principale senza alcun ruolo di Certificazione"() {
        given: "Utente senza ruoli di certificazione"
        competenzaService.isCerAny() >> false
        List<String> sezioniAllowed = []

        when: "Si recupera il menu principale"
        List<String> sezioni = extractSezioniIds(certificazioneSezioneService.listMenuPrincipale())

        then: "Non contiene sezioni"
        sezioni.isEmpty()
    }

    void "Quando Depag, Menu Pagamenti contiene solo le voci Pagamento di Depag"() {
        given: "Utente con qualsiasi ruolo di certificazione e Servizio pagamento DEPAG attivo"
        arcParametroService.getServizioPagamento() >> EServizioPagamento.DEPAG
        List<String> sezioniAllowed = [
                Sezione.PAGAMENTI_DA_INVIARE,
                Sezione.PAGAMENTI_INVIATI,
                Sezione.PAGAMENTI_RICERCA_PAGAMENTO
        ]

        when: "Si recupera il menu principale"
        List<String> sezioni = extractSezioniIds(certificazioneSezioneService.getMenuPagamenti().getSubSezioni())

        then: "Contiene solo le sezioni consentite"
        sezioni.every { it in sezioniAllowed }
    }

    void "Quando NextStep, Menu Pagamenti contiene solo le voci Pagamento di NextStep"() {
        given: "Utente con qualsiasi ruolo di certificazione e Servizio pagamento NEXTSTEP attivo"
        arcParametroService.getServizioPagamento() >> EServizioPagamento.NEXTSTEP
        List<String> sezioniAllowed = [
                Sezione.PAGAMENTI_DA_INVIARE,
                Sezione.PAGAMENTI_INVIATI
        ]

        when: "Si recupera il menu principale"
        List<String> sezioni = extractSezioniIds(certificazioneSezioneService.getMenuPagamenti().getSubSezioni())

        then: "Contiene solo le sezioni consentite"
        sezioni.every { it in sezioniAllowed }
    }

    void "Voci Dizionario quando integrazione pagamento non attiva"() {
        given: "Integrazione pagamento non attiva"
        arcParametroService.isIntegrazionePagamentiAttiva() >> false

        when: "Si recupera il menu principale"
        List<SezioneBusiness> list = certificazioneSezioneService.listMenuPrincipale()

        then: "Contiene solo Dizionario Dati Generali e Configurazione"
        list*.id.every { it in [Sezione.DIZIONARIO_DATI_GENERALI, Sezione.DIZIONARIO_CONFIGURAZIONE] }
    }

    void "Voci Dizionario quando integrazione pagamento attiva"() {
        given: "Integrazione pagamento attiva"
        arcParametroService.isIntegrazionePagamentiAttiva() >> true

        when: "Si recupera il menu principale"
        List<SezioneBusiness> list = certificazioneSezioneService.listMenuPrincipale()

        then: "Contiene Dizionario Dati Generali, Pagamento e Configurazione"
        list*.id.every {
            it in [
                    Sezione.DIZIONARIO_DATI_GENERALI,
                    Sezione.DIZIONARIO_PAGAMENTO,
                    Sezione.DIZIONARIO_CONFIGURAZIONE
            ]
        }
    }

    void "Voci Dizionario Pagamento quando DEPAG attivo"() {
        given: "Servizio pagamento DEPAG attivo"
        arcParametroService.getServizioPagamento() >> EServizioPagamento.DEPAG

        when: "Si recupera il dizionario pagamento"
        List<SezioneBusiness> list = certificazioneSezioneService.listDizionarioPagamento()

        then: "Contiene solo le voci di pagamento specifiche di DEPAG"
        list*.id.every {
            it in [
                    Sezione.DIZIONARIO_PAGAMENTO_PARAMETRI,
                    Sezione.DIZIONARIO_PAGAMENTO_VOCI_DI_COSTO,
                    Sezione.DIZIONARIO_PAGAMENTO_SERVIZI,
                    Sezione.DIZIONARIO_PAGAMENTO_DOCUMENTI
            ]
        }
    }

    void "Voci Dizionario Pagamento quando NEXTSTEP attivo"() {
        given: "Servizio pagamento NEXTSTEP attivo"
        arcParametroService.getServizioPagamento() >> EServizioPagamento.NEXTSTEP

        when: "Si recupera il dizionario pagamento"
        List<SezioneBusiness> list = certificazioneSezioneService.listDizionarioPagamento()

        then: "Contiene solo le voci di pagamento specifiche di NEXTSTEP"
        list*.id.every {
            it in [
                    Sezione.DIZIONARIO_PAGAMENTO_PARAMETRI,
                    Sezione.DIZIONARIO_PAGAMENTO_UTENTI
            ]
        }
    }

    private List<String> extractSezioniIds(List<SezioneBusiness> list) {
        list.collectMany { sezione -> [sezione.id] + sezione.subSezioni*.id }
    }
}
