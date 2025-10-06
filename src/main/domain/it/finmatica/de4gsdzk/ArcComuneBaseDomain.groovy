package it.finmatica.de4gsdzk

import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@MappedSuperclass
abstract class ArcComuneBaseDomain {

    @Id
    @Column(name = "ID")
    String id

    @Column(name = "COD_COMUNE", nullable = false)
    Integer codiceComune

    @Column(name = "COD_PROVINCIA", nullable = false)
    Integer codiceProvincia

    /*
    refs #69052
    @Column(name = "SIGLA_PROVINCIA", nullable = true)
    String siglaProvincia
    */

    @Column(name = "DES_SIGLA_PROVINCIA", nullable = true, updatable = false)
    String siglaProvincia

    @Column(name = "DES_COMUNE", nullable = false, updatable = false, insertable = false)
    String descrizioneComune

    @Column(name = "CODICE_CATASTO", nullable = true)
    String codiceCatasto

    @Column(name = "FLAG_SOPPRESSO", nullable = true)
    String soppresso

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATA_SOPPRESSIONE", nullable = false)
    Date dataSoppressione

    /*
    String getDescrizioneEstesa() {
        return (descrizioneComune?:"") + (siglaProvincia?(" (" + siglaProvincia + ")"):"")
    }
    */

    ////////////////////////////////////////////////////////////////////////
    ////////////////////////////////// GENERALI/////////////////////////////
    ////////////////////////////////////////////////////////////////////////

    static List<Map> etichetteDomain = [Etichette.Codice_Provincia, Etichette.Codice_Comune, Etichette.Denominazione_Comune, Etichette.Sigla_Provincia, Etichette.Catasto,
                                        Etichette.Valido_Dal, Etichette.Al, Etichette.Comune, Etichette.Soppresso, Etichette.Il, Etichette.Comune]
}
