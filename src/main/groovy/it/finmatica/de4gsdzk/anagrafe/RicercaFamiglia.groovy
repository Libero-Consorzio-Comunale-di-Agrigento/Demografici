package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.EtichetteMessaggi
import it.finmatica.de4gsdzk.utils.IRicerca

class RicercaFamiglia implements IRicerca {
    ArcVia via
    Long numeroCivico
    String suffisso
    Long interno
    String subInterno
    String scala
    String piano
    ETipoFamiglia tipoFamiglia
    ETipoSiNo iscrittoInAPR
    Date data

    RicercaFamiglia() {
        tipoFamiglia = null
        iscrittoInAPR = null
    }

    void validaDati() {
        boolean hasMandatoryFields = via != null && numeroCivico != null

        if (!hasMandatoryFields) {
            throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_ricerca_famiglia)
        }
    }

    static final List<Map> etichetteRicercaDesc = [Etichette.Indirizzo, Etichette.Civico, Etichette.Suffisso,
                                                   Etichette.Interno, Etichette.Scala, Etichette.Piano,
                                                   Etichette.Iscritto_in_APR, Etichette.Tipo, Etichette.Situazione_al,
                                                   EtichetteMessaggi.Compilare_campi_ricerca_famiglia
    ]

}
