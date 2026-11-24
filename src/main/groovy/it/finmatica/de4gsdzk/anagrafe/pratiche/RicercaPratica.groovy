package it.finmatica.de4gsdzk.anagrafe.pratiche

import it.finmatica.de4gsdzk.anagrafe.ETipoAnagrafe
import it.finmatica.de4gsdzk.certificazione.CerTerminalista

import it.finmatica.de4gsdzk.utils.ETipoPratica
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IRicerca

class RicercaPratica implements IRicerca {

    ETipoAnagrafe archivioAnagrafe
    ETipoPratica tipoPratica
    AnaEventoPratica statoPratica
    Date dataPraticaDa
    Date dataPraticaAl
    Integer annoPratica
    Integer numeroPratica
    ETipoNumerazione numerazione
    CerTerminalista terminalista
    String cognomeDichiarante
    String nomeDichiarante
    String codiceFiscaleDichiarante
    String matricolaDichiarante
    String idAnprDichiarante
    String idSchedaDichiarante

    static final List<Map> etichetteRicercaPraticaDesc = [Etichette.getEtichetta("Effettua_Ricerca"), Etichette.getEtichetta("Archivio_Anagrafe"), Etichette.getEtichetta("Tipo_Pratica"), Etichette.getEtichetta("Stato_Pratica"),
                                                          Etichette.getEtichetta("Data_Pratica"), Etichette.getEtichetta("Dal"), Etichette.getEtichetta("Al"), Etichette.getEtichetta("Anno"),
                                                          Etichette.getEtichetta("Numero"),Etichette.getEtichetta("Numerazione"), Etichette.getEtichetta("Terminalista"), Etichette.getEtichetta("Dichiarante"), Etichette.getEtichetta("Cognome_Dichiarante_Pratica"),
                                                          Etichette.getEtichetta("Nome_Dichiarante_Pratica"), Etichette.getEtichetta("Codice_Fiscale_Dichiarante_Pratica"), Etichette.getEtichetta("Matricola_Dichiarante"),
                                                          Etichette.getEtichetta("Id_unico_nazionale"), Etichette.getEtichetta("Id_scheda_ANPR"), Etichette.getEtichetta("Tutte"), Etichette.getEtichetta("Tutti")]

    void cancella() {
        archivioAnagrafe = null
        tipoPratica = null
        statoPratica = null
        dataPraticaDa = null
        dataPraticaAl = null
        annoPratica = null
        numeroPratica = null
        numerazione = null
        terminalista = null
        cognomeDichiarante = null
        nomeDichiarante = null
        codiceFiscaleDichiarante = null
        matricolaDichiarante = null
        idAnprDichiarante = null
        idSchedaDichiarante = null
    }

}
