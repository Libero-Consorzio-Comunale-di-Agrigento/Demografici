package it.finmatica.de4gsdzk.anagrafe

interface AnaFamigliaCustomRepository {
    AnaFamiglia getByParams(String id, Map params)
}