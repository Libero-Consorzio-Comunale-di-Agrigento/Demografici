package it.finmatica.de4gsdzk.certificazione


import it.finmatica.de4gsdzk.utils.IRicerca

class BaseRicercaCertificato implements IRicerca {
    CerTipoPagamento tipoPagamento
    CerTerminalista terminalista
    CerModalitaRilascio modalitaRilascio

    Date dataEmissioneDal
    Date dataEmissioneAl
    Boolean escludiAnnullati = Boolean.TRUE
}
