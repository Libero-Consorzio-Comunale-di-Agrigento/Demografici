package it.finmatica.de4gsdzk.pagamento


import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IRicerca

class RicercaPagamentoInviato implements IRicerca {

    Date dataInvioDal
    Date dataInvioAl
    EStatoInvio statoInvio

    static final List<Map> etichetteRicercaCerDesc = [Etichette.Effettua_Ricerca, Etichette.Da, Etichette.A, Etichette.Stato, Etichette.Inviato, Etichette.Da_inviare, Etichette.Tutti]

}
