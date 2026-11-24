package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.ESesso
import it.finmatica.de4gsdzk.utils.Etichette
import it.finmatica.de4gsdzk.utils.IRicerca
import it.finmatica.de4gsdzk.utils.TestoUtils

class RicercaIndividuo implements IRicerca {
    String cognome
    String nome
    String codiceFiscale
    Integer matricola
    Long idSoggettoAnpr
    String idUnicoAnpr
    Date dataNascitaDal
    Date dataNascitaAl
    ESesso sesso

    //    ETipoSiNo residenti

    boolean sessoEnabled = false
    boolean ricercaRettificatiEnabled = false
    boolean ricercaAnsc = false

    void validaDati() {
        boolean hasMandatoryFields = (
                (!TestoUtils.isVuoto(cognome) && !TestoUtils.isVuoto(nome)) ||
                        !TestoUtils.isVuoto(codiceFiscale) ||
                        idSoggettoAnpr != null ||
                        !TestoUtils.isVuoto(idUnicoAnpr)
        )

        if (!hasMandatoryFields) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ricerca_individuo"))
        }
    }

    static final List<Map> etichetteRicercaDesc = [Etichette.getEtichetta("Cognome"), Etichette.getEtichetta("Nome"), Etichette.getEtichetta("Codice_Fiscale"),
                                                   Etichette.getEtichetta("Data_Nascita"), Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"),
                                                   Etichette.getEtichetta("Matricola"), Etichette.getEtichetta("Id_scheda_ANPR"), Etichette.getEtichetta("Id_unico_nazionale"),
                                                   Etichette.getEtichetta("Compilare_campi_ricerca_individuo"),
                                                   //                                             ,Etichette.getEtichetta("Residenti"),
                                                   Etichette.getEtichetta("Ricerca_in_Anagrafe"), Etichette.getEtichetta("Ricerca_in_ANPR"), Etichette.getEtichetta("Ricerca_movimenti_rettificati")
    ]

}
