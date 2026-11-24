package it.finmatica.de4gsdzk.certificazione

interface CerDettaglioIncassoCustomRepository {

    List<Map<String, Object>> findAllDettaglioIncasso(Date dataInizio, Date dataFine)
}
