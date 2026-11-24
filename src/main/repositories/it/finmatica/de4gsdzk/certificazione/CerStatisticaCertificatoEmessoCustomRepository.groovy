package it.finmatica.de4gsdzk.certificazione

interface CerStatisticaCertificatoEmessoCustomRepository {

    List<Map<String, Object>> findAllDettaglioTerminalisti(Date dataInizio, Date dataFine)
}
