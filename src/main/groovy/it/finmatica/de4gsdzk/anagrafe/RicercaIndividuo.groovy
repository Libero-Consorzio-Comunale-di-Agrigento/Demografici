package it.finmatica.de4gsdzk.anagrafe

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.*

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

    void validaDati() {
        boolean hasMandatoryFields = (
                (!TestoUtils.isVuoto(cognome) && !TestoUtils.isVuoto(nome)) ||
                        !TestoUtils.isVuoto(codiceFiscale) ||
                        matricola != null ||
                        idSoggettoAnpr != null ||
                        !TestoUtils.isVuoto(idUnicoAnpr)
        )

        if (!hasMandatoryFields) {
                throw new CampoMandatoryRuntimeException(EtichetteMessaggi.Compilare_campi_ricerca_individuo)
        }
    }

    static final List<Map> etichetteRicercaDesc = [Etichette.Cognome, Etichette.Nome, Etichette.Codice_Fiscale,
                                                   Etichette.Data_Nascita, Etichette.Da, Etichette.A,
                                                   Etichette.Matricola, Etichette.Id_scheda_ANPR, Etichette.Id_unico_nazionale,
                                                   EtichetteMessaggi.Compilare_campi_ricerca_individuo,
                                                   //                                             ,Etichette.Residenti,
                                                   Etichette.Ricerca_in_Anagrafe, Etichette.Ricerca_in_ANPR, Etichette.Ricerca_movimenti_rettificati
    ]

}
