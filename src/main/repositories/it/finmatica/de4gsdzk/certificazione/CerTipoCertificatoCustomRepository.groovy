package it.finmatica.de4gsdzk.certificazione


import it.finmatica.de4gsdzk.certificazione.CerTipoCertificato
import org.springframework.data.domain.Page

interface CerTipoCertificatoCustomRepository {
    Page<CerTipoCertificato> listByParams(Map params)
}