package it.finmatica.de4gsdzk.elettorale

import it.finmatica.de4gsdzk.errors.CampoMandatoryRuntimeException
import it.finmatica.de4gsdzk.utils.*

class RicercaElettore implements IRicerca {
    Long matricola
    String cognome
    String nome
    ESesso sesso
    EStatoElettore stato
    Long fascicoloDa
    Long fascicoloA
    Integer anno
    Integer sezioneDa
    Integer sezioneA
    Long progressivoSezionaleDa
    Long progressivoSezionaleA
    Long progressivoGeneraleDa
    Long progressivoGeneraleA
    Long tesseraDa
    Long tesseraA
    Date dataTesseraDa
    Date dataTesseraA
    EleTipoLista tipoLista
    ETipoSiNo giacenza


    void validaDati() {

        if ((fascicoloDa != null && fascicoloA == null) || (fascicoloDa == null && fascicoloA != null)) {
                throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ricerca_elettore"))
        }

        if ((sezioneDa != null && sezioneA == null) || (sezioneDa == null && sezioneA != null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ricerca_elettore"))
        }

        if ((progressivoSezionaleDa != null && progressivoSezionaleA == null) || (progressivoSezionaleDa == null && progressivoSezionaleA != null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ricerca_elettore"))
        }

        if ((progressivoGeneraleDa != null && progressivoGeneraleA == null) || (progressivoGeneraleDa == null && progressivoGeneraleA != null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ricerca_elettore"))
        }

        if ((tesseraDa != null && tesseraA == null) || (tesseraDa == null && tesseraA != null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ricerca_elettore"))
        }

        if ((dataTesseraDa != null && dataTesseraA == null) || (dataTesseraDa == null && dataTesseraA != null)) {
            throw new CampoMandatoryRuntimeException(Etichette.getEtichetta("Compilare_campi_ricerca_elettore"))
        }
    }

    static final List<Map> etichetteRicercaDesc = [Etichette.getEtichetta("Da"), Etichette.getEtichetta("A"), Etichette.getEtichetta("Effettua_Ricerca"),
                                                   Etichette.getEtichetta("Compilare_campi_ricerca_elettore"), Etichette.getEtichetta("Tutti")
    ]

}
