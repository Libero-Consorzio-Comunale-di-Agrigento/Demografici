package it.finmatica.de4gsdzk.anagrafe

interface AnaAnagrafeCustomRepository {

    AnaAnagrafe getByParams(Integer id, Map params)

    List<AnaAnagrafe> findAllRettificatiByRicercaIndividuo(RicercaIndividuo r)

}