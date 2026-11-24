package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.archivi.ArcVia
import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ETipoSiNo
import it.finmatica.de4gsdzk.utils.Etichette
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
    EFascia fascia

    RicercaFamiglia() {
        tipoFamiglia = null
        iscrittoInAPR = null
        fascia = null
    }

    void validaDati() {
        boolean hasMandatoryFields = via != null

        if (!hasMandatoryFields) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ricerca_famiglia"))
        }
    }

    static final List<Map> etichetteRicercaDesc = [Etichette.getEtichetta("Indirizzo"), Etichette.getEtichetta("Civico"), Etichette.getEtichetta("Suffisso"),
                                                   Etichette.getEtichetta("Interno"), Etichette.getEtichetta("Scala"), Etichette.getEtichetta("Piano"),
                                                   Etichette.getEtichetta("Iscritto_in_APR"), Etichette.getEtichetta("Tipo"), Etichette.getEtichetta("Situazione_al"),
                                                   Etichette.getEtichetta("Compilare_campi_ricerca_famiglia")
    ]

}
