package it.finmatica.de4gsdzk.anpr


import it.finmatica.de4gsdzk.utils.Etichette

import javax.persistence.*

@Entity
@Table(name = "ANPOPE_V")
class AnpOperazione {

    @Id @Column(name = "ID")
    String id

    @Column(name = "ID_OPERAZIONE", nullable = false)
    Long idOperazione

    @Column(name = "OPERAZIONERICHIESTA", nullable = true)
    String operazioneRichiesta

    @Column(name = "DES_OPERAZIONERICHIESTA", nullable = true)
    String descrizioneOperazioneRichiesta

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATAORARICHIESTA", nullable = true)
    Date dataRichiesta

    @Temporal(TemporalType.DATE)
    @Column(name = "D_DATADECORRENZA", nullable = true)
    Date dataDecorrenza

    @Column(name = "IDOPERAZIONECOMUNE_NUMBER", nullable = true)
    Long operazioneComune

    @Column(name = "IDOPERAZIONEANPR_NUMBER", nullable = true)
    Long operazioneAnpr

    @Column(name = "DES_STATOLAVORAZIONE", nullable = true)
    String stato

    static final List<Map> etichetteDomain = [Etichette.getEtichetta("Elenco_Operazioni"), Etichette.getEtichetta("Operazione"),
                                              Etichette.getEtichetta("Data_Richiesta"), Etichette.getEtichetta("Data_Decorrenza"),
                                              Etichette.getEtichetta("Id_Operazione_Comune"), Etichette.getEtichetta("Id_Operazione_ANPR"),
                                              Etichette.getEtichetta("Stato")]

}

