package it.finmatica.de4gsdzk.certificazione

import it.finmatica.de4gsdzk.certificazione.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable

interface CerCertificatoEmessoCustomRepository {
    /*******************************
     *  Ricerca Certificato
     ******************************/
    Page<CerCertificatoEmesso> findAllByRicercaCertificato(RicercaCertificato r, Pageable pageable)

    /*******************************
     *  Ricerca Certificato Stampa
     ******************************/
    Page<CerCertificatoEmesso> findAllByRicercaCertificatoStampa(RicercaCertificatoStampa r, Pageable pageable)

    DirittiReport findDirittiByRicercaCertificatoStampa(RicercaCertificatoStampa r)

    DirittiRiepilogoReport findDirittiRiepilogoByRicercaCertificatoStampa(RicercaCertificatoStampa r)

    List<DirittiTipoPagamentoReport> findAllDirittiTipoPagamentoByRicercaCertificatoStampa(RicercaCertificatoStampa r)
}