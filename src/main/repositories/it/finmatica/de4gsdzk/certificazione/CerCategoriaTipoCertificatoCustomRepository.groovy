package it.finmatica.de4gsdzk.certificazione


import it.finmatica.de4gsdzk.certificazione.CerCategoriaTipoCertificato

interface CerCategoriaTipoCertificatoCustomRepository {
    List<CerCategoriaTipoCertificato> listByParams(Map params)
}