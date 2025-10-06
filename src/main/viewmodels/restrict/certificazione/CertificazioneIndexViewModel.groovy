package restrict.certificazione

import groovy.util.logging.Slf4j
import it.finmatica.de4gsdzk.certificazione.CertificazioneSezioneService
import it.finmatica.de4gsdzk.utils.EModulo
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.Sezione
import it.finmatica.de4gsdzk.utils.SezioneBusiness
import org.zkoss.bind.BindUtils
import org.zkoss.bind.annotation.*
import org.zkoss.zk.ui.Component
import org.zkoss.zk.ui.event.EventQueues
import org.zkoss.zk.ui.select.Selectors
import org.zkoss.zk.ui.select.annotation.VariableResolver
import org.zkoss.zk.ui.select.annotation.WireVariable
import org.zkoss.zkplus.spring.DelegatingVariableResolver
import org.zkoss.zul.Include
import org.zkoss.zul.Window
import restrict.AbstractIndexViewModel

import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichetta
import static it.finmatica.de4gsdzk.utils.EtichetteUtils.getEtichettaEnum

@Slf4j
@VariableResolver(DelegatingVariableResolver.class)
class CertificazioneIndexViewModel extends AbstractIndexViewModel {

    @WireVariable
    private CertificazioneSezioneService certificazioneSezioneService

    @Init
    init(@ContextParam(ContextType.COMPONENT) Window w) {
        self = w

        List<Map> eList = [Etichette.Dizionari, Etichette.Certificazione, Etichette.Pagamenti]
        //Aggiungo etichette menu laterale
        eList.addAll([Etichette.Gestione_Certificazione, Etichette.Da_inviare, Etichette.Inviati, Etichette.Ricerca_pagamento, Etichette.Dati_Generali, Etichette.Configurazione, Etichette.Pagamenti])

        doInit(eList)

        selectedModulo = new Sezione(getEtichettaEnum(etichette, EModulo.CERTIFICAZIONE), EModulo.CERTIFICAZIONE.name(), "", EModulo.CERTIFICAZIONE.uri, EModulo.CERTIFICAZIONE.img)

        loadSezioni()
        selectedSezione = null
        selectedSubSezione = null
    }

    void loadSezioni() {
        sezioni = certificazioneSezioneService.listMenuPrincipale().collect { transform(it) }
    }

    private Sezione transform(SezioneBusiness sezioneBusiness) {

        if (sezioneBusiness.subSezioni.isEmpty()) {
            return new Sezione(getEtichetta(etichette, sezioneBusiness.etichetta), sezioneBusiness.id, "", getUri(sezioneBusiness))
        }

        List<Sezione> subSezioni = []

        for (SezioneBusiness child : sezioneBusiness.subSezioni) {
            Sezione transformedChild = transform(child);
            subSezioni.add(transformedChild)
        }

        return new Sezione(getEtichetta(etichette, sezioneBusiness.etichetta), sezioneBusiness.id, "", "", "", subSezioni)
    }

    String getUri(SezioneBusiness sezione) {
        switch (sezione.id) {
            case Sezione.GESTIONE_CERTIFICAZIONE:
                return "/restrict/certificazione/certificati/certificatoEmessoLista.zul"
            case Sezione.PAGAMENTI_INVIATI:
                return "/restrict/certificazione/pagamenti/pagamentoInviatoLista.zul"
            case Sezione.PAGAMENTI_DA_INVIARE:
                return "/restrict/certificazione/pagamenti/pagamentoDaInviareLista.zul"
            case Sezione.PAGAMENTI_RICERCA_PAGAMENTO:
                return "/restrict/certificazione/pagamenti/pagamentoRemotoRicerca.zul"
            case Sezione.DIZIONARIO_DATI_GENERALI:
                return "/restrict/certificazione/dizionari/generale/datoGenerale.zul"
            case Sezione.DIZIONARIO_PAGAMENTO:
                return "/restrict/certificazione/dizionari/pagamento/pagamento.zul"
            case Sezione.DIZIONARIO_CONFIGURAZIONE:
                return "/restrict/certificazione/dizionari/configurazione/configurazione.zul"
        }

        return null
    }

}
