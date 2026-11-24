package it.finmatica.de4gsdzk.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.CompetenzaService
import it.finmatica.de4gsdzk.archivi.ArcParametroService
import it.finmatica.de4gsdzk.pagamento.EServizioPagamento
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Sezione
import it.finmatica.de4gsdzk.utils.SezioneBusiness
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Slf4j
@Transactional
@Service
class CertificazioneSezioneService {

    private final ArcParametroService arcParametroService
    private final CompetenzaService competenzaService

    CertificazioneSezioneService(ArcParametroService arcParametroService, CompetenzaService competenzaService) {
        this.arcParametroService = arcParametroService
        this.competenzaService = competenzaService
    }

    List<SezioneBusiness> listMenuPrincipale() {
        List<SezioneBusiness> l = []
        if (competenzaService.isCerAny()) {
            SezioneBusiness certificazione = new SezioneBusiness(Sezione.CERTIFICAZIONE, Etichette.getEtichetta("Certificazione"))
            certificazione.addSubSezione(new SezioneBusiness(Sezione.GESTIONE_CERTIFICAZIONE, Etichette.getEtichetta("Gestione_Certificazione")))
            l.add(certificazione)

            if(arcParametroService.isIntegrazionePagamentiAttiva()) {
                SezioneBusiness pagamenti = getMenuPagamenti()
                l.add(pagamenti)
            }
        }
        if (competenzaService.isCerSuperUser()) {
            SezioneBusiness dizionari = new SezioneBusiness(Sezione.DIZIONARI, Etichette.getEtichetta("Dizionari"))
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_DATI_GENERALI, Etichette.getEtichetta("Dati_Generali")))
            if (arcParametroService.isIntegrazionePagamentiAttiva()) {
                dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO, Etichette.getEtichetta("Pagamenti")))
            }
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_CONFIGURAZIONE, Etichette.getEtichetta("Configurazione")))
            l.add(dizionari)
        }
        return l
    }

    SezioneBusiness getMenuPagamenti() {
        EServizioPagamento servizioPagamento = arcParametroService.getServizioPagamento()

        SezioneBusiness pagamenti = new SezioneBusiness(Sezione.PAGAMENTI, Etichette.getEtichetta("Pagamenti"))
        pagamenti.addSubSezione(new SezioneBusiness(Sezione.PAGAMENTI_DA_INVIARE, Etichette.getEtichetta("Da_inviare")))
        pagamenti.addSubSezione(new SezioneBusiness(Sezione.PAGAMENTI_INVIATI, Etichette.getEtichetta("Inviati")))

        if (servizioPagamento == EServizioPagamento.DEPAG) {
            pagamenti.addSubSezione(new SezioneBusiness(Sezione.PAGAMENTI_RICERCA_PAGAMENTO, Etichette.getEtichetta("Ricerca_pagamento")))
        }

        return pagamenti
    }

    List<SezioneBusiness> listDizionarioPagamento() {
        SezioneBusiness parametri = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_PARAMETRI, Etichette.getEtichetta("Parametri"))
        SezioneBusiness vociDiCosto = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_VOCI_DI_COSTO, Etichette.getEtichetta("Voci_di_costo"))
        SezioneBusiness servizi = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_SERVIZI, Etichette.getEtichetta("Servizi"))
        SezioneBusiness documenti = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_DOCUMENTI, Etichette.getEtichetta("Documenti"))
        SezioneBusiness utenti = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_UTENTI, Etichette.getEtichetta("Utenti"))

        EServizioPagamento servizioPagamento = arcParametroService.getServizioPagamento()
        switch (servizioPagamento) {
            case EServizioPagamento.DEPAG:
                return [parametri, vociDiCosto, servizi, documenti]
            case EServizioPagamento.NEXTSTEP:
                return [parametri, utenti]
        }
    }
}
