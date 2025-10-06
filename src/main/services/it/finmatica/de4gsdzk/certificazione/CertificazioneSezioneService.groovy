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
            SezioneBusiness certificazione = new SezioneBusiness(Sezione.CERTIFICAZIONE, Etichette.Certificazione)
            certificazione.addSubSezione(new SezioneBusiness(Sezione.GESTIONE_CERTIFICAZIONE, Etichette.Gestione_Certificazione))
            l.add(certificazione)

            if(arcParametroService.isIntegrazionePagamentiAttiva()) {
                SezioneBusiness pagamenti = getMenuPagamenti()
                l.add(pagamenti)
            }
        }
        if (competenzaService.isCerSuperUser()) {
            SezioneBusiness dizionari = new SezioneBusiness(Sezione.DIZIONARI, Etichette.Dizionari)
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_DATI_GENERALI, Etichette.Dati_Generali))
            if (arcParametroService.isIntegrazionePagamentiAttiva()) {
                dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO, Etichette.Pagamenti))
            }
            dizionari.addSubSezione(new SezioneBusiness(Sezione.DIZIONARIO_CONFIGURAZIONE, Etichette.Configurazione))
            l.add(dizionari)
        }
        return l
    }

    SezioneBusiness getMenuPagamenti() {
        EServizioPagamento servizioPagamento = arcParametroService.getServizioPagamento()

        SezioneBusiness pagamenti = new SezioneBusiness(Sezione.PAGAMENTI, Etichette.Pagamenti)
        pagamenti.addSubSezione(new SezioneBusiness(Sezione.PAGAMENTI_DA_INVIARE, Etichette.Da_inviare))
        pagamenti.addSubSezione(new SezioneBusiness(Sezione.PAGAMENTI_INVIATI, Etichette.Inviati))

        if (servizioPagamento == EServizioPagamento.DEPAG) {
            pagamenti.addSubSezione(new SezioneBusiness(Sezione.PAGAMENTI_RICERCA_PAGAMENTO, Etichette.Ricerca_pagamento))
        }

        return pagamenti
    }

    List<SezioneBusiness> listDizionarioPagamento() {
        SezioneBusiness parametri = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_PARAMETRI, Etichette.Parametri)
        SezioneBusiness vociDiCosto = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_VOCI_DI_COSTO, Etichette.Voci_di_costo)
        SezioneBusiness servizi = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_SERVIZI, Etichette.Servizi)
        SezioneBusiness documenti = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_DOCUMENTI, Etichette.Documenti)
        SezioneBusiness utenti = new SezioneBusiness(Sezione.DIZIONARIO_PAGAMENTO_UTENTI, Etichette.Utenti)

        EServizioPagamento servizioPagamento = arcParametroService.getServizioPagamento()
        switch (servizioPagamento) {
            case EServizioPagamento.DEPAG:
                return [parametri, vociDiCosto, servizi, documenti]
            case EServizioPagamento.NEXTSTEP:
                return [parametri, utenti]
        }
    }
}
