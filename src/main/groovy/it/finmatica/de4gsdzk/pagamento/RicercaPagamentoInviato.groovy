package it.finmatica.de4gsdzk.pagamento


import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IRicerca

class RicercaPagamentoInviato implements IRicerca {

    Date dataInvioDal
    Date dataInvioAl
    EStatoInvio statoInvio

    static final List<Map> etichetteRicercaCerDesc = [Etichette.getEtichetta("Effettua_Ricerca"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"), Etichette.getEtichetta("Stato"), Etichette.getEtichetta("Inviato"), Etichette.getEtichetta("Da_inviare"), Etichette.getEtichetta("Tutti")]

}
